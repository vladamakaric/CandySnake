package fnc 
{
	/**
	 * ...
	 * @author Vladimir Makaric
	 */
	public class Line 
	{
		public var a, b, c:Number;
		
		public function Line(_a:Vector2D, _b:Vector2D) 
		{
			Set(_a, _b);
		}
		
		public function Set(_a:Vector2D, _b:Vector2D):void
		{
			a = _a.y - _b.y;
			b = _b.x - _a.x;
			c = _a.x*_b.y - _b.x*_a.y;
		}
		
		public function SetAsLs(ls:LineSegment):void
		{
			Set(ls.a, ls.b);
		}
		
		public function Copy():Line
		{
			var t:Line = new Line(new Vector2D(0,0), new Vector2D(0,0));
			t.a = a;
			t.b = b;
			t.c = c;
			return t;
		}
		
		public function PerpIt():void
		{
			var t:Number = a;
			a = b;
			b = t;
			
			if(Math.abs(a) && Math.abs(b)) a=-a;
		}
		
		
		public function GetX(_y:Number):Number
		{
			return (-b*_y - c)/a;
		}
		
		public function GetY(_x:Number):Number
		{
			return (-a*_x - c)/b;
		}
		
		public function ThroughPoint(p:Vector2D)
		{
			c = -a * p.x - b * p.y;
		}
		
		public function GetIntersectionOnXorYAxis():Vector2D
		{
			if(b)
				return new Vector2D(0, GetY(0));
			else
				return new Vector2D(GetX(0), 0);
		}
		
		public function Translate(_t:Vector2D):void
		{
			var axisIntersect:Vector2D = GetIntersectionOnXorYAxis();
			
			axisIntersect.add(_t);
			ThroughPoint(axisIntersect);
		}
		
		
		
	}

}