-- waypoint.lua - Self-contained waypoint & HUD arrow for Majestic
-- Public API:
--   MajesticWP:Add(mapID, x, y, title)   -> uid
--   MajesticWP:Remove(uid)
--   MajesticWP:RemoveAll()
--   MajesticWP:SetLocked(bool)            -- also via /mj lock | unlock
--   MajesticWP:SetSize(px)              -- 32-80 pixels, default 56

MajesticWP = {}

-- ── Locale ─────────────────────────────────────────────────────────────────
local _locale = _G["Majestic_Locale_" .. GetLocale()] or Majestic_Locale_enUS

-- ── HereBeDragons-Pins ────────────────────────────────────────────────────
local _hbdp = LibStub("HereBeDragons-Pins-2.0")

-- ── State ──────────────────────────────────────────────────────────────────
local _waypoints = {}   -- uid -> {mapID, normX, normY, title, pin}
local _nextUID   = 1
local _arrow     = nil
local _ticker    = nil
local _locked    = false
local _arrowSize = 56  -- pixels, range 32-80
local _pinnedUID = nil
local _nearUID   = nil
local _menuHook  = nil
local _bgColor   = {r=0, g=0, b=0, a=0.5}

local SIZE_MIN = 32
local SIZE_MAX = 80
local SIZE_DEFAULT = 56

local TEXT_SIZE_MIN     = 8
local TEXT_SIZE_MAX     = 24
local TEXT_SIZE_DEFAULT = 10
local _textSize = TEXT_SIZE_DEFAULT

local UPDATE_HZ = 0.1

-- ── SavedVariables ─────────────────────────────────────────────────────────
local function _db()
    MajesticArrowDB = MajesticArrowDB or {}
    return MajesticArrowDB
end

local function _saveState()
    if not _arrow then return end
    local db = _db()
    local point, _, relPoint, x, y = _arrow:GetPoint()
    db.point    = point    or "TOP"
    db.relPoint = relPoint or "CENTER"
    db.x        = x        or 0
    db.y        = y        or -200
    db.locked   = _locked
    db.size     = _arrowSize
    db.textSize = _textSize
    db.bgColor  = { r=_bgColor.r, g=_bgColor.g, b=_bgColor.b, a=_bgColor.a }
end

local function _applyBgColor(preset)
    if not _arrow then return end
    _bgColor = { r=preset.r, g=preset.g, b=preset.b, a=preset.a }
    _arrow.bg:SetColorTexture(_bgColor.r, _bgColor.g, _bgColor.b, _bgColor.a)
    _saveState()
end

-- ── Map pins ───────────────────────────────────────────────────────────────
-- Approximate minimap visible radius in yards at each zoom level (0 = most zoomed out)
local _mmZoomYards = { [0]=466, [1]=311, [2]=207, [3]=138, [4]=92, [5]=61 }
local function _createMinimapPin(title)
    local pin = CreateFrame("Frame", nil, Minimap)
    pin:SetSize(12, 12)
    pin:SetFrameLevel(Minimap:GetFrameLevel() + 10)
    local tex = pin:CreateTexture(nil, "OVERLAY")
    tex:SetAllPoints()
    tex:SetTexture(4621573)
    pin:EnableMouse(true)
    pin:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(title, 1, 0.82, 0)
        GameTooltip:Show()
    end)
    pin:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    pin:Hide()
    return pin
end

local function _createWorldMapPin(wp)
    local pin = CreateFrame("Frame", nil, UIParent)
    pin:SetSize(16, 16)
    local dot = pin:CreateTexture(nil, "OVERLAY")
    dot:SetAllPoints()
    dot:SetTexture(4621573)
    pin:EnableMouse(true)
    pin:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(wp.title, 1, 0.82, 0)
        GameTooltip:Show()
    end)
    pin:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    return pin
end

local function _repositionMinimapPin(pin, mapID, normX, normY)
    local playerMapID = C_Map.GetBestMapForUnit("player")
    if playerMapID ~= mapID then pin:Hide(); return end
    local pos = C_Map.GetPlayerMapPosition(mapID, "player")
    if not pos then pin:Hide(); return end
    local px, py = pos:GetXY()
    local mapWidth, mapHeight = C_Map.GetMapWorldSize(mapID)
    if not mapWidth or mapWidth == 0 then pin:Hide(); return end
    local zoom    = Minimap:GetZoom()
    local mmYards  = _mmZoomYards[zoom] or 207
    local mmRadius = Minimap:GetWidth() / 2
    local scale    = mmRadius / mmYards
    local dx =  (normX - px) * mapWidth  * scale
    local dy = -(normY - py) * mapHeight * scale
    if GetCVar("rotateMinimap") == "1" then
        local f = GetPlayerFacing() or 0
        local c, s = math.cos(-f), math.sin(-f)
        dx, dy = dx*c - dy*s, dx*s + dy*c
    end
    if math.sqrt(dx*dx + dy*dy) > mmRadius then pin:Hide(); return end
    pin:ClearAllPoints()
    pin:SetPoint("CENTER", Minimap, "CENTER", dx, dy)
    pin:Show()
end

local function _updateAllPins()
    for _, wp in pairs(_waypoints) do
        if wp.mmPin then _repositionMinimapPin(wp.mmPin, wp.mapID, wp.normX, wp.normY) end
    end
end

-- ── Arrow: size & lock helpers ─────────────────────────────────────────────
local function _applySize(s)
    if not _arrow then return end
    s = math.max(SIZE_MIN, math.min(SIZE_MAX, math.floor(s + 0.5)))
    _arrowSize = s
    _arrow.tex:SetSize(s, s)
    _arrow:SetSize(s + 48, s + 40)
    _saveState()
end

local function _applyTextSize(s)
    if not _arrow then return end
    s = math.max(TEXT_SIZE_MIN, math.min(TEXT_SIZE_MAX, math.floor(s + 0.5)))
    _textSize = s
    local font, _, flags = _arrow.dist:GetFont()
    _arrow.dist:SetFont(font, s, flags)
    _arrow.title:SetFont(font, s, flags)
    _saveState()
end

local function _applyLock(locked)
    if not _arrow then return end
    _locked = locked
    _arrow:SetMovable(not locked)
    _arrow:EnableMouse(true)  -- always keep mouse enabled so right-click menu works
    _arrow:RegisterForDrag(locked and "" or "LeftButton")
    _saveState()
end

local _sizeSlider = nil
local function _openSizeSlider()
    if not _sizeSlider then
        local f = CreateFrame("Frame", "MajesticSizeSliderFrame", UIParent, "BasicFrameTemplateWithInset")
        f:SetSize(260, 145)
        f:SetPoint("CENTER")
        f:SetFrameStrata("DIALOG")
        f:SetMovable(true)
        f:EnableMouse(true)
        f:RegisterForDrag("LeftButton")
        f:SetScript("OnDragStart", f.StartMoving)
        f:SetScript("OnDragStop", function(self)
            self:StopMovingOrSizing()
            local db = _db()
            db.sizeWinX = self:GetLeft()
            db.sizeWinY = self:GetBottom()
        end)
        f.TitleText:SetText(_locale.Menu.SizesTitle)

        local aSlider = CreateFrame("Slider", "MajesticSizeSlider", f, "OptionsSliderTemplate")
        aSlider:SetPoint("TOP", f, "TOP", 0, -52)
        aSlider:SetWidth(200)
        aSlider:SetMinMaxValues(SIZE_MIN, SIZE_MAX)
        aSlider:SetValueStep(1)
        aSlider:SetObeyStepOnDrag(true)
        aSlider:SetValue(_arrowSize)
        _G["MajesticSizeSliderLow"]:SetText(SIZE_MIN)
        _G["MajesticSizeSliderHigh"]:SetText(SIZE_MAX)
        _G["MajesticSizeSliderText"]:SetText("Arrow: ".._arrowSize)
        aSlider:SetScript("OnValueChanged", function(self, val)
            _G["MajesticSizeSliderText"]:SetText("Arrow: "..math.floor(val))
            _applySize(val)
        end)
        f.arrowSlider = aSlider

        local tSlider = CreateFrame("Slider", "MajesticTextSizeSlider", f, "OptionsSliderTemplate")
        tSlider:SetPoint("TOP", f, "TOP", 0, -100)
        tSlider:SetWidth(200)
        tSlider:SetMinMaxValues(TEXT_SIZE_MIN, TEXT_SIZE_MAX)
        tSlider:SetValueStep(1)
        tSlider:SetObeyStepOnDrag(true)
        tSlider:SetValue(_textSize)
        _G["MajesticTextSizeSliderLow"]:SetText(TEXT_SIZE_MIN)
        _G["MajesticTextSizeSliderHigh"]:SetText(TEXT_SIZE_MAX)
        _G["MajesticTextSizeSliderText"]:SetText("Text: ".._textSize)
        tSlider:SetScript("OnValueChanged", function(self, val)
            _G["MajesticTextSizeSliderText"]:SetText("Text: "..math.floor(val))
            _applyTextSize(val)
        end)
        f.textSlider = tSlider
        _sizeSlider = f
    end
    _sizeSlider.arrowSlider:SetValue(_arrowSize)
    _G["MajesticSizeSliderText"]:SetText("Arrow: ".._arrowSize)
    _sizeSlider.textSlider:SetValue(_textSize)
    _G["MajesticTextSizeSliderText"]:SetText("Text: ".._textSize)
    -- Restore last position if on-screen
    local db = _db()
    if db.sizeWinX and db.sizeWinY then
        local sw, sh = GetScreenWidth(), GetScreenHeight()
        local fw, fh = _sizeSlider:GetSize()
        local left, bottom = db.sizeWinX, db.sizeWinY
        if left >= 0 and left + fw <= sw and bottom >= 0 and bottom + fh <= sh then
            _sizeSlider:ClearAllPoints()
            _sizeSlider:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", left, bottom)
        else
            _sizeSlider:ClearAllPoints()
            _sizeSlider:SetPoint("CENTER")
        end
    end
    _sizeSlider:Show()
end

local function _openColorPicker()
    local snapshot = { r=_bgColor.r, g=_bgColor.g, b=_bgColor.b, a=_bgColor.a }
    ColorPickerFrame:SetupColorPickerAndShow({
        r          = _bgColor.r,
        g          = _bgColor.g,
        b          = _bgColor.b,
        opacity    = 1 - _bgColor.a,  -- WoW opacity: 0=opaque, 1=transparent
        hasOpacity = true,
        swatchFunc = function()
            local r, g, b = ColorPickerFrame:GetColorRGB()
            local a = 1 - ColorPickerFrame:GetColorAlpha()
            _applyBgColor({r=r, g=g, b=b, a=a})
        end,
        opacityFunc = function()
            local r, g, b = ColorPickerFrame:GetColorRGB()
            local a = 1 - ColorPickerFrame:GetColorAlpha()
            _applyBgColor({r=r, g=g, b=b, a=a})
        end,
        cancelFunc = function()
            _applyBgColor(snapshot)
        end,
    })
end

-- ── Context menu (right-click) ─────────────────────────────────────────────
local function _showMenu()
    MenuUtil.CreateContextMenu(_arrow, function(_, root)
        root:CreateTitle(_locale.Menu.Title)
        root:CreateButton(_locked and _locale.Menu.Unlock or _locale.Menu.Lock, function()
            _applyLock(not _locked)
        end)
        root:CreateDivider()
        root:CreateButton(_locale.Menu.Size, _openSizeSlider)
        root:CreateDivider()
        root:CreateButton(_locale.Menu.BgColor, _openColorPicker)
        root:CreateDivider()
        root:CreateButton(_locale.Menu.RemoveCurrent, function()
            MajesticWP:Remove(_nearUID)
        end)
        root:CreateButton(_locale.Menu.RemoveAll, function()
            MajesticWP:RemoveAll()
        end)
        if _menuHook then _menuHook(root) end
    end)
end

-- ── Build arrow frame ──────────────────────────────────────────────────────
local function _buildArrow()
    if _arrow then return end
    local s = _arrowSize

    _arrow = CreateFrame("Frame", "MajesticArrowFrame", UIParent)
    _arrow:SetSize(s + 48, s + 40)
    _arrow:SetPoint("TOP", Minimap, "BOTTOM", 0, -8)
    _arrow:SetFrameStrata("MEDIUM")
    _arrow:SetClampedToScreen(true)
    _arrow:SetMovable(true)
    _arrow:EnableMouse(true)
    _arrow:RegisterForDrag("LeftButton")

    -- Semi-transparent backdrop
    local bg = _arrow:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetColorTexture(_bgColor.r, _bgColor.g, _bgColor.b, _bgColor.a)
    _arrow.bg = bg

    -- Arrow texture – MinimapArrow points SOUTH at rotation 0
    local tex = _arrow:CreateTexture(nil, "ARTWORK")
    tex:SetSize(s, s)
    tex:SetPoint("TOP", _arrow, "TOP", 0, -4)
    tex:SetTexture("Interface\\Minimap\\MinimapArrow")
    tex:SetRotation(0)
    _arrow.tex = tex

    -- Distance label
    local dist = _arrow:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    dist:SetPoint("TOP", tex, "BOTTOM", 0, -2)
    dist:SetTextColor(1, 1, 1)
    _arrow.dist = dist

    -- Waypoint title
    local title = _arrow:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    title:SetPoint("TOP", dist, "BOTTOM", 0, -1)
    title:SetTextColor(1, 0.82, 0)
    _arrow.title = title

    _arrow:SetScript("OnDragStart", function(self)
        if not _locked then self:StartMoving() end
    end)
    _arrow:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        _saveState()
    end)
    _arrow:SetScript("OnMouseUp", function(_, btn)
        if btn == "RightButton" then _showMenu() end
    end)

    -- Restore saved position / settings
    local db = _db()
    if db.x then
        _arrow:ClearAllPoints()
        _arrow:SetPoint(db.point or "TOP", UIParent, db.relPoint or "CENTER",
                        db.x or 0, db.y or -200)
    end
    local savedBgColor  = db.bgColor and { r=db.bgColor.r, g=db.bgColor.g, b=db.bgColor.b, a=db.bgColor.a }
    local savedTextSize = db.textSize
    local savedLocked   = db.locked
    _applySize(db.size or SIZE_DEFAULT)
    _applyLock(savedLocked or false)
    _applyTextSize(savedTextSize or TEXT_SIZE_DEFAULT)
    if savedBgColor then _applyBgColor(savedBgColor) end

    _arrow:Hide()
end

-- ── Distance & direction ───────────────────────────────────────────────────
local function _formatDist(yards)
    if yards >= 1760 then
        return string.format("%.1f mi", yards / 1760)
    end
    return string.format("%d yd", math.floor(yards + 0.5))
end

local function _angleToPoint(px, py, tx, ty)
    return math.atan2(tx - px, -(ty - py))
end

-- ── Ticker update ──────────────────────────────────────────────────────────
local function _update()
    _updateAllPins()
    if not _arrow then return end

    local count = 0
    for _ in pairs(_waypoints) do count = count + 1 end
    if count == 0 then _arrow:Hide(); return end

    local mapID = C_Map.GetBestMapForUnit("player")
    if not mapID then _arrow:Hide(); return end

    local pos = C_Map.GetPlayerMapPosition(mapID, "player")
    if not pos then _arrow:Hide(); return end
    local px, py = pos:GetXY()

    -- Get player world position for cross-map calculations.
    -- GetWorldPosFromMapPos returns (instance, pos) where pos:GetXY() = (northing, westward).
    local pInst, pWorldPos = C_Map.GetWorldPosFromMapPos(mapID, CreateVector2D(px, py))
    local pNorth, pWest
    if pWorldPos then pNorth, pWest = pWorldPos:GetXY() end

    -- Find nearest waypoint: same map by normalized coords, or cross-map by world coords
    -- if both are on the same game instance (e.g. Eversong <-> Zul'Aman).
    local nearUID, nearDist, nearAngle, nearTitle, nearGoTo

    if _pinnedUID and _waypoints[_pinnedUID] then
        local wp = _waypoints[_pinnedUID]
        if wp.mapID == mapID then
            local dx = wp.normX - px
            local dy = wp.normY - py
            nearDist  = math.sqrt(dx * dx + dy * dy) * 4400
            nearAngle = _angleToPoint(px, py, wp.normX, wp.normY)
            nearTitle = wp.title
            nearUID   = _pinnedUID
        elseif pWorldPos then
            local wpInst, wpWorldPos = C_Map.GetWorldPosFromMapPos(wp.mapID, CreateVector2D(wp.normX, wp.normY))
            if wpWorldPos and wpInst == pInst then
                local wpNorth, wpWest = wpWorldPos:GetXY()
                nearDist  = math.sqrt((wpWest - pWest)^2 + (wpNorth - pNorth)^2)
                nearAngle = math.atan2(pWest - wpWest, wpNorth - pNorth)
                nearTitle = wp.title
                nearUID   = _pinnedUID
            end
        end
        -- Pinned selection always wins even if distance/angle can't be computed
        if not nearUID then
            nearUID   = _pinnedUID
            nearTitle = wp.title
            nearAngle = 0
            nearDist  = 0
            nearGoTo  = true
        end
    end

    for uid, wp in pairs(_waypoints) do
        if nearUID then break end
        if wp.mapID == mapID then
            local dx   = wp.normX - px
            local dy   = wp.normY - py
            local dist = math.sqrt(dx * dx + dy * dy) * 4400
            if not nearDist or dist < nearDist then
                nearDist  = dist
                nearAngle = _angleToPoint(px, py, wp.normX, wp.normY)
                nearTitle = wp.title
                nearUID   = uid
            end
        elseif pWorldPos then
            local wpInst, wpWorldPos = C_Map.GetWorldPosFromMapPos(wp.mapID, CreateVector2D(wp.normX, wp.normY))
            if wpWorldPos and wpInst == pInst then
                local wpNorth, wpWest = wpWorldPos:GetXY()
                -- World coords: northing increases north, westward increases west.
                -- east_delta = pWest - wpWest (positive = waypoint is east of player)
                -- CW-from-north angle = atan2(east_delta, north_delta)
                local dist = math.sqrt((wpWest - pWest)^2 + (wpNorth - pNorth)^2)
                if not nearDist or dist < nearDist then
                    nearDist  = dist
                    nearAngle = math.atan2(pWest - wpWest, wpNorth - pNorth)
                    nearTitle = wp.title
                    nearUID   = uid
                end
            end
        end
    end

    if not nearUID then
        -- All waypoints are on a different game instance – show "Go to <zone>".
        local nearWP, nearWPUID
        for uid, wp in pairs(_waypoints) do nearWP = wp; nearWPUID = uid; break end
        if nearWP then
            local mapInfo = C_Map.GetMapInfo(nearWP.mapID)
            local mapName = mapInfo and mapInfo.name or "?"
            _arrow.dist:SetText(string.format(_locale.Arrow.GoTo, mapName))
            _arrow.title:SetText(nearWP.title:gsub("^(.+) %((.+)%)$", "%2\n%1"))
            _arrow.tex:SetRotation(0)
            _nearUID = nearWPUID
            _arrow:Show()
        else
            _nearUID = nil
            _arrow:Hide()
        end
        return
    end

    -- Texture points NORTH at rotation=0, SetRotation is CCW.
    -- nearAngle is CW-from-north; GetPlayerFacing() is CCW-from-north (opposite sign).
    -- rotation = -(nearAngle + facing) rotates the arrow to match the world direction.
    local facing = GetPlayerFacing() or 0
    _arrow.tex:SetRotation(-(nearAngle + facing))
    if nearGoTo then
        local mapInfo = C_Map.GetMapInfo(_waypoints[nearUID].mapID)
        local mapName = mapInfo and mapInfo.name or "?"
        _arrow.dist:SetText(string.format(_locale.Arrow.GoTo, mapName))
    else
        _arrow.dist:SetText(_formatDist(nearDist))
    end
    _arrow.title:SetText(nearTitle:gsub("^(.+) %((.+)%)$", "%2\n%1"))
    _nearUID = nearUID
    _arrow:Show()
end

-- ── Public API ─────────────────────────────────────────────────────────────
function MajesticWP:Add(mapID, x, y, title)
    _buildArrow()
    local uid = _nextUID
    _nextUID  = _nextUID + 1
    local worldPin = _createWorldMapPin({title=title, mapID=mapID, normX=x, normY=y})
    -- HBD_PINS_WORLDMAP_SHOW_PARENT=1, CONTINENT=2, WORLD=3
    _hbdp:AddWorldMapIconMap(MajesticWP, worldPin, mapID, x, y, 3)
    _waypoints[uid] = {
        mapID    = mapID,
        normX    = x,
        normY    = y,
        title    = title,
        worldPin = worldPin,
        mmPin    = _createMinimapPin(title),
    }
    if not _ticker then
        _ticker = C_Timer.NewTicker(UPDATE_HZ, _update)
    end
    return uid
end

function MajesticWP:Remove(uid)
    local wp = _waypoints[uid]
    if not wp then return end
    if wp.worldPin then
        _hbdp:RemoveWorldMapIcon(MajesticWP, wp.worldPin)
        wp.worldPin:Hide()
        wp.worldPin:SetParent(nil)
    end
    if wp.mmPin then wp.mmPin:Hide(); wp.mmPin:SetParent(nil) end
    if _pinnedUID == uid then _pinnedUID = nil end
    if _nearUID == uid then _nearUID = nil end
    _waypoints[uid] = nil
    local count = 0
    for _ in pairs(_waypoints) do count = count + 1 end
    if count == 0 then
        if _ticker then _ticker:Cancel(); _ticker = nil end
        if _arrow  then _arrow:Hide() end
    end
end

function MajesticWP:RemoveAll()
    for uid in pairs(_waypoints) do MajesticWP:Remove(uid) end
end

function MajesticWP:SetLocked(locked)
    _buildArrow()
    _applyLock(locked)
end

function MajesticWP:SetSize(px)
    _buildArrow()
    _applySize(px)
end

function MajesticWP:SetTarget(uid)
    _pinnedUID = uid
end

function MajesticWP:GetTarget()
    return _pinnedUID
end

function MajesticWP:SetMenuHook(fn)
    _menuHook = fn
end

-- Minimap pins are updated via the ticker; world map pins are handled by HBD-Pins.
