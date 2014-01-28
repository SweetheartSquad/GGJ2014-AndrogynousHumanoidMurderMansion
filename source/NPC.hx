package ;

import flash.display.Bitmap;
import flixel.util.FlxPoint;
import flixel.FlxObject;
import NpcType;
/**
 * ...
 * @author Sean
 */

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
	
	public var jumpChance:Float;
	public var interactChance:Float;
	public var attackChance:Float;
	
	
	public function new(_type:NpcType) {
		super();
		targetX = -1;
		targetY = -1;
		this.health = 300;
		this.type = _type;
		
		this.randomTargetTimer = 0;
		this.targetTimer = 0;
		
		switch(type) {
			case NpcType.COWARD:
				this.aggressionTolerance = 0.1;
				this.randomTargetTimerLimit = 180;
				this.targetTimerLimit = 60;
				this.jumpChance = 0.01;
				this.interactChance = 0.01;
				this.attackChance = 0.00001;
				this.attackDmg = 15;
			case NpcType.AGGRESSOR:
				this.aggressionTolerance = 0.5;
				this.randomTargetTimerLimit = 180;
				this.targetTimerLimit = 30;
				this.jumpChance = 0.001;
				this.attackChance = 0.01;
				this.attackDmg = 34;
			case NpcType.CIVILIAN:
				this.aggressionTolerance = 0.8;
				this.randomTargetTimerLimit = 60;
				this.targetTimerLimit = 180;
				this.jumpChance = 0.001;
				this.interactChance = 0.005;
				this.attackChance = 0.0001;
				this.attackDmg = 15;
		}
	}
	
	public function moveAlongPath() {
		if (this.x < targetX) {
			this.acceleration.x = this.maxVelocity.x * (this.running ? 8 : 4) ;
			//this.facing = FlxObject.RIGHT;
		}else {
			this.acceleration.x = -this.maxVelocity.x * (this.running ? 8 : 4);
			//this.facing = FlxObject.LEFT;
		}
		if (Math.abs(this.x - targetX) < 10) {
			this.acceleration.x = 0;
		}
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
		if (Math.random() * (running ? 0.8 : 1.0) < jumpChance) {
			this.jump();
		}
	}
	public function tryInteract() {
		if (Math.random() < interactChance) {
			this.interacting = true;
		}
	}
	public function tryAttack() {
		var aggro:Float = Reg.aggressionMap.members[Reg.aggressionMap.idx(Math.round(this.x),  getRow(this.y))];
		if (Math.random() < (attackChance + attackChance*(aggressionTolerance<aggro ? 0 : 1))) {
			this.attacking = true;
		}
	}
	public function updateLocalAggression() {
		var aggro:Float = Reg.aggressionMap.members[Reg.aggressionMap.idx(Math.round(this.x), getRow(this.y))];
		
		
		if (aggro > aggressionTolerance) {
			//react to aggression
			if (type == NpcType.COWARD) {
				var minAggro:Float = aggro;
				var minLocX:Int = Math.round(this.x);
				for (curLocX in 128...Reg.aggressionMap.width - 128) {
					var curAggro:Float = Reg.aggressionMap.members[Reg.aggressionMap.idx(curLocX,  getRow(this.y))];
					if (curAggro+Math.abs(this.x - curLocX)/(Reg.gameWidth*0.5) <= minAggro) {
						minAggro = curAggro + Math.abs(this.x - curLocX) / (Reg.gameWidth*0.5);
						minLocX = curLocX;
					}
				}
				if(targetTimer <= targetTimerLimit){
					targetTimer += 1;
					randomTargetTimer = randomTargetTimerLimit;
					this.running = true;
				}else {
					setTarget(minLocX+Std.random(20)-Std.random(20), Math.round(this.y));
					targetTimer = Std.random(Math.round(targetTimerLimit*0.5));
				}
			}else if (type == NpcType.AGGRESSOR) {
				var maxAggro:Float = aggro;
				var maxLocX:Int = Math.round(this.x);
				for (curLocX in 128...Reg.aggressionMap.width - 128) {
					var curAggro:Float = Reg.aggressionMap.members[Reg.aggressionMap.idx(curLocX,  getRow(this.y))];
					if (curAggro+Math.abs(this.x - curLocX)/(Reg.gameWidth*0.5) >= maxAggro) {
						maxAggro = curAggro + Math.abs(this.x - curLocX) / (Reg.gameWidth*0.5);
						maxLocX = curLocX;
					}
				}
				if(targetTimer <= targetTimerLimit){
					targetTimer += 1;
					randomTargetTimer = randomTargetTimerLimit;
				}else {
					setTarget(maxLocX+Std.random(20)-Std.random(20), Math.round(this.y));
					targetTimer = 0;
				}
			}
		}else {
			//act normally
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