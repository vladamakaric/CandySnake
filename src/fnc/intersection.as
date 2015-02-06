package fnc 
{
	/**
	 * ...
	 * @author Vladimir Makaric
	 */
	public class intersection 
	{
		public static function PointOnLineOnLineSegment( _p:Vector2D, _ls:LineSegment ):Boolean
		{
			if(_ls.a.x != _ls.b.x)
				return misc.ValueBetweenValues(_ls.a.x, _ls.b.x, _p.x);
			else 
				return misc.ValueBetweenValues(_ls.a.y, _ls.b.y, _p.y);
		}
		
		public static function BBIntersection(bb1:BoundingBox, bb2:BoundingBox):Boolean
		{
			if (bb1.bottomRight.x < bb2.topLeft.x)
				return false;
				
			if (bb2.bottomRight.x < bb1.topLeft.x)
				return false;
				
			if (bb1.bottomRight.y < bb2.topLeft.y)
				return false;
				
			if (bb2.bottomRight.y < bb1.topLeft.y)
				return false;
				
			return true;
		}
		
		public static function PointInCircle(p:Vector2D, c:Circle)
		{
			return !distance.DistBetweenVecsBiggerThan(p, c.pos, c.r);
		}
		
		public static function GetLineSegmentCircleIntersection(_ls:LineSegment, _c:Circle, _interPoints:Array, checkForIntersection:Boolean):int
		{
			if(checkForIntersection)
				if(!LineSegmentIntersectsCircle(_ls,_c))
					return 0;


			var interNum:int = GetLineCircleIntersection(new Line(_ls.a, _ls.b), _c, _interPoints, false);
			if(!interNum)
				return 0;

			if(interNum == 1)
			{
				if(PointOnLineOnLineSegment(_interPoints[0], _ls))
					return 1;
				return 0;
			}

			if(interNum == 2)
			{
				var i:int=0;
				if(PointOnLineOnLineSegment(_interPoints[0], _ls))
					i++;

				if(PointOnLineOnLineSegment(_interPoints[1], _ls))
				{
					_interPoints[i]=_interPoints[1];
					i++;
				}

				return i;
			}
			
			return 45;
		}
		
		public static function GetLineCircleIntersection(_l:Line, _c:Circle, _interPoints:Array, checkForIntersection:Boolean):int
		{
			if(checkForIntersection)
				if(!intersection.LineIntersectsCircle(_l, _c))
					return 0;

			var temp:Line = _l.Copy();
			temp.Translate(_c.pos.GetNegative());

			var a:Number = temp.a;
			var b:Number = temp.b;
			var c:Number = temp.c;
			var r:Number = _c.r;

			var x1, x2, y1, y2:Number;

			x1 = (-(a*c) + Math.sqrt(b*b*(-c*c + a*a*r*r + b*b*r*r)))/(a*a + b*b);
			x2 = (-(a*c) - Math.sqrt(b*b*(-c*c + a*a*r*r + b*b*r*r)))/(a*a + b*b);

			if(b)
			{
				y1 = temp.GetY(x1);
				y2 = temp.GetY(x2);
			}
			else
			{
				y1 = Math.sqrt(r*r - x1*x1);
				y2 = -y1;
			}

			_interPoints[0] = new Vector2D(x1 + _c.pos.x, y1 + _c.pos.y);
			_interPoints[1] = new Vector2D(x2 + _c.pos.x, y2 + _c.pos.y);

			if(_interPoints[0] == _interPoints[1])
				return 1;

			return 2;
		}
		
		public static function PointProjectionOnLineSegment(p:Vector2D, ls:LineSegment):Boolean
		{
			var lineSegVec:Vector2D = vector.GetVectorFromAtoB(ls.a, ls.b);
			var lsLengthSq:Number = lineSegVec.lengthSq();
			var a:Vector2D = vector.GetVectorFromAtoB(ls.a, p);
			
			var projA:Number = vector.GetLenghtSqOfVectorProjectionAToB(a, lineSegVec);
			
			if (projA > lsLengthSq)
			return false;
			
			var b:Vector2D = vector.GetVectorFromAtoB(ls.b, p);
			var projB:Number = vector.GetLenghtSqOfVectorProjectionAToB(b, lineSegVec);
			
			if (projB > lsLengthSq)
			return false;
			
			return true;
		}
		
		public static function LineSegmentIntersection(_ls1:LineSegment, _ls2:LineSegment, _ip:Vector2D = null):Boolean
		{
			var s1_x, s1_y, s2_x, s2_y:Number;
			s1_x = _ls1.b.x - _ls1.a.x;     s1_y = _ls1.b.y - _ls1.a.y;
			s2_x = _ls2.b.x - _ls2.a.x;     s2_y = _ls2.b.y - _ls2.a.y;
			
			var s, t:Number;
			s = (-s1_y * (_ls1.a.x -  _ls2.a.x) + s1_x * (_ls1.a.y - _ls2.a.y)) / (-s2_x * s1_y + s1_x * s2_y);
			t = ( s2_x * (_ls1.a.y -  _ls2.a.y) - s2_y * (_ls1.a.x  -  _ls2.a.x)) / ( -s2_x * s1_y + s1_x * s2_y);
			
			if (s >= 0 && s <= 1 && t >= 0 && t <= 1)
			{
				if (_ip == null) return true;
				
				_ip.x = _ls1.a.x + (t * s1_x);
				_ip.y = _ls1.a.y + (t * s1_y);
				return true;
			}
			
			return false;
		}

		public static function LineSegmentIntersectsCircle(ls:LineSegment, circle:Circle):Boolean
		{
			return distance.GetLineSegmentPointDistanceSq(ls, circle.pos) <= circle.r * circle.r;
		}
		
		public static function LineIntersectsCircle(l:Line, circle:Circle):Boolean
		{
			return distance.GetLinePointDistance(l, circle.pos) <= circle.r;
		}
		
		public function intersection() 
		{
			
		}
		
	}

}