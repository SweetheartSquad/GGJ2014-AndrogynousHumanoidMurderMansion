package ;

import flixel.FlxSprite;
import Std;
import flixel.util.FlxColorUtil;
import flixel.FlxObject;
/**
 * ...
 * @author Sean
 */
class Particle extends FlxSprite
{
	public var timer:Int;
	public var happy:Bool;
	public function new(X:Float=0, Y:Float=0, Happy:Bool=false) 
	{
		super(X, Y);
		happy = Happy;
		var size:Int = Std.random(3) + 2;
		//this.makeGraphic(size, size, Happy?(FlxColorUtil.makeFromARGB(1.0, Std.random(105)+150, Std.random(105)+150, Std.random(105)+150)):(FlxColorUtil.makeFromARGB(1.0, Std.random(100) + 155, 0, 0)));
		this.makeGraphic(size, size, Happy ? FlxColorUtil.makeFromHSBA(Std.random(360),1,1,1.0) : FlxColorUtil.makeFromHSBA(360-Std.random(10),Math.min(1,Math.random()+0.75),Math.min(1,Math.random()+0.25),1.0));
		this.maxVelocity.set(500, 500);
		this.acceleration.y = 1500;
		this.drag.x = this.maxVelocity.x;
		this.angularVelocity = Std.random(500)-Std.random(500)+25;
		this.angularDrag = this.drag.x;
		this.velocity.x =  Std.random(1500) - Std.random(1500) + 25;
		this.velocity.y =  -Std.random(500) + 25;
		this.elasticity = Math.random();
		//smooth subpixel stuff
		this.forceComplexRender = false;
		this.timer = 0;
	}
	public function postUpdate() {
		if (this.alpha > 0) {
			this.alpha -= 0.0075;
		}else {
			this.kill();
		}
		
		if (this.timer > 0) {
			this.timer -= 1;
		}else {
			this.allowCollisions = FlxObject.ANY;
		}
		
		if (this.elasticity > 0) {
			this.elasticity -= 0.01;
		} else {
			this.elasticity = 0;
		}
	}
}