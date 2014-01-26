package;

import flash.Lib;
import flixel.FlxGame;
import flixel.FlxState;

class GameClass extends FlxGame
{
	var initialState:Class<FlxState> = MenuState; // The FlxState the game starts with.
	var framerate:Int = 60; // How many frames per second the game should run at.
	var skipSplash:Bool = true; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = true; // Whether to start the game in fullscreen on desktop targets

	/**
	 * You can pretty much ignore this logic and edit the variables above.
	 */
	public function new()
	{
		Reg.gameWidth = 720; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
		Reg.gameHeight = 405; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		var ratioX:Float = stageWidth / Reg.gameWidth;
		var ratioY:Float = stageHeight / Reg.gameHeight;
		Reg.zoom = Math.min(ratioX, ratioY);
		var actualGameWidth:Int = Math.ceil(stageWidth / Reg.zoom);
		var actualGameHeight:Int = Math.ceil(stageHeight / Reg.zoom);

		super(actualGameWidth, actualGameHeight, initialState, Reg.zoom, framerate, framerate, skipSplash, startFullscreen);
	}
}
