import XMonad
import XMonad.Config.Gnome
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders
import XMonad.Util.EZConfig

import qualified Data.Map as M

-- use Win-o rather than Win-p for gnomeRun to work around this bug:
-- http://ubuntuforums.org/showthread.php?t=2158104&p=12859037#post12859037
myKeys =
    [ ((mod4Mask, xK_o), gnomeRun) ]

-- fade inactive windows - requires xcompmgr to be running
myLogHook = fadeInactiveLogHook fadeAmount
    where fadeAmount = 0.7

main = xmonad $ gnomeConfig {
    -- use Windows instead of Alt key
    modMask = mod4Mask,
    manageHook = composeAll [
        manageHook gnomeConfig,
        -- open programs on specific workspaces
        className =? "Thunderbird" --> doShift "1",
        className =? "Google-chrome" --> doShift "2",
        className =? "Google-chrome-stable" --> doShift "2",
        className =? "Mnemosyne" --> doShift "4",
        -- notice when well-behaved windows go fullscreen
--      fullscreenManageHook, -- doesn't seem to be needed
        -- let fullscreen windows cover the Gnome panels (needed for YouTube
        -- videos)
        isFullscreen --> doFullFloat
    ],
    handleEventHook = composeAll [
        handleEventHook gnomeConfig,
        -- notice when Firefox goes fullscreen
        fullscreenEventHook
    ],
    layoutHook = 
        -- remove borders from windows that are fullscreen (does not yet work
        -- for Firefox) or the only window on the workspace
        smartBorders $
        -- let fullscreen windows cover the Gnome panels (needed for Firefox)
        fullscreenFull $
        layoutHook gnomeConfig,
    logHook = composeAll [
        logHook gnomeConfig,
        myLogHook
    ],
    -- get rid of ugly red
    focusedBorderColor = "#504F48",
    normalBorderColor = "#504F48"
} `additionalKeys` myKeys
