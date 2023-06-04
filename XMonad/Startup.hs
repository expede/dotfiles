-- | Startup configuration

module Expede.Startup where

import XMonad
import XMonad.Util.SpawnOnce

startupHook :: X ()
startupHook = do
  spawn "feh --bg-scale ~/Pictures/Wallpaper/695500.png"
