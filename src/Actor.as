package  
{
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import fnc.Vector2D;
	/**
	 * ...
	 * @author ...
	 */
	public class Actor extends EventDispatcher
	{
		var mCostume:DisplayObject;
		var mDestroy:Boolean = false;
		var mPreDestroy:Boolean = false;
		var mVisible:Boolean = false;
		var mPosition:Vector2D;
		var mAngle:Number = 0;
		
		public function Actor(_Costume:DisplayObject) 
		{
			mCostume = _Costume;
		}
		
		public function updateCostumePositionAndRotation():void 
		{
			mCostume.x = mPosition.x;
			mCostume.y = mPosition.y;
			mCostume.rotation = mAngle;
		}
		
		public function update():void
		{
			updateCostumePositionAndRotation();
		}
		
		
		public function preDestroyUpdating():void
		{
			
		}
		
		public function destroy()
		{
			mCostume.parent.removeChild(mCostume);
		}
	}
}