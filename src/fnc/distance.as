package fnc 
{
	/**
	 * ...
	 * @author Vladimir Makaric
	 */
	public class distance 
	{
		
		public function distance() 
		{
			
		}
		public static function DistBetweenVecsBiggerThan(a:Vector2D, b:Vector2D, dist:Number):Boolean
		{
			return GetDistanceSq(a, b) >= dist * dist;
		}
		
		public static function GetDistance(a:Vector2D, b:Vector2D):Number
		{
			var t:Vector2D = new Vector2D(a.x, a.y);
			t.subtract(b);
			return t.length();
		}
		
		public static function GetDistanceSq(a:Vector2D, b:Vector2D):Number
		{
			var t:Vector2D = new Vector2D(a.x, a.y);
			t.subtract(b);
			return t.lengthSq();
		}

		public static function GetLinePointDistance(l:Line, p:Vector2D):Number
		{
			return Math.abs(l.a * p.x + l.b * p.y + l.c) / Math.sqrt(l.a * l.a + l.b * l.b);
		}
		
		public static function GetLineSegmentPointDistance(ls:LineSegment, p:Vector2D):Number
		{
			return Math.sqrt(GetLineSegmentPointDistanceSq(ls, p));
		}
		
		public static function GetLineSegmentPointDistanceSq(ls:LineSegment, p:Vector2D):Number
		{
		    var l:Line = new Line(ls.a, ls.b);
			var dist:Number = GetLinePointDistance(l, p);
			
			if (intersection.PointProjectionOnLineSegment(p, ls))
				return dist*dist;
			
			return Math.min(GetDistanceSq(ls.a, p), GetDistanceSq(ls.b, p));
		}
		
	}

}