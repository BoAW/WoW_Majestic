local q = {88545, 88526, 88531, 88532, 88524}
local locale = GetLocale()
local L = _G["Majestic_Locale_" .. locale] or Majestic_Locale_enUS

local addonVersion = C_AddOns.GetAddOnMetadata("Majestic", "Version") or "?"

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
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
    print("|cff00ff00" .. string.format(L.Help.VersionLoaded or "Majestic version %s", addonVersion) .. "|r")
    if not TomTom then
        print("|cffff4444" .. (L.Help.NoTomTom or "Majestic: TomTom is not installed. Waypoint features will not work.") .. "|r")
    end
end)

local function Majestic_Check(mode)
    for i = 1, 5 do
        local r = C_QuestLog.IsQuestFlaggedCompleted(q[i])
        local c = r and 1 or 0
        DEFAULT_CHAT_FRAME:AddMessage(n[i], 1 - c, c, 0)
        if TomTom then
            if mode == "all" then
                local mapID, x, y, desc = unpack(waypoints[i])
                local uid = TomTom:AddWaypoint(mapID, x/100, y/100, {title = desc})
                if uid then activeWaypoints[i] = uid end
            elseif mode == "way" then
                if not r then
                    local mapID, x, y, desc = unpack(waypoints[i])
                    local uid = TomTom:AddWaypoint(mapID, x/100, y/100, {title = desc})
                    if uid then activeWaypoints[i] = uid end
                elseif activeWaypoints[i] then
                    TomTom:RemoveWaypoint(activeWaypoints[i])
                    activeWaypoints[i] = nil
                end
            end
        end
    end
end

local function Majestic_SlashHandler(msg)
    msg = (msg or ""):lower():trim()
    if msg == "?" or msg == "help" then
        for i = 1, 10 do
            local line = L.Help and L.Help["Label" .. i]
            if line then DEFAULT_CHAT_FRAME:AddMessage(line) end
        end
    elseif msg == "clear" then
        if TomTom then
            for i, uid in pairs(activeWaypoints) do
                TomTom:RemoveWaypoint(uid)
            end
            wipe(activeWaypoints)
            DEFAULT_CHAT_FRAME:AddMessage(L.Help.ClearDone or "Majestic waypoints cleared.")
        end
    elseif msg == "status" then
        Majestic_Check("status")
    elseif msg == "way" then
        Majestic_Check("way")
    elseif msg == "all" then
        Majestic_Check("all")
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

SLASH_MAJESTIC1 = "/majestic"
SLASH_MAJESTIC2 = "/mj"
SlashCmdList["MAJESTIC"] = Majestic_SlashHandler

-- ---------------------------------------------------------------------------
-- Tooltip: append Available / Skinned today, plus waypoint button on hover.
-- ---------------------------------------------------------------------------

local majesticLastDebugID = nil
local majesticOverlays = {}  -- owner frame -> overlay Button frame

local function MajesticCheckLureTooltip(tooltip, data)
    -- Hide all overlays on every call so nothing lingers on other items.
    for _, ov in pairs(majesticOverlays) do
        ov:Hide()
    end

    if not (data and data.id and data.id > 0) then return end

    local idx = lureSpellIDs[data.id]

    if majesticDebug and data.id ~= majesticLastDebugID then
        majesticLastDebugID = data.id
        DEFAULT_CHAT_FRAME:AddMessage(
            "|cffaaaaaa[Majestic] id=" .. data.id
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

    if TomTom and owner then
        if not majesticOverlays[owner] then
            local overlay = CreateFrame("Button", nil, owner)
            overlay:SetSize(100, 18)
            overlay:SetPoint("TOP", owner, "BOTTOM", 0, -2)
            overlay:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
            local fs = overlay:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            fs:SetAllPoints()
            fs:SetJustifyH("CENTER")
            overlay.fs = fs
            overlay:SetScript("OnClick", function(self)
                local i = self._idx
                if not i or not TomTom then return end
                if activeWaypoints[i] then
                    TomTom:RemoveWaypoint(activeWaypoints[i])
                    activeWaypoints[i] = nil
                else
                    local mapID, x, y, desc = unpack(waypoints[i])
                    local uid = TomTom:AddWaypoint(mapID, x/100, y/100, {title = desc})
                    if uid then activeWaypoints[i] = uid end
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