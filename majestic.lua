local addonName = ...   -- WoW passes the folder/addon name as the first vararg
local q = {88545, 88526, 88531, 88532, 88524}
local locale = GetLocale()
local L = _G["Majestic_Locale_" .. locale] or Majestic_Locale_enUS

local addonVersion = C_AddOns.GetAddOnMetadata(addonName, "Version") or "?"

local monthAbbrevToIndex = {
    Jan = 1, Feb = 2, Mar = 3, Apr = 4, May = 5, Jun = 6,
    Jul = 7, Aug = 8, Sep = 9, Oct = 10, Nov = 11, Dec = 12
}

local n = {L.Zones.Eversong, L.Zones.ZulAman, L.Zones.Harandar, L.Zones.Voidstorm, L.Zones.GrandBeast}
local waypoints = {
    {2395, 41.95, 80.05, L.Zones.Eversong},
    {2437, 47.69, 53.25, L.Zones.ZulAman},
    {2413, 66.28, 47.91, L.Zones.Harandar},
    {2405, 54.60, 65.80, L.Zones.Voidstorm},
    {2405, 43.25, 82.75, L.Zones.GrandBeast}
}

local activeWaypoints = {}
local majesticDebug = false
local majesticOverlays = {}  -- owner frame -> overlay Button frame

-- Lure spell ID -> index into q[]. Order: Eversong, Zul'Aman, Harandar, Voidstorm, Grand Beast.
local lureSpellIDs = {
    [238652] = 1,   -- Majestic Eversong Lure
    [238653] = 2,   -- Majestic Zul'Aman Lure
    [238654] = 3,   -- Majestic Harandar Lure
    [238655] = 4,   -- Majestic Voidstorm Lure
    [238656] = 5,   -- Grand Beast Lure
}

-- Print version to chat once the UI is ready
local f = CreateFrame("Frame")
local function _saveActiveWaypoints()
    MajesticArrowDB = MajesticArrowDB or {}
    local saved = {}
    for i, uid in pairs(activeWaypoints) do
        saved[i] = uid and true or nil
    end
    MajesticArrowDB.savedWaypoints = saved
end

f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
    print("|cff00ff00" .. string.format(L.Help.VersionLoaded or "Majestic version %s", addonVersion) .. "|r")
    -- Restore waypoints saved before last reload
    MajesticArrowDB = MajesticArrowDB or {}
    local saved = MajesticArrowDB.savedWaypoints
    if saved then
        for i, _ in pairs(saved) do
            if waypoints[i] and not activeWaypoints[i] then
                local mapID, x, y, desc = unpack(waypoints[i])
                activeWaypoints[i] = MajesticWP:Add(mapID, x/100, y/100, desc)
            end
        end
    end
end)

local function Majestic_Check(mode)
    for i = 1, 5 do
        local r = C_QuestLog.IsQuestFlaggedCompleted(q[i])
        local c = r and 1 or 0
        DEFAULT_CHAT_FRAME:AddMessage(n[i], 1 - c, c, 0)
        if mode == "all" then
            if activeWaypoints[i] then
                MajesticWP:Remove(activeWaypoints[i])
                activeWaypoints[i] = nil
            end
            local mapID, x, y, desc = unpack(waypoints[i])
            local uid = MajesticWP:Add(mapID, x/100, y/100, desc)
            activeWaypoints[i] = uid
        elseif mode == "way" then
            if not r then
                if not activeWaypoints[i] then
                    local mapID, x, y, desc = unpack(waypoints[i])
                    local uid = MajesticWP:Add(mapID, x/100, y/100, desc)
                    activeWaypoints[i] = uid
                end
            elseif activeWaypoints[i] then
                MajesticWP:Remove(activeWaypoints[i])
                activeWaypoints[i] = nil
            end
        end
    end
    _saveActiveWaypoints()
end

-- ---------------------------------------------------------------------------
-- Changelog window  (/mj version)  — text lives in changelog.lua
-- ---------------------------------------------------------------------------
local changelogFrame = nil
local function _showChangelogWindow()
    if changelogFrame then
        if changelogFrame:IsShown() then
            changelogFrame:Hide()
        else
            changelogFrame:Show()
        end
        return
    end

    local frame = CreateFrame("Frame", "MajesticChangelogFrame", UIParent, "BasicFrameTemplateWithInset")
    frame:SetSize(860, 480)
    frame:SetPoint("CENTER")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop",  frame.StopMovingOrSizing)
    frame:SetFrameStrata("DIALOG")
    frame.TitleText:SetText("Majestic \226\128\147 " .. (L.Help.ChangelogTitle or "Changelog") .. " v" .. addonVersion)

    -- Language selector buttons
    local localeList   = {"daDA","zhCN","deDE","enUS","esES","frFR","itIT","koKR","ptBR","ruRU"}
    local localeLabels = {"Dansk","中文","Deutsch","English","Español","Français","Italiano","한국어","Português","Русский"}
    local btnW, btnH, gap = 80, 20, 2
    local langButtons = {}
    local activeLocale = MajesticChangelogLocales[GetLocale()] and GetLocale() or "enUS"
    local txt  -- forward declaration so OnClick closures can reference it
    for i, loc in ipairs(localeList) do
        local btn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
        btn:SetSize(btnW, btnH)
        btn:SetPoint("TOPLEFT", frame, "TOPLEFT", 10 + (i - 1) * (btnW + gap), -30)
        btn:SetText(localeLabels[i])
        btn:SetAlpha(loc == activeLocale and 1.0 or 0.5)
        btn:SetScript("OnClick", function()
            txt:SetText(MajesticChangelogLocales[loc] or MajesticChangelogLocales["enUS"])
            for _, b in ipairs(langButtons) do b:SetAlpha(0.5) end
            btn:SetAlpha(1.0)
        end)
        langButtons[i] = btn
    end

    local sf = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
    sf:SetPoint("TOPLEFT",     frame, "TOPLEFT",     10, -56)
    sf:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30,  10)

    local content = CreateFrame("Frame", nil, sf)
    content:SetWidth(764)
    content:SetHeight(800)
    sf:SetScrollChild(content)

    txt = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    txt:SetPoint("TOPLEFT", content, "TOPLEFT", 4, -4)
    txt:SetWidth(756)
    txt:SetJustifyH("LEFT")
    txt:SetJustifyV("TOP")
    txt:SetSpacing(3)
    txt:SetText(MajesticChangelog or "")

    changelogFrame = frame
    table.insert(UISpecialFrames, "MajesticChangelogFrame")
    frame:Show()
end

local function Majestic_SlashHandler(msg)
    msg = (msg or ""):lower():trim()
    if msg == "?" or msg == "help" then
        for i = 1, 10 do
            local line = L.Help and L.Help["Label" .. i]
            if line then DEFAULT_CHAT_FRAME:AddMessage(line) end
        end
    elseif msg == "clear" then
        MajesticWP:RemoveAll()
        wipe(activeWaypoints)
        _saveActiveWaypoints()
        for _, ov in pairs(majesticOverlays) do
            if ov:IsShown() then
                ov.fs:SetText("|cff00ff00" .. (L.Tooltip.WaypointAdd or "[+] Waypoint") .. "|r")
            end
        end
        DEFAULT_CHAT_FRAME:AddMessage(L.Help.ClearDone or "Majestic waypoints cleared.")
    elseif msg == "status" then
        Majestic_Check("status")
    elseif msg == "way" then
        Majestic_Check("way")
    elseif msg == "all" then
        Majestic_Check("all")
    elseif msg == "lock" then
        MajesticWP:SetLocked(true)
        DEFAULT_CHAT_FRAME:AddMessage("|cffaaaaaa[Majestic]|r Arrow locked.")
    elseif msg == "unlock" then
        MajesticWP:SetLocked(false)
        DEFAULT_CHAT_FRAME:AddMessage("|cffaaaaaa[Majestic]|r Arrow unlocked.")
    elseif msg:match("^size (.+)$") then
        local val = tonumber(msg:match("^size (.+)$"))
        if val then
            MajesticWP:SetSize(val)
            DEFAULT_CHAT_FRAME:AddMessage("|cffaaaaaa[Majestic]|r Arrow size: " .. math.max(32, math.min(80, math.floor(val + 0.5))))
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cffaaaaaa[Majestic]|r Valid sizes: 32-80")
        end
    elseif msg == "version" then
        _showChangelogWindow()
    elseif msg == "debug" then
        majesticDebug = not majesticDebug
        DEFAULT_CHAT_FRAME:AddMessage((L.Help.DebugPrefix or "Majestic debug: ") .. (majesticDebug and "|cff00ff00" .. (L.Help.DebugOn or "ON") .. "|r" or "|cffff4444" .. (L.Help.DebugOff or "OFF") .. "|r"))
        if majesticDebug then
            -- Report frame state immediately so we don't have to guess
            local frameNames = {
                "ProfessionsBookFrame",
                "SpellBookFrame",
                "PlayerSpellsFrame",
                "ProfessionsFrame",
                "SkillBookFrame",
            }
            for _, name in ipairs(frameNames) do
                local f = _G[name]
                DEFAULT_CHAT_FRAME:AddMessage("|cffaaaaaa[Majestic] " .. name .. "=" .. tostring(f ~= nil) .. (f and (" shown=" .. tostring(f:IsShown())) or "") .. "|r")
            end
            DEFAULT_CHAT_FRAME:AddMessage("|cffaaaaaa[Majestic] ProfessionsBook_LoadUI=" .. tostring(ProfessionsBook_LoadUI ~= nil))
            -- Scan for any SpellButton-like globals
            local btnPatterns = {"SpellButton", "PrimaryProfession", "Profession"}
            for _, pat in ipairs(btnPatterns) do
                for i = 1, 12 do
                    local btn = _G[pat .. i] or _G[pat .. i .. "SpellButtonBottom"]
                    if btn then
                        local spellID = btn.spellID or (btn.GetSpellID and btn:GetSpellID())
                        DEFAULT_CHAT_FRAME:AddMessage("|cffaaaaaa[Majestic] found: " .. pat .. i .. " spellID=" .. tostring(spellID) .. "|r")
                    end
                end
            end
            -- Enumerate children of ProfessionsFrame to find spell buttons
            if ProfessionsFrame then
                local n = 0
                for _, child in ipairs({ProfessionsFrame:GetChildren()}) do
                    n = n + 1
                    local name = child:GetName() or "(unnamed)"
                    local spellID = child.spellID or (child.GetSpellID and child:GetSpellID())
                    if spellID or name:find("Spell") or name:find("Button") or name:find("Skill") then
                        DEFAULT_CHAT_FRAME:AddMessage("|cffaaaaaa[Majestic] child: " .. name .. " spellID=" .. tostring(spellID) .. "|r")
                    end
                end
                DEFAULT_CHAT_FRAME:AddMessage("|cffaaaaaa[Majestic] ProfessionsFrame total children: " .. n .. "|r")
            end
        end
    else
        for i = 1, 10 do
            local line = L.Help and L.Help["Label" .. i]
            if line then DEFAULT_CHAT_FRAME:AddMessage(line) end
        end
    end
end

-- Use the addon folder name as the slash-command key so the release build
-- ("Majestic") and the beta build ("MajesticBeta") never share a command.
local cmdKey  = addonName:upper()                        -- "MAJESTIC" or "MAJESTICBETA"
local cmd1    = "/" .. addonName:lower()                 -- "/majestic" or "/majesticbeta"
local cmd2    = addonName == "Majestic" and "/mj" or "/mjb"

_G["SLASH_" .. cmdKey .. "1"] = cmd1
_G["SLASH_" .. cmdKey .. "2"] = cmd2
SlashCmdList[cmdKey] = Majestic_SlashHandler

-- ---------------------------------------------------------------------------
-- Tooltip: append Available / Skinned today, plus waypoint button on hover.
-- ---------------------------------------------------------------------------

local majesticLastDebugID = nil

local function MajesticCheckLureTooltip(tooltip, data)
    -- Hide all overlays on every call so nothing lingers on other items.
    for _, ov in pairs(majesticOverlays) do
        ov:Hide()
    end

    -- Resolve spell/item ID from either TooltipDataProcessor (data.id) or
    -- legacy HookScript (no data — extract from the tooltip directly).
    local spellItemID
    if data and data.id and data.id > 0 then
        spellItemID = data.id
    else
        -- OnTooltipSetSpell: tooltip:GetSpell() returns name, rank, spellID
        local _, _, sid = tooltip:GetSpell()
        if sid and sid > 0 then
            spellItemID = sid
        else
            -- OnTooltipSetItem: tooltip:GetItem() returns name, link
            local _, link = tooltip:GetItem()
            if link then
                spellItemID = select(2, link:find("|Hitem:(%d+)"))
                spellItemID = spellItemID and tonumber(spellItemID)
            end
        end
    end

    if not (spellItemID and spellItemID > 0) then return end

    local idx = lureSpellIDs[spellItemID]

    if majesticDebug and spellItemID ~= majesticLastDebugID then
        majesticLastDebugID = spellItemID
        DEFAULT_CHAT_FRAME:AddMessage(
            "|cffaaaaaa[Majestic] id=" .. spellItemID
            .. (idx and " |cff00ff00MATCHED|r" or " no match")
            .. "|r")
    end

    if not idx then return end

    local owner = tooltip:GetOwner()
    local done = C_QuestLog.IsQuestFlaggedCompleted(q[idx])
    if done then
        tooltip:AddLine(L.Tooltip and L.Tooltip.UsedToday or "Skinned today", 1, 0.35, 0.35)
    else
        tooltip:AddLine(L.Tooltip and L.Tooltip.Available or "Available", 0.35, 1, 0.35)
    end

    if owner then
        if not majesticOverlays[owner] then
            local overlay = CreateFrame("Button", nil, owner)
            overlay:SetSize(100, 18)
            overlay:SetPoint("TOP", owner, "BOTTOM", 0, -2)
            local bg = overlay:CreateTexture(nil, "BACKGROUND")
            bg:SetAllPoints()
            bg:SetColorTexture(0, 0, 0, 0.6)
            overlay:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
            local fs = overlay:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            fs:SetAllPoints()
            fs:SetJustifyH("CENTER")
            overlay.fs = fs
            overlay:SetScript("OnClick", function(self)
                local i = self._idx
                if not i then return end
                if activeWaypoints[i] then
                    MajesticWP:Remove(activeWaypoints[i])
                    activeWaypoints[i] = nil
                else
                    local mapID, x, y, desc = unpack(waypoints[i])
                    activeWaypoints[i] = MajesticWP:Add(mapID, x/100, y/100, desc)
                end
                self.fs:SetText(activeWaypoints[i] and "|cffff9900" .. (L.Tooltip.WaypointRemove or "[x] Waypoint") .. "|r" or "|cff00ff00" .. (L.Tooltip.WaypointAdd or "[+] Waypoint") .. "|r")
            end)
            overlay:SetScript("OnLeave", function(self)
                self:Hide()
            end)
            majesticOverlays[owner] = overlay
        end
        local ov = majesticOverlays[owner]
        ov._idx = idx
        ov.fs:SetText(activeWaypoints[idx] and "|cffff9900" .. (L.Tooltip.WaypointRemove or "[x] Waypoint") .. "|r" or "|cff00ff00" .. (L.Tooltip.WaypointAdd or "[+] Waypoint") .. "|r")
        ov:Show()
    end
end

GameTooltip:HookScript("OnHide", function()
    majesticLastDebugID = nil
    C_Timer.After(0.1, function()
        for _, ov in pairs(majesticOverlays) do
            if not ov:IsMouseOver() then
                ov:Hide()
            end
        end
    end)
end)

if TooltipDataProcessor then
    TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Spell, MajesticCheckLureTooltip)
    TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item,  MajesticCheckLureTooltip)
else
    GameTooltip:HookScript("OnTooltipSetSpell", MajesticCheckLureTooltip)
    GameTooltip:HookScript("OnTooltipSetItem",  MajesticCheckLureTooltip)
end

-- ── Arrow context menu: lure switcher ─────────────────────────────────────
MajesticWP:SetMenuHook(function(root)
    local playerMap = C_Map.GetBestMapForUnit("player")
    local available = {}
    for i, uid in pairs(activeWaypoints) do
        if uid and waypoints[i] and waypoints[i][1] == playerMap then
            local label = n[i]:gsub("^(.+) %((.+)%)$", "%2")
            table.insert(available, {uid = uid, label = label})
        end
    end
    if #available < 2 then return end
    root:CreateDivider()
    root:CreateTitle("Lure")
    root:CreateRadio("Nearest", function() return MajesticWP:GetTarget() == nil end,
                                function() MajesticWP:SetTarget(nil) end)
    for _, entry in ipairs(available) do
        local uid = entry.uid
        root:CreateRadio(entry.label,
            function() return MajesticWP:GetTarget() == uid end,
            function() MajesticWP:SetTarget(uid) end)
    end
end)