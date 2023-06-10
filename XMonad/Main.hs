-- | @expede's XMonad config

import           XMonad
import           XMonad.Config

-- Colours
-- import Custom.Catppuccin

import Flow

-- Imports for Polybar --
import qualified Codec.Binary.UTF8.String              as UTF8
import qualified DBus                                  as D
import qualified DBus.Client                           as D
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.FadeInactive             ( fadeInactiveLogHook)
import           XMonad.Layout.LayoutModifier
import XMonad.Layout.Spacing
import XMonad.Layout.Renamed as XLR
import XMonad.Layout.ResizableTile
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Accordion
import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.BoringWindows
import XMonad.Layout.Column
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.NoBorders
import XMonad.Layout.PerScreen
import XMonad.Layout.Renamed as XLR
import XMonad.Layout.ResizableTile
import XMonad.Layout.ShowWName
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spacing
import XMonad.Layout.SubLayouts
import XMonad.Layout.Tabbed
import XMonad.Layout.WindowNavigation

import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Util.NamedScratchpad (scratchpadWorkspaceTag)
import XMonad
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks (docks)
-- import XMonad.Hooks.OnPropertyChange (onXPropertyChange)
import XMonad.Hooks.Rescreen (rescreenHook)
import XMonad.Hooks.StatusBar
import XMonad.Hooks.WindowSwallowing (swallowEventHook)
import XMonad.Util.EZConfig
import XMonad.Util.Hacks as Hacks
import XMonad.Util.NamedScratchpad (scratchpadWorkspaceTag)
import XMonad.Util.WorkspaceCompare

import XMonad (spawn)
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP

main :: IO ()
main = do
  dbus <- mkDbusClient
  -- xmonad
  --   . withSB myPolybar'
  --   . docks
  --   . (addEwmhWorkspaceSort (pure (filterOutWs [scratchpadWorkspaceTag])) . ewmh)
  --   $ def { modMask  = super
  --         , terminal = "kitty"
  --         -- Borders
  --         , borderWidth        = 3
  --         , normalBorderColor  = catTeal
  --         , focusedBorderColor = catMauve
  --         -- Hooks
  --         , logHook     = myPolybarLogHook dbus
  --         , layoutHook  = myLayoutHook
  --         , startupHook = do
  --             spawn "polybar top &"
  --             spawn "feh --bg-fill ~/.wallpaper.jpg"
  --         }
  --     `additionalKeys` keyBindings
  keyBindings
    |> additionalKeys def
      { modMask  = super
      , terminal = "kitty"

      -- Borders
      , borderWidth        = 3
      , normalBorderColor  = catTeal
      , focusedBorderColor = catMauve

      -- Hooks
      , logHook     = myPolybarLogHook dbus
      , layoutHook  = myLayoutHook
      , startupHook = do
          spawn "polybar top &"
          spawn "feh --bg-fill ~/.wallpaper.jpg"
      }
    |> (addEwmhWorkspaceSort (pure (filterOutWs [scratchpadWorkspaceTag])) . ewmh)
    |> docks
    |> withSB myPolybar'
    |> xmonad
  where
    super :: KeyMask
    super = mod4Mask

    keyBindings :: [((KeyMask, KeySym), X ())]
    keyBindings = [((super, xK_o), spawn appLauncher)]

appLauncher :: String
appLauncher  = "rofi -modi drun,ssh,window -show drun -show-icons"

myLayoutHook =
  boringWindows (ifWider 1080 (tall ||| bsp) (column ||| accordion) ||| sf ||| full)
    |> mkToggle (NOBORDERS ?? FULL ?? EOT)
    |> smartBorders
    |> showWName' myShowWNameConfig

mySpacing i = spacingRaw False (Border 10 10 30 30) True (Border i i i i) True

full = renamed [XLR.Replace "Monocle"] $ noBorders Full
tabs =
  renamed [XLR.Replace "Tabs"] $
    avoidStruts $
      tabbed
        shrinkText
        def -- myTabConfig

myTabConfig = def
column =
  renamed [XLR.Replace "Column"] $
    avoidStruts $
      windowNavigation $
        addTabs shrinkText myTabConfig $
          subLayout [] tabs $
            mySpacing 7 $
              Column 1.0

myShowWNameConfig :: SWNConfig
myShowWNameConfig =
  def { swn_font    = "xft:Vanilla Caramel:size=60"
      , swn_color   = catLavender
      , swn_bgcolor = catBase
      , swn_fade    = 0.8
      }

bsp =
  renamed [XLR.Replace "BSP"] $
    avoidStruts $
      windowNavigation $
        addTabs shrinkText myTabConfig $
          subLayout [] tabs $
            mySpacing 7 emptyBSP

sf = renamed [XLR.Replace "Float"] $ noBorders simplestFloat

accordion =
  renamed [XLR.Replace "Accordion"] $
    avoidStruts $
      windowNavigation $
        addTabs shrinkText myTabConfig $
          subLayout [] tabs $
            mySpacing 7 Accordion
tall =
  renamed [XLR.Replace "Tall"] $
    avoidStruts $
      windowNavigation $
        addTabs shrinkText def $ -- myTabConfig $
          subLayout [] tabs $
            mySpacing 7 $
              ResizableTall nmaster delta ratio []
  where
    nmaster = 1
    ratio   = 1 / 2
    delta   = 3 / 100

-- Polybar settings (needs DBus client) --
mkDbusClient :: IO D.Client
mkDbusClient = do
  dbus <- D.connectSession
  D.requestName dbus (D.busName_ "org.xmonad.log") [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]
  return dbus

-- Emit a DBus signal on log updates
dbusOutput :: D.Client -> String -> IO ()
dbusOutput dbus str = D.emit dbus $ signal { D.signalBody = body }
  where
    opath  = D.objectPath_ "/org/xmonad/Log"
    iname  = D.interfaceName_ "org.xmonad.Log"
    mname  = D.memberName_ "Update"
    signal = D.signal opath iname mname
    body   = [D.toVariant $ UTF8.decodeString str]

polybarHook :: D.Client -> PP
polybarHook dbus =
  let wrapper c s | s /= "NSP" = wrap ("%{F" <> c <> "} ") " %{F-}" s
                  | otherwise  = mempty
      blue   = "#2E9AFE"
      gray   = "#7F7F7F"
      orange = "#ea4300"
      purple = "#9058c7"
      red    = "#722222"
  in  def { ppOutput          = dbusOutput dbus
          , ppCurrent         = wrapper blue
          , ppVisible         = wrapper gray
          , ppUrgent          = wrapper orange
          , ppHidden          = wrapper gray
          , ppHiddenNoWindows = wrapper red
          , ppTitle           = wrapper purple . shorten 90
          }

myPolybarLogHook dbus = myLogHook <+> dynamicLogWithPP (polybarHook dbus)

-- ALT

myPolybar' :: StatusBarConfig
myPolybar' =
  def { sbLogHook = do
          pb <- dynamicLogString polybarPP'
          xmonadPropLog pb
      , sbStartupHook = spawn "~/.config/polybar/launch.sh"
      , sbCleanupHook = spawn "killall polybar"
      }

polybarPP' :: PP
polybarPP' =
  def { ppCurrent = textColor' "" . wrap "" ""
      , ppOrder = \(_ : l : _ : _) -> [l]
      }

textColor' :: String -> String -> String
textColor' color = wrap ("%{F" <> color <> "}") " %{F-}"

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook = fadeInactiveLogHook 0.9

catRosewater, catFlamingo, catPink, catMauve, catRed, catMaroon, catPeach, catYellow, catGreen, catTeal, catSky, catSapphire, catBlue, catLavender, catText, catSubtext1, catSubtext0, catOverlay2, catOverlay1, catOverlay0, catSurface2, catSurface1, catSurface0, catBase, catMantle, catCrust :: String

catRosewater = "#f5e0dc"
catFlamingo = "#f2cdcd"
catPink = "#f5c2e7"
catMauve = "#cba6f7"
catRed = "#f38ba8"
catMaroon = "#eba0ac"
catPeach = "#fab387"
catYellow = "#f9e2af"
catGreen = "#a6e3a1"
catTeal = "#94e2d5"
catSky = "#89dceb"
catSapphire = "#74c7ec"
catBlue = "#89b4fa"
catLavender = "#b4befe"
catText = "#cdd6f4"
catSubtext1 = "#bac2de"
catSubtext0 = "#a6adc8"
catOverlay2 = "#9399b2"
catOverlay1 = "#7f849c"
catOverlay0 = "#6c7086"
catSurface2 = "#585b70"
catSurface1 = "#45475a"
catSurface0 = "#313244"
catBase = "#1e1e2e"
catMantle = "#181825"
catCrust = "#11111b"
