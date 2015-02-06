package  
{
	import com.greensock.easing.Quad;
	import com.greensock.easing.Quart;
	import com.greensock.easing.Sine;
	import com.greensock.TweenLite;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import fnc.Vector2D;
	/**
	 * ...
	 * @author Vladimir Makaric
	 */
	public class SquareCandy extends Candy
	{
		var mBlurBase:Sprite;
		
		
		public function SquareCandy(_parent:DisplayObjectContainer, _position:Vector2D) 
		{
			
			
			
			
			super(_parent, _position);
			mTimeToLive = 150*3 + 30*3 * Math.random();
			mBoundingCircle.r += 20;
			
			mCostume.scaleX = mCostume.scaleY = 0.2;
			
			TweenLite.to(mCostume, 0.5, { scaleX:1, scaleY:1, onComplete:reverseScale } );

			playBlurAlpha();
		}
		
		
		private function playBlurAlpha():void
		{
			TweenLite.to(mBlurBase, 0.5, { alpha:0.9 ,ease:Quart.easeInOut , onComplete:reverseBlurAlpha} );
		}
		
		private function reverseBlurAlpha():void 
		{
			TweenLite.to(mBlurBase, 0.5, { alpha:0 ,ease:Quart.easeInOut , onComplete:playBlurAlpha} );
		}
		
		private function playScale():void
		{
			TweenLite.to(mCostume, 0.7, { scaleX:1, scaleY:1 ,ease:Sine.easeInOut , onComplete:reverseScale} );
		}
		
		private function reverseScale():void 
		{
			mActive = true;
			TweenLite.to(mCostume, 0.7, { scaleX:0.85, scaleY:0.85 ,ease:Sine.easeInOut , onComplete:playScale} );
		}
		
		override public function startPreDestroy(_snake:Snake, _followSpeed:Number):void 
		{
			super.startPreDestroy(_snake, _followSpeed);
			
			TweenLite.killTweensOf(mCostume);
			
	//		PartigenAnimManager.createEffect(F_CandyAnim, 1000, new Vector2D(mCostume.x, mCostume.y), mCostume.parent, mCostume.parent.getChildIndex(mCostume));
		}
		
		override public function setupGraphics(_parent:DisplayObjectContainer):void 
		{
			mBase = new F_Candy2Base();
			mBlurBase = new F_Candy2BaseBlur();
			mWrapper = new F_Candy2Wrapper();
			Sprite(mCostume).addChild(mWrapper);
			Sprite(mCostume).addChild(mBase);
			Sprite(mCostume).addChild(mBlurBase);
			
			mBlurBase.blendMode = 'add';
			
			mBlurBase.alpha = 0;
			
			_parent.addChild(mCostume);
		}
		
		
		override public function preDestroyUpdating():void 
		{
			super.preDestroyUpdating();
			
			mCostume.rotation += 0.6;
			
			
		}
		
		
	}

}