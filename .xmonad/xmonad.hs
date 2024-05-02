import XMonad
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.ManageDocks
import XMonad.Util.EZConfig
import XMonad.Util.SpawnOnce

builtinDisplay = "eDP"
dockedDisplay  = "DisplayPort-2"

-- set Command/Super key as mod key
modMask = mod4Mask

main = xmonad $ xmobarProp config

config = def
  { terminal = "kitty"
  , modMask  = modMask
  , layoutHook  = layoutHook
  , manageHook  = manageHook
  , startupHook = startupHook
  }
  `additionalKeysP` bindings

--
-- key bindings
--
bindings cfg = [ ("M-q", kill)
               , ("M-S-r", restartXMonad)
               , ("M-S-m", switchPrimaryMonitor)
               , ("M-<Space>", spawn "gmrun")
               , ("M1-C-M-<Space>", sendMessage NextLayout) -- Ctrl+Option+Cmd+Space
               , ("M-j", windows W.focusUp)
               , ("M-k", windows W.focusDown)
               , ("M-S-j", windows W.swapUp)
               , ("M-S-k", windows W.swapDown)
               ]

--
-- custom commands
--
restartXMonad = spawn "if type xmonad; then xmonad --recompile && xmonad --restart; else xmessage xmonad not in \\$PATH: \"$PATH\"; fi"
switchPrimaryMonitor = spawn "xrandr --output \"$(xrandr --listactivemonitors | awk '{print $4}' | tail -n1)\" --primary"

--
-- hooks
--
manageHook = manageDocks <+> XMonad.manageHook defaultConfig
layoutHook = avoidStruts $ XMonad.layoutHook defaultConfig
startupHook = do
  checkKeymap config (bindings config)
  spawnOnce displaySetupCommand

displaySetupCommand = "xrandr --output " ++ builtinDisplay ++ " --brightness 0.5"
