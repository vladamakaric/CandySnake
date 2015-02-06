package  {
	
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import fnc.Vector2D;
	
	
	public class F_SnakeTongue extends MovieClip {
		
		
		public var mActorToLick:Actor;

		public static const TONGUE_LICKED_CANDY = "TongueLickedCandy";
		
		
		public function F_SnakeTongue() 
		{
			stop();
			bzvz.stop();
			visible = false;
			setupFrameLabelListeners();
		}
		
		private function setupFrameLabelListeners()
		{
			for each(var frameLabel:FrameLabel in currentLabels) 
			{
				if (frameLabel.name == "middleFrame")
				{
					addFrameScript(frameLabel.frame-1, onTongueFullyExtended );          
				}
			}
			
			addFrameScript(totalFrames-1, onTongueSpitLF);
		}
		
		private function onTongueSpitLF():void 
		{
			//SEM.expand(5);
			
			dispatchEvent(new Event(TONGUE_LICKED_CANDY));
			
			visible = false;
			stop();
			bzvz.stop();
		}
		
		private function onTongueFullyExtended():void 
		{
			
		}	

		public function active():Boolean
		{
			return visible;
		}
		
		public function update(_pos:Vector2D, _angle:Number):void
		{
			x = _pos.x;
			y = _pos.y;
			rotation = _angle;
		}
		
		public function spitOutTongueToLickActor(_actorToLick:Actor)
		{
			if (!visible)
			{
				mActorToLick = _actorToLick;
				gotoAndPlay(1);
				bzvz.gotoAndPlay(1);
				visible = true;
			}
		}
	}
	
}
