package ;

/**
 * ...
 * @author Sean
 */
import flixel.FlxSprite;
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
				temp.makeGraphic(1, 3, members[idx(x, y)] > 0.5 ? 0xFFFF0000 : 0xFF0000FF);
				vis.push(temp);
			}
		}
	}
	public function colourSprites() {
		for (y in 0...this.height) {
			for (x in 0...this.width) {
				vis[idx(x,y)].makeGraphic(1, 3, members[idx(x, y)] > 0.5 ? 0xFFFF0000 : 0xFF0000FF);
			}
		}
	}
	
}