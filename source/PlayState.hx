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
import utils.SoundManager;
import haxe.io.Eof;
import sys.io.File;
import sys.io.FileInput;
import sys.io.FileOutput;


#if not flash
import utils.GamepadUtil;

#end

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	
	//private var _level:FlxTilemap;
	inline static private var TILE_WIDTH:Int = 16;
	inline static private var TILE_HEIGHT:Int = 16;
	
	//Flx Groups
	private var entities:FlxGroup;
	private var doors:FlxGroup;
	private var stairs:FlxGroup;
	private var players:FlxGroup;
	private var npcs:FlxGroup;
	
	//players
	private var player1:Player;
	private var player2:Player;
	
	//npcs
	private var npcTest:NPC;
	
	#if not flash
	//Utils 
	private var gamepadUtilOne:GamepadUtil;
	private var gamepadUtilTwo:GamepadUtil;
	#end
	
	//Thingies
	private var doorOne:Door;
	private var doorTwo:Door;
	//Sound
	private var soundManager:SoundManager;
	
	//Tile map array values
	private var tiles:Array<Array<Int>> ;
	

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void{
		//FlxG.mouse.visible = false;
		FlxG.cameras.bgColor = 0xffaaaaaa;
		
		
		doors = new FlxGroup();
		stairs = new FlxGroup();
		
		
		tiles = new Array();
		generateMapCSV();
		Reg._level = new FlxTilemap();
		Reg._level.loadMap(Assets.getText("assets/level.csv"), "assets/images/testSet.png", TILE_WIDTH, TILE_HEIGHT, FlxTilemap.AUTO);
		add(Reg._level);
		generateLevel();
		
		generateDoors();
		generateStairs();
		
		

		/*for (y in 0...Reg.gameHeight) {
			for (x in 0...Reg.gameWidth) {
				trace(Reg._level.overlapsPoint(new FlxPoint(x, y)));
			}
		}*/
		
		
		
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
		
		#if not flash
		//Utils
		gamepadUtilOne = new GamepadUtil(0);
		gamepadUtilTwo = new GamepadUtil(1);
		#end
		
		//add entities to FlxGroup
		players = new FlxGroup();
		players.add(player1);
		players.add(player2);
		npcs = new FlxGroup();
		npcs.add(npcTest);
		for(i in 0...200){
			npcs.add(new NPC());
		}
		entities = new FlxGroup();
		entities.add(players);
		entities.add(npcs);
		
		
		//Thingies
		//var doorPath:String = "assets/images/door.png"; 
		//doorOne = new Door(40,50,DOOR,doorPath,0,1);
		//doorTwo = new Door(100,300,DOOR,doorPath,1,0);
		
		//doors.add(doorOne);
		//doors.add(doorTwo);
		
		//add thingies
		add(doors);
		add(stairs);
		//add entities to game
		add(entities);
		
		
		//Add Sounds 
		soundManager = new SoundManager();
		soundManager.addSound("door", "assets/music/door.wav");
		
		
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
		
		#if not flash
		//player1 controls
		if (FlxG.keyboard.anyPressed(["J"]) || (gamepadUtilOne.getAxis() < -0.5 && gamepadUtilOne.getControllerId() == 0)){
			player1.acceleration.x = -player1.maxVelocity.x * 4;
			player1.facing = FlxObject.LEFT;
		}
		if (FlxG.keyboard.anyPressed(["L"])|| (gamepadUtilOne.getAxis() > 0.5 && gamepadUtilOne.getControllerId() == 0 )){
			player1.acceleration.x = player1.maxVelocity.x * 4;
			player1.facing = FlxObject.RIGHT;
		}
		if ((FlxG.keyboard.justPressed("I")|| (gamepadUtilOne.getPressedbuttons().exists(0)&& gamepadUtilOne.getControllerId() == 0 ))) {
			player1.jump();
		}
		if (FlxG.keyboard.justPressed("K")|| (gamepadUtilOne.getPressedbuttons().exists(1)&& gamepadUtilOne.getControllerId() == 0 )) {
			FlxG.overlap(player1, player2, killPlayer);
		}
		if (FlxG.keyboard.justPressed("U")|| (gamepadUtilOne.getPressedbuttons().exists(3)&& gamepadUtilOne.getControllerId() == 0 )) {
			player1.interacting = true;
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
		}if ((FlxG.keyboard.justPressed("W") || (gamepadUtilTwo.getPressedbuttons().exists(0) && gamepadUtilTwo.getControllerId() == 1))) {
			player2.jump();
		}if (FlxG.keyboard.anyPressed(["S"]) || (gamepadUtilTwo.getPressedbuttons().exists(1) && gamepadUtilTwo.getControllerId() == 1)) {
			FlxG.overlap(player2, player1, killPlayer);
		}
		if (FlxG.keyboard.justPressed("Q")|| (gamepadUtilTwo.getPressedbuttons().exists(3)&& gamepadUtilTwo.getControllerId() == 1 )) {
			player2.interacting = true;
		}
		if (gamepadUtilTwo.getLastbuttonUp() == 7 && gamepadUtilTwo.getControllerId() == 1) {
			player2.destroyGraphics();
			player2.generateGraphics();
		}
		
		if (FlxG.keyboard.anyJustPressed(["SPACE"])) {
			entities.callAll("destroyGraphics");
			entities.callAll("generateGraphics");
		}
		#else
		//player1 controls
		if (FlxG.keyboard.anyPressed(["J"])){
			player1.acceleration.x = -player1.maxVelocity.x * 4;
			player1.facing = FlxObject.LEFT;
		}
		if (FlxG.keyboard.anyPressed(["L"])){
			player1.acceleration.x = player1.maxVelocity.x * 4;
			player1.facing = FlxObject.RIGHT;
		}
		if (FlxG.keyboard.justPressed("I")) {
			player1.jump();
		}
		if (FlxG.keyboard.justPressed("K")) {
			FlxG.overlap(player1, player2, killPlayer);
		}
		if (FlxG.keyboard.justPressed("U")) {
			player1.interacting = true;
		}
		
		
		//player2 controls
		if (FlxG.keyboard.anyPressed(["A"])){
			player2.acceleration.x = -player2.maxVelocity.x * 4;
			player2.facing = FlxObject.LEFT;
		}if (FlxG.keyboard.anyPressed(["D"])){
			player2.acceleration.x = player2.maxVelocity.x * 4;
			player2.facing = FlxObject.RIGHT;
		}if (FlxG.keyboard.justPressed("W")) {
			player2.jump();
		}if (FlxG.keyboard.anyPressed(["S"])) {
			FlxG.overlap(player2, player1, killPlayer);
		}
		if (FlxG.keyboard.justPressed("Q")) {
			player2.interacting = true;
		}
		#end
		
		
		
		if (FlxG.keyboard.anyJustPressed(["SPACE"])) {
			entities.callAll("destroyGraphics");
			entities.callAll("generateGraphics");
		}
		
		//controls above
		npcs.callAll("moveAlongPath");
		npcs.callAll("tryInteract");
		npcs.callAll("tryJump");
		
		//states/controls above
		super.update();
		//updates below
		manageThingies();
		
		
		//Reset Variables
		entities.setAll("interacting", false);
		
		FlxG.collide(Reg._level, entities);
		entities.callAll("postUpdate");
		//FlxG.overlap(entities, entities, entityToEntity);
	}
	public function entityToEntity(attacker:Entity,victim:Entity) {
		if (attacker.interacting) {
			victim.talkBubble.alpha += 0.5;
		}
	}
	public function killPlayer(attacker:FlxObject,victim:FlxObject) {
		victim.kill();
	}

	public function manageThingies()
	{
		FlxG.overlap(doors, players, manageDoors);
		FlxG.overlap(stairs, players, manageStairs);
	}
	
	public function manageDoors(door:Door,entity:Entity)
	{
		var otherDoor:Door = getDoorById(door.relatedDoor);
		if (otherDoor != null && entity.interacting)
		{
			entity.x = otherDoor.x;
			entity.y = otherDoor.y - 10;
			soundManager.playSound("door");
		}
		
	}
	
	public function manageStairs(stairs:Stairs,entity:Entity)
	{
		var otherDoor:Stairs = getStairsById(stairs.relatedStairs);
		if (otherDoor != null && entity.interacting)
		{
			entity.x = otherDoor.x;
			entity.y = otherDoor.y - 10;
			soundManager.playSound("door");
		}
		
	}
	
	public function getDoorById(id:Int):Door
	{
		
		for (i in 0 ... doors.length)
		{
			if (cast(doors._members[i], Door).isId(id))
			{
				return (cast(doors._members[i], Door));
			}
		}
		
		return null;
	}
	
	public function getStairsById(id:Int):Stairs
	{
		
		for (i in 0 ... doors.length)
		{
			if (cast(stairs._members[i], Stairs).isId(id))
			{
				return (cast(stairs._members[i], Stairs));
			}
		}
		
		return null;
	}
	
	private function containsInt(array:Array<Int>,value:Int)
	{
		for (i in array)
		{
			if (i == value)
			{
				return true;
			}
		}
		return false;
	}
	
	public function generateDoors()
	{
		
		var tileXNum:Int = Math.round(Reg.gameWidth);
		var tileYNum:Int = Math.round(Reg.gameHeight);
		var tileStartX:Int = Math.round((tileXNum / 6)) - 1;
		var tileEndX:Int = Math.round((tileXNum / 6)) * 5 + 1;
		
		var doorCounter:Int = 0;
		
		for (i in 0...Math.round(Reg.gameHeight /16))
		{
			if (containsInt(tiles[i], 1))
			{
				if (i - 2 >= 0)
				{
					if (containsInt(tiles[i-1], 0) && containsInt(tiles[i-2],0))
					{
						if (Std.random(10) > 3)
						{
							
							doors.add(new Door(
								
								Std.random(Reg.gameWidth - 256)+128,
								(i * 16 - 30),
								DOOR,
								"assets/images/door.png",
								doorCounter,
								doorCounter + 1));
								
								var doorTwoRandX:Int = Std.random(Reg.gameWidth - 256) + 128;
								while (!(doorTwoRandX < ((cast(doors._members[doors._members.length-1],Door).x)+40))&& !(doorTwoRandX > ((cast(doors._members[doors._members.length-1],Door).x)-20)))
								{
									doorTwoRandX = Std.random(Reg.gameWidth - 256) + 128;
								}
								
							doors.add(new Door(
								Std.random(Reg.gameWidth - 256)+128,
								(i * 16 - 30),
								DOOR,
								"assets/images/door.png",
								doorCounter+1,
								doorCounter));
								doorCounter += 2;
						}
					}
				}
			}
		}
		
	}
	
	
	public function generateStairs()
	{
		
		var tileXNum:Int = Math.round(Reg.gameWidth);
		var tileYNum:Int = Math.round(Reg.gameHeight);
		var tileStartX:Int = Math.round((tileXNum / 6)) - 1;
		var tileEndX:Int = Math.round((tileXNum / 6)) * 5 + 1;
		
		var stairsCounter:Int = 0;
		
		for (i in 0...Math.round(Reg.gameHeight /16))
		{
			if (containsInt(tiles[i], 1))
			{
				if (i - 2 >= 0)
				{
					if (containsInt(tiles[i-1], 0) && containsInt(tiles[i-2],0))
					{
						if (Std.random(10) > 3)
						{
							
							stairs.add(new Stairs(
								
								Std.random(Reg.gameWidth - 256)+128,
								(i * 16 - 30),
								STAIRS,
								"assets/images/stairs.png",
								stairsCounter,
								stairsCounter + 1));
								
								var stairsTwoRandX:Int = Std.random(Reg.gameWidth - 256) + 128;
								while (!(stairsTwoRandX < ((cast(stairs._members[stairs._members.length-1],Stairs).x)+40))&& !(stairsTwoRandX > ((cast(stairs._members[stairs._members.length-1],Stairs).x)-20)))
								{
									stairsTwoRandX = Std.random(Reg.gameWidth - 256) + 128;
								}
								
							stairs.add(new Stairs(
								Std.random(Reg.gameWidth - 256)+128,
								((i + 5) * 16 - 30),
								STAIRS,
								"assets/images/stairs.png",
								stairsCounter+1,
								stairsCounter));
								stairsCounter += 2;
						}
					}
				}
			}
		}
		
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
						Reg._level.setTile(j, i, 1);
						if (j > tileStartX + 2 && j < tileEndX - 2)
						{
							if (tiles.length-1 == i)
							{
								tiles[i].push(1);
							}
							else {
								tiles.push(new Array<Int>());
								tiles[i].push(1);
							}
						}
						
				} else {
					if (j == tileStartX || j == tileStartX + 1 || j == tileEndX - 2 || j == tileEndX - 1) {
						Reg._level.setTile(j, i, 1);
						if (j > tileStartX + 2 && j < tileEndX - 2)
						{
								if (tiles.length-1 == i)
							{
								tiles[i].push(1);
							}
							else {
								tiles.push(new Array<Int>());
								tiles[i].push(1);
							}
						}
					} else {
						Reg._level.setTile(j, i, 0);
						if (j > tileStartX + 2 && j < tileEndX - 2)
						{
							if (tiles.length-1 == i)
							{
								tiles[i].push(0);
							}
							else {
								tiles.push(new Array<Int>());
								tiles[i].push(0);
							}
						}
					}
				}
			}
			floorCount++;
			if (floorCount == floorHeight) floorCount = 0;
			
			
		}
		trace(tiles.toString());
		//randomly insert a trapdoor into one of the floors
		trapX = Std.random((tileEndX - tileStartX)) + 3;
		
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
				Reg._level.setTile(trapX + i, trapY + j, 0);
			}
		}
		
		
	}
}