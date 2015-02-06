package {
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	
	public class F_About extends Sprite
	{
		public var main_class:GameDC;
		
		public function F_About(passed_class:GameDC) 
		{
			main_class = passed_class;
			back_button.addEventListener(MouseEvent.CLICK, on_back_button_clicked);
		}
		
		public function on_back_button_clicked(event:MouseEvent) 
		{
			main_class.goToMainMenu();
		}
	}
}