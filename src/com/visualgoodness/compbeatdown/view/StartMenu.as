package com.visualgoodness.compbeatdown.view
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.visualgoodness.compbeatdown.interfaces.IStartMenuDelegate;
	
	public class StartMenu extends MovieClip
	{
		private var _startBtn:MovieClip;
		private var _insuranceBtn:DropDownButton;
		private var _delegate:IStartMenuDelegate;
		
		public function set delegate(value:IStartMenuDelegate):void
		{
			_delegate = value;
		}
		
		public function StartMenu()
		{
			_startBtn = this["start_btn"] as MovieClip;
			_insuranceBtn = this["insurance_btn"] as DropDownButton;
			
			_startBtn.addEventListener(MouseEvent.CLICK, startClicked);
		}
		
		private function startClicked(e:MouseEvent):void
		{
			if (_delegate) _delegate.start(_insuranceBtn.selection);
		}
	}
}