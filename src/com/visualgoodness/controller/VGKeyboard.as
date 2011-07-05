package com.visualgoodness.controller
{
	import com.visualgoodness.events.VGNotification;
	
	import flash.display.DisplayObject;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	/**
	 * The VGKeyboard class attempts to simplify all keyboard interactions in an application. 
	 * The main features include a list of public static constants to easily find key codes,
	 * a method (<code>keyIsDown(keyCode:Number):Boolean</code>) to check if a certain key is
	 * currently down, and a polling timer that can repeatedly call a specified callback when
	 * a corresponding key is pressed.
	 * 
	 * @author Patrick Lynch
	 */
	public class VGKeyboard extends VGController
	{
		private var _keysDown:Array;
		private var _target:DisplayObject;
		private var _pollingTimer:Timer;
		private var _activePolls:Array;
		
		/**
		 * Add the listeners and initialize properties necessary for receive keyboard input.
		 * 
		 * @param target Mostly commonly a reference to <code>stage</code>, this is the DisplayObject where keyboardEvent listeners will be added.
		 */
		public function activate(target:DisplayObject):void
		{
			_target = target;
			_keysDown = [];
			_target.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			_target.addEventListener(KeyboardEvent.KEY_UP, keyUp);
			resetPolls();
		}
		
		/**
		 * Remove the listeners for receiving keyboard input.
		 * 
		 */
		public function deactivate():void
		{
			_keysDown = null;
			_target.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			_target.removeEventListener(KeyboardEvent.KEY_UP, keyUp);
			stopPolling();
		}
		
		private function keyDown(e:KeyboardEvent):void
		{
			if (!keyIsDown(e.keyCode))
			{
				_keysDown.push(e.keyCode);
				sendNotification(VGNotification.KEY_PRESSED, { keyCode:e.keyCode });
			}
		}
		
		/**
		 * Check if a specific key is currently beign held.
		 * 
		 * @param keyCode The ASCII key code of the key to check on.  Use constants of this class to easily find the key codes.
		 * @return Boolean indicating whether or not the key is currently down.
		 */
		public function keyIsDown(keyCode:Number):Boolean
		{
			var result:Boolean = false;
			var found:Boolean = false;
			for (var i:uint = 0; i < _keysDown.length && found == false; i++)
			{
				if (_keysDown[i] == keyCode)
				{
					found = false;
					result = true;
				}
			}
			return result;
		}

		/**
		 * Add the listeners and start the timer that polls for when keys are pressed.
		 * 
		 * @param interval The rate at which the polling will run and call the specified callback.
		 */
		public function startPolling(interval:Number = 33):void
		{
			if (!_pollingTimer)
			{
				_pollingTimer = new Timer(interval);
				_pollingTimer.addEventListener(TimerEvent.TIMER, onPoll);
				_pollingTimer.start();
			}
		}
		
		/**
		 * Clear the list of keys that are currently being polled for.
		 */
		public function resetPolls():void
		{
			stopPolling();
			_activePolls = [];
		}
		
		/**
		 * Stop polling for keyboard input, but keep the list of keys to poll for in memoery.  Use <code>resetPolls</code> to clear the list of keys.
		 */
		public function stopPolling():void
		{
			if (_pollingTimer)
			{
				_pollingTimer.stop();
				_pollingTimer.removeEventListener(TimerEvent.TIMER, onPoll);
				_pollingTimer = null;
			}
		}
		
		private function onPoll(e:TimerEvent):void
		{
			for (var i:uint = 0; i < _activePolls.length; i++)
			{
				var p:Object = _activePolls[i];
				if (keyIsDown(p.keyCode)) p.callback(p.keyCode);
			}
		}
		
		/**
		 * Add a key and a corresponding callback to the list of keys that are being polled when polling has been started.
		 * 
		 * @param key The ASCII key code for the key that is to be polled for.  Use constants of this class to easily find the key code.
		 * @param callback A function that will be called for each tick of the polling timer if they corresponding key is being pressed.
		 */
		public function poll(key:int, callback:Function):void
		{
			_activePolls.push({ keyCode:key, callback:callback });
		}
		
		private function keyUp(e:KeyboardEvent):void
		{
			sendNotification(VGNotification.KEY_RELEASED, { keyCode:e.keyCode });
		
			var indexToRemove:int = -1;
			var found:Boolean = false;
			for (var i:uint = 0; i < _keysDown.length && found == false; i++)
			{
				if (_keysDown[i] == e.keyCode)
				{
					indexToRemove = i;
					found = false;
				}
			}
			if (indexToRemove > -1)
				_keysDown.splice(indexToRemove);
		}
		
		public static const A:int 					= 65;
		public static const B:int 					= 66;
		public static const C:int 					= 67;
		public static const D:int 					= 68;
		public static const E:int 					= 69;
		public static const F:int 					= 70;
		public static const G:int 					= 71;
		public static const H:int 					= 72;
		public static const I:int 					= 73;
		public static const J:int 					= 74;
		public static const K:int 					= 75;
		public static const L:int 					= 76;
		public static const M:int 					= 77;
		public static const N:int 					= 78;
		public static const O:int 					= 79;
		public static const P:int 					= 80;
		public static const Q:int 					= 81;
		public static const R:int 					= 82;
		public static const S:int 					= 83;
		public static const T:int 					= 84;
		public static const U:int 		 			= 85;
		public static const V:int 				 	= 86;
		public static const W:int 					= 87;
		public static const X:int 					= 88;
		public static const Y:int 					= 89;
		public static const Z:int 					= 90;
		public static const N_0:int 				= 48;
		public static const N_1:int 				= 49;
		public static const N_2:int 				= 50;
		public static const N_3:int 				= 51;
		public static const N_4:int 				= 52;
		public static const N_5:int 				= 53;
		public static const N_6:int 				= 54;
		public static const N_7:int 				= 55;
		public static const N_8:int 				= 56;
		public static const N_9:int 				= 57;
		public static const SPACE:int 				= 32;
		public static const CONTROL:int 			= 17;
		public static const SHIFT:int 				= 16;
		public static const TILDA:int 				= 192;
		public static const UP:int 					= 38;
		public static const DOWN:int 				= 40;
		public static const LEFT:int 				= 37;
		public static const RIGHT:int 				= 39;
		public static const NUMPAD_0:int 			= 96;
		public static const NUMPAD_1:int 			= 97;
		public static const NUMPAD_2:int 			= 98;
		public static const NUMPAD_3:int 			= 99;
		public static const NUMPAD_4:int 			= 100;
		public static const NUMPAD_5:int 			= 101;
		public static const NUMPAD_6:int 			= 102;
		public static const NUMPAD_7:int 			= 103;
		public static const NUMPAD_8:int 			= 104;
		public static const NUMPAD_9:int 			= 105;
		public static const NUMPAD_DIVIDE:int 		= 111;
		public static const NUMPAD_START:int 		= 106;
		public static const NUMPAD_MINUS:int 		= 109;
		public static const NUMPAD_PLUS:int 		= 107;
		public static const NUMPAD_PERIOD:int 		= 110;
		public static const INSERT:int 				= 45;
		public static const DELETE:int 				= 46;
		public static const PAGE_UP:int 			= 33;
		public static const PAGE_DOWN:int 			= 34;
		public static const END:int 				= 35;
		public static const HOME:int 				= 36;
		public static const F1:int 					= 112;
		public static const F2:int 					= 113;
		public static const F3:int 					= 114;
		public static const F4:int 					= 115;
		public static const F5:int 					= 116;
		public static const F6:int 					= 117;
		public static const F7:int 					= 118;
		public static const F8:int 					= 119;
		public static const COMMA:int 				= 188;
		public static const PERIOD:int 				= 190;
		public static const SEMICOLON:int 			= 186;
		public static const SINGLE_QUOTE:int 		= 222;
		public static const OPEN_BRACKET:int 		= 219;
		public static const CLOSE_BRACKET:int 		= 221;
		public static const DASH:int 				= 189;
		public static const PLUS:int 				= 187;
		public static const BACK_SLASH:int 			= 220;
		public static const FORWARD_SLASH:int 		= 191;
		public static const TAB:int 				= 9;
		public static const BACKSPACE:int 			= 8;
	}
}