-- vim: ts=8 sts=4 sw=4 noexpandtab
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Accordion
import XMonad.Layout.Circle
import XMonad.Layout.Grid
import XMonad.Layout.NoBorders
import XMonad.Layout.LayoutCombinators hiding ( (|||) )
import XMonad.Layout.Tabbed
import XMonad.Layout.WindowArranger
import XMonad.Layout.PerWorkspace
import XMonad.Util.Run(unsafeSpawn,spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

main = do
    xmproc <- spawnPipe "xmobar"
    xmonad $ defaultConfig
	{ manageHook = manageDocks <+> manageHook defaultConfig
	, workspaces = ["0", "im", "play", "web"] ++
			map show [5..9 :: Int] 
	, layoutHook =	avoidStruts  $  
			onWorkspace "0" sys $
			onWorkspace "im" im $
			onWorkspace "play" play $
			onWorkspace "web" other $
			onWorkspace "9" full $
			other
	, logHook = dynamicLogWithPP xmobarPP
			{ ppOutput = hPutStrLn xmproc
			, ppTitle = xmobarColor "orange" "" . shorten 50
			}
         , normalBorderColor  = "blue"
         , focusedBorderColor = "red"
         , borderWidth = 2
	 , terminal = "urxvt +sb"
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
		  Grid		|||
		  full

	sys	= Grid |||
		  ( noBorders $ Full )

	play	= tiled |||
		  common |||
		  Grid

	im	= tiled

	work	= common 

	common	= ( noBorders $ tabbed shrinkText defaultTheme ) |||
		  Grid

	full	= noBorders Full
	tiled   = Tall 1 (3/100) (90/239)
	tiled2  = Tall 10 (3/100) (90/239)

	--minicom	= tabbed shrinkText defaultTheme **|* Full
--      mytabs    =       tabbed shrinkText (theme smallClean)
--      decorated = simpleFloat' shrinkText (theme smallClean)
--      otherLays = windowArrange   $
--                  magnifier tiled |||
--                  noBorders Full  |||
--                  Mirror tiled    |||
--                  Accordion

