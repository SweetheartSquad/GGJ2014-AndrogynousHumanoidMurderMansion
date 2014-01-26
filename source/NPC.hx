package ;

import flash.display.Bitmap;
import flixel.util.FlxPoint;
import flixel.FlxObject;
/**
 * ...
 * @author Sean
 */
enum NpcType {
	COWARD;
	CIVILIAN;
}
class NPC extends Entity{
	public var target:FlxPoint;
	public var targetX:Int;
	public var targetY:Int;
	public var type:NpcType;
	
	public var aggressionTolerance:Float;
	
	public var randomTargetTimer:Int;
	public var randomTargetTimerLimit:Int;
	public var targetTimer:Int;
	public var targetTimerLimit:Int;
	
	public function new() {
		super();
		targetX = -1;
		targetY = -1;
		
		this.type = NpcType.COWARD;
		this.aggressionTolerance = 0.1;
		this.randomTargetTimer = 0;
		this.randomTargetTimerLimit = 180;
		this.targetTimer = 0;
		this.targetTimerLimit = 60;
		//this.type = Math.random() > 0.9 ? NpcType.CIVILIAN : NpcType.COWARD;
	}
	
	public function moveAlongPath() {
		if (this.x < targetX) {
			this.acceleration.x = this.maxVelocity.x * (this.running ? 8 : 4) ;
			this.facing = FlxObject.RIGHT;
		}else {
			this.acceleration.x = -this.maxVelocity.x * (this.running ? 8 : 4);
			this.facing = FlxObject.LEFT;
		}
		if (Math.abs(this.x - targetX) < 10) {
			//getRandomTarget();
			this.acceleration.x = 0;
		}
		/*if (Std.random(5) == 1) {
			getRandomTarget();
		}*/
		//trace(targetX);
	}
	public function setTarget(_x, _y) {
		targetX = _x;
		targetY = _y;
	}
	public function getRandomTarget() {
		//do {
			var temp:Int = Math.round(Reg.gameWidth / 2);
			targetX = Std.random(temp) + Math.round(temp/2);
			targetY = Std.random(Reg.gameHeight - 40) + 20;
		//}while (/*Reg._level.getTile(Math.round(targetX)*8, Math.round(targetY)*8) == 1*/Reg._level.overlapsPoint(new FlxPoint(targetX, targetY)));
	}
	
	public function tryJump() {
		if (Math.random() < 0.001) {
			this.jump();
		}
	}
	public function tryInteract() {
		if (Math.random() < 0.025) {
			this.interacting = true;
		}
	}
	public function tryAttack() {
		if(type != NpcType.COWARD){
			if (Math.random() < 0.0001) {
				this.attacking = true;
			}
		}
	}
	public function updateLocalAggression() {
		var aggro:Float = Reg.aggressionMap.members[Reg.aggressionMap.idx(Math.round(this.x), 0)];
		
		if(aggro > aggressionTolerance){
			if (type == NpcType.COWARD) {
				var minAggro:Float = aggro;
				var minLocX:Int = Math.round(this.x);
				for (curLocX in 128...Reg.aggressionMap.width - 128) {
					var curAggro:Float = Reg.aggressionMap.members[Reg.aggressionMap.idx(curLocX, 0)];
					if (curAggro+Math.abs(this.x - curLocX)/(Reg.gameWidth*0.5) <= minAggro) {
						minAggro = curAggro + Math.abs(this.x - curLocX) / (Reg.gameWidth*0.5);
						minLocX = curLocX;
					}
				}
				if(targetTimer <= targetTimerLimit){
					targetTimer += 1;
					randomTargetTimer = randomTargetTimerLimit;
				}else {
					setTarget(minLocX+Std.random(20)-Std.random(20), Math.round(this.y));
					targetTimer = 0;
				}
			}
		}else {
			if (randomTargetTimer <= randomTargetTimerLimit) {
				randomTargetTimer += 1;
				targetTimer = targetTimerLimit;
			}else {
				randomTargetTimer = 0;
				getRandomTarget();
			}
		}
	}
}