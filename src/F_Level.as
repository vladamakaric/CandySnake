package 
{
	import com.desuade.partigen.emitters.*;
	import com.desuade.partigen.emitters.Emitter;
	import com.desuade.partigen.renderers.Renderer;
	import com.desuade.partigen.renderers.StandardRenderer;
	import com.greensock.easing.Circ;
	import com.greensock.easing.Quad;
	import com.greensock.easing.Quint;
	import com.greensock.easing.Sine;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import fl.motion.easing.Circular;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.*;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import fnc.Circle;
	import fnc.distance;
	import fnc.intersection;
	import fnc.Line;
	import fnc.vector;
	import fnc.Vector2D;
	
	
	public class F_Level extends Sprite 
	{
		public var mSnake:Snake;
		public var mGameDC:GameDC;
		public var mLvlNum:int;
		public var mAllActors:Array;
		
		public var mCandy1Anim:PartigenAnim;
		public var mCandy2Anim:PartigenAnim;
		public var mTruckExplosionAnim:PartigenAnim;
		public var mTruckStarterTimer:Timer;
		public var mCandyExplosion:CandyExplosion;
		public var mCollisionBD:BitmapData = new BitmapData(GameDC.mStageRect.width, GameDC.mStageRect.height, false, 0xFFFFFF);
		
	//	public var tempCollBMP:Bitmap = new Bitmap(mCollisionBD);
		
		public var mCandyCollisioRadius:int = 50;
		public var mCandyHaloBD:BitmapData;
		public var mCandyHaloRect:Rectangle = new Rectangle(0,0, mCandyCollisioRadius*2, mCandyCollisioRadius*2);
		public static var LEVEL_TIME:int = 0;
		public var mSpeedUpSign:MovieClip = new F_SpeedUpSign();
		public var mSlowDownSign:MovieClip = new F_SlowDownSign();
		
		public function F_Level(_gameDC:GameDC, _lvlNum:int) 
		{
			mLvlNum = _lvlNum;
			mGameDC = _gameDC;

			LEVEL_TIME = 0;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			mAllActors = [];
			mSnake = new Snake(this, new Vector2D(100, 100));
			
			addEventListener(MouseEvent.CLICK, onClick);
			addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
			mAllActors.push(new SquareCandy(this, new Vector2D(300, 300)));
			mAllActors.push(new RoundCandy(this, new Vector2D(400, 400)));
			
		//	addChild(new F_WaterAnim());
			
		//	mAllActors.push(mSnake);

			mCandy1Anim = new PartigenAnim(F_CandyAnim, 700, new Vector2D(-100,-100));
			mCandy2Anim = new PartigenAnim(F_CandyAnim2, 800, new Vector2D(-100,-100))
			mTruckExplosionAnim = new PartigenAnim(F_TruckSplosion, 1000);
			
		//	animTimer.start();
		
			
			mTruckStarterTimer = new Timer(1000, 1);
			mTruckStarterTimer.addEventListener(TimerEvent.TIMER, runTruck);
			removeChild(i_truckAnim);
			addChild(i_truckAnim);
			
			mCandyExplosion = new CandyExplosion(this);
			
			
			var candyCircle:Shape = new Shape();
			
			candyCircle.graphics.beginFill(0);
			candyCircle.graphics.drawCircle(mCandyCollisioRadius, mCandyCollisioRadius, mCandyCollisioRadius);
			candyCircle.graphics.endFill();
			
			mCandyHaloBD = new BitmapData(mCandyCollisioRadius * 2, mCandyCollisioRadius * 2, true, 0x00ffffff);
			mCandyHaloBD.draw(candyCircle);
			
		//	addChild(tempCollBMP);
			
		}
		
		private function onWheel(e:MouseEvent):void 
		{
			mSnake.speedUp();
		}

		
		
		private function runTruck(e:TimerEvent):void 
		{
			if(Math.random()<0.5)
			MovieClip(i_truckAnim).gotoAndPlay("turningPoint");
			else
			MovieClip(i_truckAnim).gotoAndPlay(0);
		}
		
		private function onClick(e:MouseEvent):void 
		{
		//	mSnake.speedUp();
			
			mAllActors.push(new SquareCandy(this, new Vector2D(mouseX, mouseY)));
			
	//		PartigenAnimManager.createEffect(F_CandyAnim, 1000, new Vector2D(mouseX, mouseY), this, this.numChildren-1);
	

			//mTruckExplosionAnim.create(this, new Vector2D(mouseX, mouseY));
			//mCandy1Anim.create(this, new Vector2D(mouseX, mouseY));
	//		mCandy2Anim.create(this, new Vector2D(mouseX, mouseY));
	//		createAnim(mouseX, mouseY);

			
			
			
			//bezveze = null;
			
			
			//trace(numChildren);
			
			
			//delete bezveze;
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.focus = this;
		}
		
		
		public function slowDownAnim()
		{
			mSlowDownSign.x = 300;
			mSlowDownSign.y = 255;
				
			addChild(mSlowDownSign);

			mSlowDownSign.scaleX = mSlowDownSign.scaleY  = mSlowDownSign.alpha =  0;

			TweenLite.to(mSlowDownSign, 0.45, { scaleX:1, scaleY:1, alpha:1, ease:Sine.easeOut } );
				
			TweenLite.to(mSlowDownSign, 0.45, { delay:0.45 ,scaleX:2, scaleY:0, alpha:0, ease:Sine.easeIn , onComplete:zbrisiGaPicko2} );
		}
		
		private function zbrisiGaPicko2():void 
		{
			mSlowDownSign.parent.removeChild(mSlowDownSign);
		}
		
		
		private function onEnterFrame(e:Event):void 
		{
		//	createAnim(100, 100);
			LEVEL_TIME++;
			
			if (LEVEL_TIME % 350 == 0)
			{
				
				
				mSpeedUpSign.x = 300;
				mSpeedUpSign.y = 0;
				
				addChild(mSpeedUpSign);

				mSpeedUpSign.scaleX = mSpeedUpSign.scaleY  = mSpeedUpSign.alpha =  0;

				TweenLite.to(mSpeedUpSign, 0.45, { scaleX:1, scaleY:1, alpha:1, y:255, ease:Quad.easeOut } );
				
				TweenLite.to(mSpeedUpSign, 0.45, { delay:0.45 ,scaleX:0, scaleY:0, alpha:0, y:450, ease:Quad.easeIn , onComplete:zbrisiGaPicko} );
				
				mSnake.speedUp();
			}
			
			var currentActor:Actor;
			for (var i:int = 0; i < mAllActors.length; i++)
			{
				currentActor = mAllActors[i];
				currentActor.update();
				
				if (currentActor.mDestroy)
				{
					Actor(mAllActors[i]).destroy();
					mAllActors.splice(i, 1);
					i--;
				}
			}
			
			mCandyExplosion.update();
			mSnake.update();
			
			setupLevelCollisionData();
			
			if(!mSnake.mPreDestroy && !mSnake.mDestroy)
			if (mSnake.testCollisionWithDO(i_truckAnim.i_mionkaGari))
			{
				mTruckExplosionAnim.create(this, new Vector2D(i_truckAnim.i_mionkaGari.x, i_truckAnim.i_mionkaGari.y));
				mCandyExplosion.explode(new Vector2D(i_truckAnim.i_mionkaGari.x, i_truckAnim.i_mionkaGari.y));
				

				MovieClip(i_truckAnim).gotoAndStop("turningPoint");
				
				mTruckStarterTimer.reset();
				mTruckStarterTimer.delay = 5000 + Math.random() * 4000;
				mTruckStarterTimer.start();
			}
			
			if(!mSnake.mTongue.active())
			for each(var actor:Actor in mAllActors)
			{
				if (actor.mPreDestroy)
				continue;
				var candy:Candy;
				
				if (actor is Candy)
				{
					candy = Candy(actor);
					if(candy.mActive)
					if (snakeAndCandyCollision(candy))
					{
						
						//i_truckAnim.stop();
						//i_truckAnim.i_mionkaGari.x = 100;
						mSnake.mTongue.spitOutTongueToLickActor(candy);
						candy.startPreDestroy(mSnake, mSnake.mIncrementsPerFrame * mSnake.mSegmentLength * 1.1);
						
						if(candy is SquareCandy)
						mCandy1Anim.create(this, candy.mPosition, getChildIndex(candy.mCostume)-1);
						else if (candy is RoundCandy)
						{
							slowDownAnim();
							mCandy2Anim.create(this, candy.mPosition, getChildIndex(candy.mCostume) - 1);
						}
					}
				}
			}
			
			if (mSnake.mDestroy)
			{
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				mGameDC.goToGameOver(mLvlNum);
			}
		}
		
		private function zbrisiGaPicko():void 
		{
			mSpeedUpSign.parent.removeChild(mSpeedUpSign);
		}
		
		private function snakeAndCandyCollision(_candy:Candy):Boolean
		{
			var snakeMouth:Vector2D = mSnake.mMouth;
			
			var halo:Circle = new Circle(snakeMouth, 23);
			
			if (!intersection.PointInCircle(_candy.mPosition, halo))
				return false;
				
			var toCandy:Vector2D = vector.GetVectorFromAtoB(snakeMouth, _candy.mPosition);
			
			if (toCandy.dotP(mSnake.mDirection) < 0)
				return false;
				
			//var dist:Number = fnc.distance.GetDistance(snakeMouth, _candy.mPosition);
			
			//if (dist < halo.r * 0.7)
			//return false;
			
				
			var snakeDirLn:Line = new Line(snakeMouth, snakeMouth.returnAddedTo(mSnake.mDirection));
			
			return intersection.LineIntersectsCircle(snakeDirLn, _candy.mBoundingCircle);
		}
		
		public function on_die_button_clicked(event:MouseEvent) 
		{
			mGameDC.goToGameOver(mLvlNum);
		}
		
		public function on_win_button_clicked(event:MouseEvent) 
		{
			mGameDC.goToLevelComplete(mLvlNum);
		}
		
		public function isPositionFree(_pos:Vector2D):Boolean
		{	
		//	trace(mCollisionBD.getPixel(200, 200));
			
			return mCollisionBD.getPixel(_pos.x, _pos.y) == 0xFFFFFF;
		}

		public function setupLevelCollisionData()
		{
			mCollisionBD.draw(mSnake.mCollisionBD);

			for each(var actor:Actor in mAllActors)
			{
				if (actor is Candy)
				{
					mCollisionBD.copyPixels(mCandyHaloBD, mCandyHaloRect, new Point( actor.mPosition.x - mCandyCollisioRadius, actor.mPosition.y - mCandyCollisioRadius), null, null, true);
				}
			}
			
		}
		
		public function getFreePositionForCandyWithinRect(_rect:Rectangle):Vector2D 
		{
			var bezveze:Vector2D = new Vector2D(100, 100);
		
			var testVec:Vector2D;
			for (var i:int = 0; i < 100; i++)
			{
				testVec = new Vector2D(_rect.x + Math.random() * _rect.width , _rect.y + Math.random() * _rect.height);
				
				if (isPositionFree(testVec))
				{
					mCollisionBD.copyPixels(mCandyHaloBD, mCandyHaloRect, new Point( testVec.x - mCandyCollisioRadius, testVec.y - mCandyCollisioRadius), null, null, true);		
					return testVec;
				}
				else 
				{
					trace("PUSI KURAC BABA!!!");	
				}
			}
			
			return bezveze;
		}
	}
}