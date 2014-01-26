package ;

import flixel.util.FlxPoint;
/**
 * ...
 * @author Sean
 */
class NPC extends Entity{
	public var target:FlxPoint;
	public function new() {
		super();
		
	}
	
	public function findPathToTarget() {
		if (this.y == target.y) {
			//same level, walk in that direction
		}else {
			//different level, find door or something
		}
		if (this.x == target.x) {
			
		}
	}
	
	public function moveAlongPath() {
		if (this.x < target.x) {
			this.acceleration.x = -this.maxVelocity.x * 4;
		}else {
			this.acceleration.x = this.maxVelocity.x * 4;
		}
	}
	
}