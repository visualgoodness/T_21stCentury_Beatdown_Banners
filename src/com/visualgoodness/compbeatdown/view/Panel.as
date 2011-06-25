package com.visualgoodness.compbeatdown.view
{
	import com.greensock.TweenNano;
	import com.greensock.easing.Sine;
	import com.visualgoodness.compbeatdown.model.ScoreKeeper;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class Panel extends MovieClip
	{
		private var _numbersLetterSpacing:int = -2;
		private var _numberStrip:MovieClip;
		private var _textFields:Array;
		private var _rowHeight:Number;
		private var _row:int;
		private var _numberStripStartY:Number;
		private var _scoreKeeper:ScoreKeeper;
		private var _numSlots:int;
		private var _cheapShotPanel:MovieClip;
		private var _queue:Array = [];
		private var _tweening:Boolean = false;
		private var _textGroup:MovieClip;
		private var _blurContainer:MovieClip;
		
		public function Panel()
		{
			_textGroup = this["panel_top"]["text_group_mc"] as MovieClip;
			_blurContainer = _textGroup["blur_container_mc"] as MovieClip;
			_textFields = [
				_blurContainer["number_strip_mc"]["num_mc_top"],
				_blurContainer["number_strip_mc"]["num_mc_bot"]
			];
			var format:TextFormat = new TextFormat();
			format.letterSpacing = _numbersLetterSpacing;
			for each (var t:MovieClip in _textFields)
			{
				TextField(t.txtfld).defaultTextFormat = format;
			}
			_numberStrip = _blurContainer["number_strip_mc"] as MovieClip;
			_numberStripStartY = _numberStrip.y;
			_rowHeight = MovieClip(_numberStrip["row_height_mc"]).height;
			_cheapShotPanel = this["panel_sm_mc"] as MovieClip;
			_cheapShotPanel.visible = false;
			_textGroup.gotoAndPlay(_textGroup.totalFrames);
		}
		
		public function set scoreKeeper(value:ScoreKeeper):void
		{
			_scoreKeeper = value;
			_scoreKeeper.addEventListener(ScoreKeeper.HITS_UPDATED, scoreUpdated);
			_scoreKeeper.addEventListener(ScoreKeeper.CLEAN_RESET, cleanReset);
			_scoreKeeper.addEventListener(ScoreKeeper.SELECTION_UPDATED, selectionUpdated);
			_scoreKeeper.addEventListener(ScoreKeeper.HIDE_CHEAP_SHOT, hideCheapShot);
			_scoreKeeper.addEventListener(ScoreKeeper.SHOW_CHEAP_SHOT, showCheapShot);
		}
		
		private function cleanReset(e:Event):void
		{
			var val:Number = _scoreKeeper.nextValue;
			trace("Panel :: cleanReset :: val = " + val);
			_textFields[0].txtfld.text = val;
			_textFields[1].txtfld.text = val;
		}
		
		private function showCheapShot(e:Event):void
		{
			_cheapShotPanel.visible = true;
			_cheapShotPanel.gotoAndPlay("show");
		}
		
		private function hideCheapShot(e:Event):void
		{
			_cheapShotPanel.addEventListener(Event.COMPLETE, cheapShotHidden);
			_cheapShotPanel.gotoAndPlay("hide");
		}
		
		private function cheapShotHidden(e:Event):void
		{
			_cheapShotPanel.removeEventListener(Event.COMPLETE, cheapShotHidden);
			_cheapShotPanel.visible = false;
		}
		
		private function selectionUpdated(e:Event):void
		{
			_textGroup.gotoAndStop(_scoreKeeper.selectionIndex+1);
		}
		
		private function scoreUpdated(e:Event = null):void
		{
			var val:Number = _scoreKeeper.nextValue;
			if (!_tweening)
			{
				_tweening = true;
				updateView(val);
			}
			else
			{
				_queue.push(val);
			}
		}
		
		private function updateView(val:Number):void
		{
			_textFields.sortOn("y", Array.NUMERIC);
			_textFields[1].txtfld.text = val;
			var animDuration:Number = 0.2;
			_blurContainer.play();
			TweenNano.to(_textFields[0], animDuration, { y:-_rowHeight, ease:Sine.easeInOut, onComplete:function():void
			{
				_textFields[0].y = _rowHeight;
				if (_queue.length > 0)
				{
					updateView(_queue.shift());
				}
				else
				{
					_tweening = false;
				}
				
			}});
			TweenNano.to(_textFields[1], animDuration, { y:0, ease:Sine.easeInOut });
		}
	}
}