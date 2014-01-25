package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import openfl.Assets;
import utils.GamepadUtil;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	
	private var _level:FlxTilemap;
	private var player1:Player;
	private var player2:Player;
	
	
	//Utils 
	private var gamepadUtilOne:GamepadUtil;
	private var gamepadUtilTwo:GamepadUtil;
	
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void{
		//FlxG.mouse.visible = false;
		FlxG.cameras.bgColor = 0xffaaaaaa;
		
		_level = new FlxTilemap();
		_level.loadMap(Assets.getText("assets/level.csv"), FlxTilemap.imgAuto, 8, 8, FlxTilemap.AUTO);
		add(_level);
		
		player1 = new Player();
		player1.x = 50;
		player1.y = 20;
		player1.maxVelocity.set(80, 500);
		player1.acceleration.y = 1500;
		player1.drag.x = player1.maxVelocity.x * 8;
		
		//smooth subpixel stuff
		player1.forceComplexRender = true;
		add(player1);
		
		player2 = new Player();
		player2.x = 50;
		player2.y = 20;
		player2.maxVelocity.set(80, 500);
		player2.acceleration.y = 500;
		player2.drag.x = player2.maxVelocity.x * 8;
		
		//smooth subpixel stuff
		player2.forceComplexRender = true;
		add(player2);
		
		
		
		//generate npcs
		
		
		
		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.show();
		#end
		
		//Utils
		gamepadUtilOne = new GamepadUtil(0);
		gamepadUtilTwo = new GamepadUtil(1);
		
		super.create();
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void {
		//controls here
		//player1
		player1.acceleration.x = 0;
		if (FlxG.keyboard.anyPressed(["LEFT"]) || (gamepadUtilOne.getAxis() < -0.5 && gamepadUtilOne.getControllerId() == 0)){
			player1.acceleration.x = -player1.maxVelocity.x * 4;
			player1.facing = FlxObject.LEFT;
		}
		if (FlxG.keyboard.anyPressed(["RIGHT"])|| (gamepadUtilOne.getAxis() > 0.5 && gamepadUtilOne.getControllerId() == 0 )){
			player1.acceleration.x = player1.maxVelocity.x * 4;
			player1.facing = FlxObject.RIGHT;
		}
		if ((FlxG.keyboard.justPressed("UP")|| (gamepadUtilOne.getPressedbuttons().exists(0)&& gamepadUtilOne.getControllerId() == 0 )) && player1.isTouching(FlxObject.FLOOR)) {
			player1.velocity.y = -player1.maxVelocity.y / 2;
		}
		if (FlxG.keyboard.justPressed("DOWN")|| (gamepadUtilOne.getPressedbuttons().exists(1)&& gamepadUtilOne.getControllerId() == 0 )) {
			FlxG.overlap(player1, player2, killPlayer);
		}
		if (FlxG.keyboard.anyJustPressed(["SPACE"])|| (gamepadUtilOne.getPressedbuttons().exists(7) && gamepadUtilOne.getControllerId() == 0)) {
			player1.destroyGraphics();
			player1.generateGraphics();
		}
		
		
		//player2
		player2.acceleration.x = 0;
		if (FlxG.keyboard.anyPressed(["A"])|| (gamepadUtilTwo.getAxis() < -0.5 && gamepadUtilTwo.getControllerId() == 1)){
			player2.acceleration.x = -player2.maxVelocity.x * 4;
			player2.facing = FlxObject.LEFT;
		}if (FlxG.keyboard.anyPressed(["D"])|| (gamepadUtilTwo.getAxis() > 0.5 && gamepadUtilTwo.getControllerId() == 1 )){
			player2.acceleration.x = player2.maxVelocity.x * 4;
			player2.facing = FlxObject.RIGHT;
		}if ((FlxG.keyboard.justPressed("W") || (gamepadUtilTwo.getPressedbuttons().exists(0) && gamepadUtilTwo.getControllerId() == 1)) && player2.isTouching(FlxObject.FLOOR)) {
			player2.velocity.y = -player2.maxVelocity.y / 2;
		}if (FlxG.keyboard.anyPressed(["S"]) || (gamepadUtilTwo.getPressedbuttons().exists(1) && gamepadUtilTwo.getControllerId() == 1)) {
			FlxG.overlap(player2, player1, killPlayer);
		}
		if (FlxG.keyboard.anyJustPressed(["SPACE"])|| (gamepadUtilTwo.getPressedbuttons().exists(7) && gamepadUtilTwo.getControllerId() == 1)) {
			player2.destroyGraphics();
			player2.generateGraphics();
		}
		
		
		
		
		super.update();
		
		//updates here
		
		FlxG.collide(_level, player1);
		FlxG.collide(_level, player2);
		
		player1.postUpdate();
		player2.postUpdate();
		
	}
	
	public function killPlayer(Object1:FlxObject,Object2:FlxObject) {
		Object2.kill();
	}
}