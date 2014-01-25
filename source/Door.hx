package ;

/**
 * ...
 * @author Ryan
 */
class Door extends Thingy
{
	public var relatedDoor:Int;

	public function new(x:Float, y:Float, type:ThingyType, imgPath:String,id:Int,relatedDoor:Int,?isActive:Bool=true) 
	{
		super(x,y,type, imgPath, id, isActive);
		this.relatedDoor = relatedDoor;
		
	}
	
}