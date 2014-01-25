package utils;
import flash.events.KeyboardEvent;
import flash.Lib;
import Map;

/**
 * ...
 * @author Ryan
 */
class KeyboardUtil
{
	
	private var pressedKeys:Map<Int,Int>;
    private var lastKeyUp:Int;

	public function new() 
	{
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.key_Down);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, this.key_Up);
		
		pressedKeys = new Map<Int,Int>();
		
	}
	
	private function key_Down(evt:KeyboardEvent){
		
		pressedKeys.set(evt.keyCode, evt.keyCode);
		
	}
	
	private function key_Up(evt:KeyboardEvent){
		
		pressedKeys.remove(evt.keyCode);
        lastKeyUp = evt.keyCode;
		
	}
	
	public function getPressedKeys():Map<Int,Int> 
	{
		return pressedKeys;
	}

    public function getLastKeyUp():Int
    {
        return lastKeyUp;
    }
	
	
}