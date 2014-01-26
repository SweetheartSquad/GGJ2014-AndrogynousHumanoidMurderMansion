package;
import flixel.*;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

/**
 * A FlxState which can be used for the game's menu.
 */
class InstructState extends FlxState
{
	private var _text1:FlxText;
	private var _text2:FlxText;
	private var particles:FlxGroup;
	private var counter:Float = 0;
	private var ready:Bool;
	
	override public function create():Void
	{
		ready = false;
		// Set a background color
		FlxG.cameras.bgColor = 0x00000000;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.show();
		#end
		
		_text1 = new FlxText((Reg.gameWidth / 2) - 100, Reg.gameHeight / 4 + 250, 290, "PRESS Q TO GO BACK");
		_text1.size = 20;
		_text1.color = 0x000000;
		add(_text1);
		
		particles = new FlxGroup();
		add(particles);
		
		super.create();
	}
	
	override public function destroy():Void
	{
		_text1 = null;
		super.destroy();
	}

	public function makeGibs(_x:Float, _y:Float) {
		particles.add(new Particle(_x, _y));
		if(Math.random()>0.1){
			particles.add(new Particle(_x, _y));
			if(Math.random()>0.2){
				particles.add(new Particle(_x, _y));
				if(Math.random()>0.3){
					particles.add(new Particle(_x, _y));
					if(Math.random()>0.4){
						particles.add(new Particle(_x, _y));
						if(Math.random()>0.5){
							particles.add(new Particle(_x, _y));
						}
					}
				}
			}
		}
	}
	
	override public function update():Void
	{
		super.update();
		
		if (FlxG.keyboard.anyJustReleased(["Q"])) {
			_text1.alpha = 0;
			ready = true;
			
			for (i in Math.round(_text1.x)...Math.round(_text1.x + _text1.width)) {
				makeGibs(i, _text1.y);
			}
		}
			
		if(ready == true){
			counter += FlxG.elapsed;
			if (counter >= 1) {
				FlxG.switchState(new MenuState());
			}
		}
		
	}	
}