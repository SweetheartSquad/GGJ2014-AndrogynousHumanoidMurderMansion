package ;

/**
 * ...
 * @author Ryan
 */
class Stairs extends Thingy
{
	public var relatedStairs:Int;

	
	public function new(x:Float, y:Float, type:ThingyType, imgPath:String,id:Int,relatedStairs:Int,?isActive:Bool=true) 
	{
		super(x,y,type, imgPath, id, isActive);
		this.relatedStairs = relatedStairs;
		
	}
	
}