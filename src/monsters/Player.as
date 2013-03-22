package monsters
{
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxSound;
	import org.flixel.FlxSprite;
	
	public class Player extends FlxSprite
	{
		[Embed(source="assets/BOY5.png")] private var MrBoy:Class;
		[Embed(source="assets/evilBOY2.png")] private var MrEvil:Class;
		[Embed(source = 'sounds/scream2.mp3')]private static var scream:Class;

		
		private var _move_speed:int = 800;
		private var _scared:int = 30;
		private var _invince:int = 30;
		private var _scream:FlxSound;

		public function Player(X:Number=0, Y:Number=0, evil:Boolean = false)
		{
			super(X, Y);
			
			if(evil)
			{
				loadGraphic(MrEvil, true, true, 100, 200);
			}
			else
			{
				loadGraphic(MrBoy, true, true, 100, 200);
			}
			maxVelocity.x = 200;
			maxVelocity.y = 200;   
			
			//Friction
			drag.x = 3000;
			drag.y = 3000;
			
			//bounding box tweaks
			width = 30;
			height = 30;
			offset.x = 30;
			offset.y = 160;
			
			//animations
			addAnimation("idle", [0]);
			addAnimation("run", [1,2,3,4,5,6,7,8], 20, true);
			addAnimation("jump", [17,18,19,20,21,22,23,24], 20, true);
			addAnimation("duck",[9,10,11,12,13,14,15,16], 20, true);
			addAnimation("dead", [8], 20);
			addAnimation("sideScream", [25,26,27,26,27,26,27,26,27,26,27,26,27,26], 20, true);
			addAnimation("upScream", [30,31], 20, true);
			addAnimation("downScream", [28,29], 20, true);
			
			_scream = new FlxSound();
			_scream.loadEmbedded(scream, false);
		}
		
		override public function update():void
		{
			//facing = FlxObject.NONE;
			//trace("X:"+x+",Y:"+y);
			if(!alive)
			{
				//trace("GUY DEAD!!");
				if(finished) exists = false;
				else
					super.update();
				return;
			}
		
			//MOVEMENT
			acceleration.x = 0;
			acceleration.y = 0;
			if(_scared >= 30 || _invince != 30)
			{
				if(FlxG.keys.LEFT)
				{
					facing = FlxObject.LEFT;
					velocity.x = -_move_speed;
				}
				else if(FlxG.keys.RIGHT)
				{
					facing = FlxObject.RIGHT;
					velocity.x = _move_speed;
				}
				else if(FlxG.keys.DOWN)
				{
					facing = FlxObject.DOWN;
					velocity.y = _move_speed;
				}
				else if(FlxG.keys.UP)
				{
					facing = FlxObject.UP;
					velocity.y = -_move_speed;
				}
				
				//ANIMATION
				if(velocity.y < 0)
				{
					play("jump");
				}
				else if(velocity.y > 0)
				{
					play("duck");
				}
				else if(velocity.x == 0)
				{
					play("idle");
				}
				else
				{
					play("run");
				}
			}
			else
			{
				_scared += 1;
				//facing = FlxObject.NONE;
				if(_scared == 30)
					_invince = 0;
			}
			if(_invince < 30)
				_invince += 1;
		}
		
		public function scareBoy(direction:uint):void
		{
			if(direction == FlxObject.RIGHT)
			{
				facing = FlxObject.RIGHT;
				play("sideScream");
			}
			if(direction == FlxObject.LEFT)
			{
				facing = FlxObject.LEFT;
				play("sideScream");
			}
			if(direction == FlxObject.UP)
			{
				facing = FlxObject.UP;
				play("upScream");
			}
			if(direction == FlxObject.DOWN)
			{
				facing = FlxObject.DOWN;
				play("downScream");
			}
			if(_scared >= 30)
			{
				_scared = 0;
				_scream.play();
			}
		}
	}
}