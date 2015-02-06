package fnc 
{
	/**
	 * ...
	 * @author Vladimir Makaric
	 */
	public class vector 
	{
		
		public function vector() 
		{
			
		}
		
		public static function GetNormalisedVectorOnLine(_l:Line):Vector2D
		{
			if(_l.a==0) return new Vector2D(1,0);
			if(_l.b==0) return new Vector2D(0,1);

			var A:Vector2D = new Vector2D(_l.GetX(0), 0);
			var B:Vector2D = new Vector2D(_l.GetX(10), 10);

			var normVecOnLine:Vector2D = GetVectorFromAtoB(A, B);
			normVecOnLine.normalize();
			return normVecOnLine;
		}
		
		public static function GetVectorFromAngleAndIntensity(_angle:Number, _intensity:Number)
		{
			return new Vector2D( Math.cos(_angle) * _intensity, Math.sin(_angle) * _intensity );
		}
		
		public static function BreakVectorIntoComponentsToLine( _l:Line, _v:Vector2D, _toLineComponent:Vector2D, _normalComponent:Vector2D )
		{
			_toLineComponent.SetVec(GetNormalisedVectorOnLine(_l));
			_normalComponent.SetVec(_toLineComponent.getPerp());

		//	trace(_toLineComponent.x + _toLineComponent.y);
			
			
			var toLineLenght, normalLenght:Number;

			if(_toLineComponent.dotP(_v) < 0)
				_toLineComponent.scale(-1);

			if(_normalComponent.dotP(_v) < 0)
				_normalComponent.scale(-1);

			toLineLenght = _toLineComponent.dotP(_v);
			normalLenght = _normalComponent.dotP(_v);

			_normalComponent.scale(normalLenght);
			_toLineComponent.scale(toLineLenght);
		}
		
		public static function ReflectVectorRayFromLine(_ray:Vector2D, _l:Line):void
		{
			var toLineC:Vector2D = new Vector2D(0, 0);
			var normToLineC:Vector2D = new Vector2D(0, 0);
			BreakVectorIntoComponentsToLine(_l, _ray, toLineC, normToLineC);
			
	//		trace(toLineC.x + toLineC.y);
	//		trace(normToLineC.x + normToLineC.y);
			
			normToLineC.scale( -1);
			normToLineC.add(toLineC);
			_ray.SetVec(normToLineC);
			//_ray.scale(0.99);
		}
		
		public static function GetVectorComponentToLine( line:Line, vec:Vector2D ):Vector2D
		{
			var toLineComponent:Vector2D = GetNormalisedVectorOnLine(line);
			
			if (toLineComponent.dotP(vec) < 0)
				toLineComponent.scale( -1);
				
			var toLineLenght:Number = toLineComponent.dotP(vec);
			
			toLineComponent.scale(toLineLenght);
			return toLineComponent;
		}
		
		public static function GetVectorBetweenVectors(a:Vector2D, b:Vector2D):Vector2D
		{
			return new Vector2D((a.x + b.x) / 2, (a.y + b.y) / 2);
		}
		
		public static function GetLenghtSqOfVectorProjectionAToB(a:Vector2D, b:Vector2D)
		{
			var dotP:Number = a.dotP(b);
			return Math.abs(dotP * dotP / b.lengthSq());
		}
		
		public static function GetVectorFromAtoB(a:Vector2D, b:Vector2D):Vector2D
		{
			var newVec:Vector2D = new Vector2D(b.x,b.y);
			newVec.subtract(a);
			
			return newVec;
		}
		
	}

}