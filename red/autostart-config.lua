-----------------------------------------------------------------------------------------------------------------------
--                                              Autostart app list                                                   --
-----------------------------------------------------------------------------------------------------------------------

-- Grab environment
local awful = require("awful")

-- Initialize tables and vars for module
-----------------------------------------------------------------------------------------------------------------------
local autostart = {}

-- Application list function
--------------------------------------------------------------------------------
function autostart.run()
  -- utils
  --awful.util.spawn_with_shell("/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1")
  --awful.util.spawn_with_shell("gnome-keyring-daemon --daemonize --login")

  -- keyboard layouts
  --awful.util.spawn_with_shell("setxkbmap tr -variant 'f' -option ctrl:nocaps")
  --awful.util.spawn_with_shell("xkbcomp $DISPLAY - | egrep -v 'group . = AltGr;' | xkbcomp - $DISPLAY")

  -- apps
  --awful.util.spawn_with_shell("sleep 1 && synergy")
  --awful.util.spawn_with_shell("sleep 1 && udiskie -ans")
  --awful.util.spawn_with_shell("sleep 3 && tickr")
  --awful.util.spawn_with_shell("goldendict")
  --awful.util.spawn_with_shell("psensor")
  --awful.util.spawn_with_shell("radiotray")
  --awful.util.spawn_with_shell("/usr/bin/dropbox start -i")
  awful.util.spawn_with_shell("compton")
  awful.util.spawn_with_shell("nm-applet")
  awful.util.spawn_with_shell("blueman-applet")
  awful.util.spawn_with_shell("parcellite")
  awful.util.spawn_with_shell("unclutter --timeout 3")
  awful.util.spawn_with_shell("pasystray")
  awful.util.spawn_with_shell("~/.scripta/set-touchpad.sh")
  awful.util.spawn_with_shell("~/.scripta/set-trackpoint.sh")
  awful.util.spawn_with_shell("~/.scripta/set-caps2ctrl.sh")
  awful.util.spawn_with_shell("~/.scripta/set-keyboard.sh")
  awful.util.spawn_with_shell("~/.scripta/start-mail-notify.sh")
  awful.util.spawn_with_shell("paplay ~/.awesome/icq.ogg")

end

-- End
-----------------------------------------------------------------------------------------------------------------------
return autostart
