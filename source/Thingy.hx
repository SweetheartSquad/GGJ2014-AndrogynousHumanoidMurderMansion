package ;

import animation.SpriteSheetHandler;
import flash.display.Sprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import utils.AnimationManager;

/**
 * ...
 * @author Ryan
 */
enum ThingyType {
	
	LADDER;
	ELEVATOR;
	STAIRS;
	DOOR;
	LEVER;
	TRAPDOOR;
}
 
class Thingy extends FlxSprite
{
	
	public var isActive:Bool;
	public var type:ThingyType; 
	public var imgPath:String;
	
	public function new(type:ThingyType, imgPath:String, ?isActive:Bool=true) 
	{
		
	}
	
	
	
}