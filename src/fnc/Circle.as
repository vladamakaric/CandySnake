package fnc 
{
	/**
	 * ...
	 * @author Vladimir Makaric
	 */
	public class Circle 
	{
		public var r:Number;
		public var pos:Vector2D;
		
		public function Circle(position:Vector2D, _r:Number) 
		{
			Set(position, _r);
		}
		
		public function Set(position:Vector2D, _r:Number):void
		{
			pos = position;
			r = _r;
		}
	}

}