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
class MenuState extends FlxState
{
	private var _text1:FlxText;
	private var _text2:FlxText;
	var bg:FlxSprite;
	var title:FlxSprite;
	private var particles:FlxGroup;
	private var counter:Float = 0;
	private var titleCounter:Float = 0;
	private var moveCount:Int = 0;
	private var pReady:Bool;
	private var qReady:Bool;
	
	override public function create():Void
	{
		pReady = false;
		qReady = false;
		
		bg = new FlxSprite(-525,-310);
		bg.loadGraphic("assets/images/background.png");
		bg.scale.x /= Reg.zoom;
		bg.scale.y /= Reg.zoom;
		add(bg);
		FlxG.cameras.bgColor = 0x00000000;
		
		title = new FlxSprite(Reg.gameWidth/2 - 220, 20);
		title.loadGraphic("assets/images/titleCard.png");
		add(title);
		
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.show();
		#end
		
		_text1 = new FlxText((Reg.gameWidth / 2) - 100, Reg.gameHeight / 4 + 280, 295, "PRESS SPACE TO START");
		_text1.size = 20;
		_text1.color = 0x000000;
		add(_text1);
		
		_text2 = new FlxText((Reg.gameWidth / 2) - 95, Reg.gameHeight / 4 + 315, 300, "PRESS Q TO READ INSTRUCTIONS");
		_text2.size = 14;
		_text2.color = 0x000000;
		add(_text2);
		
		particles = new FlxGroup();
		add(particles);
		
		super.create();
	}
	
	override public function destroy():Void
	{
		_text1 = null;
		_text2 = null;
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
		
		if (FlxG.keyboard.anyJustReleased(["SPACE"])) {
			_text1.alpha = 0;
			pReady = true;
			
			for (i in Math.round(_text1.x)...Math.round(_text1.x + _text1.width)) {
				makeGibs(i, _text1.y);
			}
			
		}
		
		if (FlxG.keyboard.anyJustReleased(["Q"])) {
			_text2.alpha = 0;
			qReady = true;
			
			for (i in Math.round(_text2.x)...Math.round(_text2.x + _text2.width)) {
				makeGibs(i, _text2.y);
			}
			
		}
		
		if(pReady == true){
			counter += FlxG.elapsed;
			if (counter >= 1) {
				FlxG.switchState(new PlayState());
			}
		}
		
		if(qReady == true){
			counter += FlxG.elapsed;
			if (counter >= 1) {
				FlxG.switchState(new InstructState());
			}
		}
		
		titleCounter += FlxG.elapsed;
		if(titleCounter >= 1) {
			if(moveCount >= 4) {
				moveCount = 1;
			} else {
				moveCount++;
			}
			
			switch(moveCount) {
				case 1:
					title.y -= 6;
				case 2:
					title.y += 6;
				case 3:
					title.y += 6;
				case 4:
					title.y -= 6;
				default:
					
			}
			
			makeGibs(title.x+50, title.y+title.height-125);
			makeGibs(title.x+50, title.y+title.height-125);
			makeGibs(title.x+50, title.y+title.height-125);
			makeGibs(title.x+50, title.y+title.height-125);
			makeGibs(title.x+50, title.y+title.height-125);
			makeGibs(title.x+title.width-50, title.y+title.height-125);
			makeGibs(title.x+title.width-50, title.y+title.height-125);
			makeGibs(title.x+title.width-50, title.y+title.height-125);
			makeGibs(title.x+title.width-50, title.y+title.height-125);
			makeGibs(title.x+title.width-50, title.y+title.height-125);
			
			titleCounter = 0;
			
		}
		
	}	
}