package ;

import animation.SpriteSheetHandler;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import openfl.Assets;
import utils.AnimationManager;

/**
 * ...
 * @author Ryan
 */

class Teleporter extends FlxSprite
{
	
	public var isActive:Bool;
	public var type:ThingyType; 
	public var imgPath:String;
	public var id:Int;
	public var relatedId:Int;
	
	public function new(x:Float, y:Float, type:ThingyType, imgPath:String, id:Int,otherId:Int ,?isActive:Bool=true) 
	{
		super();
		this.type = type;
		this.imgPath = imgPath;
		this.id = id;
		this.isActive = isActive;
		this.x = x;
		this.y = y;
		this.relatedId = otherId;
		drawGraphics();
	}
	
	private function drawGraphics()
	{
		if(type == DOOR)
		makeGraphic(20, 30, 0xff00aa11);
		
		if (type == STAIRS)
		makeGraphic(20, 30, 0xffee3311);
		
		if (type == ELEVATOR)
		makeGraphic(20, 30, 0xff224466);
	}
	
	public function isId(id:Int):Bool
	{
		if (id == this.id)
		{
			return true;
		}
		else return false;
		
	}
	
}