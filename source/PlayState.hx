package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import flixel.util.FlxPath;
import flixel.util.FlxPoint;
import openfl.Assets;
import utils.GamepadUtil;
import haxe.io.Eof;
import sys.io.File;
import sys.io.FileInput;
import sys.io.FileOutput;


/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	
	private var _level:FlxTilemap;
	inline static private var TILE_WIDTH:Int = 16;
	inline static private var TILE_HEIGHT:Int = 16;
	
	//Flx Groups
	private var entities:FlxGroup;
	private var thingies:FlxGroup;
	private var players:FlxGroup;
	private var npcs:FlxGroup;
	
	//players
	private var player1:Player;
	private var player2:Player;
	
	//npcs
	private var npcTest:NPC;
	
	//Utils 
	private var gamepadUtilOne:GamepadUtil;
	private var gamepadUtilTwo:GamepadUtil;
	
	//Thingies
	private var doorOne:Door;
	private var doorTwo:Door;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void{
		//FlxG.mouse.visible = false;
		FlxG.cameras.bgColor = 0xffaaaaaa;
		
		
		generateMapCSV();
		_level = new FlxTilemap();
		_level.loadMap(Assets.getText("assets/level.csv"), "assets/images/testSet.png", TILE_WIDTH, TILE_HEIGHT, FlxTilemap.AUTO);
		add(_level);
		generateLevel();

		player1 = new Player();
		player2 = new Player();
		
		//generate npcs
		npcTest = new NPC();
		npcTest.x = 150;
		npcTest.y = 100;
		
		
		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.show();
		#end
		
		//Utils
		gamepadUtilOne = new GamepadUtil(0);
		gamepadUtilTwo = new GamepadUtil(1);
		
		//add entities to FlxGroup
		players = new FlxGroup();
		players.add(player1);
		players.add(player2);
		npcs = new FlxGroup();
		npcs.add(npcTest);
		entities = new FlxGroup();
		entities.add(players);
		entities.add(npcs);
		
		
		//Thingies
		var doorPath:String = "assets/images/door.png"; 
		doorOne = new Door(DOOR,doorPath,0);
		doorTwo = new Door(DOOR,doorPath,1);
		
		thingies = new FlxGroup();
		thingies.add(doorOne);
		thingies.add(doorTwo);
		
		//add thingies
		add(thingies);
		
		//add entities to game
		add(entities);
		
		super.create();
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void {
		//reset accelerations
		for (i in 0 ... players.length) {
			cast(players._members[i],Entity).acceleration.x = 0;
		}for (i in 0 ... npcs.length) {
			cast(npcs._members[i],Entity).acceleration.x = 0;
		}
		
		//player1 controls
		if (FlxG.keyboard.anyPressed(["J"]) || (gamepadUtilOne.getAxis() < -0.5 && gamepadUtilOne.getControllerId() == 0)){
			player1.acceleration.x = -player1.maxVelocity.x * 4;
			player1.facing = FlxObject.LEFT;
		}
		if (FlxG.keyboard.anyPressed(["L"])|| (gamepadUtilOne.getAxis() > 0.5 && gamepadUtilOne.getControllerId() == 0 )){
			player1.acceleration.x = player1.maxVelocity.x * 4;
			player1.facing = FlxObject.RIGHT;
		}
		if ((FlxG.keyboard.justPressed("I")|| (gamepadUtilOne.getPressedbuttons().exists(0)&& gamepadUtilOne.getControllerId() == 0 )) && player1.isTouching(FlxObject.FLOOR)) {
			player1.velocity.y = -player1.maxVelocity.y / 2;
		}
		if (FlxG.keyboard.justPressed("K")|| (gamepadUtilOne.getPressedbuttons().exists(1)&& gamepadUtilOne.getControllerId() == 0 )) {
			FlxG.overlap(player1, player2, killPlayer);
		}
		if (FlxG.keyboard.justPressed("Q")|| (gamepadUtilOne.getPressedbuttons().exists(3)&& gamepadUtilOne.getControllerId() == 0 )) {
			FlxG.overlap(player1, player2, killPlayer);
		}
		if (gamepadUtilOne.getLastbuttonUp() == 7 && gamepadUtilOne.getControllerId() == 0) {
			player1.destroyGraphics();
			player1.generateGraphics();
		}
		
		
		//player2 controls
		if (FlxG.keyboard.anyPressed(["A"])|| (gamepadUtilTwo.getAxis() < -0.5 && gamepadUtilTwo.getControllerId() == 1)){
			player2.acceleration.x = -player2.maxVelocity.x * 4;
			player2.facing = FlxObject.LEFT;
		}if (FlxG.keyboard.anyPressed(["D"])|| (gamepadUtilTwo.getAxis() > 0.5 && gamepadUtilTwo.getControllerId() == 1 )){
			player2.acceleration.x = player2.maxVelocity.x * 4;
			player2.facing = FlxObject.RIGHT;
		}if ((FlxG.keyboard.justPressed("W") || (gamepadUtilTwo.getPressedbuttons().exists(0) && gamepadUtilTwo.getControllerId() == 1)) && player2.isTouching(FlxObject.FLOOR)) {
			player2.velocity.y = -player2.maxVelocity.y / 2;
		}if (FlxG.keyboard.anyPressed(["S"]) || (gamepadUtilTwo.getPressedbuttons().exists(1) && gamepadUtilTwo.getControllerId() == 1)) {
			FlxG.overlap(player2, player1, killPlayer);
		}
		if (FlxG.keyboard.justPressed("U")|| (gamepadUtilOne.getPressedbuttons().exists(3)&& gamepadUtilOne.getControllerId() == 1 )) {
			FlxG.overlap(player1, player2, killPlayer);
		}
		if (gamepadUtilTwo.getLastbuttonUp() == 7 && gamepadUtilTwo.getControllerId() == 1) {
			player2.destroyGraphics();
			player2.generateGraphics();
		}
		
		if (FlxG.keyboard.anyJustPressed(["SPACE"])) {
			entities.callAll("destroyGraphics");
			entities.callAll("generateGraphics");
		}
		
		
		
		//states/controls above
		super.update();
		//updates below
		
		FlxG.collide(_level, entities);
		entities.callAll("postUpdate");
		
	}
	
	public function killPlayer(attacker:FlxObject,victim:FlxObject) {
		victim.kill();
	}
	
	public function generateMapCSV() {
		var fname = "assets/level.csv";
		var fout = File.write(fname, false);
		
		//create a level file
		for (i in 0...Math.round(Reg.gameHeight/16)) {
			for (j in 0...Math.round(Reg.gameWidth/16)) {
				fout.writeString("0, ");
			}
			fout.writeString("\n");
		}

		fout.close();
	}
	
	public function generateLevel() {
		var tileXNum:Int = Math.round(Reg.gameWidth / 16);
		var tileYNum:Int = Math.round(Reg.gameHeight / 16);
		var tileStartX:Int = Math.round((tileXNum / 6)) - 1;
		var tileEndX:Int = Math.round((tileXNum / 6)) * 5 + 1;
		
		var floorHeight = Math.round((tileYNum - 4) / 4);
		var floorCount = -2;
		
		var trapX:Int;
		var trapY:Int;
		var floorNum:Int = Std.random(4);
		
		//add walls and floors to the level
		for (i in 0...tileYNum) {
			for (j in tileStartX...tileEndX) {
				if (floorCount == (floorHeight - 1) || i == 0 || i == 1 || i == tileYNum - 1 || i == tileYNum - 2) {
						_level.setTile(j, i, 1);
				} else {
					if (j == tileStartX || j == tileStartX + 1 || j == tileEndX - 2 || j == tileEndX - 1) {
						_level.setTile(j, i, 1);
					} else {
						_level.setTile(j, i, 0);
					}
				}
			}
			floorCount++;
			if (floorCount == floorHeight) floorCount = 0;
		}
		
		//randomly insert a trapdoor into one of the floors
		trapX = Std.random((tileEndX-tileStartX)) + 3;
		switch(floorNum) {
			case 0:
				trapY = 1 + floorHeight;
			case 1:
				trapY = 1 + floorHeight * 2;
			case 2:
				trapY = 1 + floorHeight * 3;
			default:
				trapY = -1;
		}
		
		for (i in 0...2) {
			for (j in 0...1) {
				_level.setTile(trapX + i, trapY + j, 0);
			}
		}
	}
}