-----------------------------------------------------------------------------------------------------------------------
--                                                Rules config                                                       --
-----------------------------------------------------------------------------------------------------------------------

-- Grab environment
local awful =require("awful")

-- Initialize tables and vars for module
-----------------------------------------------------------------------------------------------------------------------
local rules = {}

-- Build rule table
-----------------------------------------------------------------------------------------------------------------------
function rules:build(args)

    local args = args or {}
    local tags = args.tags or {} -- bad !!!

    local user_rules = {
    {
        rule = { class = "Tickr" },
        properties = { border_width = 0, floating = true, sticky = true }
    --    properties = { border_width = 0, floating = true, sticky = true, ontop = true }
    },
    --{
    --    rule = { class = "mpv" },
    --    properties = { border_width = 0, floating = true }
    --    callback = function (c)
    --            c:geometry({ x = 5, y = 965, width = 900 , height = 800 }) end
    --            c:geometry({ x = 2290, y = 965, width = 900 , height = 800 }) end
    --            c:geometry({ x = 1050, y = 965, width = 900 , height = 800 }) end
    --},
    {
        rule = { class = "Anki" },
        properties = { border_width = 0, floating = true },
        callback = function (c)
                c:geometry({ x = 5, y = 550, width = 960 , height = 1200 }) end
    },
    {
        rule = { class = "Smplayer" },
        properties = { border_width = 0, floating = true },
        callback = function (c)
                c:geometry({ x = 5, y = 550, width = 960 , height = 540 }) end
    },
    --{
    --    rule = { class = "Pidgin", role = "buddy_list"},
    --    properties = { tag = tags[1][3], border_width = 0, floating = true, ontop = true },
    --    properties = { tag = tags[1][2], floating=true, switchtotag = false, maximized_vertical=true, ma
    --    callback = function (c)
    --            c:geometry({ x = 2845, y = 0, width = 355 , height = 1760 }) end
    --},
    --{
    --    rule = { class = "Pidgin", role =  "conversation"},
    --    rule_any   = { class = { "pinentry", "Plugin-container", "Acyl.py" } },
    --    properties = { tag = tags[1][3], floating = true },
    --    properties = { tag = tags[1][4], border_width = 0, floating = false, ontop = true },
    --    callback = function (c)
    --            c:geometry({ x = 1500, y = 5, width = 1320 , height = 1750 }) end
    --},
    --{
    --    rule       = { class = "google-chrome" }, except = { role = "google-chrome" },
    --    properties = { border_width = 0, floating = true },
    --    callback = function( c )
    --            c:geometry( { x = 970, y = 0, width = 2220 , height = 1750 }) end
    --},
    {
        rule       = { class = "Emacs" }, except = { role = "emacs" },
        properties = { tag = tags[1][3], border_width = 0, floating = false },
    --    callback = function( c )
    --            c:geometry( { x = 0, y = 0, width = 3100 , height = 1750 }) end
    },
    {
        rule = { class = "Hangups", role = "Terminator" },
        properties = { tag = tags[1][4], floating = false, switchtotag = false }
    },
    {
        rule = { class =  "Firefox" },
        properties = { tag = tags[1][3], switchtotag = false }
    },
    {
        rule = { class = "Mutt" },
        properties = { tag = tags[1][3], switchtotag = true }
    },
    {
        rule = { class = "Weechat" },
        properties = { tag = tags[1][3], switchtotag = false }
    },
    {
        rule = { class = "VirtualBox" },
        properties = { tag = tags[1][4], switchtotag = false }
    },
    {
        rule = { class = "libreoffice" },
        properties = { tag = tags[1][5], floating = false, switchtotag = true }
    },
    {
        rule = { class = "feh" },
        properties = { tag = tags[1][6], floating = false, switchtotag = true }
    },
    {
        rule       = { class = "Gimp" }, except = { role = "gimp-image-window" },
        properties = { floating = true }
    },
    {
        rule       = { class = "Key-mon" },
        properties = { sticky = true }
    },
    {
        rule = { class = "Exaile" },
        callback = function(c)
            for _, exist in ipairs(awful.client.visible(c.screen)) do
                if c ~= exist and c.class == exist.class then
                    awful.client.floating.set(c, true)
                    return
                end
            end
            awful.client.movetotag(tags[1][3], c)
            c.minimized = true
        end
    }
}

    return user_rules
end

-- End
-----------------------------------------------------------------------------------------------------------------------
return rules
