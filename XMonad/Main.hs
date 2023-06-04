-- | @expede's XMonad config

module Expede.Main where

import           XMonad
import           XMonad.Config

main :: IO ()
main =
  xmonad def
    { modMask = mod4Mask -- Use Super instead of Alt
    , terminal = "kitty"
    -- more changes
    }
