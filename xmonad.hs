import XMonad
import XMonad.Config.Gnome
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.NoBorders

import qualified Data.Map as M

main = xmonad gnomeConfig {
    -- use Windows instead of Alt key
    modMask = mod4Mask,
    manageHook = composeAll [
        manageHook gnomeConfig,
        -- open programs on specific workspaces
        className =? "Thunderbird" --> doShift "1",
        className =? "Firefox" --> doShift "2",
        className =? "Skype" --> doShift "8",
        -- let fullscreen windows cover the Gnome panels
        isFullscreen --> doFullFloat
    ],
    -- remove borders from fullscreen windows (etc.)
    layoutHook = smartBorders $ layoutHook gnomeConfig
}
