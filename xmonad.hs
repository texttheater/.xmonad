import LocalConfig

import XMonad
import XMonad.Actions.OnScreen
import XMonad.Config.Gnome
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName (setWMName)
import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders
import XMonad.Util.EZConfig
import XMonad.Util.Run

import qualified Data.Map as M

myKeys =
    [ ((mod4Mask, xK_m), safeSpawn "thunderbird" []),
      ((mod4Mask, xK_f), safeSpawn "firefox" [])
    ]
    ++
    -- Always show workspaces 1-5 on screen 1, 6-9 on screen 2
    -- FIXME does not work when the workspace is switched programmatically,
    -- e.g. when a browser opens a link with an external program which is tied
    -- to a particular workspace (see below)
    let w = workspaces myConfig in
    [ ((mod4Mask, xK_1), windows (viewOnScreen screenForFirstGroup (w!!0))),
      ((mod4Mask, xK_2), windows (viewOnScreen screenForFirstGroup (w!!1))),
      ((mod4Mask, xK_3), windows (viewOnScreen screenForFirstGroup (w!!2))),
      ((mod4Mask, xK_4), windows (viewOnScreen screenForFirstGroup (w!!3))),
      ((mod4Mask, xK_5), windows (viewOnScreen screenForFirstGroup (w!!4))),
      ((mod4Mask, xK_6), windows (viewOnScreen screenForSecondGroup (w!!5))),
      ((mod4Mask, xK_7), windows (viewOnScreen screenForSecondGroup (w!!6))),
      ((mod4Mask, xK_8), windows (viewOnScreen screenForSecondGroup (w!!7))),
      ((mod4Mask, xK_9), windows (viewOnScreen screenForSecondGroup (w!!8)))
    ]

-- fade inactive windows - requires xcompmgr to be running
myLogHook = fadeInactiveLogHook fadeAmount
    where fadeAmount = 1 -- for now, don't fade; full opacity

myConfig = gnomeConfig {
    -- use Windows instead of Alt key
    modMask = mod4Mask,
    startupHook = composeAll [
        startupHook gnomeConfig,
        setFullscreenSupported
    ],
    manageHook = composeAll [
        manageHook gnomeConfig,
        -- open programs on specific workspaces
        className =? "Thunderbird" --> doShift "1",
        className =? "Geary" --> doShift "1",
        className =? "Evince" --> doShift "6",
        className =? "Okular" --> doShift "6",
        className =? "Google-chrome" --> doShift screenForBrowser,
        className =? "google-chrome" --> doShift screenForBrowser,
        className =? "Google-chrome-stable" --> doShift screenForBrowser,
        className =? "chromium-browser" --> doShift screenForBrowser,
        className =? "Chromium-browser" --> doShift screenForBrowser,
        className =? "Firefox" --> doShift screenForBrowser,
        className =? "Mendeley Desktop" --> doShift "8",
        className =? "update-manager" --> doShift "9",
        className =? "Update-manager" --> doShift "9",
        className =? "Steam" --> doShift "9",
        className =? "Deluge" --> doShift "9",
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
    -- Ubuntu colors
    focusedBorderColor = "#504F48",
    normalBorderColor = "#3C3B37",
    -- actually, don't show borders
    borderWidth = 0,
    -- focus follows mouse
    focusFollowsMouse = True
} `additionalKeys` myKeys

setFullscreenSupported :: X ()
setFullscreenSupported = withDisplay $ \dpy -> do
    r <- asks theRoot
    a <- getAtom "_NET_SUPPORTED"
    c <- getAtom "ATOM"
    supp <- mapM getAtom ["_NET_WM_STATE_HIDDEN"
                         ,"_NET_WM_STATE_FULLSCREEN" -- XXX Copy-pasted to add this line
                         ,"_NET_NUMBER_OF_DESKTOPS"
                         ,"_NET_CLIENT_LIST"
                         ,"_NET_CLIENT_LIST_STACKING"
                         ,"_NET_CURRENT_DESKTOP"
                         ,"_NET_DESKTOP_NAMES"
                         ,"_NET_ACTIVE_WINDOW"
                         ,"_NET_WM_DESKTOP"
                         ,"_NET_WM_STRUT"
                         ]
    io $ changeProperty32 dpy r a c propModeReplace (fmap fromIntegral supp)

    setWMName "xmonad"

main = xmonad $ myConfig
