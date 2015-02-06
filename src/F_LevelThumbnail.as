package {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.*;
	import flash.net.SharedObject;
	
	public class F_LevelThumbnail extends Sprite 
	{
		public var mGameDC:GameDC;
		public var mLevelNum:int;
		public var mCookie:SharedObject;
		
		public function F_LevelThumbnail(_levelNum:int, _gameDC:GameDC) 
		{
			mCookie = SharedObject.getLocal("savegame");
			
			if (mCookie.data.level_passed==undefined) {
				mCookie.data.level_passed=1;
			}
			if (mCookie.data.level_passed<_levelNum) {
				alpha = 0.5;
			}
			else 
			{
				this.buttonMode = true;
				this.mouseChildren = false;
				addEventListener(MouseEvent.CLICK, onLevelClicked);
			}
			
			mGameDC = _gameDC;
			mLevelNum = _levelNum;
			y = _levelNum*60-10;
			leveltext.text = "Level "+_levelNum;
			mCookie.close();
		}
		
		public function onLevelClicked(event:MouseEvent) 
		{
			mGameDC.goToLevel(mLevelNum);
		}
	}
}