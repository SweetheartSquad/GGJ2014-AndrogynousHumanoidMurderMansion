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

class Thingy extends FlxSprite
{
	
	public var isActive:Bool;
	public var type:ThingyType; 
	public var imgPath:String;
	public var id:Int;
	
	public function new(type:ThingyType, imgPath:String, id:Int ,?isActive:Bool=true) 
	{
		super();
		this.type = type;
		this.imgPath = imgPath;
		this.id = id;
		this.isActive = isActive;
	}
	
	private function makeGraphics()
	{
		this.loadGraphic("imgPath");
	
	}
	
}