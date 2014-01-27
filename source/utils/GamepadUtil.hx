package utils;

#if flash
#else
import flash.Lib;
import openfl.events.JoystickEvent;
import Map;

/**
 * ...
 * @author Ryan
 */
class XboxControls {
	public static var A:Int = 0;
	public static var B:Int = 1;
	public static var X:Int = 2;
	public static var Y:Int = 3;
	public static var L1:Int = 4;
	public static var R1:Int = 5;
	public static var SELECT:Int = 6;
	public static var START:Int = 7;
	public static var L3:Int = 8;
	public static var R3:Int = 9;
}

class GamepadUtil{
	private var pressedbuttons:Map<Int,Int>;
    private var lastbuttonUp:Int;
	private var axis:Float;
	private var device:Int;

	
	public function new(device:Int) 
	{
		this.device = device;
		Lib.current.stage.addEventListener(JoystickEvent.BUTTON_DOWN, this.button_Down);
		Lib.current.stage.addEventListener(JoystickEvent.BUTTON_UP, this.button_Up);
		Lib.current.stage.addEventListener(JoystickEvent.AXIS_MOVE, this.axis_Move);
		
		pressedbuttons = new Map<Int,Int>();
		axis = 0.0;
		
	}
	private function button_Down(evt:JoystickEvent){
		
		if (evt.device == device)
		{
			pressedbuttons.set(evt.id, evt.id);
			device = evt.device;
		}
	}
	
	private function button_Up(evt:JoystickEvent){
		
		if (evt.device == device)
		{
			pressedbuttons.remove(evt.id);
			lastbuttonUp = evt.id;
			device = evt.device;
			pressedbuttons = new  Map<Int,Int>();
			
		}
		
	}
	
	public function axis_Move(evt:JoystickEvent)
	{
		if (evt.device == device)
		{
			axis = evt.axis[0];
		}
	}
	
	public function clear()
	{
		if (pressedbuttons.exists(5) || pressedbuttons.exists(4))
		{
			pressedbuttons = new  Map<Int,Int>();
			pressedbuttons.set(5, 5);
			pressedbuttons.set(4, 4);
			
		}
		else
		{
			pressedbuttons = new  Map<Int,Int>();
		}
		
	}
	
	public function getPressedbuttons():Map<Int,Int> 
	{
		return pressedbuttons;
	}
	
	public function getControllerId():Int
	{
		return device;
	}

    public function getLastbuttonUp():Int
    {
		var temp = lastbuttonUp;
		lastbuttonUp = -1;
        return temp;
    }
	
	public function getAxis():Float
	{
		return axis;
	}
}
#end
