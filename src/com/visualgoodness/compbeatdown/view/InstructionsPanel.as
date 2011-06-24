package com.visualgoodness.compbeatdown.view
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import com.visualgoodness.compbeatdown.interfaces.IInstructionsPanelDelegate;
	
	public class InstructionsPanel extends MovieClip
	{
		public static const CONTROLS:int 		= 0;
		public static const TAKE_SHOT:int 		= 1;
		public static const PLAY_AGAIN:int		= 2;
		
		private var _panel:MovieClip;
		private var _delegate:IInstructionsPanelDelegate;
		
		public function InstructionsPanel()
		{
			_panel = this["panel_body_mc"] as MovieClip;
			for (var i:int = 0; i < 4; i++) {
				var btn:MovieClip = _panel["btn_" + i] as MovieClip;
				btn.gotoAndPlay(i+1);
			}
		}
		public function set delegate(value:IInstructionsPanelDelegate):void
		{
			_delegate = value;
		}
		
		public function show():void
		{
			gotoAndPlay("show");
		}
		
		public function hide():void
		{
			gotoAndPlay("hide");
		}
		
		private function activate():void
		{
			buttonMode = true;
			addEventListener(MouseEvent.CLICK, clicked);
		}
		
		private function deactivate():void
		{
			buttonMode = false;
			removeEventListener(MouseEvent.CLICK, clicked);
		}
		
		private function clicked(e:MouseEvent):void
		{
			_delegate.playAgain();
			hide();
			deactivate();
		}
		
		public function showIndex(index:int):void
		{
			_panel.gotoAndStop(index+1);
			if (index == PLAY_AGAIN) activate();
			else deactivate();
		}
	}
}