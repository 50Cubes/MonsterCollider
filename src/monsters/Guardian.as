package monsters
{
	import org.flixel.FlxObject;
	import org.flixel.FlxSound;
	import org.flixel.FlxSprite;
	
	public class Guardian extends FlxSprite
	{
		private var _winMusic:FlxSound;

		[Embed(source="assets/guardian3.png")] private var MrBoy:Class;
		[Embed(source='sounds/win.mp3')]private static var winSound:Class;

		public function Guardian(X:Number=0, Y:Number=0, SimpleGraphic:Class=null)
		{
			super(X, Y, SimpleGraphic);
			
			loadGraphic(MrBoy, true, true, 250, 250);

			width = 80;
			height = 80;
			offset.x = 30;
			offset.y = 160;
			
			addAnimation("idle", [0]);
			addAnimation("spin", [1,2,3,4,5],20,true);
			addAnimation("push", [6]);
			
			_winMusic = new FlxSound();
			_winMusic.loadEmbedded(winSound);
			
			facing = FlxObject.RIGHT;
		}
		
		override public function update():void
		{
			super.update();
		}
		
		override public function destroy():void
		{
			super.destroy();
		}
		
		public function fightToTheDeath():void
		{
			_winMusic.play();
			play("spin");
			immovable = false;
			maxVelocity.x = 1000;
			velocity.x = 50;
		}
	}
}