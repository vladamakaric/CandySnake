package 
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.*;
	
	public class F_GameOver extends Sprite 
	{
		public var mGameDC:GameDC;
		public var mLastLvlNum:int;
		
		public function F_GameOver(_gameDC:GameDC, _lvlNum:int) 
		{
			mLastLvlNum = _lvlNum;
			mGameDC = _gameDC;
			overtext.text = "Level " + _lvlNum + " failed";
			
			addChildAt(GameDC.mStageBMP, getChildIndex(play_again_button) -1 );

			TweenMax.to(GameDC.mStageBMP, 7, {blurFilter:{blurX:40}});
			
			
		//	addEventListener(Event.ENTER_FRAME, bezveze);

			level_select_button.visible = false;
			main_menu_button.visible = false;
			play_again_button.addEventListener(MouseEvent.CLICK, onPlayAgainClicked);
	//		level_select_button.addEventListener(MouseEvent.CLICK, onLevelSelectClicked);
	//		main_menu_button.addEventListener(MouseEvent.CLICK, onMainMenuButtonClicked);
		}

		
		public function destroy()
		{
			removeChild(GameDC.mStageBMP);
			
	//		play_again_button.removeEventListener(MouseEvent.CLICK, onPlayAgainClicked);
		//	level_select_button.removeEventListener(MouseEvent.CLICK, onLevelSelectClicked);
			//main_menu_button.removeEventListener(MouseEvent.CLICK, onMainMenuButtonClicked);
		}
		
		
		public function onPlayAgainClicked(event:MouseEvent) 
		{
			mGameDC.goToLevel(mLastLvlNum); destroy();
		}
		
		public function onLevelSelectClicked(event:MouseEvent) 
		{
			mGameDC.goToLevelSelection(); destroy();
		}
		
		public function onMainMenuButtonClicked(event:MouseEvent) 
		{
			mGameDC.goToMainMenu(); destroy();
		}
	}
}