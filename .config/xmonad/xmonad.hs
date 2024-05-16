import XMonad
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.ManageDocks
import XMonad.Util.EZConfig
import XMonad.Util.SpawnOnce
import qualified Data.Map as M
import qualified XMonad.StackSet as W

builtinDisplay = "eDP-1"
dockedDisplay  = "DisplayPort-2"

-- set Command/Super key as mod key
myModMask = mod4Mask

main = xmonad . docks $ withSB myStatusBar $ myConfig

preKeymapConfig = def
  { terminal = "kitty"
  , modMask  = myModMask
  , layoutHook  = myLayoutHook
  , manageHook  = myManageHook
  , startupHook = myStartupHook
  }

myConfig = preKeymapConfig 
  `additionalKeysP` bindings

--
-- Status Bar
--
myStatusBar = statusBarProp "xmobar" (pure xmobarPP)

--
-- key bindings
--
bindings = [ ("M-q", kill)
           , ("M-S-r", restartXMonad)
           , ("M-S-m", switchPrimaryMonitor)
           , ("M-<Space>", spawn "gmrun")
           , ("M1-C-M-<Space>", sendMessage NextLayout) -- Ctrl+Option+Cmd+Space
--            , ("M1-C-M-n", setLayout $ XMonad.layoutHook myConfig) -- Ctrl+Option+Cmd+n
           , ("M1-C-M-t", withFocused toggleFloat) -- Ctrl+Option+Cmd+t
           , ("M-j", windows W.focusUp)
           , ("M-k", windows W.focusDown)
           , ("M-S-j", windows W.swapUp)
           , ("M-S-k", windows W.swapDown)
           , ("<XF86MonBrightnessUp>", brightnessUp)
           , ("<XF86MonBrightnessDown>", brightnessDown)
           , ("<XF86AudioRaiseVolume>", volumeUp)
           , ("<XF86AudioLowerVolume>", volumeDown)
           , ("<XF86AudioMute>", muteToggle)
           , ("<XF86AudioPlay>", playPauseToggle)
           , ("<XF86AudioPrev>", playPrev)
           , ("<XF86AudioNext>", playNext)
           ]

--
-- custom commands
--
restartXMonad = spawn "if type xmonad; then xmonad --recompile && xmonad --restart; else xmessage xmonad not in \\$PATH: \"$PATH\"; fi"
switchPrimaryMonitor = spawn "xrandr --output \"$(xrandr --listactivemonitors | awk '{print $4}' | tail -n1)\" --primary"

brightnessUp = spawn "/run/current-system/sw/bin/light -A 20"
brightnessDown = spawn "/run/current-system/sw/bin/light -U 20"

volumeUp = spawn "/run/current-system/sw/bin/pamixer -i 5"
volumeDown = spawn "/run/current-system/sw/bin/pamixer -d 5"
muteToggle = spawn "/run/current-system/sw/bin/pamixer --toggle-mute"
playPauseToggle = spawn "/run/current-system/sw/bin/playerctl play-pause"
playNext = spawn "/run/current-system/sw/bin/playerctl next"
playPrev = spawn "/run/current-system/sw/bin/playerctl previous"

--
-- hooks
--
myManageHook = manageDocks <+> XMonad.manageHook def
myLayoutHook = avoidStruts $ XMonad.layoutHook def
myStartupHook = do
--   checkKeymap preKeymapConfig bindings
  spawnOnce displaySetupCommand

-- no need to turn brightness down in software for the framework
-- laptop with the fn keys for brightness working:
displaySetupCommand = "xrandr --output " ++ builtinDisplay ++ " --brightness 1.0"


--
-- Helpers
--

toggleFloat :: Window -> X ()
toggleFloat w =
  windows
    ( \s ->
        if M.member w (W.floating s)
          then W.sink w s
          else (W.float w (W.RationalRect (1 / 3) (1 / 4) (1 / 2) (1 / 2)) s)
    )

