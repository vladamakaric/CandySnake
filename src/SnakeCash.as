package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Vladimir Makaric
	 */
	public class SnakeCash 
	{
		public var mTaperCircleShapeArr:Array;
		public var mEraserCircle:Shape;
		public var mTaperCircleBDArr:Array;
		public var mTransparencyCircleBDArr:Array;
		public var mTransparencyCBDNum:int = 30;
		public var mEraserCircleBD:BitmapData;
		public var mEraserCircleBMP:Bitmap;
		
		public function SnakeCash(_snake:Snake) 
		{
			mTaperCircleShapeArr = [];
			mTaperCircleBDArr = [];
			mTransparencyCircleBDArr = [];
			
			
			var girthDecrement:Number = (_snake.mTrunkGirth-_snake.mEndGirth) / _snake.mMaxTaperSegments;
			var currentGirth:Number = _snake.mTrunkGirth; 
			
			for (var i:int = 0; i < _snake.mMaxTaperSegments; i++ )
			{
				var circleShape:Shape = new Shape();
				circleShape.graphics.beginFill(_snake.mTrunkColor);
				circleShape.graphics.drawCircle(_snake.mTrunkGirth, _snake.mTrunkGirth, currentGirth);
				circleShape.graphics.endFill();
				mTaperCircleShapeArr.push(circleShape);
				currentGirth -= girthDecrement;
				
				var circleBD:BitmapData = new BitmapData(_snake.mTrunkGirth * 2, _snake.mTrunkGirth * 2, true, 0x00FFFFFF);
				circleBD.draw(circleShape, null, _snake.mWhiteColor);
				
				mTaperCircleBDArr.push(circleBD);
			}

			mEraserCircle = new Shape();
			mEraserCircle.graphics.beginFill(0);
			mEraserCircle.graphics.drawCircle(_snake.mTrunkGirth+1, _snake.mTrunkGirth+1, _snake.mTrunkGirth+1);
			mEraserCircle.graphics.endFill();
			
			mEraserCircleBD = new BitmapData(_snake.mTrunkGirth * 2 + 2, _snake.mTrunkGirth * 2 + 2, true, 0x00FFFFFF);
			mEraserCircleBD.draw(mEraserCircle, null, _snake.mBlackColor);
			
			mEraserCircleBMP = new Bitmap(mEraserCircleBD);
			mEraserCircleBMP.cacheAsBitmap = true;
			
			
			var currentAlpha:Number = 1;
			var alphaDecrement:Number = 1 / mTransparencyCBDNum;
			var circleBDRect:Rectangle = new Rectangle(0, 0, _snake.mTrunkGirth * 2, _snake.mTrunkGirth * 2); 
			//trace(alphaDecrement);
			
			for (i = 0; i < mTransparencyCBDNum; i++ )
			{
				var circleAlphaBD:BitmapData = new BitmapData(_snake.mTrunkGirth * 2, _snake.mTrunkGirth * 2, true, 0x00FFFFFF + ( currentAlpha*0xFF << 24 ));
				mTransparencyCircleBDArr.push(circleAlphaBD);
				currentAlpha -= alphaDecrement;
			}
		}
		
	}

}