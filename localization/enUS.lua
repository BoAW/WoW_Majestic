Majestic_Locale_enUS = {
    Build = {
        Version = "Version",
        Build = "Build",
        Date = "Date",
        Interface = "Interface",
        LocalizationLoaded = "Localization loaded for locale: %s",
        LocalizationNotFound = "Localization table not found for locale: %s",
        MonthNames = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"}
    },
    Help = {
        Label1 = "Usage: /majestic or /mj",
        Label2 = "Options:",
        Label3 = "  ? or help - Show this help message",
        Label4 = "  all - Check status and add waypoints for all quests",
        Label5 = "  clear - Remove all Majestic waypoints",
        Label6 = "  details - Show add-on version, build information and localization status",
        Label7 = "  status - Check quest status",
        Label8 = "  way - Check status, add waypoints for incomplete and remove completed",
        ClearDone = "Majestic waypoints (TomTom) cleared.",
        VersionLoaded = "Majestic version %s",
        NoTomTom = "Majestic: TomTom is not installed. Waypoint features will not work.",
        DebugPrefix = "Majestic debug: ",
        DebugOn  = "ON",
        DebugOff = "OFF"
    },
    Zones = {
        Eversong = "Eversong (Ghostclaw Elder)",
        GrandBeast = "Voidstorm – Grand Beast Lure (Netherscythe)",
        Harandar = "Harandar (Lumenfin)",
        Voidstorm = "Voidstorm (Umbrafang)",
        ZulAman = "Zul'Aman (Silverscale)",
    },    -- Keywords matched (case-insensitive substring) against the tooltip title
    -- of lure spells/items in the Skinning spellbook. One entry per beast,
    -- ordered to match the quest array: Eversong, Zul'Aman, Harandar, Voidstorm, Grand Beast.
    LureKeywords = {"eversong", "zul", "harandar", "voidstorm", "grand"},
    Tooltip = {
        UsedToday = "Skinned today",
        Available  = "Available",
        WaypointAdd    = "[+] Waypoint",
        WaypointRemove = "[x] Waypoint",
    },
    Arrow = {
        GoTo = "Go to %s",
    },
    Menu = {
        Title         = "Majestic Arrow",
        Lock          = "Lock",
        Unlock        = "Unlock",
        Size          = "Size...",
        BgColor       = "Background Color...",
        RemoveCurrent = "Remove Current",
        RemoveAll     = "Remove All",
        SizesTitle    = "Sizes",
    },
}
