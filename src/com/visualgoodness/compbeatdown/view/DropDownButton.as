package com.visualgoodness.compbeatdown.view
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	
	public class DropDownButton extends MovieClip
	{
		public static const ITEM_SELECTED:String = "dropDownButtonItemSelected";
		
		private var over:Boolean = false;
		private var _dropDown:MovieClip;
		private var _dropDownItems:Array = [];
		public var selection:int = -1;
		public var selectionName:String = "";
		private var clicked:Boolean = false;
		private var expanded:Boolean = false;
		private var defaultText:String;
		
		public function DropDownButton()
		{
			initial_hit_area.buttonMode = true;
			defaultText = this["selection_txt"].text;
			//addEventListener(Event.ENTER_FRAME, run);
			initial_hit_area.addEventListener(MouseEvent.CLICK, expand);
			//addEventListener(MouseEvent.ROLL_OVER, expand);
			//addEventListener(MouseEvent.ROLL_OUT, collapse);
			addEventListener(Event.REMOVED_FROM_STAGE, removed);
			
			_dropDown = this["dropdown_mc"] as MovieClip;
			var index:int = 0;
			for (var i:uint = 0; i < 5; i++)
			{
				var item:MovieClip = _dropDown["item_"+i] as MovieClip;
				item.gotoAndStop(++index);
				item.addEventListener(MouseEvent.CLICK, itemClicked);
				item.buttonMode = true;
				_dropDownItems.push(item);
			}
		}
		
		public function reset():void
		{
			this["selection_txt"].text = defaultText;
			selection = -1;
		}
		
		private function removed(e:Event):void
		{
			//removeEventListener(Event.ENTER_FRAME, run);
			//removeEventListener(MouseEvent.ROLL_OVER, expand);
			//removeEventListener(MouseEvent.ROLL_OUT, collapse);
			removeEventListener(Event.REMOVED_FROM_STAGE, removed);
			for each (var item:MovieClip in _dropDownItems)
				item.removeEventListener(MouseEvent.CLICK, itemClicked);
		}
		
		private function itemClicked(e:MouseEvent):void
		{
			//clicked = true;
			setTimeout(function():void { clicked = false; }, 500);
			collapse();
			for (var i:uint = 0; i < _dropDownItems.length; i++)
			{
				var item:MovieClip = _dropDownItems[i] as MovieClip;
				if (item.name == MovieClip(e.currentTarget).name)
				{
					selection = i;
					selectionName = item["name_txt"].text as String;
					TextField(this["selection_txt"]).text = selectionName;
					break;
				}
			}
			trace("DropDownButton :: selection = " + selection);
			dispatchEvent(new Event(DropDownButton.ITEM_SELECTED));
		}
		
		private function expand(e:MouseEvent):void
		{
			if (expanded) return;
			expanded = true;
			//if (clicked) return;
			gotoAndPlay("over");				 
		}
		
		public function collapse(e:MouseEvent = null):void
		{
			if (!expanded) return;
			expanded = false;
			//if (clicked) return;
			gotoAndPlay("out");				 
		}
		
		/*private function run(e:Event):void
		{
			if (clicked) return;
			if (hitTestPoint(mouseX, mouseY, true))
			{
				if (!over)
				{
					over = true;
					gotoAndPlay("over");
				}
			}
			else
			{
				if (over)
				{
					over = false;
					gotoAndPlay("out");
				}
			}
		}*/
	}
}