package fnc 
{
	/**
	 * ...
	 * @author Vladimir Makaric
	 */
	public class LineSegment 
	{
		public var a:Vector2D;
		public var b:Vector2D;
		public var BBox:BoundingBox;
		
		
		public function LineSegment(_a:Vector2D, _b:Vector2D) 
		{
			BBox = new BoundingBox(_a, _b);
			Set(_a, _b);
		}
		
		public function Set(_a:Vector2D, _b:Vector2D):void
		{
			a = _a;
			b = _b;
			BBox.SetFromVecs(a, b);
		}
		
		public function Length():Number
		{
			return vector.GetVectorFromAtoB(a, b).length();
		}
		
	}

}