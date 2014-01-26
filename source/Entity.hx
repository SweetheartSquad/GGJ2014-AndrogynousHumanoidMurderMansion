package ;
import animation.SpriteSheetHandler;
import flash.display.Sprite;
import flash.display.StageQuality;
import flash.display.StageScaleMode;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import utils.AnimationManager;
import flixel.util.FlxColorUtil;

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

class Entity extends FlxSprite {
	private var walkSpeed:Float;
	private var runSpeed:Float;
	//private var health:Int;
	private var attackDmg:Int;
	public var attacking:Bool;
	public var attackTimer:Int;
	private var attackTimerLimit:Int;
	public var interacting:Bool;
	public var running:Bool;
	
	private var idleTimer:Int;
	private var idleTimerLimit:Int;
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
	public var talkBubble:Sprite;
	
	private var animationManagerLegs:AnimationManager;
	private var animationManagerArms:AnimationManager;
	
	private var w:Int;
	private var h:Int;
	private var headSize:Int;
	
	public function new(){
		super();
		
		interacting = false;
		attacking = false;
		running = false;
		
		this.attackTimer = 0;
		this.attackTimerLimit = 9;
		this.idleTimer = 0;
		this.idleTimerLimit = 120;
		
		var temp:Int = Math.round(Reg.gameWidth / 2);
		this.x = Std.random(temp) + Math.round(temp/2);
		this.y = 20;
		this.maxVelocity.set(80, 500);
		this.acceleration.y = 1500;
		this.drag.x = this.maxVelocity.x * 8;
		
		//smooth subpixel stuff
		this.forceComplexRender = false;
		
		generateGraphics();
		
	}
	
	public function generateGraphics() {
		if(this.alive){
			this.velocity.y -= this.maxVelocity.y/5;
			
			w = Std.random(15)+5;
			h = Std.random(25)+10;
			headSize = Math.round(Std.random(w)/3) + 2;
			
			this.maxVelocity.y = 400*30/h;
			
			this.makeGraphic(w, h, 0x000000FF);
			
			primaryColour = FlxColorUtil.makeFromARGB(1.0, Std.random(255), Std.random(255), Std.random(255));
			secondaryColour = Math.random() > 0.5 ? FlxColorUtil.getAnalogousHarmony(primaryColour, Std.random(50)).color2 : FlxColorUtil.getAnalogousHarmony(primaryColour, Std.random(50)).color3;
			
			
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
			animationManagerLegs = new AnimationManager(legs.graphics,"assets/images/legAnimationsHD.png");
			var spriteSheetHandler:SpriteSheetHandler = new SpriteSheetHandler();
			animationManagerLegs.addAnimationState("walk", SpriteSheetHandler.getSpriteArray(360*3, 66*3, 40*3, 23*3, 0, 0, 9, 0), 3);
			animationManagerLegs.addAnimationState("jump", SpriteSheetHandler.getSpriteArray(360*3, 66*3, 40*3, 23*3, 0, 4, 9, 0), 3);
			animationManagerLegs.addAnimationState("idle", SpriteSheetHandler.getSpriteArray(360*3, 66*3, 40*3, 23*3, 0, 2, 2, 0), 15);
			animationManagerLegs.setAnimationState("idle");
			
			legs.scaleY = h/40/3;
			legs.scaleX = w/20/3;
			
			arms = new Sprite();
			Lib.current.stage.addChild(arms);
			
			
			animationManagerArms = new AnimationManager(arms.graphics,"assets/images/armAnimationsHD.png");
			animationManagerArms.addAnimationState("walk", SpriteSheetHandler.getSpriteArray(500*3, 154*3, 50*3, 22*3, 0, 0, 9, 0), 3);
			animationManagerArms.addAnimationState("attack1", SpriteSheetHandler.getSpriteArray(500*3, 154*3, 50*3, 22*3, 0, 9, 8, 0), 3);
			animationManagerArms.addAnimationState("attack2", SpriteSheetHandler.getSpriteArray(500*3, 154*3, 50*3, 22*3, 0, 2, 8, 0), 3);
			animationManagerArms.addAnimationState("idle1", SpriteSheetHandler.getSpriteArray(500*3, 154*3, 50*3, 22*3, 0, 10, 5, 0), 3);
			animationManagerArms.addAnimationState("idle2", SpriteSheetHandler.getSpriteArray(500*3, 154*3, 50*3, 22*3, 0, 4, 10, 0), 3);
			animationManagerArms.addAnimationState("idle3", SpriteSheetHandler.getSpriteArray(500*3, 154*3, 50*3, 22*3, 0, 12, 8, 0), 3);
			animationManagerArms.addAnimationState("idle4", SpriteSheetHandler.getSpriteArray(500*3, 154*3, 50*3, 22*3, 0, 6, 2, 0), 15);
			animationManagerArms.setAnimationState("idle1");
			
			arms.scaleY = h/30/3;
			arms.scaleX = w/10/3;
			
			talkBubble = new Sprite();
			talkBubble.graphics.beginFill(0xFFFFFFFF);
			talkBubble.alpha = 0.0;
			talkBubble.graphics.drawCircle(0, 0, 10);
			talkBubble.graphics.endFill();
			Lib.current.stage.addChild(talkBubble);
			
			body.scaleX *= Reg.zoom;
			body.scaleY *= Reg.zoom;
			head.scaleX *= Reg.zoom;
			head.scaleY *= Reg.zoom;
			legs.scaleX *= Reg.zoom;
			legs.scaleY *= Reg.zoom;
			arms.scaleX *= Reg.zoom;
			arms.scaleY *= Reg.zoom;
			talkBubble.scaleX *= Reg.zoom;
			talkBubble.scaleY *= Reg.zoom;
			
			this.antialiasing = false;
		}
	}
	
	public function destroyGraphics() {
		if(body!=null){
			body.graphics.clear();
			Lib.current.stage.removeChild(body);
			//body = null;
		}
		if(head!=null){
			head.graphics.clear();
			Lib.current.stage.removeChild(head);
			//head = null;
		}
		if(legs!=null){
			legs.graphics.clear();
			Lib.current.stage.removeChild(legs);
			//legs = null;
		}
		if(arms!=null){
			arms.graphics.clear();
			Lib.current.stage.removeChild(arms);
			//arms = null;
		}
		if(talkBubble!=null){
			talkBubble.graphics.clear();
			Lib.current.stage.removeChild(talkBubble);
			//talkBubble = null;
		}
	}
	
	public function jump() {
		if (this.isTouching(FlxObject.FLOOR)) {
			this.velocity.y = -this.maxVelocity.y / 2;
			animationManagerLegs.reset("jump");
		}
		
	}
	public function postUpdate() {
		body.x = (this.x + (this.facing == FlxObject.LEFT ? w : 0))*Reg.zoom;// + (this.facing == FlxObject.LEFT ? -w / 2 : 0);
		body.y = (this.y)*Reg.zoom;
		head.x = body.x + (w/2 * (this.facing == FlxObject.LEFT ? -1 : 1))*Reg.zoom;
		head.y = body.y - headSize/2 * Reg.zoom;
		legs.x = body.x + (body.width*1.5 * (this.facing == FlxObject.LEFT ? -1 : 1));
		legs.y = body.y+body.height;
		arms.x = body.x + (body.width*3.25 * (this.facing == FlxObject.LEFT ? -1 : 1));
		arms.y = body.y + h / 12 * Reg.zoom;
		talkBubble.x = head.x;
		talkBubble.y = head.y - 5 * Reg.zoom;
		if (talkBubble.alpha > 0) {
			talkBubble.alpha -= 0.1;
		}
		
		if (this.isTouching(FlxObject.FLOOR)) {
			if (Math.abs(this.velocity.x) > 1) {
				animationManagerLegs.setAnimationState("walk");
			}else {
				animationManagerLegs.setAnimationState("idle");
			}
			animationManagerLegs.draw();
		}else {
			/*animationManagerLegs.setAnimationState("jump");
			if(animationManagerLegs.currentState.getCurrentFrame()<=5){
				animationManagerLegs.draw();
			}*/
		}
		
		if (this.attacking) {
			animationManagerArms.setAnimationState("attack2");
			idleTimer = 0;
		}else {
			if (this.isTouching(FlxObject.FLOOR)) {
				if (Math.abs(this.velocity.x) > 1) {
					animationManagerArms.setAnimationState("walk");
					idleTimer = 0;
				}else {
					if(idleTimer == 0 || idleTimer == idleTimerLimit){
						idleTimer = 0;
						if(Math.random()>0.75){
							animationManagerArms.setAnimationState("idle" + Std.string(Std.random(3) + 2));
						}else {
							animationManagerArms.setAnimationState("idle4");
						}
					}
					idleTimer += 1;
				}
			}
		}
		animationManagerArms.draw();
		
		body.scaleX = Math.abs(body.scaleX) * (this.facing == FlxObject.LEFT ? -1 : 1);
		head.scaleX = Math.abs(head.scaleX) * (this.facing == FlxObject.LEFT ? -1 : 1);
		legs.scaleX = Math.abs(legs.scaleX) * (this.facing == FlxObject.LEFT ? 1 : -1);
		arms.scaleX = Math.abs(arms.scaleX) * (this.facing == FlxObject.LEFT ? 1 : -1);
	}
	
	public function attackDelay() {
		if(attacking){
			if (this.attackTimer >= this.attackTimerLimit) {
				this.attacking = false;
				this.attackTimer = 0;
			}else {
				this.attackTimer += 1;
			}
		}
	}
	
	override public function kill() {
		this.destroyGraphics();
		super.kill();
		
	}
	
	
	public function updateAggression() {
		if (this.attacking) {
			Reg.aggressionMap.members[Reg.aggressionMap.idx(Math.round(this.x), 0)] += 1;
			for (i in 0...100) {
				if(x+i < Reg.gameWidth){
					Reg.aggressionMap.members[Reg.aggressionMap.idx(Math.round(this.x + i), 0)] += 1/i*2;
				}
				if(x-i > 0){
					Reg.aggressionMap.members[Reg.aggressionMap.idx(Math.round(this.x - i), 0)] += 1/i*2;
				}
			}
		}
	}
}