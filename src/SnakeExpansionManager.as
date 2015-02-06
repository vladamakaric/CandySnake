package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import fnc.Vector2D;
	/**
	 * ...
	 * @author Vladimir Makaric
	 */
	public class SnakeExpansionManager extends Sprite
	{
		var mSnake:Snake;
		var mTailBMP:Bitmap;
		var mColor:uint = 0xFFFFFF;
		var mProlongationTimer:Timer;
		var mIncrementationActive:Boolean = false;
		var mActive:Boolean = false;
		var mDecrement:int = 0;
		
		var circleNum:int = 0;
		var segmentsPerTick:int = 4;
		
		var mAlphaDropSegmentNum:int = 20;
		
		
		public function SnakeExpansionManager(_snake:Snake, _delayBetweenIncrements:Number) 
		{
			mSnake = _snake;
			mTailBMP = new Bitmap(new BitmapData(600, 500, true, 0x00FFFFFF));
			addChild(mTailBMP);
			
			mProlongationTimer = new Timer(_delayBetweenIncrements, 0);
			mProlongationTimer.addEventListener(TimerEvent.TIMER, snakeExpansionIncrement);
			mProlongationTimer.addEventListener(TimerEvent.TIMER_COMPLETE, snakeExpansionEnded);
			
			blendMode = 'add';
			
			var blurFilter:BlurFilter = new BlurFilter(8, 8, BitmapFilterQuality.LOW);
			filters = [blurFilter];
		}
		
		public function expand(_segNum:int)
		{
			if (!mIncrementationActive)
			{
				mActive = true;
				mIncrementationActive = true;
				mProlongationTimer.reset();
				mProlongationTimer.repeatCount = _segNum/segmentsPerTick;
				mProlongationTimer.start();

				//mTailBMP.bitmapData = null;
			}			
			else
			{
				mProlongationTimer.repeatCount = mProlongationTimer.repeatCount + _segNum/segmentsPerTick;
			}
		}
		
		private function snakeExpansionEnded(e:TimerEvent):void 
		{
			mIncrementationActive = false;
		}
		
		public function active():Boolean
		{
			return mActive;
		}
		
		private function snakeExpansionIncrement(e:TimerEvent):void 
		{
			for (var i:int = 0; i < segmentsPerTick; i++)
			{
				mSnake.addSegmentInTail();
				circleNum++;
			}
		}

		public function draw()
		{
			var node:Vector2D;
			var maxGirth:Number = mSnake.mTrunkGirth;
			var expandedTailBD:BitmapData = new BitmapData(600, 500, true, 0x00FFFFFF);
			var circleRect:Rectangle = new Rectangle(0, 0, maxGirth*2, maxGirth*2);
			var nodes:Array = mSnake.mNodes;

			var cashArrayIncrement:Number = mSnake.mMaxTaperSegments / mSnake.mTaperSegments;
			var floatingIndex:Number = 0;
			
			var circleBDIndex:int = 0;
			var currentAlpha:Number = 1;

			var currentBD:BitmapData;
			var alphaBD:BitmapData;
			
			for (var i:int = 0; i < circleNum; i++)
			{
				if (i % 3 != 0)
				{
					floatingIndex += cashArrayIncrement;
					circleBDIndex = floatingIndex;
					continue;
				}
				
				node = nodes[nodes.length - (i + 1)];

				if (i > circleNum - mAlphaDropSegmentNum)
					currentAlpha = Number(circleNum - i) / Number(mAlphaDropSegmentNum) * 0.7;
				else
					currentAlpha = 1;
				
				if (circleBDIndex > mSnake.mMaxTaperSegments -1)
					circleBDIndex = mSnake.mMaxTaperSegments - 1;
					

				currentBD = mSnake.mCash.mTaperCircleBDArr[ mSnake.mMaxTaperSegments - 1 -circleBDIndex];
				alphaBD = mSnake.mCash.mTransparencyCircleBDArr[mSnake.mCash.mTransparencyCBDNum-1 - int(currentAlpha*mSnake.mCash.mTransparencyCBDNum - 1)];
				
				expandedTailBD.copyPixels(currentBD, circleRect, new Point(node.x - maxGirth, node.y - maxGirth), alphaBD, null, true );
				currentBD.colorTransform(circleRect, new ColorTransform(1, 1, 1, 1/currentAlpha));
				floatingIndex += cashArrayIncrement;
				circleBDIndex = floatingIndex;
			}
			
			mTailBMP.bitmapData = expandedTailBD;
			
			if (!mIncrementationActive)
			{
				circleNum-=segmentsPerTick;
				
				if (0 > circleNum)
				{
					circleNum = 0;
					mActive = false;
				}
			}
		}
	}

}