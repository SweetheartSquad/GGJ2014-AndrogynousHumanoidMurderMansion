package ;
import animation.SpriteSheetHandler;
import flash.display.Sprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import utils.AnimationManager;

import flash.Lib;
import Std;
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
	private var primaryColour:Int;
	private var secondaryColour:Int;
	private var headShape:FlxSprite;
	
	//bodyparts
	private var body:Sprite;
	private var head:Sprite;
	private var arms:Sprite;
	private var legs:Sprite;
	
	private var animationManagerLegs:AnimationManager;
	private var animationManagerArms:AnimationManager;
	
	private var w:Int;
	private var h:Int;
	private var headSize:Int;
	
	public function new(){
		super();
		
		this.x = 50;
		this.y = 20;
		this.maxVelocity.set(80, 500);
		player2.acceleration.y = 1500;
		this.drag.x = this.maxVelocity.x * 8;
		
		//smooth subpixel stuff
		this.forceComplexRender = true;
		
		generateGraphics();
		
	}
	
	public function generateGraphics() {
		
		
		w = Std.random(5)+5;
		h = Std.random(10)+15;
		headSize = Std.random(3) + 2;
		this.makeGraphic(w, h, 0x330000FF);
		
		primaryColour = Std.random(16777215);
		secondaryColour = Std.random(16777215);
		
		body = new Sprite();
		body.graphics.beginFill(primaryColour);
		body.graphics.drawRect(0, 0, w, h/2);
		body.graphics.endFill();
		Lib.current.stage.addChild(body);
		
		head = new Sprite();
		head.graphics.beginFill(secondaryColour);
		head.graphics.drawCircle(0, 0, headSize);
		head.graphics.endFill();
		Lib.current.stage.addChild(head);
		
		legs = new Sprite();
		Lib.current.stage.addChild(legs);
		animationManagerLegs = new AnimationManager(legs.graphics,"assets/images/animation/legAnim.png");
		var spriteSheetHandler:SpriteSheetHandler = new SpriteSheetHandler();
		animationManagerLegs.addAnimationState("idle", SpriteSheetHandler.getSpriteArray(40, 20, 20, 20, 0, 0, 2, 0), 15);
		animationManagerLegs.setAnimationSate("idle");
		
		legs.scaleY = (h/20)/2;
		legs.scaleX = (w/20);
		
		arms = new Sprite();
		Lib.current.stage.addChild(arms);
		animationManagerArms = new AnimationManager(arms.graphics,"assets/images/animation/armAnim.png");
		var spriteSheetHandler:SpriteSheetHandler = new SpriteSheetHandler();
		animationManagerArms.addAnimationState("idle", SpriteSheetHandler.getSpriteArray(40, 20, 20, 20, 0, 0, 2, 0), 15);
		animationManagerArms.setAnimationSate("idle");
		
		arms.scaleY = (h/20)/1.5;
		arms.scaleX = (w/20)*1.5;
	}
	
	public function destroyGraphics() {
		body.graphics.clear();
		head.graphics.clear();
		legs.graphics.clear();
		arms.graphics.clear();
		
		Lib.current.stage.removeChild(body);
		Lib.current.stage.removeChild(head);
		Lib.current.stage.removeChild(legs);
		Lib.current.stage.removeChild(arms);
		
		body = null;
		head = null;
		legs = null;
		arms = null;
	}
	
	public function postUpdate() {
		//trace(sp.x,this.x);
		body.x = this.x + (this.facing == FlxObject.LEFT ? w : 0);// + (this.facing == FlxObject.LEFT ? -w / 2 : 0);
		body.y = this.y;
		head.x = body.x;
		head.y = body.y;
		legs.x = body.x;
		legs.y = body.y+body.height;
		arms.x = body.x;
		arms.y = body.y;
		animationManagerLegs.draw();
		animationManagerArms.draw();
		
		body.scaleX = Math.abs(body.scaleX) * (this.facing == FlxObject.LEFT ? -1 : 1);
		head.scaleX = Math.abs(head.scaleX) * (this.facing == FlxObject.LEFT ? -1 : 1);
		legs.scaleX = Math.abs(legs.scaleX) * (this.facing == FlxObject.LEFT ? -1 : 1);
		arms.scaleX = Math.abs(arms.scaleX) * (this.facing == FlxObject.LEFT ? -1 : 1);
	}
}