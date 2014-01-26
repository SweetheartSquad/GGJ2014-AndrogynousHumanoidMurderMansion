package ;
import flixel.FlxSprite;

/**
 * ...
 * @author Ian
 */
class TrapDoor extends FlxSprite
{

	public var isActive:Bool;
	public var imgPath:String;
	public var id:Int;
	
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
		loadGraphic(imgPath);
		//makeGraphic(32, 16, 0xff550099);
	}
	
}