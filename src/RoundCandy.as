package  
{
	import com.greensock.easing.Quad;
	import com.greensock.easing.Quart;
	import com.greensock.easing.Quint;
	import com.greensock.easing.Sine;
	import com.greensock.TweenLite;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import fnc.Vector2D;
	/**
	 * ...
	 * @author Vladimir Makaric
	 */
	public class RoundCandy extends Candy
	{
		
		public function RoundCandy(_parent:DisplayObjectContainer, _position:Vector2D) 
		{
			
			
			
			super(_parent, _position);
			mTimeToLive = 90*3 + 20*3 * Math.random();
			mBoundingCircle.r += 20;
			
			mCostume.scaleX = mCostume.scaleY = 0;
			
			
			
			
			
			TweenLite.to(mCostume, 0.5, { scaleX:1, scaleY:1, ease:Quart.easeIn, onComplete:reverseScale } );
			
			playRotation();
		}
		
		private function reverseRotation():void
		{
			TweenLite.to(mBase, 0.7, { rotation:180, ease:Quad.easeIn , onComplete:playRotation} );
		}
		
		private function playRotation():void
		{
			TweenLite.to(mBase, 0.7, { rotation:360, ease:Quad.easeOut , onComplete:reverseRotation} );
		}
		
		private function playScale():void
		{
			TweenLite.to(mCostume, 0.7, { scaleX:1, scaleY:1 ,ease:Sine.easeInOut , onComplete:reverseScale} );
		}
		
		private function reverseScale():void 
		{
			mActive = true;
			TweenLite.to(mCostume, 0.7, { scaleX:0.85, scaleY:0.85 , ease:Sine.easeInOut , onComplete:playScale } );
			
		}
		
		override public function startPreDestroy(_snake:Snake, _followSpeed:Number):void 
		{
			super.startPreDestroy(_snake, _followSpeed);
			
			TweenLite.killTweensOf(mCostume);
		}
		
		override public function setupGraphics(_parent:DisplayObjectContainer):void 
		{
			mBase = new F_Candy1Base();
			mWrapper = new F_Candy1Wrapper();
			Sprite(mCostume).addChild(mWrapper);
			Sprite(mCostume).addChild(mBase);
			
			_parent.addChild(mCostume);
		}
		
		override public function preDestroyUpdating():void 
		{
			super.preDestroyUpdating();
			
			mCostume.rotation += 0.6;
		}
		
	}

}