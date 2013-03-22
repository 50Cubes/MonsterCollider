package states
{
	import org.flixel.FlxG;
	import org.flixel.FlxSound;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	
	public class titleScreen extends FlxState
	{
		public function titleScreen()
		{
			super();
		}
		
		private var _maze:FlxSprite;
		private var _startMusic:FlxSound;

		
		[Embed(source = 'assets/titlescreen.png')]private static var bgImage:Class;
		[Embed(source = 'sounds/startscreen2.mp3')]private static var startMusic:Class;

		override public function create():void
		{
			super.create();
			
			_maze = new FlxSprite();//-570, -500);
			_maze.loadGraphic(bgImage, false, false, 2300, 1700);
			add(_maze);
			
			_startMusic = new FlxSound();
			_startMusic.loadEmbedded(startMusic, true);
			_startMusic.play();
		}
		
		override public function update():void
		{
			super.update();
			if (FlxG.keys.S)
			{
				FlxG.switchState(new StartState(_startMusic));
			}
		}
	}
}