package ;
import flixel.FlxSprite;

/**
 * ...
 * @author Ian
 */
class Lever extends FlxSprite
{

	public var isActive:Bool;
	public var imgPath:String;
	public var targetId:Int;
	
	public function new(x:Float, y:Float, imgPath:String, ?isActive:Bool=false) 
	{
		super();
		this.imgPath = imgPath;
		this.isActive = isActive;
		this.x = x;
		this.y = y;
		drawGraphics();
	}
	
	private function drawGraphics()
	{
		makeGraphic(4, 10, 0xff550099);
	}
	
}