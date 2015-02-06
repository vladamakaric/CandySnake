package {
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	
	public class F_MainMenu extends Sprite 
	{
		public var mGameDC:GameDC;
		
		public function F_MainMenu(passed_class:GameDC) 
		{
			mGameDC = passed_class;
			play_button.addEventListener(MouseEvent.CLICK, onPlayBtnClicked);
			how_to_button.addEventListener(MouseEvent.CLICK, onAboutBtnClicked);
		}
		
		public function onPlayBtnClicked(event:MouseEvent) 
		{
			mGameDC.goToLevelSelection();
		}
		
		public function onAboutBtnClicked(event:MouseEvent)
		{
			mGameDC.goToAbout();
		}
	}
}