import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.SpawnOnce

builtinDisplay = "eDP"

main = xmonad =<< xmobar myConfig

myConfig = def
  { terminal = "kitty"
  , modMask  = mod4Mask
  , layoutHook  = myLayoutHook
  , manageHook  = myManageHook
  , startupHook = myStartupHook
  }


myManageHook = manageDocks <+> XMonad.manageHook defaultConfig
myLayoutHook = avoidStruts $ XMonad.layoutHook defaultConfig

myStartupHook = do
  spawnOnce displaySetupCommand

displaySetupCommand = "xrandr --output " ++ builtinDisplay ++ " --brightness 0.5"
