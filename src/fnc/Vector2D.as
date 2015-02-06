package fnc
{
	/**
	 * ...
	 * @author Vladimir Makaric
	 */
	public class Vector2D 
	{
		public var x:Number;
		public var y:Number;
		
		public function Vector2D(_x:Number, _y:Number) 
		{
			Set(_x, _y);
		}
		
		public function Set(_x:Number, _y:Number)
		{
			x = _x;
			y = _y;
		}
		
		public function returnAddedTo(otherVec:Vector2D):Vector2D
		{
			return new Vector2D(otherVec.x + x, otherVec.y + y);
		}
		
		public function getCopy():Vector2D
		{
			return new Vector2D(x, y);
		}
		
		public function Clear():void
		{
			Set(0, 0);
		}
		
		public function GetScaled(scale:Number):Vector2D
		{
			return new Vector2D(scale * x, scale * y);
		}
		
		public function GetNegative():Vector2D
		{
			return new Vector2D( -x, -y);
		}
		
		public function add(otherVec:Vector2D):void
		{
			x += otherVec.x;
			y += otherVec.y;
		}
		
		public function subtract(otherVec:Vector2D):void
		{
			x -= otherVec.x;
			y -= otherVec.y;
		}
		
		public function dotP(otherVec:Vector2D):Number
		{
			return x * otherVec.x + y * otherVec.y;
		}
		
		public function length():Number
		{
			return Math.sqrt(x * x + y * y);
		}
		
		public function lengthSq():Number
		{
			return x * x + y * y;
		}
		
		public function SetVec(vec:Vector2D)
		{
			x = vec.x;
			y = vec.y;
		}
		
		public function normalize():void
		{
			var fLength:Number = length();	
		
			if (fLength == 0) 
				return;
				
			x /= fLength;
			y /= fLength;
		}
		
		public function direction():Vector2D
		{
			var tlength:Number = length();
			return new Vector2D(x / tlength, y / tlength);
		}
		
		public function perpIt():void
		{
			var temp:Number = x;
			x = -y;
			y = temp;
		}
		
		public function getRescaled(s:Number):Vector2D
		{
			var newVec:Vector2D = new Vector2D(x, y);
			newVec.reScale(s);
			return newVec;
		}
		
		public function getPerp():Vector2D
		{
			var newVec:Vector2D = new Vector2D(x, y);
			newVec.perpIt();
			return newVec;
		}
		
		public function reScale(s:Number):void
		{
			normalize();
			scale(s);
		}
		
		public function scale(k:Number):void
		{
			x *= k;
			y *= k;
		}
		
		public function rotate(angle:Number):void
		{
			var tx:Number = x;
			x =  x * Math.cos(angle) - y * Math.sin(angle);
			y = tx * Math.sin(angle) + y * Math.cos(angle);
		}
		
		public function rotateAroundPoint(angle:Number, point:Vector2D):void
		{
			var atob:Vector2D = vector.GetVectorFromAtoB(point, this);
			atob.rotate(angle);
			x = atob.x + point.x;
			y = atob.y + point.y;
		}
	}
}