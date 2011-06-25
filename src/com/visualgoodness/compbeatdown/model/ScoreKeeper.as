package com.visualgoodness.compbeatdown.model
{
	import com.visualgoodness.compbeatdown.events.ReactionEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.setTimeout;

	public class ScoreKeeper extends EventDispatcher
	{
		public static const HITS_UPDATED:String 			= "hitsUpdated";
		public static const SHOW_CHEAP_SHOT:String 			= "showCheapShot";
		public static const HIDE_CHEAP_SHOT:String 			= "hideCheapShot";
		public static const CLEAN_RESET:String 				= "cleanReset";
		public static const SELECTION_UPDATED:String 		= "selectionUpdated";
		public static const GAME_OVER:String 				= "gameOver";
		
		private var _amts:Array 							= [ 492, 516, 457, 535, 461 ];
		private var _numHitsToFinish:int 					= 20;
		private var _hits:int;
		private var _hitsToRevelCheapShot:int 				= 15;
		private var _totalHits:int;
		private var _numReactions:int 						= 4;
		private var _cheapShotIndex:int 					= 4;
		private var _currentReaction:int 					= 0;
		private var _reactionHits:int 						= 0;
		private var _reactionHitInterval:int 				= 4;
		private var _reactionIsPlaying:Boolean 				= false;
		private var _selectionIndex:int 					= 4;
		private var _cheapShotReady:Boolean 				= false;
		
		public var gameOverTimeout:int						= 2000;
		
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
		
		public function get cheapShotReady():Boolean
		{
			return _cheapShotReady;
		}
		
		private function reset():void
		{
			_hits = 0;
			_totalHits = 0;
			_reactionHits = 0;
			_currentReaction = 0;
			_cheapShotReady = false;
			dispatchEvent(new Event(ScoreKeeper.CLEAN_RESET));
		}
		
		private function checkGameOver():Boolean
		{
			if (_totalHits >= _numHitsToFinish)
			{
				_totalHits = _numHitsToFinish;
				dispatchEvent(new Event(ScoreKeeper.GAME_OVER));
				return true;
			}
			return false;
		}
		
		public function hit(tryCheapShot:Boolean = false):void
		{
			_hits++;
			_totalHits++;
			if (_totalHits == _hitsToRevelCheapShot)
			{
				_cheapShotReady = true;
				dispatchEvent(new Event(ScoreKeeper.SHOW_CHEAP_SHOT));
				setTimeout(function():void { dispatchEvent(new Event(ScoreKeeper.HIDE_CHEAP_SHOT))}, 4000);
			}
			
			var reactionToPlay:int;
			if (tryCheapShot && _cheapShotReady)
			{
				reactionToPlay = _cheapShotIndex;
				_totalHits = _numHitsToFinish;
				dispatchEvent(new ReactionEvent(ReactionEvent.START_REACTION, reactionToPlay));
			}
			
			if (!_reactionIsPlaying)
			{
				_reactionHits++;
				if (_reactionHits >= _reactionHitInterval)
				{
					_reactionHits = 0;
					_reactionIsPlaying = true;
					reactionToPlay = _currentReaction;
					if (_currentReaction++ >= _numReactions) _currentReaction = 0;
					dispatchEvent(new ReactionEvent(ReactionEvent.START_REACTION, reactionToPlay));
				}
			}
			dispatchEvent(new Event(ScoreKeeper.HITS_UPDATED));
			checkGameOver();
		}
		
		public function reactionComplete():void
		{
			_reactionIsPlaying = false;
		}
		
		public function get hits():int
		{
			return _hits;
		}
	}
}