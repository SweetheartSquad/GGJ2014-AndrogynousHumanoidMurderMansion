package ;
import flash.display.Sprite;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;

import flash.Lib;

/**
 * ...
 * @author Sean
 */
enum Facing {
	LEFT;
	RIGHT;
}

enum State {
	IDLE;
	WALKING;
	RUNNING;
}

class Entity extends FlxSprite {
	private var walkSpeed:Float;
	private var runSpeed:Float;
	//private var health:Int;
	private var attackDmg:Int;
	private var state:State;
	private var attacking:Bool;
	private var interacting:Bool;
	//private var facing:Facing;
	
	//appearance
	private var primaryColour:FlxColor;
	private var secondaryColour:FlxColor;
	private var headShape:FlxSprite;
	
	//bodyparts
	private var head:FlxSprite;
	private var body:FlxSprite;
	private var legs:FlxSprite;
	private var sp:Sprite;
	
	public function new(){
		//head.lo
		super();
		sp = new Sprite();
		sp.graphics.beginFill(0xFF0000);
		sp.graphics.drawCircle(0, 0, 5);
		sp.graphics.endFill();
		Lib.current.stage.addChild(sp);
		//head.makeGraphic(12, 2, FlxColor.CRIMSON);
		//body.makeGraphic(10, 5, FlxColor.AZURE);
		//legs.makeGraphic(8, 3, FlxColor.GREEN);
	}
	
	public function postUpdate() {
		sp.x = this.x;
		sp.y = this.y;
	}
}