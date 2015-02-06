package  
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import fnc.Vector2D;
	/**
	 * ...
	 * @author Vladimir Makaric
	 */
	public class PartigenAnim
	{
		var timer:Timer;
		var anim:*;
		var mEmmiterOffset:Vector2D;

		public function PartigenAnim(animClass:Class, duration:Number, _emmiterOffset:Vector2D = null) 
		{
			if (_emmiterOffset)
				mEmmiterOffset = _emmiterOffset;
			else  
			mEmmiterOffset = new Vector2D(0, 0);
			
			anim = new animClass();
			timer = new Timer(duration, 1);
			timer.addEventListener(TimerEvent.TIMER, timerComplete);
		}

		public function create(_parent:DisplayObjectContainer, _pos:Vector2D, _index:int = -1)
		{
			if (timer.running)
			return;
			
			if (_index > -1)
				_parent.addChildAt(anim, _index);
			else
				_parent.addChild(anim);
				

			anim.x = _pos.x + mEmmiterOffset.x;
			anim.y = _pos.y + mEmmiterOffset.y;
			anim.kurac.start();
			timer.start();
		}
		
		public function timerComplete(e:TimerEvent):void 
		{
			timer.reset();
			var bezvezeX:XML = anim.kurac.toXML();
			
			anim.parent.removeChild(anim);
			anim.kurac.stop();
			anim.kurac.reset();
			anim.kurac.fromXML(bezvezeX);
		}
		
	}

}