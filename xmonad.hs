import XMonad
import XMonad.Config.Gnome
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.NoBorders

import qualified Data.Map as M

-- use Win-o rather than Win-p for gnomeRun to avoid this bug:
-- http://ubuntuforums.org/showthread.php?t=2158104&p=12859037#post12859037
myKeys (XConfig {modMask = mod4Mask}) = M.fromList $
    [ ((mod4Mask, xK_o), gnomeRun) ]

main = xmonad gnomeConfig {
    -- use Windows instead of Alt key
    modMask = mod4Mask,
    -- add custom key bindings (see above)
    keys = myKeys <+> keys gnomeConfig,
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
