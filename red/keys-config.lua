-----------------------------------------------------------------------------------------------------------------------
--                                          Hotkeys and mouse buttons config                                         --
-----------------------------------------------------------------------------------------------------------------------

-- Grab environment
local beautiful = require("beautiful")
local awful = require("awful")
local redflat = require("redflat")
local redshift = require("redshift")
local scratch = require("scratch")

-- Redshift - https://github.com/YoRyan/awesome-redshift
-----------------------------------------------------------------------------------------------------------------------
-- set binary path (optional)
redshift.redshift = "/usr/bin/redshift"
-- set additional redshift arguments (optional)
--redshift.options = "-c ~/.config/redshift.conf"
-- 1 for dim, 0 for not dimmed
redshift.init(1)

-- Initialize tables and vars for module
-----------------------------------------------------------------------------------------------------------------------
local hotkeys = { settings = { slave = true}, mouse = {} }

-- key aliases
local sw = redflat.float.appswitcher
local current = redflat.widget.tasklist.filter.currenttags
local allscr = redflat.widget.tasklist.filter.allscreen
local laybox = redflat.widget.layoutbox
local tagsel = awful.tag.selected
local exaile = redflat.float.exaile
local mpd = redflat.float.mpd
local redbar = redflat.titlebar
local gui_editor = "emacsclient -nc -s /tmp/emacs1000/server "

-- key functions
local br = function(args)
  redflat.float.brightness:change_with_gsd(args)
end

local focus_switch_byd = function(dir)
  return function()
    awful.client.focus.bydirection(dir)
    if client.focus then client.focus:raise() end
  end
end

local focus_previous = function()
  awful.client.focus.history.previous()
  if client.focus then client.focus:raise() end
end

local swap_with_master = function()
  if client.focus then client.focus:swap(awful.client.getmaster()) end
end

-- !!! Filters from tasklist used in 'all' functions !!!
-- !!! It's need a custom filter to best performance !!!
local function minimize_all()
  for _, c in ipairs(client.get()) do
    if current(c, mouse.screen) then c.minimized = true end
  end
end

local function restore_all()
  for _, c in ipairs(client.get()) do
    if current(c, mouse.screen) and c.minimized then c.minimized = false end
  end
end

local function kill_all()
  for _, c in ipairs(client.get()) do
    if current(c, mouse.screen) and not c.sticky then c:kill() end
  end
end

local function minimize_all_else(c)
  thisScreen = client.focus.screen
  for _, cc in ipairs(client.get(c.screen)) do
    if current(cc, thisScreen) and cc.window ~= c.window then
      cc.minimized = true
    end
  end
end

local function has_minimized_one_else(c)
  for _, cc in ipairs(client.get(c.screen)) do
    if current(cc, client.focus.screen) and cc.minimized == true then
      return true
    end
  end
end

local function restore_all_else(c)
  for _, cc in ipairs(client.get(c.screen)) do
    if current(cc, client.focus.screen) and cc.minimized then cc.minimized = false end
  end
end

-- numeric key function
local function naction(i, handler, is_tag)
  return function ()
    if is_tag or client.focus then
      local tag = awful.tag.gettags(is_tag and mouse.screen or client.focus.screen)[i]
      if tag then handler(tag) end
    end
  end
end

-- volume functions
local volume_raise = function() redflat.widget.pulse:change_volume({ show_notify = true })              end
local volume_lower = function() redflat.widget.pulse:change_volume({ show_notify = true, down = true }) end
local volume_mute  = function() redflat.widget.pulse:mute() end

--other
local function toggle_placement()
  hotkeys.settings.slave = not hotkeys.settings.slave
  redflat.float.notify:show({
      text = (hotkeys.settings.slave and "Slave" or "Master") .. " placement",
      icon = beautiful.icon and beautiful.icon.warning
  })
end

-- Set key for widgets, layouts and other secondary stuff
-----------------------------------------------------------------------------------------------------------------------

-- custom widget keys
redflat.float.appswitcher.keys.next  = { "a", "A", "Tab" }
redflat.float.appswitcher.keys.prev  = { "q", "Q", }
redflat.float.appswitcher.keys.close = { "Super_L", "Return", "Escape" }

-- layout keys
local resize_keys = {
  resize_up    = { "i", "I", },
  resize_down  = { "k", "K", },
  resize_left  = { "j", "J", },
  resize_right = { "l", "L", },
}

redflat.layout.common.keys = redflat.util.table.merge(redflat.layout.common.keys, resize_keys)
redflat.layout.grid.keys = redflat.util.table.merge(redflat.layout.grid.keys, resize_keys)
redflat.layout.map.keys = redflat.util.table.merge(redflat.layout.map.keys, resize_keys)
redflat.layout.map.keys = redflat.util.table.merge(redflat.layout.map.keys, { last = { "p", "P" } })

-- quick launcher settings
local launcher_keys = {}
for i = 1, 9 do launcher_keys["#" .. tostring(i + 9)] = { app = "", run = "" } end
local launcher_style = { service_hotkeys = { close = { "Escape" }, switch = { "Return" }} }

-- Build hotkeys depended on config parameters
-----------------------------------------------------------------------------------------------------------------------
function hotkeys:init(args)

  local args = args or {}
  self.menu = args.menu or redflat.menu({ items = { {"Empty menu"} } })
  self.mod = args.mod or "Mod4"
  self.qmod = args.qmod or "Mod1"
  self.terminal = args.terminal or "x-terminal-emulator"
  self.layouts = args.layouts
  self.rs = args.rs or "tickr"
  self.nau = args.nau or "nautilus"
  self.clementine = args.clementine or "clementine"
  self.smplayer = args.smp or "smplayer"
  self.termite = args.termite or "termite"
  self.fm = args.fm or "termite --class Ranger -r Ranger -e ranger"
  self.calendar = args.calendar or "termite --class Ranger -r Calcurse -e calcurse"
  self.mpv = args.mpv or "mpv --profile=pseudo-gui"
  self.newsbeuter = args.newsbeuter or "termite -e newsbeuter"
  self.browser = args.browser or "google-chrome-stable %U --force-device-scale-factor=1.4"
  self.keepassx = args.keepassx or "keepassx2"
  self.virtualbox = args.virtualbox or "virtualbox"
  self.rofi = args.rofi or "/bin/sh -c ${HOME}/.scripts/rofi.sh"
  self.alsamix = args.alsamix or "/bin/sh -c ${HOME}/.scripta/start-alsamixer.sh"
  self.pulsemix = args.pulsemix or "/bin/sh -c ${HOME}/.scripta/start-pulsemixer.sh"
  self.buku = args.buku or "/bin/sh -c ${HOME}/.scripta/buku-bookmark.sh"
  self.touchpad = args.touchpad or "/bin/sh -c ${HOME}/.scripta/set-touchpad-toggle.sh"
  self.pulsechange = args.pulsechange or "/bin/sh -c ${HOME}/.scripta/set-pulse-switch-out"
  self.seltr = args.seltr or "/bin/sh -c ${HOME}/.scripta/seltr"
  self.seltrl = args.seltrl or "/bin/sh -c ${HOME}/.scripta/seltr-long"
  self.seltrp = args.seltrp or "/bin/sh -c ${HOME}/.scripta/seltr-long-tr"
  self.weechat = args.weechat or "/bin/sh -c ${HOME}/.scripta/start-weechat.sh"
  self.windows = args.windows or "/bin/sh -c ${HOME}/.scripta/start-windows.sh"
  self.cplay = args.cplay or "/bin/sh -c ${HOME}/.scripta/cplay"
  self.lock = args.lock or "/bin/sh -c ${HOME}/.scripta/start-lock.sh"
  self.mail = args.mail or "/bin/sh -c ${HOME}/.scripta/start-mutt-1.sh"
  --self.emacsnw = args.emacsnw or "/bin/sh -c ${HOME}/.scripta/start-emacs-1.sh"
  self.emacs = args.emacs or "emacs"
  self.gnus = args.gnus or "emacs -f gnus"
  self.mpvf = args.mpvf or "/bin/sh -c ${HOME}/.scripta/series-seinfeld.sh"
  self.mpvm = args.mpvm or "/bin/sh -c ${HOME}/.scripta/series-meet.sh"
  self.ncmpcpp = args.ncmpcpp or "/bin/sh -c ${HOME}/.scripta/start-ncmpcpp2.sh"
  self.off = args.off or "/bin/sh -c ${HOME}/.scripta/start-poweroff.sh"
  self.reboot = args.reboot or "/bin/sh -c ${HOME}/.scripta/start-reboot.sh"
  self.suspend = args.suspend or "/bin/sh -c ${HOME}/.scripta/start-suspend.sh"
  self.hibernate = args.hibernate or "/bin/sh -c ${HOME}/.scripta/start-hibernate.sh"
  self.scrot = args.scrot or "/bin/sh -c ${HOME}/.scripta/start-screenshot.sh"
  self.windowsSave = args.windowsSave or "/bin/sh -c ${HOME}/.scripta/start-windows-save.sh"
  self.lightu = args.lightu or "/bin/sh -c ${HOME}/.scripta/qlight --up"
  self.lightd = args.lightd or "/bin/sh -c ${HOME}/.scripta/qlight --down"
  self.sessionr = args.sessionr or "/bin/sh -c ${HOME}/.scripta/session-r.sh"
  self.sessions = args.sessions or "/bin/sh -c ${HOME}/.scripta/session-s.sh"
  self.need_helper = args.need_helper or true


  -- quick launcher settings
  local launcher_settings = {
    keys = launcher_keys,
    switchmod = { self.mod, self.qmod            },
    setupmod  = { self.mod, self.qmod, "Control" },
    runmod    = { self.mod, self.qmod, "Shift"   }
  }

  redflat.float.qlaunch:init(launcher_settings, launcher_style)

  -- Global keys
  --------------------------------------------------------------------------------
  self.raw_global = {
    { comment = "Power keys" },
    {
      args = { { "Mod1",      "Mod5" }, "0", function () awful.util.spawn(self.off) end },
      comment = "Poweroff"
    },
    {
      args = { { "Mod1",      "Mod5" }, "7", function () awful.util.spawn(self.reboot) end },
      comment = "Reboot"
    },
    {
      args = { { "Mod1",      "Mod5" }, "9", function () awful.util.spawn(self.hibernate) end },
      comment = "Hibernate"
    },
    {
      args = { { "Mod1",      "Mod5" }, "8", function () awful.util.spawn(self.suspend) end },
      comment = "Suspend to RAM"
    },
    {
      args = { {              "Mod5" }, "l", function () awful.util.spawn(self.lock) end },
      comment = "Screen Lock"
    },
    {
      args = { { self.mod,           }, "Z", function () awful.util.spawn(self.sessions) end },
      comment = "Session Save"
    },
    {
      args = { { self.mod,           }, "z", function () awful.util.spawn(self.sessionr) end },
      comment = "Session Restore"
    },
    {
      args = { { self.mod, "Control" }, "r", awesome.restart },
      comment = "Restart awesome"
    },
    { comment = "Series Keys" },
    {
      args = { { "Mod1",      "Mod5" }, "3", function () awful.util.spawn(self.mpvf) end },
      comment = "MPV Series 1"
    },
    {
      args = { { "Mod1",      "Mod5" }, "2", function () awful.util.spawn(self.mpvm) end },
      comment = "MPV Series 2"
    },
    { comment = "Scrachtpad" },
    {
      args = { { self.mod,           }, "t", function() scratch.drop("termite", "top", "center", 0.60, 0.40, true) end },
      comment = "Drop Down Terminal"
    },
    {
      args = { { self.mod,           }, "l", function() scratch.drop("termite --class NCMPCPP -r NCMPCPP -e ncmpcpp", "top", "center", 0.70, 0.50, true) end },
      comment = "Drop Down Ncmpcpp"
    },
    {
      args = { { "Mod1",   "Control" }, "n", function() scratch.drop("nautilus", "top", "center", 0.70, 0.70, true) end },
      comment = "Drop Down Nautilus"
    },
    {
      args = { {              "Mod1" }, "t", function() scratch.drop(self.pulsemix, "top", "center", 0.50, 0.30, true) end },
      comment = "Drop Down Pulsemixer"
    },
    { comment = "Applications Keys" },
    {
      args = { { self.mod,           }, "Return", function () awful.util.spawn(self.terminal) end },
      comment = "Terminator"
    },
    {
      args = { {              "Mod1" }, "v", function () awful.util.spawn(self.browser) end },
      comment = "Browser"
    },
    {
      args = { {              "Mod5" }, "n", function () awful.util.spawn(self.fm) end },
      comment = "Ranger"
    },
    {
      args = { {              "Mod1" }, "n", function () awful.util.spawn(self.nau) end },
      comment = "Nautilus"
    },
    {
      args = { {              "Mod5" }, "p", function () awful.util.spawn(self.cplay) end },
      comment = "Music Pause"
    },
    {
      args = { { self.mod,           }, "u", function () awful.util.spawn(self.rofi) end },
      comment = "Rofi"
    },
    {
      args = { {              "Mod1" }, "c", function () awful.util.spawn(self.seltrl) end },
      comment = "Translate Popup Long"
    },
    {
      args = { {              "Mod1" }, "i", function () awful.util.spawn(self.seltrp) end },
      comment = "Translate Popup Long"
    },
    {
      args = { { self.mod,      "Mod1" }, "b", function () awful.util.spawn(self.buku) end },
      comment = "Buku Add"
    },
    {
      args = { { self.mod,      "Mod1" }, "t", function () awful.util.spawn(self.touchpad) end },
      comment = "TouchPad Toggle"
    },
    {
      args = { {              "Mod5" }, "e", function () awful.util.spawn(self.smplayer) end },
      comment = "Smplayer"
    },
    {
      args = { {              "Mod5" }, "i", function () awful.util.spawn(self.clementine) end },
      comment = "Clementine"
    },
    {
      args = { {              "Mod5" }, "r", function () awful.util.spawn(self.rs) end },
      comment = "Tickr"
    },
    {
      args = { {              "Mod5" }, "t", function () awful.util.spawn(self.emacs) end },
      comment = "Emacs Gui"
    },
    {
      args = { {              "Mod5" }, "s", function () awful.util.spawn(gui_editor) end },
      comment = "Emacs-Client Gui"
    },
    {
      args = { {              "Mod5" }, "m", function () awful.util.spawn(self.gnus) end },
      comment = "Gnus"
    },
    {
      args = { {              "Mod5" }, "k", function () awful.util.spawn(self.keepassx) end },
      comment = "KeepassX"
    },
    {
      args = { {              "Mod5" }, "b", function () awful.util.spawn(self.newsbeuter) end },
      comment = "Newsbeuter"
    },
    {
      args = { {              "Mod5" }, "c", function () awful.util.spawn(self.calendar) end },
      comment = "Calcurse"
    },
    {
      args = { { self.mod,    "Mod5" }, "w", function () awful.util.spawn(self.weechat) end },
      comment = "WeeChat"
    },
    {
      args = { { "Mod1",      "Mod5" }, "v", function () awful.util.spawn(self.virtualbox) end },
      comment = "VirtualBox"
    },
    {
      args = { { "Mod1",      "Mod5" }, "w", function () awful.util.spawn(self.windows) end },
      comment = "Windows VM"
    },
    {
      args = { { "Mod1",      "Mod5" }, "q", function () awful.util.spawn(self.windowsSave) end },
      comment = "Windows VM SaveState"
    },
    {
      args = { {                     }, "Print", function () awful.util.spawn(self.scrot) end },
      comment = "PrintScreen"
    },
    {
      args = { { self.mod,           }, "h", function () hints.focus() end },
      comment = "Hints"
    },
    {
      args = { { self.mod,           }, "b", function () redflat.service.keyboard.handler() end },
      comment = "Window control mode"
    },
    { comment = "Window focus" },
    {
      args = { { self.mod,           }, "l", focus_switch_byd("right"), },
      comment = "Focus right client"
    },
    {
      args = { { self.mod,           }, "j", focus_switch_byd("left"), },
      comment = "Focus left client"
    },
    {
      args = { { self.mod,           }, "i", focus_switch_byd("up"), },
      comment = "Focus client above"
    },
    {
      args = { { self.mod,           }, "k", focus_switch_byd("down"), },
      comment = "Focus client below"
    },
    {
      args = { { self.mod,           }, "u", awful.client.urgent.jumpto, },
      comment = "Focus first urgent client"
    },
    {
      args = { { self.mod,           }, "Tab", focus_previous, },
      comment = "Return to previously focused client"
    },
    { comment = "Tag navigation" },
    {
      args = { { self.mod,           }, "Left", awful.tag.viewprev },
      comment = "View previous tag"
    },
    {
      args = { { self.mod,           }, "Right", awful.tag.viewnext },
      comment = "View next tag"
    },
    {
      args = { { self.mod,           }, "Escape", awful.tag.history.restore },
      comment = "View previously selected tag set"
    },
    { comment = "Widgets" },
    {
      args = { { self.mod,           }, "x", function() redflat.float.top:show() end },
      comment = "Show top widget"
    },
    {
      args = { { self.mod,           }, "w", function() hotkeys.menu:toggle() end },
      comment = "Open main menu"
    },
    {
      args = { { self.mod, self.qmod }, "w", function() redflat.float.qlaunch:show() end },
      comment = "Show quick launch widget"
    },
    {
      args = { { self.mod,           }, "y", function () laybox:toggle_menu(tagsel(mouse.screen)) end },
      comment = "Open layout menu"
    },
    {
      args = { { self.mod            }, "p", function () redflat.float.prompt:run() end },
      comment = "Run prompt"
    },
    {
      args = { { self.mod            }, "r", function() redflat.float.apprunner:show() end },
      comment = "Allication launcher"
    },
    {
      args = { {              "Mod1" }, "e", function() redflat.widget.minitray:toggle() end },
      comment = "Show minitray"
    },
    --{
    --    args = { { self.mod            }, "e", function() exaile:show() end },
    --    comment = "Show exaile widget"
    --},
    {
      args = { { self.mod            }, "e", function() mpd:show() end },
      comment = "Show mpd widget"
    },
    {
      args = { { self.mod            }, "F1", function() redflat.float.hotkeys:show() end },
      comment = "Show hotkeys helper"
    },
    {
      args = { { self.mod, "Control" }, "u", function () redflat.widget.upgrades:update(true) end },
      comment = "Check available upgrades"
    },
    {
      args = { { self.mod, "Control" }, "m", function () redflat.widget.mail:update() end },
      comment = "Check new mail"
    },
    { comment = "Application switcher" },
    {
      args = { { self.mod            }, "a", nil, function() sw:show({ filter = current }) end },
      comment = "Switch to next with current tag"
    },
    {
      args = { { self.mod            }, "q", nil, function() sw:show({ filter = current, reverse = true }) end },
      comment = "Switch to previous with current tag"
    },
    {
      args = { { self.mod, "Control" }, "a", nil, function() sw:show({ filter = allscr }) end },
      comment = "Switch to next through all tags"
    },
    {
      args = { { self.mod, "Control" }, "q", nil, function() sw:show({ filter = allscr, reverse = true }) end },
      comment = "Switch to previous through all tags"
    },
    { comment = "Music player" },
    {
      args = { {                     }, "XF86AudioPlay", function() exaile:action("PlayPause") end },
      comment = "Play/Pause"
    },
    {
      args = { {                     }, "XF86AudioNext", function() exaile:action("Next") end },
      comment = "Next track"
    },
    {
      args = { {                     }, "XF86AudioPrev", function() exaile:action("Prev") end },
      comment = "Previous track"
    },
    {
      args = { { self.mod,   "Shift" }, "l", function () awful.util.spawn(self.ncmpcpp) end },
      comment = "MPD Ncmpcpp"
    },
    {
      args = { { self.mod            }, "F7", function () awful.util.spawn("mpc prev") end },
      comment = "MPD Prev"
    },
    {
      args = { { self.mod            }, "F8", function () awful.util.spawn("mpc toggle") end },
      comment = "MPD Toggle"
    },
    {
      args = { { self.mod            }, "F9", function () awful.util.spawn("mpc next") end },
      comment = "MPD Next"
    },
    {
      args = { { self.mod            }, "F10", function () awful.util.spawn("mpc stop") end },
      comment = "MPD Stop"
    },
    { comment = "Volume control" },
    {
      args = { {                     }, "XF86AudioRaiseVolume", volume_raise },
      comment = "Increase volume"
    },
    {
      args = { {                    }, "XF86AudioLowerVolume", volume_lower },
      comment = "Reduce volume"
    },
    --{
    --  args = { {             "Mod5" }, "f", function () awful.util.spawn(self.alsamix) end },
    --  comment = "Alsamixer"
    --},
    {
      args = { {             "Mod5" }, "a", function () awful.util.spawn(self.pulsemix) end },
      comment = "Pulsemixer"
    },
    {
      args = { { self.mod            }, "F11", function () awful.util.spawn(self.pulsechange) end },
      comment = "Pulse Output Change"
    },
    --{
    --    args = { {                     }, "XF86AudioRaiseVolume", function () awful.util.spawn("pulseaudio-ctl up") end },
    --    args = { {                     }, "XF86AudioRaiseVolume", function () awful.util.spawn("pactl -- set-sink-volume 1 +5%") end },
    --    comment = "Increase volume"
    --},
    --{
    --    args = { {                     }, "XF86AudioLowerVolume", function () awful.util.spawn("pulseaudio-ctl down") end },
    --    args = { {                     }, "XF86AudioLowerVolume", function () awful.util.spawn("pactl -- set-sink-volume 1 -5%") end },
    --    comment = "Reduce volume"
    --},
    {
      args = { { self.mod,            }, "v", volume_mute },
      -- args = { {                     }, "XF86AudioMute", function () awful.util.spawn("pulseaudio-ctl mute") end },
      comment = "Toggle mute"
    },
    { comment = "Brightness control" },
    {
      args = { {                     }, "XF86MonBrightnessUp", function () awful.util.spawn("xbacklight -inc 5") end },
      --args = { {                     }, "XF86MonBrightnessUp", function() br({ step = 5 }) end },
      --args = { {                     }, "XF86MonBrightnessUp", function () awful.util.spawn(self.lightu) end },
      comment = "Increase brightness"
    },
    {
      args = { {                     }, "XF86MonBrightnessDown", function () awful.util.spawn("xbacklight -dec 5") end },
      --args = { {                     }, "XF86MonBrightnessDown", function() br({ step = 5, down = true }) end },
      --args = { {                     }, "XF86MonBrightnessDown", function () awful.util.spawn(self.lightd) end },
      comment = "Reduce brightness"
    },
    {
      args = { { "Mod1",      "Mod5" }, "1", function() redshift.toggle() end },
      comment = "Redshift toggle"
    },
    { comment = "Window manipulation" },
    {
      args = { { self.mod,           }, "F3", toggle_placement },
      comment = "Toggle master/slave placement"
    },
    {
      args = { { self.mod, "Control" }, "Return", swap_with_master },
      comment = "Swap focused client with master"
    },
    {
      args = { { self.mod, "Control" }, "n", awful.client.restore },
      comment = "Restore first minmized client"
    },
    {
      args = { { self.mod, "Shift"   }, "n", minimize_all },
      comment = "Minmize all with current tag"
    },
    {
      args = { { self.mod, "Control", "Shift" }, "n", restore_all },
      comment = "Restore all with current tag"
    },
    {
      args = { { self.mod, "Shift"   }, "F4", kill_all },
      comment = "Kill all with current tag"
    },
    { comment = "Layouts" },
    {
      args = { { self.mod,           }, "k", function () awful.layout.inc(self.layouts, 1) end },
      comment = "Switch to next layout"
    },
    {
      args = { { self.mod, "Shift"   }, "k", function () awful.layout.inc(self.layouts, - 1) end },
      comment = "Switch to previous layout"
    },
    { comment = "Titlebar" },
    {
      args = { { self.mod,           }, "comma", function (c) redbar.toggle_group(client.focus) end },
      comment = "Switch to next client in group"
    },
    {
      args = { { self.mod,           }, "period", function (c) redbar.toggle_group(client.focus, true) end },
      comment = "Switch to previous client in group"
    },
    {
      args = { { self.mod, "Control" }, "t", function (c) redbar.toggle_view(client.focus) end },
      comment = "Toggle focused titlebar view"
    },
    {
      args = { { self.mod,   "Shift" }, "t", function (c) redbar.toggle_view_all() end },
      comment = "Toggle all titlebar view"
    },
    {
      args = { { self.mod, "Control" }, "t", function (c) redbar.toggle(client.focus) end },
      comment = "Toggle focused titlebar visible"
    },
    {
      args = { { self.mod, "Control", "Shift" }, "t", function (c) redbar.toggle_all() end },
      comment = "Toggle all titlebar visible"
    },
    { comment = "Tile control" },
    {
      args = { { self.mod, "Shift"   }, "j", function () awful.tag.incnmaster(1) end },
      comment = "Increase number of master windows by 1"
    },
    {
      args = { { self.mod, "Shift"   }, "l", function () awful.tag.incnmaster(-1) end },
      comment = "Decrease number of master windows by 1"
    },
    {
      args = { { self.mod, "Control" }, "j", function () awful.tag.incncol(1) end },
      comment = "Increase number of non-master columns by 1"
    },
    {
      args = { { self.mod, "Control" }, "l", function () awful.tag.incncol(-1) end },
      comment = "Decrease number of non-master columns by 1"
    },
  }

  -- Client keys
  --------------------------------------------------------------------------------
  self.raw_client = {
    { comment = "Client keys" }, -- fake element special for hotkeys helper
    {
      args = { { self.mod,           }, "f", function (c) c.fullscreen = not c.fullscreen end },
      comment = "Set client fullscreen"
    },
    {
      args = { { self.mod,           }, "s", function (c) c.sticky = not c.sticky end },
      comment = "Toogle client sticky status"
    },
    {
      args = { { self.mod,           }, "F4", function (c) c:kill() end },
      comment = "Kill focused client"
    },
    {
      args = { { self.mod, "Control" }, "f", awful.client.floating.toggle },
      comment = "Toggle client floating status"
    },
    {
      args = { { self.mod,           }, "o", function (c) c.ontop = not c.ontop end },
      comment = "Toggle client ontop status"
    },
    {
      args = { { self.mod,           }, "n", function (c) c.minimized = true end },
      comment = "Minimize client"
    },
    {
      args = { { self.mod,           }, "m", function (c) c.maximized = not c.maximized end },
      comment = "Maximize client"
    },
  }

  -- Bind all key numbers to tags
  --------------------------------------------------------------------------------
  local num_tips = { { comment = "Numeric keys" } } -- this is special for hotkey helper

  local num_bindings = {
    {
      mod     = { self.mod },
      args    = { awful.tag.viewonly, true },
      comment = "Switch to tag"
    },
    {
      mod     = { self.mod, "Control" },
      args    = { awful.tag.viewtoggle, true },
      comment = "Toggle tag view"
    },
    {
      mod     = { self.mod, "Shift" },
      args    = { awful.client.movetotag },
      comment = "Tag client with tag"
    },
    {
      mod     = { self.mod, "Control", "Shift" },
      args    = { awful.client.toggletag },
      comment = "Toggle tag on client"
    },
  }

  -- bind
  self.num = {}

  for k, v in ipairs(num_bindings) do
    -- add fake key to tip table
    num_tips[k + 1] = { args = { v.mod, "1 .. 9" }, comment = v.comment, codes = {} }
    for i = 1, 9 do
      table.insert(num_tips[k + 1].codes, i + 9)
      -- add numerical key objects to global
      self.num = awful.util.table.join(
        self.num, awful.key(v.mod, "#" .. i + 9, naction(i, unpack(v.args)))
      )
    end
  end

  -- Mouse bindings
  --------------------------------------------------------------------------------

  -- global
  self.mouse.global = awful.util.table.join(
    awful.button({}, 3, function () self.menu:toggle() end)
    --awful.button({}, 4, awful.tag.viewnext),
    --awful.button({}, 5, awful.tag.viewprev)
  )

  -- client
  self.mouse.client = awful.util.table.join(
    awful.button({                     }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({                     }, 2, redflat.service.mouse.move),
    awful.button({ self.mod            }, 3, redflat.service.mouse.resize),
    awful.button({                     }, 8, function(c) c:kill() end),
    awful.button({ self.mod            }, 4, function (c) minimize_all_else(c) end),
    awful.button({ self.mod            }, 5,
      function (c)
        if has_minimized_one_else(c) then restore_all_else(c) end
      end
    )
  )

  -- Hotkeys helper setup
  --------------------------------------------------------------------------------
  if self.need_helper then
    redflat.float.hotkeys.raw_keys = awful.util.table.join(self.raw_global, self.raw_client, num_tips)
  end

  self.client = redflat.util.table.join_raw(hotkeys.raw_client, awful.key)
  self.global = redflat.util.table.join_raw(hotkeys.raw_global, awful.key)
  self.global = awful.util.table.join(self.global, hotkeys.num)
  self.global = awful.util.table.join(self.global, redflat.float.qlaunch.hotkeys)
end

-- End
-----------------------------------------------------------------------------------------------------------------------
return hotkeys
