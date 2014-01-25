package ;
import animation.SpriteSheetHandler;
import flash.display.Sprite;
import flixel.FlxG;
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
	private var primaryColour:FlxColor;
	private var secondaryColour:FlxColor;
	private var headShape:FlxSprite;
	
	//bodyparts
	private var head:Sprite;
	private var body:Sprite;
	private var arms:Sprite;
	private var legs:Sprite;
	
	private var animationManagerLegs:AnimationManager;
	private var animationManagerArms:AnimationManager;
	
	private var w:Int;
	private var h:Int;
	private var headSize:Int;
	
	public function new(){
		super();
		
		w = Std.random(5)+5;
		h = Std.random(10)+10;
		headSize = Std.random(3)+2;
		this.makeGraphic(w, h);
		
		head = new Sprite();
		head.graphics.beginFill(0xFF00FF);
		head.graphics.drawCircle(0, 0, headSize);
		head.graphics.endFill();
		Lib.current.stage.addChild(head);
		
		body = new Sprite();
		body.graphics.beginFill(0xFF00FF);
		body.graphics.drawRect(0, 0, w, h/2);
		body.graphics.endFill();
		Lib.current.stage.addChild(body);
		
		legs = new Sprite();
		Lib.current.stage.addChild(legs);
		animationManagerLegs = new AnimationManager(legs.graphics,"assets/images/animation/legAnim.png");
		var spriteSheetHandler:SpriteSheetHandler = new SpriteSheetHandler();
		animationManagerLegs.addAnimationState("idle", SpriteSheetHandler.getSpriteArray(40, 20, 20, 20, 0, 0, 2, 0), 15);
		animationManagerLegs.setAnimationSate("idle");
		
		arms = new Sprite();
		Lib.current.stage.addChild(arms);
		animationManagerArms = new AnimationManager(arms.graphics,"assets/images/animation/armAnim.png");
		var spriteSheetHandler:SpriteSheetHandler = new SpriteSheetHandler();
		animationManagerArms.addAnimationState("idle", SpriteSheetHandler.getSpriteArray(40, 20, 20, 20, 0, 0, 2, 0), 15);
		animationManagerArms.setAnimationSate("idle");
		
	}
	
	public function postUpdate() {
		//trace(sp.x,this.x);
		head.x = this.x;
		head.y = this.y;
		body.x = this.x;
		body.y = this.y;
		/*legs.x = body.x;
		legs.y = body.y;
		arms.x = body.x;
		arms.y = body.y;*/
		animationManagerLegs.draw();
		animationManagerArms.draw();
	}
}