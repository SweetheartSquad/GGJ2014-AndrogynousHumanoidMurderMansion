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

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	
	private var _level:FlxTilemap;
	private var _player:FlxSprite;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void{
		//FlxG.mouse.visible = false;
		FlxG.cameras.bgColor = 0xffaaaaaa;
		
		_level = new FlxTilemap();
		_level.loadMap(Assets.getText("assets/level.csv"), FlxTilemap.imgAuto, 0, 0, FlxTilemap.AUTO);
		add(_level);
		
		_player = new FlxSprite(FlxG.width / 2 - 5);
		_player.makeGraphic(8, 8, FlxColor.CRIMSON);
		_player.maxVelocity.set(100, 500);
		_player.acceleration.y = 500;
		_player.drag.x = _player.maxVelocity.x * 8;
		
		//smooth subpixel stuff
		_player.forceComplexRender = true;
		add(_player);
		
		
		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.show();
		#end
		
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
		if (FlxG.keyboard.justPressed("LEFT")){
			_player.acceleration.x = -_player.maxVelocity.x * 8;
		}if (FlxG.keyboard.justPressed("RIGHT")){
			_player.acceleration.x = _player.maxVelocity.x * 8;
		}if (FlxG.keyboard.justPressed("UP") && _player.isTouching(FlxObject.FLOOR)) {
			_player.velocity.y = -_player.maxVelocity.y / 2;
		}
		
		super.update();
		
		//updates here
		
		FlxG.collide(_level, _player);
	}	
}