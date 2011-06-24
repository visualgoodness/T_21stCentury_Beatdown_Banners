package com.visualgoodness.compbeatdown.controller
{
	import com.visualgoodness.controller.VGKeyboard;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import com.visualgoodness.compbeatdown.interfaces.IInputDelegate;
	import com.visualgoodness.compbeatdown.view.Gloves;

	public class BoxingInputManager
	{
		private var _keyboard:VGKeyboard;
		private var _delegate:IInputDelegate;
		private var _mouseHitArea:MovieClip;
		
		public function BoxingInputManager(delegate:IInputDelegate, mouseHitArea:MovieClip)
		{
			_delegate = delegate;
			_mouseHitArea = mouseHitArea;
		}
		
		public function activate():void
		{	
			// Activate keyboard input
			if (!_keyboard) _keyboard = new VGKeyboard();
			_keyboard.activate(_mouseHitArea.stage);
			_keyboard.poll(VGKeyboard.LEFT, onInput);
			_keyboard.poll(VGKeyboard.RIGHT, onInput);
			_keyboard.poll(VGKeyboard.UP, onInput);
			_keyboard.poll(VGKeyboard.DOWN, onInput);
			_keyboard.startPolling(1000/18);
			
			_mouseHitArea.buttonMode = true;
			_mouseHitArea.mouseEnabled = true;
			_mouseHitArea.addEventListener(MouseEvent.CLICK, clicked);
		}
		
		public function deactivate():void
		{	
			_keyboard.resetPolls();
		
			_mouseHitArea.buttonMode = false;
			_mouseHitArea.mouseEnabled = false;
			_mouseHitArea.removeEventListener(MouseEvent.CLICK, clicked);
		}
		
		private function onInput(keyCode:int):void
		{
			var punch:int;
			switch(keyCode)
			{
				case VGKeyboard.LEFT:
				case VGKeyboard.D:
					punch = Gloves.JAB_L;
					break;
				case VGKeyboard.RIGHT:
				case VGKeyboard.A:
					punch = Gloves.JAB_R;
					break;
				case VGKeyboard.UP:
				case VGKeyboard.W:
					punch = Gloves.HOOK;
					break;
				case VGKeyboard.S:
				case VGKeyboard.DOWN:
					punch = Gloves.LOW;
					break;
			}
			_delegate.swing(punch);
		}
		
		private function clicked(e:MouseEvent):void
		{
			var t:MovieClip = e.currentTarget as MovieClip;
			var mx:Number = t.mouseX - t.width/2;
			var my:Number = -t.mouseY + t.height/2;
			var area:int = 0;
			var rad:Number = Math.atan2(my,mx) / Math.PI * 180;
			
			// DIAGONAL
			/*if (rad < 45 && rad > -45) swing(VGKeyboard.RIGHT);
			if (rad > 135 && rad < 180) swing(VGKeyboard.LEFT);
			if (rad > -180 && rad < -135) swing(VGKeyboard.LEFT);
			if (rad > -135 && rad < -45) swing(VGKeyboard.DOWN);
			if (rad > 45 && rad < 135) swing(VGKeyboard.UP);*/
			
			// HALF
			if (mx > 0) onInput(VGKeyboard.RIGHT);
			else onInput(VGKeyboard.LEFT);
		}
	}
}