package utils;


import flash.Lib;
import openfl.events.JoystickEvent;
import Map;

/**
 * ...
 * @author Ryan
 */
class GamepadUtil
{
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
		}
		
	}
	
	public function axis_Move(evt:JoystickEvent)
	{
		if (evt.device == device)
		{
			axis = evt.axis[0];
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
        return lastbuttonUp;
    }
	
	public function getAxis():Float
	{
		return axis;
	}
	
	
	
}