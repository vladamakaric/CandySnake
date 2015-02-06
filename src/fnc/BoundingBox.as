package fnc 
{
	/**
	 * ...
	 * @author Vladimir Makaric
	 */
	public class BoundingBox 
	{
		public var topLeft:Vector2D;
		public var bottomRight:Vector2D;
	
		public function BoundingBox(vec1:Vector2D, vec2:Vector2D) 
		{
			topLeft = new Vector2D(0, 0);
			bottomRight = new Vector2D(0, 0);
			SetFromVecs(vec1, vec2);
		}
		
		public function SetTLBRVecs(tLeft:Vector2D, bRight:Vector2D)
		{
			topLeft = tLeft;
			bottomRight = bRight;
		}
		
		public function SetFromCircle(c:Circle)
		{
			topLeft = c.pos.returnAddedTo(new Vector2D( -c.r, -c.r));
			bottomRight = c.pos.returnAddedTo(new Vector2D( c.r, c.r));
		}
		
		public function SetFromLS(ls:LineSegment)
		{
			SetFromVecs(ls.a, ls.b);
		}
		
		public function SetFromVecs(vec1:Vector2D, vec2:Vector2D):void
		{
			if (vec1.x > vec2.x)
			{
				bottomRight.x = vec1.x;
				topLeft.x = vec2.x;
			}
			else
			{
				bottomRight.x = vec2.x;
				topLeft.x = vec1.x;
			}
			
			if (vec1.y > vec2.y)
			{
				bottomRight.y = vec1.y;
				topLeft.y = vec2.y;
			}
			else
			{
				bottomRight.y = vec2.y;
				topLeft.y = vec1.y;
			}
		}
	}
}