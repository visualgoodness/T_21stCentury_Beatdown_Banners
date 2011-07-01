package com.visualgoodness.compbeatdown.view
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class VGTimelineButton extends MovieClip
	{		
		public function VGTimelineButton()
		{
			activate();
		}
		
		public function activate():void
		{
			gotoAndStop("enabled");
			buttonMode = true;
			addEventListener(MouseEvent.ROLL_OVER, onOver);
			addEventListener(MouseEvent.ROLL_OUT, onOut);
		}
		
		public function deactivate(e:Event = null):void
		{
			buttonMode = false;
			removeEventListener(MouseEvent.ROLL_OVER, onOver);
			removeEventListener(MouseEvent.ROLL_OUT, onOut);
			gotoAndStop("disabled");
		}
		
		protected function onOver(e:MouseEvent):void
		{
			gotoAndPlay("over");
		}
		
		protected function onOut(e:MouseEvent):void
		{
			gotoAndPlay("out");
		}
	}
}