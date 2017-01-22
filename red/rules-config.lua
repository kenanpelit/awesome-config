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
      --properties = { border_width = 0, floating = true, sticky = true, ontop = true }
    },
    --{
    --  rule = { class = "mpv" },
    --  properties = { border_width = 0, floating = true },
    --  callback = function (c)
    --    c:geometry({ x = 800, y = 300, width = 1600, height = 1200 }) end
    --},
    --{
    --  rule = { class = "Terminator" }, except = { role = "terminator" },
      --properties = { tag = tags[1][1],  border_width = 0, floating = true },
      --properties = { border_width = 0, floating = true },
      --callback = function (c)
       -- c:geometry( { x = 20, y = 20, width = 2260, height = 1700 }) end
    --},
    {
      rule = { class = "mpv" }, except = { role = "gl" },
      properties = { border_width = 0, floating = true, switchtotag = true },
      callback = function (c)
        c:geometry( { x = 2240, y = 440, width = 940, height = 800 }) end
    },
    {
      rule = { class = "Ranger" },
      properties = { tag = tags[1][3], floating = false, switchtotag = true },
      callback = function (c)
        c:geometry( { x = 20, y = 20, width = 2200, height = 1720 }) end
    },
    {
      rule = { class = "Keepassx" },
      properties = { floating = false, switchtotag = true },
      callback = function (c)
        c:geometry( { x = 2240, y = 40, width = 940, height = 1674 }) end
    },
    {
      rule = { class = "Anki" },
      properties = { border_width = 0, floating = true },
      callback = function (c)
        c:geometry({ x = 5, y = 550, width = 960, height = 1200 }) end
    },
    {
      rule = { class = "Smplayer" },
      properties = { border_width = 0, floating = true },
      callback = function (c)
        c:geometry({ x = 5, y = 550, width = 960, height = 540 }) end
    },
    {
      rule = { class = "Google-chrome" }, except = { role = "google-chrome" },
      properties = { tag = tags[1][1],  border_width = 0, floating = true },
      callback = function (c)
        c:geometry( { x = 20, y = 20, width = 2200, height = 1720 }) end
        --c:geometry( { x = 40, y = 40, width = 2300, height = 1674 }) end
    },
    {
      rule = { class = "Emacs" }, except = { role = "emacs" },
      properties = { tag = tags[1][3], border_width = 0, floating = false },
      --callback = function( c )
        --c:geometry( { x = 0, y = 0, width = 3100 , height = 1750 }) end
    },
    {
      rule = { class =  "Xephyr" },
      properties = { tag = tags[1][4], floating = true, switchtotag = true },
      callback = function (c)
        c:geometry({ x = 300, y = 140, width = 2560, height = 1440 }) end
    },
    {
      rule = { class =  "Firefox" },
      properties = { tag = tags[1][3], floating = true, switchtotag = false },
      callback = function (c)
        c:geometry({ x = 800, y = 450, width = 1600, height = 900 }) end
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
      rule = { class = "Gimp" }, except = { role = "gimp-image-window" },
      properties = { floating = true }
    },
    {
      rule = { class = "Key-mon" },
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
