package states
{
	import monsters.Guardian;
	import monsters.Monster;
	import monsters.Player;
	
	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	import org.flixel.FlxRect;
	import org.flixel.FlxSound;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxTilemap;
	
	public class MazeState extends FlxState
	{
		[Embed(source = 'assets/pathfinding_map.txt', mimeType = "application/octet-stream")] private var _dataMap:Class;
		[Embed(source = 'assets/clear.png')]private static var clear_tiles:Class;
		[Embed(source = 'assets/background2.png')]private static var bgImage:Class;
		[Embed(source = 'assets/door.png')]private static var doorImage:Class;
		[Embed(source = 'sounds/gameost.mp3')]private static var mazeMusic:Class;
		[Embed(source = 'sounds/insideouttheme.mp3')]private static var mazeMusic2:Class;
		[Embed(source = 'sounds/youShallNotPass2.mp3')]private static var youShallNotPassSound:Class;
		[Embed(source = 'assets/burlspeech.png')]private static var youShallNotImage:Class;
		[Embed(source = 'assets/pushtext2.png')]private static var gateInfoImage:Class;

		
		public function MazeState($evil:Boolean = false)
		{
			super();
			_evil = $evil;
		}
		
		private var _player:Player;
		private var _monster:Monster;
		private var _guardian:Guardian;
		private var _collisionMap:FlxTilemap;
		private var _bg:Backdrop;
		private var _goal:FlxSprite;
		private var _door:FlxSprite;
		private var _doorOpen:Boolean = false;
		private var _doorStart:Boolean = false;
		private var _monsterGo:int;
		private var _evil:Boolean;
		private var _mazeMusic:FlxSound;
		private var _youShallNotPass:FlxSound;
		private var _noPassText:FlxSprite;
		private var _gateText:FlxSprite;
		private var _gatePlate:FlxSprite;
		
		private var _tileSize:int = 100;
		private var _textTimeout:int = 80;
		

		
		override public function create():void
		{
			super.create();
			
			FlxG.framerate = 50;
			FlxG.flashFramerate = 50;
			
			_bg = new Backdrop(0,0,bgImage,1);
			add(_bg);
			
			_collisionMap = new FlxTilemap();
			_collisionMap.loadMap(new _dataMap, clear_tiles, _tileSize, _tileSize, 0, 1);
			//_collisionMap.loadMap(new _dataMap, auto_tiles, _tileSize, _tileSize, 0, 1);
			add(_collisionMap);
			
			//Create Monsters
			_guardian = new Guardian(2050,1400);//FlxSprite(2150, 1400).makeGraphic(80,80, 0xFFFF0000);
			_guardian.maxVelocity.x = 0;
			_guardian.maxVelocity.y = 0;
			_guardian.immovable = true;
			add(_guardian);
			
			_door = new FlxSprite(25, 170);
			_door.loadGraphic(doorImage, true, true, 300, 250);
			_door.immovable = true;
			add(_door);
			
			_door.addAnimation("idle", [3]);
			_door.addAnimation("open", [3,2,1,0], 2,false);
			_door.play("idle");
			
			setupPlayer();
			
			_monster = new Monster(220, 70, _player);
			_monster.maxVelocity.x = 1200;
			_monster.maxVelocity.y = 1200;
			_monster.active = false;
			add(_monster);

			_goal = new FlxSprite(2200, 1400).makeGraphic(80,80,0x000000);
			add(_goal);
			
			FlxG.worldBounds = new FlxRect(0,0,_collisionMap.width, _collisionMap.height);
						
			//trace("W:"+_collisionMap.width+",H:"+_collisionMap.height);
			
			_mazeMusic = new FlxSound();
			if(!_evil)
			{
				_mazeMusic.loadEmbedded(mazeMusic, true);
			}
			else
			{
				_mazeMusic.loadEmbedded(mazeMusic2, true);
			}
			_mazeMusic.play();
			
			_youShallNotPass = new FlxSound();
			_youShallNotPass.loadEmbedded(youShallNotPassSound, false);
			
			_noPassText = new FlxSprite(1860,1180);//new FlxText(2050, 1180, 150, "Sorry boy.  It will take someone larger than you to get through me");
			_noPassText.loadGraphic(youShallNotImage);
			_noPassText.visible = false;
			add(_noPassText);
			
			
			_gateText = new FlxSprite(200,220);//new FlxText(200, 260, 150, "Push to open");
			_gateText.loadGraphic(gateInfoImage);
			_gateText.visible = false;
			add(_gateText);
			
			_gatePlate = new FlxSprite(466, 413).makeGraphic(80,80,0x0000000);
			_gatePlate.immovable;
			add(_gatePlate);
		}
		
		override public function destroy():void
		{
			super.destroy();
			_mazeMusic.kill();
		}
		
		override public function update():void
		{
			FlxG.collide(_player, _collisionMap);
			FlxG.collide(_player, _goal, winRar);
			FlxG.overlap(_player, _gatePlate, showGateInfo);
			FlxG.collide(_player, _monster, eatPlayer);
			if(_monster.alive)
			{
				FlxG.collide(_player, _guardian, youShallNotPass);
			}
			FlxG.collide(_collisionMap, _monster, monsterHitWall);
			FlxG.collide(_monster, _guardian, finishHim);
			if(!_doorOpen)
			{
				FlxG.collide(_player, _door, openSesame);
			}
			if(_doorStart)
			{
				_gateText.kill();
				_monsterGo += 1;
				if(_monsterGo == 50)
				{
					_doorOpen = true;
				}
				else if(_monsterGo == 60)
				{
					_monster.active = true;
				}
			}
			
			if(_noPassText.visible == true)
			{
				_textTimeout -= 1;
				if(_textTimeout == 0)
				{
					_textTimeout = 100;
					_noPassText.visible = false;
					_guardian.play("idle");
				}
			}
			
			if(_gateText.visible == true)
			{
				_textTimeout -= 1;
				if(_textTimeout == 0)
				{
					_textTimeout = 100;
					_gateText.visible = false;
				}
			}
			
			if(FlxG.keys.S && FlxG.keys.T && FlxG.keys.A && FlxG.keys.R)
			{
				FlxG.switchState(new titleScreen());
			}
			
			super.update();
		}
		
		private function eatPlayer(player:FlxSprite, monster:FlxSprite):void
		{
			_player.alive = false;
			_monster.velocity.x = 0;
			_monster.velocity.y = 0;
			
			FlxG.switchState(new DeadState());
		}
		
		private function monsterHitWall(map:FlxTilemap, monster:FlxSprite):void
		{
			//trace('Wall hit');
			_monster.acceleration.x = 0;
			_monster.acceleration.y = 0;
			_monster.velocity.x = 0;
			_monster.velocity.y = 0;
			_monster.dashing = false;
		}
		
		private function setupPlayer():void
		{
			_player = new Player(623, 270, _evil);
			add(_player);
			
			var cam:FlxCamera = new FlxCamera(0,0, FlxG.width, FlxG.height);
			cam.follow(_player);
			cam.setBounds(0,0,_collisionMap.width, _collisionMap.height);
			FlxG.addCamera(cam);
		}
		
		private function finishHim(monster:Monster, guardian:Guardian):void
		{
			//_guardian.immovable = false;
			_guardian.fightToTheDeath();
			_monster.kill();
		}
		
		private function winRar(player:Player, goal:FlxSprite):void
		{
			FlxG.switchState(new FinState());
		}
		
		private function openSesame(player:Player, door:FlxSprite):void
		{
			_door.play("open");
			_doorStart = true;
		}
		
		private function youShallNotPass(player:Player, guardian:Guardian):void
		{
			_guardian.play("push");
			_youShallNotPass.play(false);
			_noPassText.visible = true;
		}
		
		private function showGateInfo(player:Player, gate:FlxSprite):void
		{
			if(!_doorOpen)
				_gateText.visible = true;
		}
	}
}