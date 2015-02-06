package {
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	import flash.text.*;
	
	public class F_LevelComplete extends Sprite 
	{
		public var mGameDC:GameDC;
		public var mLastLevel:int;
		public var mCookie:SharedObject;
		
		public function F_LevelComplete(passed_class:GameDC, level:int) 
		{
			mCookie = SharedObject.getLocal("savegame");
			mCookie.data.level_passed = level + 1;
			mCookie.close();
			mLastLevel = level;
			mGameDC = passed_class;
			congratztext.text = "Level " + level + " completed";
			next_level_button.addEventListener(MouseEvent.CLICK, onNextLevelBtnClicked);
			level_select_button.addEventListener(MouseEvent.CLICK, onLevelSelectBtnClicked);
			main_menu_button.addEventListener(MouseEvent.CLICK, onMainMenuBtnClicked);
		}
		public function onNextLevelBtnClicked(event:MouseEvent) 
		{
			mGameDC.goToLevel(mLastLevel+1);
		}
		
		public function onLevelSelectBtnClicked(event:MouseEvent) 
		{
			mGameDC.goToLevelSelection();
		}
		
		public function onMainMenuBtnClicked(event:MouseEvent) 
		{
			mGameDC.goToMainMenu();
		}
	}
}