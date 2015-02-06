package  
{
	import fl.motion.easing.Circular;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import fnc.Circle;
	import fnc.distance;
	import fnc.vector;
	import fnc.Vector2D;
	/**
	 * ...
	 * @author ...
	 */
	public class Candy extends Actor
	{
		public var mBoundingCircle:Circle;
		public var mRadius:Number;
		public var mFollowPos:Vector2D;
		public var mFollowSpeed:Number;
		public var mStartDist:Number;
		public var mSnake:Snake;
		public var mBase:Sprite;
		public var mWrapper:Sprite;
		public var mActive:Boolean = false;
		
		
		public var mTimeToLive:int;
		
		public var mSelfPreDestroy:Boolean = false;
		
		public function Candy(_parent:DisplayObjectContainer, _position:Vector2D) 
		{
			super(new Sprite());
	
			setupGraphics(_parent);
			
			

			
			mPosition = _position;
			mBoundingCircle = new Circle(mPosition, mCostume.width/2);
			
			mCostume.x = _position.x;
			mCostume.y = _position.y;
		}
		
		public function setupGraphics(_parent:DisplayObjectContainer):void 
		{
			
		}
		
		public function startPreDestroy(_snake:Snake, _followSpeed:Number):void
		{
			if (!_snake)
			return;
			mPreDestroy = true;
			mSnake = _snake;
			mFollowPos = mSnake.mMouth.returnAddedTo(mSnake.mDirection.GetScaled(5));
			mFollowSpeed = _followSpeed;
			mStartDist = distance.GetDistance(mFollowPos, mPosition);
		}
		
		
		override public function preDestroyUpdating():void 
		{
			if (!mSelfPreDestroy)
			{
				mFollowPos = mSnake.mMouth.returnAddedTo(mSnake.mDirection.GetScaled(mSnake.mIncrementsPerFrame*6));
				var dist:Number = distance.GetDistance(mFollowPos, mPosition);
				
				var dRatio = dist / mStartDist;



				var toFollow:Vector2D = vector.GetVectorFromAtoB(mPosition, mFollowPos).direction();
				
				mPosition.add(toFollow.GetScaled(mFollowSpeed))
			}
			
			mCostume.scaleX *= 0.8;
			mCostume.scaleY = mCostume.scaleX;
			
			if (mCostume.scaleX < 0.1)
				mDestroy = true;
		}
		
		override public function update():void 
		{
			mTimeToLive-=GameDC.stepSize;
			
			if (mTimeToLive < 0 && !mPreDestroy)
			{
				startPreDestroy(null, 45);
				mSelfPreDestroy = true;
				mPreDestroy = true;
			}
			
			if (mPreDestroy)
				preDestroyUpdating();
			
			super.update();
		}
	}

}