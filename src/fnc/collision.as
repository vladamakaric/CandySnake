package fnc 
{
	/**
	 * ...
	 * @author Vladimir Makaric
	 */
	public class collision 
	{
		
		//private static function BallHitsLS
		
		
		
		private static function BallHitsLSEndPoint(_c:Circle, _ls:LineSegment, _ballSpeed:Vector2D, lsEndPoint:Vector2D):void
		{	
			var lineFromLS:Line = new Line(_ls.a, _ls.b);
			var vecToLSG:Vector2D = vector.GetVectorFromAtoB(_c.pos, lsEndPoint);
			var normalComp:Vector2D = new Vector2D(0,0);
			var paralelComp:Vector2D = new Vector2D(0,0);
			vector.BreakVectorIntoComponentsToLine(lineFromLS, vecToLSG, paralelComp, normalComp);
			
			var currentToPrevPosVec:Vector2D = vector.GetVectorFromAtoB(_c.pos, Global.currentLevel.mPlayer.mParticle.mPreviousPos);
			var distToLine:Number = distance.GetLinePointDistance(lineFromLS, _c.pos);

			if(normalComp.length() > _c.r*0.5 && paralelComp.length() < _c.r*0.7 )
			{
				var perpVecToBallSpeed:Vector2D = currentToPrevPosVec.getRescaled(-_c.r * 2).getPerp();
				
				var perpLS:LineSegment = new LineSegment(_c.pos.returnAddedTo(perpVecToBallSpeed), _c.pos.returnAddedTo(perpVecToBallSpeed.GetNegative()));
				
				var sideInterPoints:Array = new Array();
				intersection.GetLineSegmentCircleIntersection(perpLS, _c, sideInterPoints, true);
				
				var outerLSArr:Array = [new LineSegment(sideInterPoints[0], Vector2D(sideInterPoints[0]).returnAddedTo(currentToPrevPosVec)),
										new LineSegment(sideInterPoints[1], Vector2D(sideInterPoints[1]).returnAddedTo(currentToPrevPosVec))];
										
				var interP:Vector2D =  new Vector2D(0, 0);
				
				
				for each(var outerLS:LineSegment in outerLSArr)
				{
					if (!intersection.LineSegmentIntersection(outerLS, _ls, interP))
						continue;
						
			//		trace("SLIDE");
					var toInterP:Vector2D = vector.GetVectorFromAtoB(_c.pos, interP);
					
					if (toInterP.dotP(normalComp) > 0)
					normalComp.scale( -1);
					
					normalComp.reScale(_c.r - distToLine);
					
					_c.pos.add(normalComp);
					vector.ReflectVectorRayFromLine(_ballSpeed, lineFromLS);
					return;
				}
			}
			
			var curDistToLS:Number = distance.GetLineSegmentPointDistance(_ls, _c.pos);
			var prevDistToLS:Number  = distance.GetLineSegmentPointDistance(_ls, Global.currentLevel.mPlayer.mParticle.mPreviousPos); 
			
		//	trace("prevDTS: " + prevDistToLS + "  curDTS: " + curDistToLS);

			var interPP:Array = new Array();
			
			intersection.GetLineSegmentCircleIntersection(_ls, _c, interPP, false);
			
			var distTOInter:Number = distance.GetDistance(lsEndPoint, interPP[0]);
			
			var displacementV:Vector2D = vector.GetVectorFromAtoB(lsEndPoint, _c.pos);
			var dvs:Number = displacementV.length();
			
			displacementV.reScale(_c.r - dvs);

			_c.pos.add(displacementV);
			var tangent:Line = misc.GetTangentFromPointOnCircle(_c.pos, lsEndPoint);
			vector.ReflectVectorRayFromLine(_ballSpeed, tangent);
			return;
		}
		
		private static function BallHitsEndPoint(endP:Vector2D, otherEP:Vector2D, ballCenter:Vector2D):Boolean
		{
			var toBall:Vector2D = vector.GetVectorFromAtoB(endP, ballCenter);
			var toOtherEP:Vector2D = vector.GetVectorFromAtoB(endP, otherEP);
			
			if ( toBall.dotP(toOtherEP) > 0)
			return false;
			else 
			return true;
		}
		
		
		public static function BounceBallOfLine(circle:Circle, line:Line, ballV:Vector2D, centerInter:Vector2D = null)
		{
			if (centerInter == null)
			{
				var interPoints:Array = new Array();
				var interCount:int = intersection.GetLineCircleIntersection(line, circle, interPoints, false);
				
				if(interCount == 2)
				centerInter = vector.GetVectorBetweenVectors(interPoints[0], interPoints[1]);
				else 
				centerInter = interPoints[0];
			}
			
			var displacement:Vector2D = vector.GetVectorFromAtoB(centerInter, circle.pos);
			var displacementSize:Number = circle.r - displacement.length();
			displacement.reScale(displacementSize);
			//displacement.add(displacement.getRescaled(6));
			circle.pos.add(displacement);
			
			
			vector.ReflectVectorRayFromLine(ballV, line);	
			
			
		//	ballV.scale(0.9);
		}
		
		
		public static function LineSegmentBallEdgeCollisionResponse(circle:Circle, ls:LineSegment, ballV:Vector2D):void
		{
			var aInCircle:Boolean = intersection.PointInCircle(ls.a, circle);
			var bInCircle:Boolean = intersection.PointInCircle(ls.b, circle);
			
			if(aInCircle && BallHitsEndPoint(ls.a, ls.b, circle.pos))
			{
				BallHitsLSEndPoint(circle, ls, ballV, ls.a);
				return;
			}
			
			if(bInCircle && BallHitsEndPoint(ls.b, ls.a, circle.pos))
			{
				BallHitsLSEndPoint(circle, ls, ballV, ls.b);
				return;
			}

			var line:Line = new Line(ls.a, ls.b);
			BounceBallOfLine(circle, line, ballV);
		}
		
		
		public static function BallLineSegmentCollisionResponse(circle:Circle, ls:LineSegment, ballV:Vector2D):Boolean
		{
			var interPoints:Array = new Array();
			var interCount:int = intersection.GetLineSegmentCircleIntersection(ls, circle, interPoints, false);

			if(interCount == 0)
				return false;
			
			var aInCircle:Boolean = intersection.PointInCircle(ls.a, circle);
			var bInCircle:Boolean = intersection.PointInCircle(ls.b, circle);
			
			if(aInCircle && BallHitsEndPoint(ls.a, ls.b, circle.pos))
			{
				BallHitsLSEndPoint(circle, ls, ballV, ls.a);
				return true;
			}
			
			if(bInCircle && BallHitsEndPoint(ls.b, ls.a, circle.pos))
			{
				BallHitsLSEndPoint(circle, ls, ballV, ls.b);
				return true;
			}
			
			var centerIntersect:Vector2D = new Vector2D(0,0);

			
			var line:Line = new Line(ls.a, ls.b);
			
			if(interCount == 2)
				centerIntersect = vector.GetVectorBetweenVectors(interPoints[0], interPoints[1]);
			else
			{
				if (bInCircle || aInCircle)
				{					
					BounceBallOfLine(circle, line, ballV);
					return true;
				}
				else				
				centerIntersect = interPoints[0];
			}
			
			BounceBallOfLine(circle, line, ballV, centerIntersect);
			return true;
		}
		
		public function collision() 
		{
			
		}
		
	}

}