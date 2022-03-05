import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.EZConfig
import XMonad.Util.SpawnOnce

builtinDisplay = "eDP"

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
  
myKeys = [ ((myModMask, xK_q), kill)
         , ((myModMask .|. shiftMask, xK_r), spawn "if type xmonad; then xmonad --recompile && xmonad --restart; else xmessage xmonad not in \\$PATH: \"$PATH\"; fi") -- %! Restart xmonad
         ]

myManageHook = manageDocks <+> XMonad.manageHook defaultConfig
myLayoutHook = avoidStruts $ XMonad.layoutHook defaultConfig

myStartupHook = do
  spawnOnce displaySetupCommand

displaySetupCommand = "xrandr --output " ++ builtinDisplay ++ " --brightness 0.5"
