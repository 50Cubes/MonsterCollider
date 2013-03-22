package monsters
{
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
		
	public class Monster extends FlxSprite
	{
		[Embed(source="assets/monster.png")] private var MrBoy:Class;
		
		private var _player:Player;
		private var _accel:int = 500;
		
		public var dashing:Boolean = false;
		
		public function Monster(X:Number, Y:Number, ThePlayer:Player, SimpleGraphic:Class=null)
		{
			super(X, Y, SimpleGraphic);
			_player = ThePlayer;
			
			health = 10;
			
			loadGraphic(MrBoy, true, true, 200, 200);
			
			maxVelocity.x = 1200;
			maxVelocity.y = 1200;
			
			width = 80;
			height = 90;
			offset.x = 60;
			offset.y = 160;

			drag.x = 10;
			drag.y = 10;
			
			//elasticity = 30;
			
			//animations
			addAnimation("idle", [0]);
			addAnimation("run", [1,2,3,4], 20, true);
			addAnimation("jump", [5,6,7,8], 20, true);
			addAnimation("duck",[9,10,11,12], 20, true);
			addAnimation("dead", [8], 5);
		}
		
		override public function destroy():void
		{
			super.destroy();
		}
		
		override public function update():void
		{
			super.update();
			
			if(_player.alive)
			{
				//trace('in sight, PlayerX:'+_player.y+",MonsterX:"+y);
				if(Math.abs(_player.y - y) < _player.height*3)
				{
					//trace('in sight, PlayerX:'+_player.x+",MonsterX:"+x);
					if(_player.x < x)
					{
//						this.facing = FlxObject.RIGHT;
						if(!dashing) dashWest();
						if(_player.velocity.x > 0)
						{
							_player.scareBoy(FlxObject.RIGHT);
						}
						trace("Facing:"+facing);
					}
					else if(_player.x > x)
					{
//						this.facing = FlxObject.LEFT;
						if(!dashing) dashEast();
						if(_player.velocity.x < 0)
						{
							_player.scareBoy(FlxObject.LEFT);
						}
						trace("Facing:"+facing);
					}
				}
				if(Math.abs(_player.x - x) < _player.width*2)
				{
					//trace('in sight, PlayerY:'+_player.y+",MonsterY:"+y);
					if(_player.y < y)
					{
//						facing = FlxObject.DOWN;
						if(!dashing) dashSouth();
						if(_player.velocity.y > 0)
						{
							_player.scareBoy(FlxObject.DOWN);
						}
						trace("Facing:"+facing);
					}
					else if(_player.y > y)
					{
//						facing = FlxObject.UP;
						if(!dashing) dashNorth();
						if(_player.velocity.y < 0)
						{
							_player.scareBoy(FlxObject.UP);
						}
						trace("Facing:"+facing);
					}
				}
				//ANIMATION
				if(acceleration.y < 0)
				{
					play("duck");
				}
				else if(acceleration.y > 0)
				{
					play("jump");
				}
				else if(acceleration.x == 0)
				{
					play("idle");
				}
				else
				{
					play("run");
				}
			}
		}
		
		private function dashNorth():void
		{
			dashing = true;
			facing = FlxObject.UP;
			acceleration.y = _accel;
//			trace("Facing:"+facing);

		}
		private function dashSouth():void
		{
			dashing = true;
			facing = FlxObject.DOWN;
			acceleration.y = -_accel;
//			trace("Facing:"+facing);

		}
		private function dashEast():void
		{
			dashing = true;
			facing = FlxObject.LEFT;
			acceleration.x = _accel;
//			trace("Facing:"+facing);

		}
		private function dashWest():void
		{
			dashing = true;
			facing = FlxObject.RIGHT;
			acceleration.x = -_accel;
//			trace("Facing:"+facing);

		}
	}
}