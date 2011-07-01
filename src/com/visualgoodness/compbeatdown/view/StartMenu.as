package com.visualgoodness.compbeatdown.view
{
	import com.greensock.TweenNano;
	import com.greensock.easing.Sine;
	import com.visualgoodness.compbeatdown.interfaces.IStartMenuDelegate;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	public class StartMenu extends MovieClip
	{
		public static const START_MENU_WILL_SHOW:String = "startMenuWillShow";
		
		private var _startBtn:VGTimelineButton;
		private var _insuranceBtn:DropDownButton;
		private var _delegate:IStartMenuDelegate;
		private var _helper:MovieClip;
		private var _dropDownOpen:Boolean = false;
		private var _timeout:int;
		
		public function set delegate(value:IStartMenuDelegate):void
		{
			_delegate = value;
		}
		
		public function StartMenu()
		{
			_helper = this["helper_line_mc"] as MovieClip;
			_helper.alpha = 0;
			_startBtn = this["start_btn"] as VGTimelineButton;
			_insuranceBtn = this["insurance_btn"] as DropDownButton;
			_insuranceBtn.addEventListener(MouseEvent.CLICK, dropDownClicked);
			_startBtn.addEventListener(MouseEvent.CLICK, startClicked);
			_startBtn.deactivate();
		}
		
		private function startIdleTimer():void
		{
			clearTimeout(_timeout);
			_timeout = setTimeout(function():void {
				if (_insuranceBtn.selection == -1)
					TweenNano.to(_helper, 0.5, { alpha:1, ease:Sine.easeOut });
			}, 5000);
		}
		
		private function dropDownClicked(e:MouseEvent):void
		{
			_dropDownOpen = true;
			_insuranceBtn.removeEventListener(MouseEvent.CLICK, dropDownClicked);
			_startBtn.addEventListener(MouseEvent.CLICK, startClicked);
			clearTimeout(_timeout);
			TweenNano.killTweensOf(_helper);
			TweenNano.to(_helper, 0.5, { alpha:0, ease:Sine.easeOut });
		}
		
		public function willShow(e:Event = null):void
		{
			_dropDownOpen = false;
			startIdleTimer();
			_insuranceBtn.addEventListener(DropDownButton.ITEM_SELECTED, itemSelected);
			_insuranceBtn.addEventListener(MouseEvent.CLICK, dropDownClicked);
			_startBtn.addEventListener(MouseEvent.CLICK, startClicked);
			_insuranceBtn.reset();
			TweenNano.killTweensOf(_helper);
			_startBtn.deactivate();
		}
		
		private function itemSelected(e:Event):void
		{
			if (_insuranceBtn.selection != -1)
			{
				TweenNano.to(_helper, 0.5, { alpha:0, ease:Sine.easeOut });
				_dropDownOpen = false;
				_startBtn.activate();
			}
		}
		
		private function startClicked(e:MouseEvent):void
		{
			if (_insuranceBtn.selection == -1)
			{
				if (!_dropDownOpen)
					TweenNano.to(_helper, 0.5, { alpha:1, ease:Sine.easeOut });
			}
			else
			{
				if (_delegate)
				{
					_startBtn.removeEventListener(MouseEvent.CLICK, startClicked);
					clearTimeout(_timeout);
					_insuranceBtn.collapse();
					trace("StartMenu :: _insuranceBtn.selection = " + _insuranceBtn.selection); 
					_delegate.start(_insuranceBtn.selection);	
				}
			}
		}
	}
}