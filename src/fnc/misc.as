package fnc 
{
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Vladimir Makaric
	 */
	public class misc 
	{
		
		public static function GetShrunkenRect(_rect:Rectangle, _amount:int):Rectangle
		{
			return new Rectangle(_rect.x + _amount, _rect.y + _amount, _rect.width - _amount * 2, _rect.height - _amount * 2);
		}
		
		public static function ValueBetweenValues(_v1:Number, _v2:Number, _value:Number, leeway:Number = 0 )
		{
			var maxValue:Number = _v1;
			var minValue:Number;

			if(maxValue < _v2)
				maxValue = _v2;

			if(maxValue == _v2)
				minValue = _v1;
			else
				minValue = _v2;

			return _value >= (minValue-leeway) && _value <= (maxValue + leeway);
		}
		
		public static function GetTangentFromPointOnCircle( _circleCenter:Vector2D, _pointOnCircle:Vector2D ):Line
		{
			var toPoint:Vector2D = vector.GetVectorFromAtoB(_circleCenter, _pointOnCircle);
			toPoint.perpIt();
			
			var vec:Vector2D = new Vector2D(0, 0);
			vec.SetVec(_pointOnCircle);
			vec.add(toPoint);
			
			return new Line(vec, _pointOnCircle);
		}
				
		public function misc() 
		{
			
		}
		
	}

}