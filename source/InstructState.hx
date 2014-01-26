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
	var bg:FlxSprite;
	var instructions:FlxSprite;
	private var particles:FlxGroup;
	private var counter:Float = 0;
	private var instructCounter:Float = 0;
	private var screenCount:Int = 1;
	private var ready:Bool;
	
	override public function create():Void
	{
		ready = false;
		
		bg = new FlxSprite(-525,-310);
		bg.loadGraphic("assets/images/background.png");
		bg.scale.x /= Reg.zoom;
		bg.scale.y /= Reg.zoom;
		add(bg);
		FlxG.cameras.bgColor = 0x00000000;
		
		instructions = new FlxSprite(Reg.gameWidth/2 - 260, 25);
		instructions.loadGraphic("assets/images/instructions1.png");
		add(instructions);
		
		_text1 = new FlxText((Reg.gameWidth / 2) - 100, Reg.gameHeight / 4 + 320, 290, "PRESS Q TO GO BACK");
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
		
		instructCounter += FlxG.elapsed;
		if(instructCounter >= 1) {
			if(screenCount >= 4) {
				screenCount = 1;
			} else {
				screenCount++;
			}
			instructions.loadGraphic("assets/images/instructions"+screenCount+".png");
			instructCounter = 0;
		}
		
	}	
}