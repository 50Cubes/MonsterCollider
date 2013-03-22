package
{
	import org.flixel.FlxGame;
	
	import states.StartState;
	import states.titleScreen;
	
	[SWF(width="1200", height="700", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]
	
	public class MonsterCollider extends FlxGame
	{
		public function MonsterCollider()
		{
			//super(800, 600, MazeState, 1);
			super(1200, 700, titleScreen, 1);
		}
	}
}