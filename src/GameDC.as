package {
	import com.greensock.OverwriteManager;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import fnc.Vector2D;
	
	
	public class GameDC extends Sprite 
	{
		public var mMainMenu:F_MainMenu;
		public var mLevel:F_Level;
		public var mGameOver:F_GameOver;
		public var mLevelSelection:F_LevelSelection;
		public var mAbout:F_About;
		public var mLevelComplete:F_LevelComplete;
		public static var mStageRect:Rectangle;
		public static var mStageBMP:Bitmap;
		public static var TIME:int = 0;
		public var timer:Timer;
		public static var stepSize:int = 3;
		
		public function GameDC() 
		{
			OverwriteManager.init(2)
//			PartigenAnimManager.init();
			mStageRect = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			mStageBMP = new Bitmap(new BitmapData(mStageRect.width, mStageRect.height));
			
			goToLevel(0);
			//goToMainMenu();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			timer = new Timer(100, 0);
			timer.addEventListener(TimerEvent.TIMER, updateGlobalTime);
			timer.start();
		}
		
		private function updateGlobalTime(e:TimerEvent):void 
		{
			TIME++;
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		//	PartigenAnimManager.createEffect(F_CandyAnim, 1000, new Vector2D(0, 0), this, 0);
		}
		
		public function goToMainMenu() 
		{
			mMainMenu = new F_MainMenu(this);
			mAbout=removeMC(mAbout);
			mLevelSelection=removeMC(mLevelSelection);
			mGameOver=removeMC(mGameOver);
			mLevelComplete=removeMC(mLevelComplete);
			addChild(mMainMenu);
		}
		
		public function goToAbout() 
		{
			mAbout = new F_About(this);
			mMainMenu=removeMC(mMainMenu);
			addChild(mAbout);
		}
		
		public function goToGameOver(level) 
		{
			mGameOver = new F_GameOver(this, level);
			mLevel = removeMC(mLevel);
			
			//removeChild(mLevel);
			//mLevel = null;
			addChild(mGameOver);
		}
		
		public function goToLevelComplete(level) 
		{
			mLevelComplete = new F_LevelComplete(this,level);
			mLevel=removeMC(mLevel);
			addChild(mLevelComplete);
		}
		
		public function goToLevelSelection() 
		{
			mLevelSelection = new F_LevelSelection(this);
			mMainMenu=removeMC(mMainMenu);
			mAbout=removeMC(mAbout);
			mGameOver=removeMC(mGameOver);
			mLevelComplete=removeMC(mLevelComplete);
			addChild(mLevelSelection);
		}
		
		public function goToLevel(level:int) 
		{
			mLevel = new F_Level(this,level);
			mLevelSelection=removeMC(mLevelSelection);
			mGameOver=removeMC(mGameOver);
			mLevelComplete=removeMC(mLevelComplete);
			addChild(mLevel);
		}
		
		private function removeMC(clip:*) 
		{
			if (clip)
				removeChild(clip);
			
			return null;
		}
	}
}