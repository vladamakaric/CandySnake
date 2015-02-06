package  
{
	import com.greensock.easing.Quad;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import fl.motion.Color;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.FrameLabel;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.filters.BevelFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BitmapFilterType;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import fnc.vector;
	import fnc.Vector2D;
	/**
	 * ...
	 * @author ...
	 */
	
	public class Snake extends Actor
	{
		public var LEFT:Boolean = false;
		public var RIGHT:Boolean = false;
				
		
		
		
		
		
		public var mAngularVelJerk:Number = 0.02;
		public var mAngularAcceleration:Number = 0.04;
		public var mAngularVel:Number = 0;
		public var mMaxAVel:Number = 0.13;
		public var mNodes:Array;
		public var mLeftOverNodes:Array;
		public var mSnakeLength:int = 100;
		public var mSegmentLength:Number = 2;
		public var mMaxTaperLegth:int = 60;
		public var mMaxTaperSegments:int = mMaxTaperLegth / mSegmentLength;
		
		
		
		public var mTaperSegments:int;

		public var mTrunkGirth:Number = 5;
		public var mEndGirth:Number = 1.5;
		public var mGirthDecrement:Number = (mTrunkGirth-mEndGirth) / mTaperSegments;
		
		public var mDamping:Number = 0.87;
		public var mNodeNum:int = mSnakeLength / mSegmentLength;
		public var mLastFrameNodeNum:int = mNodeNum;
		public var mHead:Sprite;
		public var mEyes:Sprite;
		public var mTorso:Bitmap;
		public var mTongue:F_SnakeTongue;
		public var mCollisionBD:BitmapData = new BitmapData(600, 450, false, 0xFFFFFF);
		
		public var mTailBD:BitmapData = new BitmapData(600, 450, true, 0x00FFFFFF);
		
		public var mTailBDEraser:BitmapData = new BitmapData(600, 450, true, 0x00FFFFFF);
		
		
		public var mBlackColor:Color;
		public var mWhiteColor:Color;
		public var mDirection:Vector2D;
		public var mMouth:Vector2D;
		public var SEM:SnakeExpansionManager;
		public var mTrunkColor:uint = 0xF8F500;
		
		public var mCash:SnakeCash;
		public var mDrawInitial:Boolean = false;
		var collisionTEmp:Bitmap;
		
		public var mMovedInFrame:Boolean = false;
		
		
		public var mIncrementsPerFrame:int = 3; // = mPixelPerFrame/ mSegmentLength;
		
		
		
		public function Snake(parent:DisplayObjectContainer, _position:Vector2D) 
		{
			super(null);

			
			
			mLeftOverNodes = [];
			mNodes = [];
			mPosition = _position;

			mCostume = new Sprite();
			mHead = new F_SnakeHead();

			
			mTongue = new F_SnakeTongue();
			mDirection = new Vector2D(1, 0);
			mBlackColor = new Color();
			mBlackColor.setTint (0x000000, 1);
			
			mWhiteColor = new Color();
			mWhiteColor.setTint (0xFFFFFF, 1);
			
			parent.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			collisionTEmp = new Bitmap(new BitmapData(600, 450, true, 0x00FFFFFF));
			mTorso = new Bitmap(new BitmapData(600, 450, true, 0x00FFFFFF));
			
			parent.addChild(mCostume);
			Sprite(mCostume).addChild(mTorso);

			addNodes();
			addFilters();
			
			Sprite(mCostume).addChild(mTongue);
			Sprite(mCostume).addChild(mHead);
			
			
			mTongue.addEventListener(F_SnakeTongue.TONGUE_LICKED_CANDY, onTongueLickedCandy);
			SEM = new SnakeExpansionManager(this, 10);
			
			Sprite(mCostume).parent.addChild(SEM);
			
	//		Sprite(mCostume).parent.addChild(collisionTEmp);
		}
		
		
		
		
		
		public function speedUp()
		{

			mIncrementsPerFrame++;
			mMaxAVel += mAngularVelJerk;
			TweenMax.to(mCostume, 0.5, { glowFilter: { color:0xFF3333, alpha:1, blurX:8, blurY:8 , strength:4.5}} );
			TweenMax.to(mCostume, 0.5, { glowFilter: { color:0xFF3333, alpha:0, blurX:0, blurY:0, remove:true } , delay:0.5} );
			
			
			
			
			
			
			//glowFilter:{color:0x91e600, alpha:1, blurX:30, blurY:30, remove:true}});
			//TweenMax.to(mSnake.mCostume, 1, {colorTransform:{tint:0x00ff00, tintAmount:0.5}});
		//	TweenMax.to(mSnake.mCostume, 1, {removeGlow:true, delay:1});
			
			
			//TweenMax.to(myObject,1,{removeTint:true});
		}
		
		
		public function slowDown()
		{

			if (mIncrementsPerFrame == 2)
				return;
				
			mIncrementsPerFrame--;
			mMaxAVel -= mAngularVelJerk;
			
			TweenMax.to(mCostume, 0.5, { glowFilter: { color:0x33CCFF, alpha:1, blurX:8, blurY:8 , strength:8.5}} );
			TweenMax.to(mCostume, 0.5, { glowFilter: { color:0x33CCFF, alpha:0, blurX:0, blurY:0, remove:true } , delay:0.5} );
		}
		
		private function onTongueLickedCandy(e:Event):void 
		{
			if(F_SnakeTongue(e.currentTarget).mActorToLick is SquareCandy)
			SEM.expand(50);
			else
			slowDown();
		}

		private function onAddedToStage(e:Event):void 
		{
			mCostume.parent.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			mCostume.parent.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);	
			mCostume.parent.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);	
			mCash = new SnakeCash(this);
		}
		
		private function onKeyUp(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.LEFT) LEFT = false; else 
			if (e.keyCode == Keyboard.RIGHT) RIGHT = false;
		}

		private function onKeyDown(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.LEFT) LEFT = true; else 
			if (e.keyCode == Keyboard.RIGHT) RIGHT = true;
		}
		
		public function addSegmentInTail()
		{
			var lastNode:Vector2D = mNodes[mNodes.length - 1];	
			var tailDir:Vector2D = vector.GetVectorFromAtoB(mNodes[mNodes.length - 2], lastNode);
			
			mNodes.push(lastNode.returnAddedTo(tailDir));	
			mNodeNum++;
		}

		private function addFilters()
		{
			var dropShadow:DropShadowFilter = new DropShadowFilter();
			dropShadow.distance = 1;
			dropShadow.angle = 45;
			dropShadow.color = 0x000000;
			dropShadow.alpha = 0.7;
			dropShadow.blurX = dropShadow.blurY = 2;
			dropShadow.strength = 1.2;
			dropShadow.quality = BitmapFilterQuality.LOW;
			dropShadow.inner = false;
			dropShadow.knockout = false;
			dropShadow.hideObject = false;

			var myBevel2:BevelFilter = new BevelFilter();
			myBevel2.type = BitmapFilterType.INNER;
			myBevel2.distance = 3;
			myBevel2.highlightColor = 0xFFFFFF;
			myBevel2.shadowColor = 0x000000;
			myBevel2.strength = 1.4;
			myBevel2.quality = BitmapFilterQuality.MEDIUM;
			myBevel2.blurX = myBevel2.blurY = 4;
			myBevel2.highlightAlpha = 0.4;
			myBevel2.shadowAlpha = 0.6;

			mCostume.filters = [dropShadow, myBevel2];
		}
		

		private function drawSnakeWithTaperedTail():void
		{	
			var currentGirth:Number = mTrunkGirth; 
			var node:Vector2D;
			var circleMatrix:Matrix = new Matrix();
			
			var newNodesNum:int = mNodes.length - mLastFrameNodeNum;
			
			if (!mDrawInitial)
			{
				newNodesNum = mNodes.length - mTaperSegments;
				mDrawInitial = true;
			}
			
			for (var i:int = 0; i < mIncrementsPerFrame; i++)
			{
				node = mNodes[i];
				circleMatrix.identity();
				circleMatrix.translate(node.x - mTrunkGirth, node.y - mTrunkGirth);
				mTorso.bitmapData.draw(Shape(mCash.mTaperCircleShapeArr[0]), circleMatrix);  
			}

			for (i = 0; i < mTaperSegments - 1; i++)
			{
				node = mNodes[mNodes.length - i - 1];
				circleMatrix.identity();
				circleMatrix.translate(node.x - mTrunkGirth -1, node.y - mTrunkGirth-1);
				mTorso.bitmapData.draw(mCash.mEraserCircleBMP, circleMatrix, null, 'erase');  
			}
			
			for (i = 0; i < mLeftOverNodes.length; i++ )
			{
				node = mLeftOverNodes[i];
				circleMatrix.identity();
				circleMatrix.translate(node.x - mTrunkGirth -1, node.y - mTrunkGirth-1);
				mTorso.bitmapData.draw(mCash.mEraserCircleBMP, circleMatrix, null, 'erase'); 
			}

			var cashArrayIncrement:Number = mMaxTaperSegments / mTaperSegments;
			var floatingIndex:Number = 0;
			for (i = mNodes.length - mTaperSegments; i < mNodes.length; i++)
			{
				
				node = mNodes[i];
				circleMatrix.identity();
				circleMatrix.translate(node.x - mTrunkGirth, node.y - mTrunkGirth);

				mTorso.bitmapData.draw(Shape(mCash.mTaperCircleShapeArr[  int(floatingIndex) ]), circleMatrix);  
				currentGirth -= mGirthDecrement;
				
				floatingIndex += cashArrayIncrement;
			}
			
			//
			//trace(newNodesNum);
			
			for (i = 0; i < newNodesNum - mIncrementsPerFrame -1; i++)
			{
				node = mNodes[mNodes.length - mTaperSegments - i - 1];
				circleMatrix.identity();
				circleMatrix.translate(node.x - mTrunkGirth, node.y - mTrunkGirth);
				mTorso.bitmapData.draw(Shape(mCash.mTaperCircleShapeArr[0]), circleMatrix); 
			}
			
		//	mTorso.bitmapData.draw(mTailBD);
			
			mLastFrameNodeNum = mNodes.length;
		}
		
		private function setupCollisionMask()
		{
			mCollisionBD.fillRect(GameDC.mStageRect, 0xFFFFFF);
			mCollisionBD.draw(mTorso.bitmapData, null, mBlackColor);
			
			var matrixSnakeHead:Matrix = new Matrix();
			matrixSnakeHead.rotate(mAngle);
			matrixSnakeHead.translate(mPosition.x, mPosition.y);
			mCollisionBD.draw(mHead, matrixSnakeHead,  mBlackColor);
			
			var bridge:Sprite = new F_LakeMask();
			bridge.cacheAsBitmap = true;
			
			mCollisionBD.draw(bridge, null, mBlackColor);
			
			collisionTEmp.bitmapData = mCollisionBD;
			
			
		}
		
		private function setupScalesTextures()
		{

		}
		
		private function advanceSnake()
		{
		//	trace(mIncrementsPerFrame);
			var firstNode = mNodes[0];
			var prevFirstNode = firstNode.getCopy();
			firstNode.add(mDirection.GetScaled(mSegmentLength));
			
			var prevNode:Vector2D = prevFirstNode;
			for (var i:int = 1; i < mNodeNum; i++)
			{
				var tempNode:Vector2D = Vector2D(mNodes[i]).getCopy();
				mNodes[i] = prevNode;
				prevNode = tempNode;
			}
		}
		
		private function addNodes()
		{
			for (var i:int = 0; i < mNodeNum; i++)
				mNodes.push(new Vector2D(mPosition.x - i * mSegmentLength, mPosition.y));
		}

		public function testCollisionWithDO(_do:DisplayObject):Boolean
		{
			//mCollisionBD.fillRect(GameDC.mStageRect, 0xFFFFFF);

			var matrix:Matrix = new Matrix();
			matrix.scale(1.2, 1.2);
			matrix.rotate(_do.rotation/180*Math.PI);
			matrix.translate(_do.x, _do.y);
			mCollisionBD.draw(_do, matrix, mBlackColor);
			
			return collision();
		}
		
		private function collision():Boolean
		{
			if (!GameDC.mStageRect.containsPoint(new Point(mPosition.x, mPosition.y)))
				return true;

			var feelerVec:Vector2D = mPosition.getCopy();
			
			feelerVec.add(vector.GetVectorFromAngleAndIntensity(mAngle, 15));

			var feelerVec2:Vector2D = feelerVec.returnAddedTo(mDirection.GetScaled(2));
			
			if (!mCollisionBD.getPixel(feelerVec.x, feelerVec.y) || !mCollisionBD.getPixel(feelerVec2.x, feelerVec2.y))  //0 je crna boja, sto je boja zmije u collisionBD
				return true;
					
			return tailExpansionCollision();
		}
		
		private function tailExpansionCollision():Boolean
		{
			if (!SEM.mIncrementationActive)
			return false;
			
			var tailEndPoint:Vector2D = mNodes[mNodes.length - 1];
			
			if (!GameDC.mStageRect.containsPoint(new Point(tailEndPoint.x, tailEndPoint.y)))
				return true;
				
				
			var tailDir:Vector2D = vector.GetVectorFromAtoB(mNodes[mNodes.length - 2], tailEndPoint).getRescaled(3);
				
			var feelerVec:Vector2D = tailEndPoint.returnAddedTo(tailDir);
			var feelerVec2:Vector2D = feelerVec.returnAddedTo(tailDir.GetScaled(0.4));
			
			return !mCollisionBD.getPixel(feelerVec.x, feelerVec.y) || !mCollisionBD.getPixel(feelerVec2.x, feelerVec2.y);
		}
		
		
		private function rememberLeftOverNodes():void
		{
			mLeftOverNodes = [];
			
			for (var i:int = 0; i < mIncrementsPerFrame; i++)
				mLeftOverNodes.push(Vector2D(mNodes[mNodes.length - 1 - i]).getCopy());
		}
		
		private function moveSnake():Boolean
		{
			GameDC.stepSize = mIncrementsPerFrame;
			
			rememberLeftOverNodes();

			for (var i:int = 0; i < mIncrementsPerFrame; i++)
				advanceSnake();
				
			mPosition = mNodes[0];

			mHead.x = mPosition.x;
			mHead.y = mPosition.y;
			
			mHead.rotation = mAngle / Math.PI * 180;
			
			mTongue.update(mPosition, mHead.rotation);	
			
			return true;
		}

		override public function update():void 
		{
			if (mPreDestroy)
			{
				preDestroyUpdating();
				return;
			}
			
			if (LEFT) mAngularVel -= mAngularAcceleration;
			if (RIGHT) mAngularVel += mAngularAcceleration;
			if(!RIGHT && !LEFT) mAngularVel *= mDamping;
			
			if (mAngularVel > mMaxAVel)
				mAngularVel = mMaxAVel;
				
			else if (mAngularVel < -mMaxAVel)
				mAngularVel = -mMaxAVel;
			
			mAngle += mAngularVel;
			
			if (Math.abs(mAngularVel) < 0.001)
				mAngularVel = 0;
			
			mDirection = vector.GetVectorFromAngleAndIntensity(mAngle, 1);
			
			
			moveSnake();
		
			
			mMouth = mPosition.returnAddedTo(mDirection.GetScaled(14));
			
			mTaperSegments = mNodeNum / 3;
			
			if (mTaperSegments > mMaxTaperSegments)
			mTaperSegments = mMaxTaperSegments;
			
			drawSnakeWithTaperedTail();
			
			if (SEM.active())
			SEM.draw();
			
			setupCollisionMask();
			
			if (collision())
			{
				var costumeCopyBD:BitmapData = new BitmapData(600, 450, false, 0x00FFFFFF);
				costumeCopyBD.draw(mCostume);
				
				var costumeCopyBMP:Bitmap = new Bitmap(costumeCopyBD);
				mCostume.parent.addChild(costumeCopyBMP);
				costumeCopyBMP.blendMode = 'multiply';
				
				
				TweenMax.to(mCostume, 0.33, { colorTransform: { tint:0xff0000, tintAmount:1 }, onComplete:finishRedSnake } );
				TweenMax.to(mCostume, 0.6, {glowFilter:{color:0xFF0000, alpha:1, blurX:14, blurY:14}});
				
				mPreDestroy = true;
				return;
			}
		}
		
		private function finishRedSnake():void 
		{
			GameDC.mStageBMP = new Bitmap( new BitmapData(600, 450, false, 0x00FFFFFF));
			GameDC.mStageBMP.bitmapData.draw(mCostume.parent);

			TweenMax.to(GameDC.mStageBMP, 1.6, { colorTransform: { tint:0xff0000, tintAmount:0.5 }, ease:Quad.easeInOut, delay:0.1} );
			
			mDestroy = true;
		}
	}

}