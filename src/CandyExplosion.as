package  
{
	import com.greensock.TweenLite;
	import flash.geom.Rectangle;
	import fnc.misc;
	import fnc.Vector2D;
	/**
	 * ...
	 * @author Vladimir Makaric
	 */
	public class CandyExplosion 
	{		
		var mFlyingCandys:Array;
		var mLevel:F_Level;
		
		var mMaxBlueCandyNum:int = 2;
		var mMaxRedCandyNum:int = 4;
		var mParticleFXs:Array;
		
		
		public function CandyExplosion(_level:F_Level) 
		{
			mParticleFXs = [];
			mFlyingCandys = [];
			mLevel = _level;
			
			for (var i:int = 0; i < 10; i++)
			{
				mParticleFXs.push(new F_RedStarEmm());
				
			}
		}
		
		public function explode(_pos:Vector2D)
		{
			var blueCandyNum:int = Math.random() * mMaxBlueCandyNum;
			var redCandyNum:int = 1 + Math.random() * mMaxRedCandyNum;
			
			var candy:Candy;
			
			for (var i:int = 0; i < redCandyNum + blueCandyNum; i++)
			{
				var position:Vector2D = mLevel.getFreePositionForCandyWithinRect(misc.GetShrunkenRect(GameDC.mStageRect, 40));

				if (i > redCandyNum - 1)
				{
					candy = new RoundCandy(mLevel, _pos.getCopy());
					mFlyingCandys.push(new FlyingCandy(candy, position, 10, mParticleFXs[i]));
				}
				else
				{
					candy = new SquareCandy(mLevel, _pos.getCopy());
					mFlyingCandys.push(new FlyingCandy(candy, position, 10, mParticleFXs[i]));
				}
				
				mLevel.mAllActors.push(candy);
			}
		}
		
		public function update()
		{
			var currentFC:FlyingCandy;
			for (var i:int = 0; i < mFlyingCandys.length; i++)
			{
				currentFC = FlyingCandy(mFlyingCandys[i]);
				currentFC.update();
				
				if (!currentFC.mActive)
				{
					currentFC.destroy();
					mFlyingCandys.splice(i, 1);
					i--;
				}
			}
		}

	}

}