package  
{
	import com.greensock.easing.Circ;
	import com.greensock.TweenLite;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import fnc.Vector2D;
	/**
	 * ...
	 * @author Vladimir Makaric
	 */
	public class FlyingCandy 
	{

		var mEmmiter:MovieClip;
		var mFinishPosition:Vector2D;
		var mCandyPiece:Candy;
		var mDuration:int;
		var mActive:Boolean = true;
		var mStartTime:int;
		var mPreDestroy:Boolean = false;
		
		public function FlyingCandy(_candy:Candy, _dest:Vector2D, _duration:int, _emmiter:MovieClip ) 
		{
			mStartTime = GameDC.TIME;
			
			mCandyPiece = _candy;
			mDuration = _duration;
			
			TweenLite.to(mCandyPiece.mPosition, _duration/10, { x: _dest.x , y: _dest.y, ease:Circ.easeOut } );
			
			var index:int = _candy.mCostume.parent.getChildIndex(_candy.mCostume) - 1;
			
			mEmmiter = _emmiter;
			update();
			_candy.mCostume.parent.addChild(mEmmiter);
			mEmmiter.kurac.start();
			
		}
		
		public function preDestroy()
		{
			mEmmiter.kurac.stop();
		}
		
		public function destroy()
		{
			mEmmiter.parent.removeChild(mEmmiter);
		}
		
		public function update()
		{
			if (!mPreDestroy)
			{
				mEmmiter.kurac.x = mCandyPiece.mPosition.x;
				mEmmiter.kurac.y = mCandyPiece.mPosition.y;
				
				if (GameDC.TIME - mStartTime == mDuration - 3)
				{
					mPreDestroy = true;
					preDestroy();
				}
				
				return;
			}
			
			if (GameDC.TIME - mStartTime == mDuration)
			{
				mActive = false;
			//	destroy();
			}
		}
	}
}