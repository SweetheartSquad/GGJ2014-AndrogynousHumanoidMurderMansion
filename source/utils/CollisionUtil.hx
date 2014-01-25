package utils;


import flash.display.*;
import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.display.Sprite;
import flash.events.*;
import flash.geom.Rectangle;
import utils.CollisionUtil;
/**
 * ...
 * @author Ryan
 * The point of this class is to check for pixel perfect collision.
 * We do this by fisr checking if there is an intersection between the two
 * sprites. If there is we check all of the pixels in that intersection to see if 
 * any of them are not transperant. If they arent then we have a collision
 */

class CollisionUtil
{
	public function new() 
	{
		
	}
	public static function isColliding(spriteOne:Sprite, spriteTwo:Sprite):Bool
	{
		
		/*
		 * First we get the bitmap data from the sprites
		 */
		var bitmapOne = new BitmapData(Math.round(spriteOne.width), Math.round(spriteOne.height),true,0x00000000);
		var bitmapTwo = new BitmapData(Math.round(spriteTwo.width), Math.round(spriteTwo.height),true,0x00000000);
		bitmapOne.draw(spriteOne,null,null,BlendMode.ALPHA);
		bitmapTwo.draw(spriteTwo, null, null, BlendMode.ALPHA); 

		/*
		 * Here we get rectangle data for each of the sprites so that we can get the 
		 * intersecton rectangle
		 */
		var rect:Rectangle;
		
		var spriteOneRect:Rectangle = new Rectangle(spriteOne.x, spriteOne.y, spriteOne.width, spriteOne.height);
		
		var spriteTwoRect:Rectangle = new Rectangle(spriteTwo.x, spriteTwo.y, spriteTwo.width, spriteTwo.height);
		
		rect = spriteOneRect.intersection(spriteTwoRect);
	
		/*
		 * Since rect and the sprites still have the x and y
		 * values from the actual stage we need to find where the 
		 * intersection rectangle's coordinates are in relation to the 
		 * sprites themselves. This is becasue when we put in the coordinates
		 * for our getPixel32 functions they need to be the coordinates in the
		 * bitmaps not in the stage
		 */
		var diffXOne = rect.x - spriteOne.x;
		var diffYOne = rect.y - spriteOne.y;
		var diffXTwo = rect.x - spriteTwo.x;
		var diffYTwo = rect.y - spriteTwo.y;
		
		for (j in 0...Math.round(rect.height))
		{
			for (i in 0...Math.round(rect.width))
			{
				if (
				(bitmapOne.getPixel32(Math.round(diffXOne) + i, Math.round(diffYOne) + j ) >>> 24 > 0 ) 
				&& (bitmapTwo.getPixel32(Math.round(diffXTwo) + i, Math.round(diffYTwo)+j) >>> 24 > 0 ))
				{
					return true;
				}
			}
		}
		
		return false;
		
	}
	
}
