package utils;

import flash.media.Sound;
import flash.media.SoundChannel;
import haxe.Timer;
import Map;
import flash.net.URLRequest;

/**
 * ...
 * @author Ryan
 */
class SoundManager
{
	public var sounds:Map<String, Sound>;
	public var songs:Map < String, Array<Array<Sound>> > ;
	private var soundChannel:SoundChannel;
	private var songCounter:Int;
	private var songSegmentCounter:Int;
	public var yourTimer:haxe.Timer;
	
	public function new() 
	{
		sounds = new Map();
		songs = new Map();
		//soundChannel = new SoundChannel();
		songCounter = 0;
		songSegmentCounter = 0;
		yourTimer = new haxe.Timer(500);
	}
	
	public function addSound(name:String,path:String)
	{
		var temp:Sound = new Sound();
		temp.load(new URLRequest(path));
		sounds.set(name, temp);
		
	}
	
	public function addSong(name:String, paths:Array<String>)
	{
		var soundArray:Array <Array<Sound>> = new Array();
		
		var chorus:Array<String> = new Array();
		
		var totalPaths:Array <Int>;
		
		for (j in 0...6)
		{
			totalPaths = createArray(paths.length);
			totalPaths = randomArray(totalPaths);
			var tempPaths:Array<String> = new Array();
			
			for (t in 0...paths.length)
			{
				tempPaths.insert(totalPaths[t], paths[t]);
			}
			
			var tempArr:Array<Sound> = new Array();
			
			if (j == 2)
			{
				chorus = tempPaths; 
			}
			
			if (j == 5)
			{
				tempPaths = chorus;
			}
			
			for (i in tempPaths)
			{
				var temp:Sound = new Sound();
				temp.load(new URLRequest(i));
				tempArr.push(temp);
				
			}
			
			soundArray.push(tempArr);
		}
		songs.set(name, soundArray);
	}
	
	private function createArray(arraySize:Int)
	{
		var array:Array<Int> = new Array();
		for (i in 0...arraySize)
		{
			array[i] = i;
		}
		return array;
	}
	private function randomArray(_array:Array<Int>)
	{
		var _length:Int= _array.length;
		var mixed:Array<Int>= _array.slice(0,_length);
		var rn:Int;
		var it:Int;
		var el:Int;
		for (i in 0..._array.length)
		{
			el = mixed[i];
			rn = Math.floor(Math.random() * _length);
			mixed[i] = mixed[rn];
			mixed[rn] = el;
		}
		return mixed;
	}
	
	private function playSongInteral(name:String)
	{
		if (songSegmentCounter < songs.get(name).length)
		{
			if (songCounter < songs.get(name)[songSegmentCounter].length)
			{
				
					
				songs.get(name)[songSegmentCounter][songCounter].play();
					
				//soundTemp[songCounter].play();
				
				songCounter++;
				
				if (songCounter >= songs.get(name)[songSegmentCounter].length)
				{
					songCounter = 0;
				}
			}
			
			songSegmentCounter++;
			
			if(songSegmentCounter >= songs.get(name).length)
			{
				songSegmentCounter = 0;
			}
		}
	
	}
	
	public function playSong(name:String)
	{
		
		yourTimer.run = function():Void {
				
			playSongInteral(name);		
		};
	}
	
	public function playSound(name:String):Void
	{
		sounds.get(name).play();
	}
	
	
}