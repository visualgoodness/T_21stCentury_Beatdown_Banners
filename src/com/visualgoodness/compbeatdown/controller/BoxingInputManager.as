package com.visualgoodness.compbeatdown.controller
{
	import com.visualgoodness.compbeatdown.interfaces.IInputDelegate;
	import com.visualgoodness.compbeatdown.view.Gloves;
	import com.visualgoodness.controller.VGKeyboard;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	public class BoxingInputManager
	{
		private var _keyboard:VGKeyboard;
		private var _delegate:IInputDelegate;
		private var _mouseHitArea:MovieClip;
		private var _interval:int;
		private var _currentTime:int = 0;
		private var _maxIdleTime:int = 5;
		private var _idle:Boolean = false;
		
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
			
			startTimer();
		}
		
		private function startTimer():void
		{
			stopTimer();
			_currentTime = 0;
			_interval = setInterval(timerTick, 1000);
		}
		
		public function idleNotificationComplete():void
		{
			startTimer();
		}
		
		private function timerTick():void
		{
			//trace("timer tick = " + _currentTime);
			if (_currentTime++ > _maxIdleTime)
			{
				stopTimer();
				_delegate.userIsIdle();
			}
		}
		
		private function stopTimer():void
		{
			clearInterval(_interval);
		}
		
		public function deactivate():void
		{
			stopTimer();
			
			_keyboard.resetPolls();
		
			_mouseHitArea.buttonMode = false;
			_mouseHitArea.mouseEnabled = false;
			_mouseHitArea.removeEventListener(MouseEvent.CLICK, clicked);
		}
		
		private function onInput(keyCode:int):void
		{
			startTimer();
				
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
			var t:MovieClip = _mouseHitArea;
			var mx:Number = t.mouseX;
			var my:Number = t.mouseY;
			
			if (my < t.height * 0.33) onInput(VGKeyboard.UP);
			else if (my > t.height * 0.66) onInput(VGKeyboard.DOWN);
			else if (mx > t.width/2) onInput(VGKeyboard.RIGHT);
			else onInput(VGKeyboard.LEFT);
		}
	}
}