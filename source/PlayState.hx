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

import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;


#if flash
#else
import utils.GamepadUtil;
import sys.io.File;
import sys.io.FileInput;
import sys.io.FileOutput;

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
	private var players:FlxGroup;
	private var npcs:FlxGroup;
	
	private var particles:FlxGroup;
	
	//players
	private var player1:Player;
	private var player2:Player;
	
	//npcs
	private var npcTest:NPC;
	
	#if flash
	#else
	//Utils 
	private var gamepadUtilOne:GamepadUtil;
	private var gamepadUtilTwo:GamepadUtil;
	#end
	
	//Thingies
	private var doorOne:Teleporter;
	private var doorTwo:Teleporter;
	//Sound
	private var soundManager:SoundManager;
	
	//Tile map array values
	private var tiles:Array<Array<Int>> ;
	
	
	//Ids
	private var teleporterId:Int;
	
	private static var doorThreshold:Int = 140;
	
	

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void{
		//FlxG.mouse.visible = false;
		FlxG.cameras.bgColor = 0xffaaaaaa;
		
		doors = new FlxGroup();
		teleporterId = 0;
		
		tiles = new Array();
		
		#if flash
		#else
		generateMapCSV();
		#end
		
		
		Reg.aggresionMap = new TwoDArray(Reg.gameWidth, 4);
		
		
		
		
		Reg._level = new FlxTilemap();
		Reg._level.loadMap(Assets.getText("assets/level.csv"), "assets/images/woodTileSet.png", TILE_WIDTH, TILE_HEIGHT, FlxTilemap.AUTO);
		
		//var bm = new Bitmap(new TestBMD(100,100));
		var bg:FlxSprite = new FlxSprite(-525,-310);
		bg.loadGraphic("assets/images/background.png");
		bg.scale.x /= Reg.zoom;
		bg.scale.y /= Reg.zoom;
		add(bg);
		add(Reg._level);
		generateLevel();
		
		generateStairs();
		generateDoors();
		generateElevators();
		
		

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
		
		#if flash
	trace("FLASH");
		#else
	trace("!FLASH");
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
		
		for(i in 0...Reg.npcCount){
			npcs.add(new NPC());
		}
		entities = new FlxGroup();
		entities.add(players);
		entities.add(npcs);
		
		
		//add thingies
		add(doors);
		//add entities to game
		add(entities);
		
		
		//Add Sounds 
		soundManager = new SoundManager();
		soundManager.addSound("door", "assets/music/door.wav");
		
		particles = new FlxGroup();
		add(particles);
		
		for (y in 0...Reg.aggresionMap.height) {
			for (x in 0...Reg.aggresionMap.width) {
				this.add(Reg.aggresionMap.vis[Reg.aggresionMap.idx(x,y)]);
			}
		}
		
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
		
		#if flash
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
			player1.attacking = true;
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
			player2.attacking = true;
		}
		if (FlxG.keyboard.justPressed("Q")) {
			player2.interacting = true;
		}
		#else
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
			player1.attacking = true;
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
		}if (FlxG.keyboard.justPressed("S")|| (gamepadUtilTwo.getPressedbuttons().exists(1)&& gamepadUtilTwo.getControllerId() == 1 )) {
			player2.attacking = true;
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
		#end
		
		
		
		if (FlxG.keyboard.anyJustPressed(["SPACE"])) {
			entities.callAll("destroyGraphics");
			entities.callAll("generateGraphics");
		}
		
		//controls above
		npcs.callAll("moveAlongPath");
		npcs.callAll("tryInteract");
		npcs.callAll("tryJump");
		npcs.callAll("tryAttack");
		
		//states/controls above
		super.update();
		//updates below
		manageThingies();
		

		//Reset Variables
		entities.setAll("interacting", false);
		
		FlxG.collide(Reg._level, entities);
		FlxG.collide(Reg._level, particles,particleCollide);
		particles.callAll("postUpdate");
		
		entities.callAll("postUpdate");
		FlxG.overlap(entities, entities, entityToEntity);
		
		
		entities.callAll("attackDelay");
		
		Reg.aggresionMap.reduceAggression();
		
		entities.callAll("updateAggresion");
		
		/*for (y in 0...Reg.aggresionMap.height) {
			for (x in 0...Reg.aggresionMap.width) {
				this.remove(Reg.aggresionMap.vis[Reg.aggresionMap.idx(x,y)]);
			}
		}*/
		
		//Reg.aggresionMap.colourSprites();
		
		/*for (y in 0...Reg.aggresionMap.height) {
			for (x in 0...Reg.aggresionMap.width) {
				this.add(Reg.aggresionMap.vis[Reg.aggresionMap.idx(x,y)]);
			}
		}*/
	}
	public function entityToEntity(object1:Entity,object2:Entity) {
		if (object1.interacting) {
			object2.talkBubble.alpha += 0.5;
		}
		
		if (object2.attacking && object2.attackTimer == 3) {
			makeGibs(object1.x, object1.y);
			object1.kill();
		}
		if (object1.attacking && object1.attackTimer == 3) {
			makeGibs(object2.x, object2.y);
			object2.kill();
		}
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
	public function particleCollide(object1:FlxTilemap, object2:Particle) {
		//trace("collision");
		if(Math.random()<0.01){
			object2.allowCollisions = FlxObject.NONE;
			object2.timer = 8;
		}
	}
	public function manageThingies()
	{
		FlxG.overlap(doors, entities, manageTeleporters);
	}
	
	public function manageTeleporters(door:Teleporter,entity:Entity)
	{
		var otherTeleporter:Teleporter = getTeleporterById(door.relatedId);
		if (otherTeleporter != null && entity.interacting)
		{
			entity.x = otherTeleporter.x;
			entity.y = otherTeleporter.y - 10;
			soundManager.playSound("door");
		}
		
	}
	
	public function getTeleporterById(id:Int):Teleporter
	{
		
		for (i in 0 ... doors.length)
		{
			if (cast(doors._members[i], Teleporter).isId(id))
			{
				return (cast(doors._members[i], Teleporter));
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
							
							doors.add(new Teleporter(
								
								Std.random((Reg.gameWidth - doorThreshold) - doorThreshold) + doorThreshold,
								(i * 16 - 30),
								DOOR,
								"assets/images/door.png",
								teleporterId,
								teleporterId + 1));
								
								var doorTwoRandX:Int = Std.random((Reg.gameWidth - doorThreshold) - doorThreshold) + doorThreshold;
								while ((doorTwoRandX < ((cast(doors._members[doors._members.length-1],Teleporter).x)+60))&& (doorTwoRandX > ((cast(doors._members[doors._members.length-1],Teleporter).x)-40)))
								{
									doorTwoRandX = Std.random((Reg.gameWidth - doorThreshold) - doorThreshold) + doorThreshold;
								}
								
							doors.add(new Teleporter(
								Std.random((Reg.gameWidth - doorThreshold) - doorThreshold) + doorThreshold,
								(i * 16 - 30),
								DOOR,
								"assets/images/door.png",
								teleporterId+1,
								teleporterId));
								teleporterId += 2;
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
		
		for (i in 0...Math.round(Reg.gameHeight /16))
		{
			if (containsInt(tiles[i], 1))
			{
				if (i - 2 >= 0)
				{
					if (containsInt(tiles[i-1], 0) && containsInt(tiles[i-2],0) && !containsInt(tiles[i+1],1))
					{
						if (Std.random(10) > 3)
						{
							
							doors.add(new Teleporter(
								
								Std.random((Reg.gameWidth - doorThreshold) - doorThreshold) + doorThreshold,
								(i * 16 - 30),
								STAIRS,
								"assets/images/door.png",
								teleporterId,
								teleporterId + 1));
								
								var doorsTwoRandX:Int = Std.random((Reg.gameWidth - doorThreshold) - doorThreshold) + doorThreshold;
								
								var genX = true; 
								
								while (
								{
									(doorsTwoRandX < ((cast(doors._members[doors._members.length-1],Teleporter).x)+60))&& (doorsTwoRandX > ((cast(doors._members[doors._members.length-1],Teleporter).x)-40)))
									doorsTwoRandX = Std.random((Reg.gameWidth - doorThreshold) - doorThreshold) + doorThreshold;
								}
								
								var doorsTwoRandY:Int = 0;
								var tempI = i+1;
								
								
								while(containsInt(tiles[tempI],0))
								{
									tempI++;
								}
								
								
							doors.add(new Teleporter(
								Std.random((Reg.gameWidth - doorThreshold) - doorThreshold) + doorThreshold,
								((tempI) * 16 - 30),
								STAIRS,
								"assets/images/door.png",
								teleporterId+1,
								teleporterId));
								teleporterId += 2;
						}
					}
				}
			}
		}
		
	}
	
	public function generateElevators()
	{
		var tileXNum:Int = Math.round(Reg.gameWidth);
		var tileYNum:Int = Math.round(Reg.gameHeight);
		var tileStartX:Int = Math.round((tileXNum / 6)) - 1;
		var tileEndX:Int = Math.round((tileXNum / 6)) * 5 + 1;
		
		for (i in 0...Math.round(Reg.gameHeight /16))
		{
			if (containsInt(tiles[i], 1))
			{
				if (i - 2 >= 0)
				{
					if (containsInt(tiles[i-1], 0) && containsInt(tiles[i-2],0))
					{
						if (!hasStairs(i))
						{
							
							doors.add(new Teleporter(
								
								Std.random((Reg.gameWidth - doorThreshold) - doorThreshold) + doorThreshold,
								(i * 16 - 30),
								ELEVATOR,
								"assets/images/door.png",
								teleporterId,
								teleporterId + 1));
								
								
						}
					}
				}
			}
		}
		
		var numElev:Int = 0;
		
		for (i in 0...doors.length)
		{
			if (cast(doors._members[i], Teleporter).type == ELEVATOR)
			numElev++; 
		}
		
		if (numElev == 1)
		{
			for (i in 0...Math.round(Reg.gameHeight /16))
				{
					if (hasStairs(i))
					{
						if (containsInt(tiles[i], 1))
						{
							if (i - 2 >= 0)
							{
								if (containsInt(tiles[i-1], 0) && containsInt(tiles[i-2],0))
								{
									doors.add(new Teleporter(
										
										Std.random((Reg.gameWidth - doorThreshold) - doorThreshold) + doorThreshold,
										(i * 16 - 30),
										ELEVATOR,
										"assets/images/door.png",
										teleporterId,
										teleporterId + 1));
										
									break;
								}
							}
					}	}
				
			}
		}
	}
	
	private function hasStairs(iterator:Int)
	{
		for (i in 0...doors.length)
		{
			if ((cast(doors._members[i], Teleporter).y+30 )/ 16 == iterator && cast(doors._members[i], Teleporter).type==STAIRS)
			return true;
		}
		
		return false;
	}
	
	private function hasElevator(iterator:Int)
	{
		for (i in 0...doors.length)
		{
			if ((cast(doors._members[i], Teleporter).y+30 )/ 16 == iterator && cast(doors._members[i], Teleporter).type==ELEVATOR)
			return true;
		}
		
		return false;
	}
	
	
	#if flash
	#else
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
	#end
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