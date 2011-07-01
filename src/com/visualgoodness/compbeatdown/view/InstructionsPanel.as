package com.visualgoodness.compbeatdown.view
{
	import com.visualgoodness.compbeatdown.interfaces.IInstructionsPanelDelegate;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class InstructionsPanel extends MovieClip
	{
		public static const CONTROLS:String 		= "controls";
		public static const TAKE_SHOT:String 		= "takeShot";
		public static const PLAY_AGAIN:String		= "playAgain";
		public static const CHEAP_SHOT:String		= "cheapShot";
		
		private var _panel:MovieClip;
		private var _delegate:IInstructionsPanelDelegate;
		private var _hideStartFrame:int = 0;
		public var state:String;
		
		public function InstructionsPanel()
		{
			gotoAndStop("hide");
			_hideStartFrame = currentFrame;
			gotoAndStop(1);
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
		
		public function show(label:String = null):void
		{
			if (label)
			{
				showIndex(label);
				state = label;
			}
			gotoAndPlay("show");
		}
		
		public function hide():void
		{
			if (currentFrame > 1 && currentFrame < _hideStartFrame)
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
		
		public function showIndex(index:String):void
		{
			_panel.gotoAndPlay(index);
			if (index == PLAY_AGAIN) activate();
			else deactivate();
		}
	}
}