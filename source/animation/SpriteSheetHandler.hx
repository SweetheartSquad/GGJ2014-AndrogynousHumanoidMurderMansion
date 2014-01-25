package animation;

import flash.geom.Rectangle;

/**
 * ...
 * @author Ryan
 */
class SpriteSheetHandler
{
	

	public function new() 
	{
		
	}
	
	public static function getSpriteArray(imgWidth:Int, imgHeight:Int, spriteWidth:Int, spriteHeight:Int, startXCoord:Int, startYCoord:Int, endXCoord, endYCoord):Array<Rectangle>
	{
			var spritesX:Int;
			var spritesY:Int = cast(Math.round(imgHeight / spriteHeight),Int);
			var rectArray:Array<Rectangle> = new Array<Rectangle> ();
			var currentX:Float = startXCoord;
			var currentY:Float = startYCoord;
			
			if (endXCoord < cast(imgWidth / spriteWidth, Int))
			{
				spritesX = endXCoord;
			}
			else
			{
				spritesX = cast(imgWidth / spriteWidth, Int); 
			}
			
			
			for (i in 0...(spritesX * spritesY))
			{
				
				if (currentX >= endXCoord && currentY>=endYCoord)
				{
					break;
				}
				
				if (currentX < spritesX)
				{
					rectArray.push(new Rectangle((currentX* spriteWidth) ,(currentY * spriteHeight),(spriteWidth),(spriteHeight)));
						
					currentX++;
					
				}
				else {
					
					currentX = 0; 
					currentY++;
					rectArray.push(new Rectangle((currentX * spriteWidth) , (currentY * spriteHeight), (spriteWidth), (spriteHeight)));
					currentX++;
				}
			}
				
		return rectArray;			
				
	}
			
		
	
	
}