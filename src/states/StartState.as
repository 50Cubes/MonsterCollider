package states
{
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSound;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	public class StartState extends FlxState
	{
		private var _intro:FlxText;
		private var _maze:FlxSprite;
		private var _sound:FlxSound;

		[Embed(source = 'assets/instructions.png')]private static var bgImage:Class;

		
		public function StartState(sound:FlxSound)
		{
			_sound = sound;
			super();
		}
		
		override public function create():void
		{
			super.create();
			
			_maze = new FlxSprite();//-570, -500);
			_maze.loadGraphic(bgImage, false, false, 2300, 1700);
			//_maze.scale = new FlxPoint(.4,.4);
			add(_maze);
			
			_intro = new FlxText(415, 415, 400, "Press S to start");
			add(_intro);
			
		}
		
		override public function update():void
		{
			super.update();
			if(FlxG.keys.E && FlxG.keys.V && FlxG.keys.I && FlxG.keys.L && FlxG.keys.SPACE && FlxG.keys.B)
			{
				FlxG.switchState(new MazeState(true));
//				_startMusic.kill();
			}
			if (FlxG.keys.S)
			{
				FlxG.switchState(new MazeState());
//				_startMusic.kill();
				_sound.kill();
			}
		}
	}
}