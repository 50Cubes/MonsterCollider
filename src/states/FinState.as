package states
{
	import org.flixel.FlxG;
	import org.flixel.FlxSound;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	public class FinState extends FlxState
	{
		private var fin:FlxSprite;
		private var creditTimer:int = 200;
		private var _finMusic:FlxSound;
		
		[Embed(source = 'assets/victory.png')]private static var finImage:Class;
		[Embed(source = 'assets/credits2.png')]private static var creditImage:Class;
		[Embed(source = 'sounds/victory.mp3')]private static var funMusic:Class;


		public function FinState()
		{
			super();
		}
		
		override public function create():void
		{
			super.create();
			
			fin = new FlxSprite();
			fin.loadGraphic(finImage, false, false, 2300, 1700);
			add(fin);
			
			_finMusic = new FlxSound();
			_finMusic.loadEmbedded(funMusic, true);
			_finMusic.play();
		}
		
		override public function update():void
		{
			super.update();
			
			if (FlxG.keys.R)
			{
				FlxG.switchState(new MazeState());
				_finMusic.kill();
			}
			if(FlxG.keys.E && FlxG.keys.V && FlxG.keys.I && FlxG.keys.L && FlxG.keys.SPACE && FlxG.keys.B)
			{
				FlxG.switchState(new MazeState(true));
				_finMusic.kill();
			}
			creditTimer -= 1;
			if(creditTimer == 0)
			{
				fin.loadGraphic(creditImage, false, false, 2300, 1700);
			}
		}
	}
}