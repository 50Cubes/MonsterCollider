package states
{
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSound;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.system.FlxAnim;
	import org.osmf.layout.ScaleMode;
	
	public class DeadState extends FlxState
	{
		private var dead:FlxSprite;
		private var _death:FlxSprite;
		private var _playedOnce:Boolean = false;
		private var _deathSound:FlxSound;
		private var _animationCountdown:int = 120;


		[Embed(source='sounds/death.mp3')]private static var deathSound:Class;
		[Embed(source="assets/killscreen2.png")] private var deathAnim:Class;
		[Embed(source = 'assets/retry.png')]private static var finImage:Class;
		
		public function DeadState()
		{
			super();
		}
		
		override public function create():void
		{
			super.create();
			
			dead = new FlxSprite(0,200)
			dead.loadGraphic(finImage, false, false, 1216, 158);
			dead.scale = new FlxPoint(.5, .5);
			dead.visible= false;
			add(dead);
			
			_death = new FlxSprite(150, 100);
			_death.loadGraphic(deathAnim, false, false, 800, 500);
			_death.addAnimation("eaten", [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,15,16,15,16,15], 10, false);
			_death.visible = false;
			//_death.offset.x = 400;
			add(_death);
			
			_deathSound = new FlxSound();
			_deathSound.loadEmbedded(deathSound, false);
			_deathSound.play();
		}
		
		override public function update():void
		{
			if(!_playedOnce)
			{
				trace("DEAD!");
				_death.visible = true;
				_death.play("eaten");
				_playedOnce = true;
			}
			else
			{
				_animationCountdown -=1;
				if(_animationCountdown == 0)
				{
					_death.kill();
					dead.visible= true;
				}
			}
			if (FlxG.keys.R)
			{
				FlxG.switchState(new MazeState());
			}
			if(FlxG.keys.E && FlxG.keys.V && FlxG.keys.I && FlxG.keys.L && FlxG.keys.SPACE && FlxG.keys.B)
			{
				FlxG.switchState(new MazeState(true));
			}
			super.update();
		}
		
		override public function destroy():void
		{
			super.destroy();
			_deathSound.kill();
		}

	}
}