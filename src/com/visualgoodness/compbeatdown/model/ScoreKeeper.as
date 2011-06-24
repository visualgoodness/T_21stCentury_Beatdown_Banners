package com.visualgoodness.compbeatdown.model
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.setTimeout;
	import com.visualgoodness.compbeatdown.events.ReactionEvent;

	public class ScoreKeeper extends EventDispatcher
	{
		public static const HITS_UPDATED:String = "hitsUpdated";
		public static const SHOW_CHEAP_SHOT:String = "showCheapShot";
		public static const HIDE_CHEAP_SHOT:String = "hideCheapShot";
		public static const CLEAN_RESET:String = "cleanReset";
		public static const SELECTION_UPDATED:String = "selectionUpdated";
		public static const GAME_OVER:String = "gameOver";
		
		private var _amts:Array = [ 468, 399, 354, 453, 265 ];
		private var _numHitsToFinish:int = 5;
		private var _hits:int;
		private var _maxHits:int;
		private var _hitsToRevelCheapShot:int = 5;
		private var _totalHits:int;
		private var _numReactions:int = 6;
		private var _currentReaction:int = 0;
		private var _reactionHits:int = 0;
		private var _reactionHitInterval:int = 4;
		private var _reactionIsPlaying:Boolean = false;
		private var _selectionIndex:int = 4;
		
		public function set selectionIndex(value:int):void
		{
			reset();
			_selectionIndex = value;
			dispatchEvent(new Event(ScoreKeeper.SELECTION_UPDATED));
		}
		
		public function get nextValue():int
		{
			var amt:int = int(_amts[_selectionIndex] / _numHitsToFinish) * _totalHits;
			return amt;
		}
		
		public function get selectionIndex():int
		{
			return _selectionIndex;
		}
		
		private function reset():void
		{
			_hits = 0;
			_totalHits = 0;
			_reactionHits = 0;
			dispatchEvent(new Event(ScoreKeeper.CLEAN_RESET));
		}
		
		public function hit():void
		{
			_hits++;
			_totalHits++;
			if (_totalHits >= _numHitsToFinish)
			{
				_totalHits = _numHitsToFinish;
				dispatchEvent(new Event(ScoreKeeper.GAME_OVER));
				return;
			}
			if (_totalHits == _hitsToRevelCheapShot)
			{
				dispatchEvent(new Event(ScoreKeeper.SHOW_CHEAP_SHOT));
				setTimeout(function():void { dispatchEvent(new Event(ScoreKeeper.HIDE_CHEAP_SHOT))}, 4000);
			}
			if (_hits > _maxHits) _hits = 0;
			dispatchEvent(new Event(ScoreKeeper.HITS_UPDATED));
			
			if (!_reactionIsPlaying)
			{
				_reactionHits++;
				if (_reactionHits >= _reactionHitInterval)
				{
					_reactionHits = 0;
					_reactionIsPlaying = true;
					dispatchEvent(new ReactionEvent(ReactionEvent.START_REACTION, _currentReaction));
					_currentReaction++;
					if (_currentReaction >= _numReactions) _currentReaction = 0;
				}
			}
		}
		
		public function reactionComplete():void
		{
			_reactionIsPlaying = false;
		}
		
		public function get reactionIsPlaying():Boolean
		{
			return _reactionIsPlaying;
		}
		
		public function set maxHits(value:int):void
		{
			_maxHits = value;
		}	
		
		public function get hits():int
		{
			return _hits;
		}
	}
}