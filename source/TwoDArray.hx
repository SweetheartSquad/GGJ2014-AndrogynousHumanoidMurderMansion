package ;

/**
 * ...
 * @author Sean
 */
import flixel.FlxSprite;
import flixel.util.FlxColorUtil;
class TwoDArray
{
	public var width:Int;
	public var height:Int;
	public var members:Array<Float>;
	public var vis:Array<FlxSprite>;
	public function new(_w:Int, _h:Int, _default:Float = 0) 
	{
		width = _w;
		height = _h;
		members = new Array();
		vis = new Array();
		for (i in 0 ... (width * height)) {
			members.push(_default);
		}
		initSprites();
	}
	
	public function idx(_x:Int, _y:Int):Int {
		return _y * width + _x;
	}
	
	public function initSprites() {
		for (y in 0...this.height) {
			for (x in 0...this.width) {
				var temp:FlxSprite = new FlxSprite(x, y*5);
				temp.makeGraphic(1, 3, FlxColorUtil.makeFromARGB(Math.min(1,members[idx(x, y)]),0xFF,0x00,0x00));
				vis.push(temp);
			}
		}
	}
	public function colourSprites() {
		for (y in 0...this.height) {
			for (x in 0...this.width) {
				vis[idx(x,y)].makeGraphic(1, 3, FlxColorUtil.makeFromARGB(Math.min(1,members[idx(x, y)]),0xFF,0x00,0x00));
			}
		}
	}
	public function reduceAggression() {
		for (y in 0...this.height) {
			for (x in 0...this.width) {
				if(members[idx(x, y)] > 1){
					members[idx(x, y)] = 0.99;
				}else if(members[idx(x, y)] > 0.01){
					members[idx(x, y)] -= 0.01;
				}else {
					members[idx(x, y)] = 0;
				}
			}
		}
	}
	
}