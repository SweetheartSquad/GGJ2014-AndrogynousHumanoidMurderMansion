package animation;

/**
 * ...
 * @author Ryan
 */

import flash.display.*;
import flash.events.*;

class AnimationState
{
	
	private var frames:Array<Int>;
	private var currentFrame:Int;
	private var frameRate:Int;
	private var frameCounter:Int;

	public function new(framePass:Array<Int>, frameRatePass:Int) 
	{
		frames = framePass;
		frameRate = frameRatePass;
		currentFrame = 0;
		frameCounter = 0;
	}
	
	public function getCurrentFrame()
	{
		frameCounter++;
		
		if (frameCounter >= frameRate)
		{
			frameCounter = 0;
			currentFrame++;
			if (currentFrame >= frames.length )
			{
				currentFrame = 0;
			}
		}
		
		return frames[currentFrame];
	}
	
	public function setCurrentFrame(_frame:Int) {
		currentFrame = _frame;
		frameCounter = 0;
	}
	
}