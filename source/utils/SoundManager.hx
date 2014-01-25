package utils;

import flash.media.Sound;
import flash.media.SoundChannel;
import Map;
import flash.net.URLRequest;
/**
 * ...
 * @author Ryan
 */
class SoundManager
{
	public var sounds:Map<String, Sound>;
	private var soundChannel:SoundChannel;
	
	public function new() 
	{
		sounds = new Map();
		//soundChannel = new SoundChannel();
	}
	
	public function addSound(name:String,path:String)
	{
		var temp:Sound = new Sound();
		temp.load(new URLRequest("assets/music/door.wav"));
		sounds.set(name, temp);
		
		
	}
	
	public function playSound(name:String):Void
	{
		sounds.get(name).play();
	}
	
	
}