-- vim:ts=4 expandtab sw=4 sts=4
import XMonad hiding ( (|||) )
import Control.Monad (liftM2)
import qualified XMonad.StackSet as W
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
-- import XMonad.Layout.Grid
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

import XMonad.Layout.Accordion
import XMonad.Layout.Circle
import XMonad.Layout.ComboP
import XMonad.Layout.Grid
import XMonad.Layout.LayoutCombinators
import XMonad.Layout.Magnifier
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.SimpleFloat
import XMonad.Layout.Tabbed
import XMonad.Layout.TwoPane
import XMonad.Layout.ThreeColumns
import XMonad.Prompt.Theme
import XMonad.Layout.WindowArranger
import XMonad.Util.Themes


main = do
    xmproc <- spawnPipe "/home/wayne/.cabal/bin/xmobar /home/wayne/.xmobarrc"
    --xmproc <- spawnPipe "xmobar /home/wayne/.xmobarrc"
    xmonad $ defaultConfig 
        { workspaces            =   ["1:home", "2:var", "3:web", "4:dev"] ++ 
                                    map show [5 .. 7 :: Int] ++ 
                                        ["8:gimp","9:vm"]
        , manageHook            =   manageDocks <+> myManageHook 
        , layoutHook            =   onWorkspace "1:home"            homLay $
                                    onWorkspace "9:vm"              vm_Lay $
                                    onWorkspace "8:gimp"            gmpLay $
                                    onWorkspaces ["4:dev","2:var"]  devLay $
                                                                    stdLay
        , logHook               =   dynamicLogWithPP xmobarPP
			                        { ppOutput = hPutStrLn xmproc
			                        , ppTitle = xmobarColor "white" "" . 
                                        shorten 50
			                        }
        , modMask               = mod4Mask
        , terminal              = "urxvt +sb"
        , focusedBorderColor    = "white"
        } `additionalKeys`
        [ ((mod4Mask .|. shiftMask, xK_w), spawn "xscreensaver-command -lock")
          --,((mod4Mask, xK_b), sendMessage $ SetStruts [minBound .. maxBound] [])
          --,((mod4Mask .|. shiftMask, xK_b), sendMessage $ SetStruts [] [minBound .. maxBound]) 
          , ((mod4Mask, xK_b), sendMessage ToggleStruts)
        ]
    where
      -- composite layouts
      stdLay    = avoidStruts $ (mytabs ||| tiled ||| nbfull ||| Grid)
      devLay    = nbfull ||| (avoidStruts $ mytabs)

      -- singleton layouts
      homLay    = Circle
      vm_Lay    = nbfull
      gmpLay    = combineTwoP (TwoPane 0.04 0.82) (tabbedLayout) 
                    (Accordion) (Title "Toolbox")

      -- layout parts
      mytabs    = tabbed shrinkText (theme smallClean)
      tiled     = Tall nmaster delta ratio
      nbfull    = noBorders Full
      tabbedLayout = tabbedBottomAlways shrinkText (theme smallClean)
        
      -- layout vars
        -- the default number of windows in the master pane
      nmaster = 2
        -- default proportion of screen occupied by master pane
      ratio = 84/127
        -- percent of scrren to increment by when resizing panes
      delta = 3/100
      

-- Window rules:
myManageHook :: ManageHook
myManageHook = composeAll . concat $
    [ 
    [(className =? x <||> title =? x <||> resource =? x) --> 
        doShiftAndGo "9:vbox" | x <- my9Shifts]
    ,  [isDialog --> doFloat]
    , [title =? t --> doFloat | t <- myTFloats]
    , [(className =? x <||> title =? x <||> resource =? x) --> 
        doShiftAndGo "8:media" | x <- my8Shifts]
    , [(className =? "Gimp") --> doShiftAndGo "8:media"]
    ]
        where
            doShiftAndGo = doF . liftM2 (.) W.greedyView W.shift
            myCFloats = ["Ekiga", "MPlayer", "Nitrogen", "Nvidia-settings", "Sysinfo", "XCalc", "XFontSel", "Xmessage"]
            myTFloats = ["Downloads", "Iceweasel Preferences", "Save As..."]
            myRFloats = []
            my8Shifts = ["gimp", "Inkscape"]
            my9Shifts = ["VirtualBox", "Wine"]
