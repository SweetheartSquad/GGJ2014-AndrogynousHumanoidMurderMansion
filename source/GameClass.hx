package;

import flash.Lib;
import flixel.FlxGame;
import flixel.FlxState;

class GameClass extends FlxGame
{
	var actualGameWidth:Int = 720; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var actualGameHeight:Int = 480; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var initialState:Class<FlxState> = MenuState; // The FlxState the game starts with.
	var framerate:Int = 60; // How many frames per second the game should run at.
	var skipSplash:Bool = false; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets

	/**
	 * You can pretty much ignore this logic and edit the variables above.
	 */
	public function new()
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		var ratioX:Float = stageWidth / actualGameWidth;
		var ratioY:Float = stageHeight / actualGameHeight;
		Reg.zoom = Math.min(ratioX, ratioY);
		Reg.gameWidth = Math.ceil(stageWidth / Reg.zoom);
		Reg.gameHeight = Math.ceil(stageHeight / Reg.zoom);

		super(Reg.gameWidth, Reg.gameHeight, initialState, Reg.zoom, framerate, framerate, skipSplash, startFullscreen);
	}
}
