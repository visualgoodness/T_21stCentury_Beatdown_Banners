package
{
	import flash.display.MovieClip;
	
	public class InstructionsPanel extends MovieClip
	{
		private var _panel:MovieClip;
		
		public function InstructionsPanel()
		{
			_panel = this["panel_body_mc"] as MovieClip;
			for (var i:int = 0; i < 4; i++) {
				var btn:MovieClip = _panel["btn_" + i] as MovieClip;
				btn.gotoAndPlay(i+1);
			}
		}
	}
}