package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	
	public class DropDownButton extends MovieClip
	{
		private var over:Boolean = false;
		private var _dropDown:MovieClip;
		private var _dropDownItems:Array = [];
		public var selection:int = 0;
		public var selectionName:String = "";
		private var clicked:Boolean = false;
		private var _delegate:IDropDownButtonDelegate;
		
		public function set delegate(value:IDropDownButtonDelegate):void
		{
			_delegate = value;
		}
		
		public function DropDownButton()
		{
			initial_hit_area.buttonMode = true;
			
			addEventListener(Event.ENTER_FRAME, run);
			addEventListener(MouseEvent.ROLL_OVER, onOver);
			addEventListener(MouseEvent.ROLL_OUT, onOut);
			addEventListener(Event.REMOVED_FROM_STAGE, removed);
			
			_dropDown = this["dropdown_mc"] as MovieClip;
			var index:int = 0;
			for (var i:uint = 0; i < _dropDown.numChildren; i++)
			{
				if (_dropDown.getChildAt(i)["name"] == "item_" + (i-1))
				{
					var item:MovieClip = _dropDown.getChildAt(i) as MovieClip;
					item.gotoAndStop(++index);
					item.addEventListener(MouseEvent.CLICK, itemClicked);
					item.buttonMode = true;
					_dropDownItems.push(item);
				}
			}
		}
		
		private function removed(e:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, run);
			removeEventListener(MouseEvent.ROLL_OVER, onOver);
			removeEventListener(MouseEvent.ROLL_OUT, onOut);
			removeEventListener(Event.REMOVED_FROM_STAGE, removed);
			for each (var item:MovieClip in _dropDownItems)
				item.removeEventListener(MouseEvent.CLICK, itemClicked);
		}
		
		private function itemClicked(e:MouseEvent):void
		{
			clicked = true;
			setTimeout(function():void { clicked = false; }, 500);
			gotoAndPlay("out");
			for (var i:uint = 0; i < _dropDownItems.length; i++)
			{
				var item:MovieClip = _dropDownItems[i] as MovieClip;
				if (item.name == MovieClip(e.currentTarget).name)
				{
					selection = i;
					selectionName = item["name_txt"].text as String;
					TextField(this["selection_txt"]).text = selectionName;
					trace("Selection made " + i);
					break;
				}
			}
		}
		
		private function onOver(e:MouseEvent):void
		{
			if (clicked) return;
			gotoAndPlay("over");				 
		}
		
		private function onOut(e:MouseEvent):void
		{
			if (clicked) return;
			gotoAndPlay("out");				 
		}
		
		private function run(e:Event):void
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
		}
	}
}