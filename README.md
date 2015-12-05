.xmonad
=======

My XMonad configuration, used with Gnome Flashback (Metacity) Session on Ubuntu
14.04.

To use, put the `.xmonad` directory into your home directory and configure
Gnome to run these two commands on login, e.g. using
the graphical tool `gnome-session-properties`:

* `xcompmgr` for window fading
* `xmonad --replace` for replacing Metacity with XMonad

Obviously, make sure xcompmgr and xmonad are installed.
