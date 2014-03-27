package;


import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.MovieClip;
import flash.text.Font;
import flash.media.Sound;
import flash.net.URLRequest;
import flash.utils.ByteArray;
import haxe.Unserializer;
import openfl.Assets;

#if (flash || js)
import flash.display.Loader;
import flash.events.Event;
import flash.net.URLLoader;
#end

#if ios
import openfl.utils.SystemPath;
#end


@:access(flash.media.Sound)
class DefaultAssetLibrary extends AssetLibrary {
	
	
	public static var className (default, null) = new Map <String, Dynamic> ();
	public static var path (default, null) = new Map <String, String> ();
	public static var type (default, null) = new Map <String, AssetType> ();
	
	
	public function new () {
		
		super ();
		
		#if flash
		
		className.set ("assets/data/data-goes-here.txt", __ASSET__assets_data_data_goes_here_txt);
		type.set ("assets/data/data-goes-here.txt", Reflect.field (AssetType, "text".toUpperCase ()));
		className.set ("assets/images/armAnimations.png", __ASSET__assets_images_armanimations_png);
		type.set ("assets/images/armAnimations.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("assets/images/armAnimationsHD.png", __ASSET__assets_images_armanimationshd_png);
		type.set ("assets/images/armAnimationsHD.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("assets/images/background.png", __ASSET__assets_images_background_png);
		type.set ("assets/images/background.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("assets/images/door.png", __ASSET__assets_images_door_png);
		type.set ("assets/images/door.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("assets/images/doorObjThingy.png", __ASSET__assets_images_doorobjthingy_png);
		type.set ("assets/images/doorObjThingy.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("assets/images/ElevatorObjThingy.png", __ASSET__assets_images_elevatorobjthingy_png);
		type.set ("assets/images/ElevatorObjThingy.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("assets/images/heart.png", __ASSET__assets_images_heart_png);
		type.set ("assets/images/heart.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("assets/images/heart_mask.png", __ASSET__assets_images_heart_mask_png);
		type.set ("assets/images/heart_mask.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("assets/images/images-go-here.txt", __ASSET__assets_images_images_go_here_txt);
		type.set ("assets/images/images-go-here.txt", Reflect.field (AssetType, "text".toUpperCase ()));
		className.set ("assets/images/instructions1.png", __ASSET__assets_images_instructions1_png);
		type.set ("assets/images/instructions1.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("assets/images/instructions2.png", __ASSET__assets_images_instructions2_png);
		type.set ("assets/images/instructions2.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("assets/images/instructions3.png", __ASSET__assets_images_instructions3_png);
		type.set ("assets/images/instructions3.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("assets/images/instructions4.png", __ASSET__assets_images_instructions4_png);
		type.set ("assets/images/instructions4.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("assets/images/legAnimations.png", __ASSET__assets_images_leganimations_png);
		type.set ("assets/images/legAnimations.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("assets/images/legAnimationsHD.png", __ASSET__assets_images_leganimationshd_png);
		type.set ("assets/images/legAnimationsHD.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("assets/images/LeverObjThingy.png", __ASSET__assets_images_leverobjthingy_png);
		type.set ("assets/images/LeverObjThingy.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("assets/images/mask.png", __ASSET__assets_images_mask_png);
		type.set ("assets/images/mask.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("assets/images/runCycle.png", __ASSET__assets_images_runcycle_png);
		type.set ("assets/images/runCycle.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("assets/images/StairObjThingy.png", __ASSET__assets_images_stairobjthingy_png);
		type.set ("assets/images/StairObjThingy.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("assets/images/titleCard.png", __ASSET__assets_images_titlecard_png);
		type.set ("assets/images/titleCard.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("assets/images/TrapDoorObjThingy.png", __ASSET__assets_images_trapdoorobjthingy_png);
		type.set ("assets/images/TrapDoorObjThingy.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("assets/images/woodTileSet.png", __ASSET__assets_images_woodtileset_png);
		type.set ("assets/images/woodTileSet.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("assets/level.csv", __ASSET__assets_level_csv);
		type.set ("assets/level.csv", Reflect.field (AssetType, "binary".toUpperCase ()));
		className.set ("assets/music/door.wav", __ASSET__assets_music_door_wav);
		type.set ("assets/music/door.wav", Reflect.field (AssetType, "sound".toUpperCase ()));
		className.set ("assets/music/f1.wav", __ASSET__assets_music_f1_wav);
		type.set ("assets/music/f1.wav", Reflect.field (AssetType, "sound".toUpperCase ()));
		className.set ("assets/music/f2.wav", __ASSET__assets_music_f2_wav);
		type.set ("assets/music/f2.wav", Reflect.field (AssetType, "sound".toUpperCase ()));
		className.set ("assets/music/f3.wav", __ASSET__assets_music_f3_wav);
		type.set ("assets/music/f3.wav", Reflect.field (AssetType, "sound".toUpperCase ()));
		className.set ("assets/music/f4.wav", __ASSET__assets_music_f4_wav);
		type.set ("assets/music/f4.wav", Reflect.field (AssetType, "sound".toUpperCase ()));
		className.set ("assets/music/f5.wav", __ASSET__assets_music_f5_wav);
		type.set ("assets/music/f5.wav", Reflect.field (AssetType, "sound".toUpperCase ()));
		className.set ("assets/music/f6.wav", __ASSET__assets_music_f6_wav);
		type.set ("assets/music/f6.wav", Reflect.field (AssetType, "sound".toUpperCase ()));
		className.set ("assets/music/f7.wav", __ASSET__assets_music_f7_wav);
		type.set ("assets/music/f7.wav", Reflect.field (AssetType, "sound".toUpperCase ()));
		className.set ("assets/music/f8.wav", __ASSET__assets_music_f8_wav);
		type.set ("assets/music/f8.wav", Reflect.field (AssetType, "sound".toUpperCase ()));
		className.set ("assets/music/music-goes-here.txt", __ASSET__assets_music_music_goes_here_txt);
		type.set ("assets/music/music-goes-here.txt", Reflect.field (AssetType, "text".toUpperCase ()));
		className.set ("assets/sounds/sounds-go-here.txt", __ASSET__assets_sounds_sounds_go_here_txt);
		type.set ("assets/sounds/sounds-go-here.txt", Reflect.field (AssetType, "text".toUpperCase ()));
		
		
		#elseif html5
		
		addExternal("assets/data/data-goes-here.txt", "text", "assets/data/data-goes-here.txt");
		addExternal("assets/images/armAnimations.png", "image", "assets/images/armAnimations.png");
		addExternal("assets/images/armAnimationsHD.png", "image", "assets/images/armAnimationsHD.png");
		addExternal("assets/images/background.png", "image", "assets/images/background.png");
		addExternal("assets/images/door.png", "image", "assets/images/door.png");
		addExternal("assets/images/doorObjThingy.png", "image", "assets/images/doorObjThingy.png");
		addExternal("assets/images/ElevatorObjThingy.png", "image", "assets/images/ElevatorObjThingy.png");
		addExternal("assets/images/heart.png", "image", "assets/images/heart.png");
		addExternal("assets/images/heart_mask.png", "image", "assets/images/heart_mask.png");
		addExternal("assets/images/images-go-here.txt", "text", "assets/images/images-go-here.txt");
		addExternal("assets/images/instructions1.png", "image", "assets/images/instructions1.png");
		addExternal("assets/images/instructions2.png", "image", "assets/images/instructions2.png");
		addExternal("assets/images/instructions3.png", "image", "assets/images/instructions3.png");
		addExternal("assets/images/instructions4.png", "image", "assets/images/instructions4.png");
		addExternal("assets/images/legAnimations.png", "image", "assets/images/legAnimations.png");
		addExternal("assets/images/legAnimationsHD.png", "image", "assets/images/legAnimationsHD.png");
		addExternal("assets/images/LeverObjThingy.png", "image", "assets/images/LeverObjThingy.png");
		addExternal("assets/images/mask.png", "image", "assets/images/mask.png");
		addExternal("assets/images/runCycle.png", "image", "assets/images/runCycle.png");
		addExternal("assets/images/StairObjThingy.png", "image", "assets/images/StairObjThingy.png");
		addExternal("assets/images/titleCard.png", "image", "assets/images/titleCard.png");
		addExternal("assets/images/TrapDoorObjThingy.png", "image", "assets/images/TrapDoorObjThingy.png");
		addExternal("assets/images/woodTileSet.png", "image", "assets/images/woodTileSet.png");
		addExternal("assets/level.csv", "binary", "assets/level.csv");
		addExternal("assets/music/door.wav", "sound", "assets/music/door.wav");
		addExternal("assets/music/f1.wav", "sound", "assets/music/f1.wav");
		addExternal("assets/music/f2.wav", "sound", "assets/music/f2.wav");
		addExternal("assets/music/f3.wav", "sound", "assets/music/f3.wav");
		addExternal("assets/music/f4.wav", "sound", "assets/music/f4.wav");
		addExternal("assets/music/f5.wav", "sound", "assets/music/f5.wav");
		addExternal("assets/music/f6.wav", "sound", "assets/music/f6.wav");
		addExternal("assets/music/f7.wav", "sound", "assets/music/f7.wav");
		addExternal("assets/music/f8.wav", "sound", "assets/music/f8.wav");
		addExternal("assets/music/music-goes-here.txt", "text", "assets/music/music-goes-here.txt");
		addExternal("assets/sounds/sounds-go-here.txt", "text", "assets/sounds/sounds-go-here.txt");
		
		
		#else
		
		try {
			
			#if blackberry
			var bytes = ByteArray.readFile ("app/native/manifest");
			#elseif tizen
			var bytes = ByteArray.readFile ("../res/manifest");
			#elseif emscripten
			var bytes = ByteArray.readFile ("assets/manifest");
			#else
			var bytes = ByteArray.readFile ("manifest");
			#end
			
			if (bytes != null) {
				
				bytes.position = 0;
				
				if (bytes.length > 0) {
					
					var data = bytes.readUTFBytes (bytes.length);
					
					if (data != null && data.length > 0) {
						
						var manifest:Array<AssetData> = Unserializer.run (data);
						
						for (asset in manifest) {
							
							path.set (asset.id, asset.path);
							type.set (asset.id, asset.type);
							
						}
						
					}
					
				}
				
			} else {
				
				trace ("Warning: Could not load asset manifest");
				
			}
			
		} catch (e:Dynamic) {
			
			trace ("Warning: Could not load asset manifest");
			
		}
		
		#end
		
	}
	
	
	#if html5
	private function addEmbed(id:String, kind:String, value:Dynamic):Void {
		className.set(id, value);
		type.set(id, Reflect.field(AssetType, kind.toUpperCase()));
	}
	
	
	private function addExternal(id:String, kind:String, value:String):Void {
		path.set(id, value);
		type.set(id, Reflect.field(AssetType, kind.toUpperCase()));
	}
	#end
	
	
	public override function exists (id:String, type:AssetType):Bool {
		
		var assetType = DefaultAssetLibrary.type.get (id);
		
		#if pixi
		
		if (assetType == IMAGE) {
			
			return true;
			
		} else {
			
			return false;
			
		}
		
		#end
		
		if (assetType != null) {
			
			if (assetType == type || ((type == SOUND || type == MUSIC) && (assetType == MUSIC || assetType == SOUND))) {
				
				return true;
				
			}
			
			#if flash
			
			if ((assetType == BINARY || assetType == TEXT) && type == BINARY) {
				
				return true;
				
			} else if (path.exists (id)) {
				
				return true;
				
			}
			
			#else
			
			if (type == BINARY || type == null) {
				
				return true;
				
			}
			
			#end
			
		}
		
		return false;
		
	}
	
	
	public override function getBitmapData (id:String):BitmapData {
		
		#if pixi
		
		return BitmapData.fromImage (path.get (id));
		
		#elseif flash
		
		return cast (Type.createInstance (className.get (id), []), BitmapData);
		
		#elseif openfl_html5
		
		return BitmapData.fromImage (ApplicationMain.images.get (path.get (id)));
		
		#elseif js
		
		return cast (ApplicationMain.loaders.get (path.get (id)).contentLoaderInfo.content, Bitmap).bitmapData;
		
		#else
		
		return BitmapData.load (path.get (id));
		
		#end
		
	}
	
	
	public override function getBytes (id:String):ByteArray {
		
		#if pixi
		
		return null;
		
		#elseif flash
		
		return cast (Type.createInstance (className.get (id), []), ByteArray);
		
		#elseif openfl_html5
		
		return null;
		
		#elseif js
		
		var bytes:ByteArray = null;
		var data = ApplicationMain.urlLoaders.get (path.get (id)).data;
		
		if (Std.is (data, String)) {
			
			bytes = new ByteArray ();
			bytes.writeUTFBytes (data);
			
		} else if (Std.is (data, ByteArray)) {
			
			bytes = cast data;
			
		} else {
			
			bytes = null;
			
		}

		if (bytes != null) {
			
			bytes.position = 0;
			return bytes;
			
		} else {
			
			return null;
		}
		
		#else
		
		return ByteArray.readFile (path.get (id));
		
		#end
		
	}
	
	
	public override function getFont (id:String):Font {
		
		#if pixi
		
		return null;
		
		#elseif (flash || js)
		
		return cast (Type.createInstance (className.get (id), []), Font);
		
		#else
		
		return new Font (path.get (id));
		
		#end
		
	}
	
	
	public override function getMusic (id:String):Sound {
		
		#if pixi
		
		return null;
		
		#elseif flash
		
		return cast (Type.createInstance (className.get (id), []), Sound);
		
		#elseif openfl_html5
		
		var sound = new Sound ();
		sound.__buffer = true;
		sound.load (new URLRequest (path.get (id)));
		return sound; 
		
		#elseif js
		
		return new Sound (new URLRequest (path.get (id)));
		
		#else
		
		return new Sound (new URLRequest (path.get (id)), null, true);
		
		#end
		
	}
	
	
	public override function getPath (id:String):String {
		
		#if ios
		
		return SystemPath.applicationDirectory + "/assets/" + path.get (id);
		
		#else
		
		return path.get (id);
		
		#end
		
	}
	
	
	public override function getSound (id:String):Sound {
		
		#if pixi
		
		return null;
		
		#elseif flash
		
		return cast (Type.createInstance (className.get (id), []), Sound);
		
		#elseif js
		
		return new Sound (new URLRequest (path.get (id)));
		
		#else
		
		return new Sound (new URLRequest (path.get (id)), null, type.get (id) == MUSIC);
		
		#end
		
	}
	
	
	public override function getText (id:String):String {
		
		#if js
		
		var bytes:ByteArray = null;
		var data = ApplicationMain.urlLoaders.get (path.get (id)).data;
		
		if (Std.is (data, String)) {
			
			return cast data;
			
		} else if (Std.is (data, ByteArray)) {
			
			bytes = cast data;
			
		} else {
			
			bytes = null;
			
		}

		if (bytes != null) {
			
			bytes.position = 0;
			return bytes.readUTFBytes (bytes.length);
			
		} else {
			
			return null;
		}
		
		#else
		
		var bytes = getBytes (id);
		
		if (bytes == null) {
			
			return null;
			
		} else {
			
			return bytes.readUTFBytes (bytes.length);
			
		}
		
		#end
		
	}
	
	
	public override function isLocal (id:String, type:AssetType):Bool {
		
		#if flash
		
		if (type != AssetType.MUSIC && type != AssetType.SOUND) {
			
			return className.exists (id);
			
		}
		
		#end
		
		return true;
		
	}
	
	
	public override function loadBitmapData (id:String, handler:BitmapData -> Void):Void {
		
		#if pixi
		
		handler (getBitmapData (id));
		
		#elseif (flash || js)
		
		if (path.exists (id)) {
			
			var loader = new Loader ();
			loader.contentLoaderInfo.addEventListener (Event.COMPLETE, function (event:Event) {
				
				handler (cast (event.currentTarget.content, Bitmap).bitmapData);
				
			});
			loader.load (new URLRequest (path.get (id)));
			
		} else {
			
			handler (getBitmapData (id));
			
		}
		
		#else
		
		handler (getBitmapData (id));
		
		#end
		
	}
	
	
	public override function loadBytes (id:String, handler:ByteArray -> Void):Void {
		
		#if pixi
		
		handler (getBytes (id));
		
		#elseif (flash || js)
		
		if (path.exists (id)) {
			
			var loader = new URLLoader ();
			loader.addEventListener (Event.COMPLETE, function (event:Event) {
				
				var bytes = new ByteArray ();
				bytes.writeUTFBytes (event.currentTarget.data);
				bytes.position = 0;
				
				handler (bytes);
				
			});
			loader.load (new URLRequest (path.get (id)));
			
		} else {
			
			handler (getBytes (id));
			
		}
		
		#else
		
		handler (getBytes (id));
		
		#end
		
	}
	
	
	public override function loadFont (id:String, handler:Font -> Void):Void {
		
		#if (flash || js)
		
		/*if (path.exists (id)) {
			
			var loader = new Loader ();
			loader.contentLoaderInfo.addEventListener (Event.COMPLETE, function (event) {
				
				handler (cast (event.currentTarget.content, Bitmap).bitmapData);
				
			});
			loader.load (new URLRequest (path.get (id)));
			
		} else {*/
			
			handler (getFont (id));
			
		//}
		
		#else
		
		handler (getFont (id));
		
		#end
		
	}
	
	
	public override function loadMusic (id:String, handler:Sound -> Void):Void {
		
		#if (flash || js)
		
		/*if (path.exists (id)) {
			
			var loader = new Loader ();
			loader.contentLoaderInfo.addEventListener (Event.COMPLETE, function (event) {
				
				handler (cast (event.currentTarget.content, Bitmap).bitmapData);
				
			});
			loader.load (new URLRequest (path.get (id)));
			
		} else {*/
			
			handler (getMusic (id));
			
		//}
		
		#else
		
		handler (getMusic (id));
		
		#end
		
	}
	
	
	public override function loadSound (id:String, handler:Sound -> Void):Void {
		
		#if (flash || js)
		
		/*if (path.exists (id)) {
			
			var loader = new Loader ();
			loader.contentLoaderInfo.addEventListener (Event.COMPLETE, function (event) {
				
				handler (cast (event.currentTarget.content, Bitmap).bitmapData);
				
			});
			loader.load (new URLRequest (path.get (id)));
			
		} else {*/
			
			handler (getSound (id));
			
		//}
		
		#else
		
		handler (getSound (id));
		
		#end
		
	}
	
	
	public override function loadText (id:String, handler:String -> Void):Void {
		
		#if js
		
		if (path.exists (id)) {
			
			var loader = new URLLoader ();
			loader.addEventListener (Event.COMPLETE, function (event:Event) {
				
				handler (event.currentTarget.data);
				
			});
			loader.load (new URLRequest (path.get (id)));
			
		} else {
			
			handler (getText (id));
			
		}
		
		#else
		
		var callback = function (bytes:ByteArray):Void {
			
			if (bytes == null) {
				
				handler (null);
				
			} else {
				
				handler (bytes.readUTFBytes (bytes.length));
				
			}
			
		}
		
		loadBytes (id, callback);
		
		#end
		
	}
	
	
}


#if pixi
#elseif flash

@:keep class __ASSET__assets_data_data_goes_here_txt extends null { }
@:keep class __ASSET__assets_images_armanimations_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep class __ASSET__assets_images_armanimationshd_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep class __ASSET__assets_images_background_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep class __ASSET__assets_images_door_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep class __ASSET__assets_images_doorobjthingy_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep class __ASSET__assets_images_elevatorobjthingy_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep class __ASSET__assets_images_heart_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep class __ASSET__assets_images_heart_mask_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep class __ASSET__assets_images_images_go_here_txt extends null { }
@:keep class __ASSET__assets_images_instructions1_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep class __ASSET__assets_images_instructions2_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep class __ASSET__assets_images_instructions3_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep class __ASSET__assets_images_instructions4_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep class __ASSET__assets_images_leganimations_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep class __ASSET__assets_images_leganimationshd_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep class __ASSET__assets_images_leverobjthingy_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep class __ASSET__assets_images_mask_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep class __ASSET__assets_images_runcycle_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep class __ASSET__assets_images_stairobjthingy_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep class __ASSET__assets_images_titlecard_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep class __ASSET__assets_images_trapdoorobjthingy_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep class __ASSET__assets_images_woodtileset_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep class __ASSET__assets_level_csv extends null { }
@:keep class __ASSET__assets_music_door_wav extends null { }
@:keep class __ASSET__assets_music_f1_wav extends null { }
@:keep class __ASSET__assets_music_f2_wav extends null { }
@:keep class __ASSET__assets_music_f3_wav extends null { }
@:keep class __ASSET__assets_music_f4_wav extends null { }
@:keep class __ASSET__assets_music_f5_wav extends null { }
@:keep class __ASSET__assets_music_f6_wav extends null { }
@:keep class __ASSET__assets_music_f7_wav extends null { }
@:keep class __ASSET__assets_music_f8_wav extends null { }
@:keep class __ASSET__assets_music_music_goes_here_txt extends null { }
@:keep class __ASSET__assets_sounds_sounds_go_here_txt extends null { }


#elseif html5






































#end
