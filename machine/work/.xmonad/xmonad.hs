-- vim: ts=8 sts=4 sw=4 noexpandtab
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Accordion
import XMonad.Layout.Grid
import XMonad.Layout.NoBorders
import XMonad.Layout.LayoutCombinators hiding ( (|||) )
import XMonad.Layout.Reflect
import XMonad.Layout.Tabbed
import XMonad.Layout.WindowArranger
import XMonad.Layout.PerWorkspace
import XMonad.Util.Run(unsafeSpawn,spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

main = do
    unsafeSpawn "trayer --edge top --align right --SetDockType true --SetPartialStrut true  --expand true --width 10 --transparent true --tint 0x191970 --height 12 &"
    unsafeSpawn "xloadimage -onroot visual/lush-summer_louisville_kentucky.jpg &"
    unsafeSpawn "xscreensaver -no-splash &"
    unsafeSpawn "evolution"
    xmproc <- spawnPipe "xmobar"
    xmonad $ defaultConfig
	{ manageHook = manageDocks <+> manageHook defaultConfig
	, workspaces = ["mail","minicom","web","work","schpcb"] ++
			map show [6..7 :: Int] ++ ["im"] ++ map show [9] 
	, layoutHook =	avoidStruts  $  
			onWorkspace "mail" mail $
			onWorkspace "minicom" minicom $
			onWorkspace "work" work $
			onWorkspace "web" work $
			onWorkspace "schpcb" schpcb $
			onWorkspace "im" im $
			onWorkspace "9" work $
			other
	, logHook = dynamicLogWithPP xmobarPP
			{ ppOutput = hPutStrLn xmproc
			, ppTitle = xmobarColor "green" "" . shorten 50
			}
         , normalBorderColor  = "grey"
         , focusedBorderColor = "green"
	, modMask = mod4Mask
	} `additionalKeys`
	[ ((mod4Mask .|. shiftMask, xK_w), spawn "xscreensaver-command -lock")
	, ((mod4Mask .|. shiftMask, xK_g), spawn "evolution")
	, ((mod4Mask .|. controlMask, xK_t), sendMessage $ ToggleStrut U )
	, ((mod4Mask, xK_b     ), sendMessage ToggleStruts)
	]
    where
      -- layouts
	other	= tiled		|||
		  Mirror tiled	|||
		  Grid	|||
		  noBorders Full	
	mail	= Full **|*** Full
	minicom	= tabbed shrinkText defaultTheme **|* Full
	im	= reflectHoriz $ Grid ***|* tabbed shrinkText defaultTheme 
	schpcb	= Grid |||
		  noBorders Full
	work	= noBorders $
		  tabbed shrinkText defaultTheme |||
		  Full
	tiled   = Tall 1 (3/100) (84/265)
	tiled2  = Tall 10 (3/100) (84/265)

--      mytabs    =       tabbed shrinkText (theme smallClean)
--      decorated = simpleFloat' shrinkText (theme smallClean)
--      otherLays = windowArrange   $
--                  magnifier tiled |||
--                  noBorders Full  |||
--                  Mirror tiled    |||
--                  Accordion

