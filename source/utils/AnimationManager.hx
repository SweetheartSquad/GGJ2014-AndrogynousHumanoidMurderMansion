package utils;

/**
 * ...
 * @author Ryan
 */

 
import animation.AnimationState;
import flash.display.*;
import flash.display.Bitmap;
import flash.events.*;
import flash.geom.Rectangle;
import openfl.Assets;
import openfl.display.Tilesheet;


class AnimationManager{
	
	private var bitmap:Bitmap;
	private var tileSheet:Tilesheet;
	private var animationStates:Map<String, AnimationState>;
	private var graphics:Graphics;
	private var addedTiles:Int;
	public var currentState:AnimationState;

	public function new(graphic:Graphics, bitmapPath:String){
		graphics = graphic;
		tileSheet = new Tilesheet(Assets.getBitmapData(bitmapPath));
		animationStates = new Map();
		addedTiles = 0;
	}
	
	public function addAnimationState(name:String, frames:Array<Rectangle>, frameRate:Int):Void
	{
		for(i in frames)
		{
			tileSheet.addTileRect(i);
		}
		
		var tileIds:Array<Int> = new Array();
		
	
		for(i in addedTiles...addedTiles+frames.length)
		{
			tileIds.push(addedTiles);
			addedTiles++;
		}
		
		animationStates.set(name, new AnimationState(tileIds, frameRate));
	}
	
	public function setAnimationState(name:String)
	{
		if (currentState != null && currentState != animationStates.get(name))
		{
			currentState.setCurrentFrame(1);
		}
		currentState = animationStates.get(name); 
		
	}
	public function draw()
	{
		var data=[0.0, 0.0, currentState.getCurrentFrame()];
		graphics.clear();
		tileSheet.drawTiles(graphics, data, true);
	}
	public function drawNoLoop(freezeAtFrame:Int)
	{
		if(currentState.getCurrentFrame() <= freezeAtFrame){
			var data=[0.0, 0.0, currentState.getCurrentFrame()];
			graphics.clear();
			tileSheet.drawTiles(graphics, data, true);
		}
	}
	
	public function reset(name:String) {
		currentState.setCurrentFrame(0);
	}
}