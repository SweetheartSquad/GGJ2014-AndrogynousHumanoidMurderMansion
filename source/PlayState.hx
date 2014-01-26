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
import flixel.util.FlxSpriteUtil;

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
	private var teleporters:FlxGroup;
	private var players:FlxGroup;
	private var npcs:FlxGroup;
	
	private var particles:FlxGroup;
	
	//players
	private var player1:Player;
	private var player2:Player;
	
	private var player1LivesMask:Array<FlxSprite>;
	private var player2LivesMask:Array<FlxSprite>;
		
	//npcs
	private var npcTest:NPC;
	
	#if flash
	#else
	//Utils 
	private var gamepadUtilOne:GamepadUtil;
	private var gamepadUtilTwo:GamepadUtil;
	#end
	
	//Thingies
	//Lever/Trapdoor
	private var lever:Lever;
	private var trapdoor:TrapDoor;
	private var trapTimer:Int;
	
	//Sound
	private var soundManager:SoundManager;
	
	//Tile map array values
	private var tiles:Array<Array<Int>> ;
	
	
	//Ids
	private var teleporterId:Int;
	
	private static var doorThreshold:Int = 140;
	
	private var framesElapsed:Int = 0;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void{
		//FlxG.mouse.visible = false;
		FlxG.cameras.bgColor = 0xffaaaaaa;
		
		teleporters = new FlxGroup();
		teleporterId = 0;
		
		tiles = new Array();
		
		#if flash
		#else
		generateMapCSV();
		#end
		
		
		Reg.aggressionMap = new TwoDArray(Reg.gameWidth, 4);
		
		
		
		
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
		
		player1 = new Player();
		player2 = new Player();
		
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
		
		for(i in 0...Reg.npcCount){
			npcs.add(new NPC(Math.random()>0.25 ? NpcType.COWARD : NpcType.AGGRESSOR));
		}
		entities = new FlxGroup();
		entities.add(players);
		entities.add(npcs);
		
		
		//add thingies
		add(teleporters);
		//add entities to game
		add(entities);
		
		
		//Add Sounds 
		soundManager = new SoundManager();
		soundManager.addSound("door", "assets/music/door.wav");
		
		var songOneArray:Array<String> = ["assets/music/f1.wav",
		"assets/music/f2.wav",
		"assets/music/f3.wav",
		"assets/music/f4.wav",
		"assets/music/f5.wav",
		"assets/music/f6.wav",
		"assets/music/f7.wav",
		"assets/music/f8.wav",
		];
		
		soundManager.addSong("songOne", songOneArray);
		soundManager.playSong("songOne");
		
		particles = new FlxGroup();
		add(particles);
		
		for (y in 0...Reg.aggressionMap.height) {
			for (x in 0...Reg.aggressionMap.width) {
				this.add(Reg.aggressionMap.vis[Reg.aggressionMap.idx(x,y)]);
			}
		}
		
		var player1Lives:Array<FlxSprite> = new Array();
		var player2Lives:Array<FlxSprite> = new Array();
		player1LivesMask = new Array();
		player2LivesMask = new Array();
		
		player1Lives.push(new FlxSprite(10, 0));
		player1Lives.push(new FlxSprite(10, 75));
		player1Lives.push(new FlxSprite(10, 150));
		player1LivesMask.push(new FlxSprite(10, 0));
		player1LivesMask.push(new FlxSprite(10, 75));
		player1LivesMask.push(new FlxSprite(10, 150));
		
		player2Lives.push(new FlxSprite(Reg.gameWidth-85, 0));
		player2Lives.push(new FlxSprite(Reg.gameWidth-85, 75));
		player2Lives.push(new FlxSprite(Reg.gameWidth-85, 150));
		player2LivesMask.push(new FlxSprite(Reg.gameWidth-85, 0));
		player2LivesMask.push(new FlxSprite(Reg.gameWidth-85, 75));
		player2LivesMask.push(new FlxSprite(Reg.gameWidth-85, 150));
		
		for (i in player1Lives) {
			cast(i, FlxSprite).loadGraphic("assets/images/heart.png");
			add(i);
		}
		for (i in player2Lives) {
			cast(i, FlxSprite).loadGraphic("assets/images/heart.png");
			add(i);
		}for (i in player1LivesMask) {
			cast(i, FlxSprite).loadGraphic("assets/images/heart_mask.png");
			add(i);
		}
		for (i in player2LivesMask) {
			cast(i, FlxSprite).loadGraphic("assets/images/heart_mask.png");
			add(i);
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
		framesElapsed += 1;
		
		//reset accelerations
		for (i in 0 ... players.length) {
			cast(players._members[i],Entity).acceleration.x = 0;
		}for (i in 0 ... npcs.length) {
			cast(npcs._members[i],Entity).acceleration.x = 0;
		}
		
		
		if(player1.alive && player2.alive){
		#if flash
		//player1 controls
		if (FlxG.keyboard.anyPressed(["A"])){
			player1.acceleration.x = -player1.maxVelocity.x * (player1.running ? 8 : 4);
			player1.facing = FlxObject.LEFT;
		}
		if (FlxG.keyboard.anyPressed(["D"])){
			player1.acceleration.x = player1.maxVelocity.x * (player1.running ? 8 : 4);
			player1.facing = FlxObject.RIGHT;
		}
		if (FlxG.keyboard.justPressed("W")) {
			player1.jump();
		}
		if (FlxG.keyboard.justPressed("S")) {
			player1.attacking = true;
		}
		if (FlxG.keyboard.justPressed("Q")) {
			player1.interacting = true;
		}if (FlxG.keyboard.anyPressed(["E"])) {
			player1.running = true;
		}
		
		
		//player2 controls
		if (FlxG.keyboard.anyPressed(["J"])){
			player2.acceleration.x = -player2.maxVelocity.x * (player2.running ? 8 : 4);
			player2.facing = FlxObject.LEFT;
		}if (FlxG.keyboard.anyPressed(["L"])){
			player2.acceleration.x = player2.maxVelocity.x * (player2.running ? 8 : 4);
			player2.facing = FlxObject.RIGHT;
		}if (FlxG.keyboard.justPressed("I")) {
			player2.jump();
		}if (FlxG.keyboard.anyPressed(["K"])) {
			player2.attacking = true;
		}if (FlxG.keyboard.justPressed("U")) {
			player2.interacting = true;
		}if (FlxG.keyboard.anyPressed(["O"])) {
			player2.running = true;
		}
		#else
		//player1 controls
		if (FlxG.keyboard.anyPressed(["A"]) || (gamepadUtilOne.getAxis() < -0.5 && gamepadUtilOne.getControllerId() == 0)){
			player1.acceleration.x = -player1.maxVelocity.x * (player1.running ? 8 : 4);
			player1.facing = FlxObject.LEFT;
		}
		if (FlxG.keyboard.anyPressed(["D"])|| (gamepadUtilOne.getAxis() > 0.5 && gamepadUtilOne.getControllerId() == 0 )){
			player1.acceleration.x = player1.maxVelocity.x * (player1.running ? 8 : 4);
			player1.facing = FlxObject.RIGHT;
		}
		if ((FlxG.keyboard.justPressed("W")|| (gamepadUtilOne.getPressedbuttons().exists(0)&& gamepadUtilOne.getControllerId() == 0 ))) {
			player1.jump();
		}
		if (FlxG.keyboard.justPressed("S")|| (gamepadUtilOne.getPressedbuttons().exists(1)&& gamepadUtilOne.getControllerId() == 0 )) {
			player1.attacking = true;
		}
		if (FlxG.keyboard.justPressed("Q")|| (gamepadUtilOne.getPressedbuttons().exists(2)&& gamepadUtilOne.getControllerId() == 0 )) {
			player1.interacting = true;
		}if (FlxG.keyboard.anyPressed(["E"])|| ((gamepadUtilOne.getPressedbuttons().exists(5)||gamepadUtilOne.getPressedbuttons().exists(4))&& gamepadUtilOne.getControllerId() == 0 )) {
			player1.running = true;
		}
		/*if (gamepadUtilOne.getLastbuttonUp() == 7 && gamepadUtilOne.getControllerId() == 0) {
			player1.destroyGraphics();
			player1.generateGraphics();
			
		}*/
		
		
		//player2 controls
		if (FlxG.keyboard.anyPressed(["J"])|| (gamepadUtilTwo.getAxis() < -0.5 && gamepadUtilTwo.getControllerId() == 1)){
			player2.acceleration.x = -player2.maxVelocity.x * (player2.running ? 8 : 4);
			player2.facing = FlxObject.LEFT;
		}if (FlxG.keyboard.anyPressed(["L"])|| (gamepadUtilTwo.getAxis() > 0.5 && gamepadUtilTwo.getControllerId() == 1 )){
			player2.acceleration.x = player2.maxVelocity.x * (player2.running ? 8 : 4);
			player2.facing = FlxObject.RIGHT;
		}if ((FlxG.keyboard.justPressed("I") || (gamepadUtilTwo.getPressedbuttons().exists(0) && gamepadUtilTwo.getControllerId() == 1))) {
			player2.jump();
		}if (FlxG.keyboard.justPressed("K")|| (gamepadUtilTwo.getPressedbuttons().exists(1)&& gamepadUtilTwo.getControllerId() == 1 )) {
			player2.attacking = true;
		}
		if (FlxG.keyboard.justPressed("U")|| (gamepadUtilTwo.getPressedbuttons().exists(2)&& gamepadUtilTwo.getControllerId() == 1 )) {
			player2.interacting = true;
		}if (FlxG.keyboard.anyPressed(["O"])|| ((gamepadUtilTwo.getPressedbuttons().exists(5)||gamepadUtilTwo.getPressedbuttons().exists(4))&& gamepadUtilTwo.getControllerId() == 1 )) {
			player2.running = true;
		}
		/*if (gamepadUtilTwo.getLastbuttonUp() == 7 && gamepadUtilTwo.getControllerId() == 1) {
			player2.destroyGraphics();
			player2.generateGraphics();
		}*/
		
		
		/*if (FlxG.keyboard.anyJustPressed(["SPACE"])) {
			entities.callAll("destroyGraphics");
			entities.callAll("generateGraphics");
			
			trapdoor.kill();
			lever.kill();
			teleporters.kill();
			teleporters = new FlxGroup();
			add(teleporters);
			generateLevel();
		}*/
		#end
		
		
		/*if (FlxG.keyboard.anyJustPressed(["SPACE"])) {
			entities.callAll("destroyGraphics");
			entities.callAll("generateGraphics");
		}*/
		
		//controls above
		npcs.callAll("moveAlongPath");
		npcs.callAll("tryInteract");
		npcs.callAll("tryJump");
		if(framesElapsed > 600){
			npcs.callAll("tryAttack");
		}
		
		entities.callAll("runningCheck");}
		//states/controls above
		super.update();
		
		if(player1.alive && player2.alive){
		//updates below
		manageThingies();

		//Reset Variables
		entities.setAll("interacting", false);
		}
		FlxG.collide(Reg._level, entities);
		FlxG.collide(Reg._level, particles,particleCollide);
		particles.callAll("postUpdate");
		
		entities.callAll("postUpdate");
		if(player1.alive && player2.alive){
		FlxG.overlap(entities, entities, entityToEntity);
		entities.setAll("running", false);
		
		
		entities.callAll("attackDelay");
		
		Reg.aggressionMap.reduceAggression();
		
		
		entities.callAll("updateAggression");
		npcs.callAll("updateLocalAggression");
		
		if(Reg.viewAggression){
			Reg.aggressionMap.colourSprites();
		}
		
		}else{
			entities.setAll("winState", true);
			player1.alive ? makeGibs(player1.x, player1.y, true) : makeGibs(player2.x, player2.y, true);
		}
		
		
		
		//GUI
		if (player1 != null) {
			player1LivesMask[player1.lives].alpha = player1.health / 100;
			if (player1.lives < 2) {
				player1LivesMask[2].alpha = 0;
			}if (player1.lives < 1) {
				player1LivesMask[1].alpha = 0;
			}if(player1.lives < 0){
				player1LivesMask[0].alpha = 0;
			}
		}if(player2 != null){
			player2LivesMask[player2.lives].alpha = player2.health / 100;
			if (player2.lives < 2) {
				player2LivesMask[2].alpha = 0;
			}if (player2.lives < 1) {
				player2LivesMask[1].alpha = 0;
			}if(player2.lives < 0) {
				player2LivesMask[0].alpha = 0;
			}
		}
		
	}
	public function entityToEntity(object1:Entity,object2:Entity) {
		if (object2.attacking && object2.attackTimer == 3) {
			makeGibs(object1.x, object1.y);
			object1.health -= object2.attackDmg;
			if(object1.health <= 0.0){
			makeGibs(object1.x, object1.y);
			makeGibs(object1.x, object1.y);
				object1.kill();
			}
		}
		if (object1.attacking && object1.attackTimer == 3) {
			makeGibs(object2.x, object2.y);
			object2.health -= object1.attackDmg;
			if(object2.health <= 0.0){
			makeGibs(object2.x, object2.y);
			makeGibs(object2.x, object2.y);
				object2.kill();
			}
		}
	}
	public function makeGibs(_x:Float, _y:Float, _happy:Bool = false) {
		particles.add(new Particle(_x, _y, _happy));
		particles.add(new Particle(_x, _y, _happy));
		particles.add(new Particle(_x, _y, _happy));
		if(Math.random()>0.6){
			makeGibs(_x, _y, _happy);
		}
	}
	public function particleCollide(object1:FlxTilemap, object2:Particle) {
		//trace("collision");
		if(Math.random()<0.01){
			object2.allowCollisions = FlxObject.NONE;
			object2.timer = 8;
		}
	}
	public function manageThingies(){
		FlxG.overlap(teleporters, entities, manageTeleporters);
		FlxG.overlap(lever, entities, manageLever);
		FlxG.collide(trapdoor, entities);
		trapdoor.immovable = true;
		if (trapTimer > 0) {
			--trapTimer;
		}else if (trapTimer == 0 && trapdoor.isActive == true) {
			trapdoor.x -= 32;
			trapdoor.y -= 1;
			trapdoor.isActive = false;
		}
	}
	
	public function manageTeleporters(door:Teleporter,entity:Entity){
		var otherTeleporter:Teleporter = getTeleporterById(door.relatedId);
		if (otherTeleporter != null && entity.interacting) {
			entity.interacting = false;
			entity.x = otherTeleporter.x;
			entity.y = otherTeleporter.y - 10;
			soundManager.playSound("door");
		}
		
	}
	public function manageLever(lever:Lever,entity:Entity){
		if (trapdoor != null && entity.interacting && trapdoor.isActive == false) {
			entity.interacting = false;
			trapdoor.x += 32;
			trapdoor.y += 1;
			trapdoor.isActive = true;
			trapTimer = 100;
		}
		
	}
	public function getTeleporterById(id:Int):Teleporter
	{
		
		for (i in 0 ... teleporters.length)
		{
			if (cast(teleporters._members[i], Teleporter).isId(id))
			{
				return (cast(teleporters._members[i], Teleporter));
			}
		}
		
		return null;
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
		var tileStartX:Int = Math.round((tileXNum / 8));
		var tileEndX:Int = tileXNum-tileStartX;
		
		var floorHeight = Math.round((tileYNum - 4) / 4);
		var floorCount = -3;
		
		var tempX:Int;
		var tempY:Int;
		
		//add walls and floors to the level
		for (y in 0...tileYNum) {
			for (x in tileStartX...tileEndX) {
				if (floorCount == (floorHeight - 1) || y == 0 || y == 1 || y == tileYNum - 1 || y == tileYNum - 2) {
					Reg._level.setTile(x, y, 1);
					if (x > tileStartX + 2 && x < tileEndX - 2){
						if (tiles.length-1 == y){
							tiles[y].push(1);
						}else {
							tiles.push(new Array<Int>());
							tiles[y].push(1);
						}
					}
				} else {
					if (x == tileStartX || x == tileStartX + 1 || x == tileEndX - 2 || x == tileEndX - 1) {
						Reg._level.setTile(x, y, 1);
						if (x > tileStartX + 2 && x < tileEndX - 2){
							if (tiles.length-1 == y){
								tiles[y].push(1);
							}else {
								tiles.push(new Array<Int>());
								tiles[y].push(1);
							}
						}
					} else {
						Reg._level.setTile(x, y, 0);
						if (x > tileStartX + 2 && x < tileEndX - 2){
							if (tiles.length-1 == y){
								tiles[y].push(0);
							}else {
								tiles.push(new Array<Int>());
								tiles[y].push(0);
							}
						}
					}
				}
			}
			floorCount++;
			if (floorCount == floorHeight) floorCount = 0;
		}
		
		//randomly insert a hole into one of the floors
		tempX = getTempX();
		tempY = getTempY();
		for (i in 0...2) {
			for (j in 0...1) {
				Reg._level.setTile(tempX + i, tempY + j, 0);
			}
		}
		
		
		
		
		
		//create the trapdoor
		trapdoor = new TrapDoor((tempX*16), (tempY*16),"assets/image/trapdoor.png");
		add(trapdoor);
		
		//position and create lever
		tempX = getTempX() * 16;
		tempY = getTempY() * 16;
		
		lever = new Lever(tempX, (tempY) - 22,"assets/image/lever.png");
		add(lever);
		
		
		//elevators -> stairs -> doors
		//ELEVATORS
		tempX = getTempX() * 16;
		var maxNumElevators = Std.random(3) + 2;
		for (numElevators in 0...maxNumElevators) {
			var flag:Bool = true;
			var flag2:Bool = false;
			do {
				tempY = (getTempY() -2) * 16;
				for (i in teleporters._members) {
					if (Math.abs(cast(i, Teleporter).y - tempY) < 75) {
						flag2 = true;
						break;
					}
				}
				flag = false;
				if (flag2) {
					flag = true;
					flag2 = false;
				}
			}while (flag);
			
			var tempId:Int = teleporters.length;
			teleporters.add(new Teleporter(tempX, tempY, ThingyType.ELEVATOR, "assets/elevator.png", numElevators, numElevators == maxNumElevators-1 ? 0 : tempId + 1));
		}
		
		//STAIRS
		for (numStairs in 0...2/*Std.random(3)*/) {
			//first stair
			var flag:Bool = true;
			var flag2:Bool = false;
			do {
				tempY = (getTempY()-2) * 16;
				tempX = getTempX() * 16;
				for (i in teleporters._members) {
					if ((Math.abs(cast(i, Teleporter).x - tempX) < 75) && (Math.abs(cast(i, Teleporter).y - tempY) < 75)) {
						flag2 = true;
						break;
					}
				}
				flag = false;
				if (flag2) {
					flag = true;
					flag2 = false;
				}
			}while (flag);
			var tempId:Int = teleporters.length;
			teleporters.add(new Teleporter(tempX, tempY, ThingyType.STAIRS, "assets/stairs.png", tempId, tempId + 1));
			
			//second stair floor
			do {
				tempY = (getTempY()-2) * 16;
			}while (Math.abs(cast(teleporters._members[teleporters.length-1],Teleporter).y-tempY) < 75);
			
			//second stair xpos
			flag = true;
			flag2 = false;
			do {
				tempX = getTempX() * 16;
				for (i in teleporters._members) {
					if (Math.abs(cast(i, Teleporter).x - tempX) < 75 && Math.abs(cast(i, Teleporter).y - tempY) < 75) {
						flag2 = true;
						break;
					}
				}
				flag = false;
				if (flag2) {
					flag = true;
					flag2 = false;
				}
			}while (flag);
			teleporters.add(new Teleporter(tempX, tempY, ThingyType.STAIRS, "assets/stairs.png", tempId+1, tempId));
		}
		
		for(numDoors in 0...Std.random(2)+1){
			//first door
			var tempId:Int = teleporters.length;
			var sentinel:Int = 0;
			var flag:Bool = true;
			var flag2:Bool = false;
			do {
				tempY = (getTempY()-2) * 16;
				tempX = getTempX() * 16;
				for (i in teleporters._members) {
					if ((Math.abs(cast(i, Teleporter).x - tempX) < 75) && (Math.abs(cast(i, Teleporter).y - tempY) < 75)) {
						flag2 = true;
						break;
					}
				}
				flag = false;
				if (flag2) {
					flag = true;
					flag2 = false;
				}
				if (sentinel < 100000) {
					sentinel += 1;
				}else {
					//trace("broken1");
					break;
				}
			}while (flag);
			teleporters.add(new Teleporter(tempX, tempY, ThingyType.DOOR, "assets/door.png", tempId, tempId + 1));
			
			//first door
			var flag:Bool = true;
			var flag2:Bool = false;
			do {
				tempX = getTempX() * 16;
				for (i in teleporters._members) {
					if ((Math.abs(cast(i, Teleporter).x - tempX) < 50) && (Math.abs(cast(i, Teleporter).y - tempY) < 75)) {
						flag2 = true;
						break;
					}
				}
				flag = false;
				if (flag2) {
					flag = true;
					flag2 = false;
				}
				if (sentinel < 200000) {
					sentinel += 1;
				}else {
					//trace("broken2");
					break;
				}
			}while (flag);
			//trace(sentinel);
			teleporters.add(new Teleporter(tempX, tempY, ThingyType.DOOR, "assets/door.png", tempId+1, tempId));
		}
		
		
		//generate stalactites/stalagmites
		var tempTile:Array<Int> = new Array();
		for (i in 0...Std.random(50)+5) {
			var _x:Int = getTempX();
			var _y:Int = getTempY() - 1;
			tempTile.push(_x);
			Reg._level.setTile(_x, _y, compareToTeleporters(_x,_y));
			
			
		}for (i in 0...Std.random(50)+5) {
			var _x:Int;
			var _y:Int = getTempY() + 1 - floorHeight;
			if (_y < floorHeight) {
				_y -= 1;
			}
			var flag:Bool = true;
			var flag2:Bool = false;
			do {
				_x = getTempX();
				
				for (i in tempTile) {
					if (i == _x) {
						flag2 = true;
						break;
					}
				}
				flag = false;
				if (flag2) {
					flag = true;
					flag2 = false;
				}
			}while (flag);
			Reg._level.setTile(_x, _y, compareToTeleporters(_x,_y));
		}
		
		
		var tempTile:Array<Int> = new Array();
		for (i in 0...Std.random(3)+3) {
			var _x:Int = getTempX();
			var _y:Int;
			if (i >= 3) {
				_y = getTempY();
			}else if (i == 0) {
				_y = 2 + floorHeight;
			}else if (i == 1) {
				_y = 2 + floorHeight * 2;
			}else {
				_y = 2 + floorHeight * 3;
			}
			Reg._level.setTile(_x, _y, 0);
		}
	}
	public function compareToTeleporters(tempX:Int, tempY:Int) {
		for (i in teleporters._members) {
			if ((cast(i, Teleporter).x - tempX*16 < 5) && (cast(i, Teleporter).y - tempY*16 < 5)) {
				return 0;
			}
		}
		return 1;
	}
	public function getTempX():Int {
		var tileXNum:Int = Math.round(Reg.gameWidth / 16);
		var tileStartX:Int = Math.round((tileXNum / 8));
		var tileEndX:Int = tileXNum-tileStartX;
		
		return Std.random((tileEndX - tileStartX) - 5) + tileStartX+2;
	}
	public function getTempY():Int {
		var tileYNum:Int = Math.round(Reg.gameHeight / 16);
		var floorHeight = Math.round((tileYNum - 4) / 4);
		switch(Std.random(4)) {
			case 0:
				return (2 + floorHeight);
			case 1:
				return (2 + (floorHeight * 2));
			case 2:
				return (2 + (floorHeight * 3));
			case 3:
				return (2 + (floorHeight * 4));
			default:
				return -1;
		}
	}
}