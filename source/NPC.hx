package ;

import flixel.util.FlxPoint;
import flixel.FlxObject;
/**
 * ...
 * @author Sean
 */

class NPC extends Entity{
	public var target:FlxPoint;
	public var targetX:Int;
	public var targetY:Int;
	public function new() {
		super();
		targetX = -1;
		targetY = -1;
	}
	
	public function findPathToTarget() {
		
	}
	
	public function moveAlongPath() {
		if (targetX == -1 || targetY == -1) {
			getRandomTarget();
		}
		if (this.x < targetX) {
			this.acceleration.x = this.maxVelocity.x * 4;
			this.facing = FlxObject.RIGHT;
		}else {
			this.acceleration.x = -this.maxVelocity.x * 4;
			this.facing = FlxObject.LEFT;
		}
		if (Math.abs(this.x - targetX) < 10) {
			getRandomTarget();
		}
		/*if (Std.random(5) == 1) {
			getRandomTarget();
		}*/
		//trace(targetX);
	}
	
	public function getRandomTarget() {
		do {
			targetX = Std.random(Reg.gameWidth - 40) + 20;
			targetY = Std.random(Reg.gameHeight - 40) + 20;
		}while (/*Reg._level.getTile(Math.round(targetX)*8, Math.round(targetY)*8) == 1*/Reg._level.overlapsPoint(new FlxPoint(targetX, targetY)));
	}
}