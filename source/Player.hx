package ;

/**
 * ...
 * @author Sean
 */
class Player extends Entity {
	public var lives:Int = 3;
	public function new() {
		super();
		
	}
	
	override public function kill() {
		if (this.lives > 0) {
			this.lives -= 1;
			this.destroyGraphics();
			this.generateGraphics();
			this.placeRandom();
		}else {
			super.kill();
		}
	}
}