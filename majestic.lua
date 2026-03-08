local q = {88545, 88526, 88531, 88532, 88524}
local locale = GetLocale()
local L = _G["Majestic_Locale_" .. locale] or Majestic_Locale_enUS

local buildVersion, buildNumber, buildDate, interfaceVersion = GetBuildInfo()
local addonVersion = C_AddOns.GetAddOnMetadata("Majestic", "Version") or "?"

local monthAbbrevToIndex = {
    Jan = 1, Feb = 2, Mar = 3, Apr = 4, May = 5, Jun = 6,
    Jul = 7, Aug = 8, Sep = 9, Oct = 10, Nov = 11, Dec = 12
}

local month, day, year = buildDate:match("(%a+)%s+(%d+)%s+(%d+)")
if month and day and year then
    local monthIndex = monthAbbrevToIndex[month]
    local monthName = monthIndex and L.Build.MonthNames and L.Build.MonthNames[monthIndex] or month
    buildDate = string.format("%d %s %s", tonumber(day), monthName, year)
end

local n = {L.Zones.Eversong, L.Zones.ZulAman, L.Zones.Harandar, L.Zones.Voidstorm, L.Zones.GrandBeast}
local waypoints = {
    {2395, 41.95, 80.05, L.Zones.Eversong},
    {2437, 47.69, 53.25, L.Zones.ZulAman},
    {2413, 66.28, 47.91, L.Zones.Harandar},
    {2405, 54.60, 65.80, L.Zones.Voidstorm},
    {2405, 43.25, 82.75, L.Zones.GrandBeast}
}

local activeWaypoints = {}

-- Print version to chat once the UI is ready
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
    print("|cff00ff00Majestic version " .. addonVersion .. "|r")
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
    elseif msg == "details" then
        DEFAULT_CHAT_FRAME:AddMessage(
            string.format("%s: %s | %s: %s | %s: %s | %s: %s",
                L.Build.Version, addonVersion,
                L.Build.Build, buildNumber,
                L.Build.Interface, interfaceVersion,
                L.Build.Date, buildDate)
        )
        DEFAULT_CHAT_FRAME:AddMessage(string.format(L.Build.LocalizationLoaded, locale))
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
