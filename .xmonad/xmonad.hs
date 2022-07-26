import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.EZConfig
import XMonad.Util.SpawnOnce

builtinDisplay = "eDP"
dockedDisplay  = "DisplayPort-2"

-- set Command/Super key as mod key
myModMask = mod4Mask

main = xmonad =<< xmobar myConfig

myConfig = def
  { terminal = "kitty"
  , modMask  = myModMask
  , layoutHook  = myLayoutHook
  , manageHook  = myManageHook
  , startupHook = myStartupHook
  }
  `additionalKeys` myKeys

--
-- key bindings
--
myKeys = [ ((myModMask, xK_q), kill)
         , ((myModMask .|. shiftMask, xK_r), restartXMonad)
         , ((myModMask .|. shiftMask, xK_m), switchPrimaryMonitor)
         ]

--
-- custom commands
--
restartXMonad = spawn "if type xmonad; then xmonad --recompile && xmonad --restart; else xmessage xmonad not in \\$PATH: \"$PATH\"; fi"
switchPrimaryMonitor = spawn "xrandr --output \"$(xrandr --listactivemonitors | awk '{print $4}' | tail -n1)\" --primary"

--
-- hooks
--
myManageHook = manageDocks <+> XMonad.manageHook defaultConfig
myLayoutHook = avoidStruts $ XMonad.layoutHook defaultConfig
myStartupHook = spawnOnce displaySetupCommand

displaySetupCommand = "xrandr --output " ++ builtinDisplay ++ " --brightness 0.5"
