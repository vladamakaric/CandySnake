package 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.display.SimpleButton;
	
	public class F_LevelSelection extends Sprite 
	{
		public var mGameDC:GameDC;

		
		public function F_LevelSelection(_gameDC:GameDC) 
		{
			var levelThumb:F_LevelThumbnail;
			mGameDC = _gameDC;
			
			for (var i:int = 1; i <= 5; i++) 
			{
				levelThumb = new F_LevelThumbnail(i,mGameDC);
				addChild(levelThumb);
			}
			
			main_menu_button.addEventListener(MouseEvent.CLICK, onMainMenuClicked);
		}
		
		public function onMainMenuClicked(event:MouseEvent) 
		{
			mGameDC.goToMainMenu();
		}
	}
}