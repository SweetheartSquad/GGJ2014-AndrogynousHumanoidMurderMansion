package utils;

/**
 * ...
 * @author Ryan
 */
import flash.events.MouseEvent;
import flash.Lib;
 
class MouseUtil
{
	
	private var mouseStatus:Bool = false;

	public function new() 
	{
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
	}
	
	private function mouseDown(e:MouseEvent):Void
	{
		if (e.buttonDown)
		{
			mouseStatus = true;
		}
		else
		{
			mouseStatus = false;
		}
	}
	
	private function mouseUp(e:MouseEvent):Void
	{
		if (e.buttonDown)
		{
			mouseStatus = true;
		}
		
		else
		{
			mouseStatus = false;
		}
	}
	
	public function isMouseDown():Bool {
		
		return mouseStatus;
	}
	
	
}