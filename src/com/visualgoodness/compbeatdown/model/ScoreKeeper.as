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
		public static const STEP_SHOW:String 				= "gameOver";
		
		private var _amts:Array;
		private var _numHitsToFinishInGame:int				= 20;
		private var _hitsToRevelCheapShot:int 				= 15;
		private var _hitsToStopShowingInstructions:int		= 8;
		private var _numHitsToFinish:int;
		private var _hits:int;
		private var _totalHits:int;
		private var _numReactions:int 						= 5;
		private var _cheapShotIndex:int 					= 5;
		private var _cheapShotIndex2:int 					= 6;
		private var _currentReaction:int 					= 0;
		private var _reactionHits:int 						= 0;
		private var _reactionHitInterval:int 				= 4;
		private var _reactionIsPlaying:Boolean 				= false;
		private var _selectionIndex:int;
		private var _cheapShotReady:Boolean 				= false;
		private var _alwaysPlayCheapShotAsEnd:Boolean		= false;
		private var _introIndex:int;
		private var _playAltCheapShot:Boolean				= true;
		
		public var gameOverTimeout:int						= 2000;
		public var shouldShowInstructions:Boolean			= true;
		
		public function ScoreKeeper()
		{
			_amts = [
				492,  // Geico
				516,  // All State
				535,  // Progressive
				457,  // State Farm
				461,  // Other
				500   // Default
			];
			// By default, have the last amount selected and only four hits to reach max for intro:
			_numHitsToFinish = 4;
			_introIndex = _amts.length - 1;
			_selectionIndex = _introIndex;
		}
		
		public function set selectionIndex(value:int):void
		{
			_numHitsToFinish = _numHitsToFinishInGame;
			reset();
			_selectionIndex = value;
			dispatchEvent(new Event(ScoreKeeper.SELECTION_UPDATED));
		}
		
		public function get nextValue():int
		{
			var amt:int = int(_amts[_selectionIndex] / _numHitsToFinish) * _totalHits;
			if (_totalHits == _numHitsToFinish) amt = _amts[_selectionIndex];
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
			_cheapShotReady = false;
			shouldShowInstructions = true;
			dispatchEvent(new Event(ScoreKeeper.CLEAN_RESET));
		}
		
		public function hit(tryCheapShot:Boolean = false):void
		{
			_hits++;
			_totalHits++;
			
			
			if (_totalHits > _hitsToStopShowingInstructions) shouldShowInstructions = false;
			if (_totalHits == _hitsToRevelCheapShot)
			{
				_cheapShotReady = true;
				dispatchEvent(new Event(ScoreKeeper.SHOW_CHEAP_SHOT));
				//setTimeout(function():void { dispatchEvent(new Event(ScoreKeeper.HIDE_CHEAP_SHOT))}, 4000);
			}
			var reactionToPlay:int;
			if (tryCheapShot && _cheapShotReady)
			{
				_playAltCheapShot = !_playAltCheapShot;
				reactionToPlay = _playAltCheapShot ? _cheapShotIndex2 : _cheapShotIndex;
				_totalHits = _numHitsToFinish;
				dispatchEvent(new ReactionEvent(ReactionEvent.START_REACTION, reactionToPlay));
				trace("--> HIT\t cheap shot reaction = " + reactionToPlay);
			}
			
			if (reactionToPlay != _cheapShotIndex && reactionToPlay != _cheapShotIndex2)
			{
				_reactionHits++;
				if (_reactionHits >= _reactionHitInterval)
				{
					_reactionHits = 0;
					_reactionIsPlaying = true;
					reactionToPlay = _currentReaction;
					if (_currentReaction++ >= _numReactions-1) _currentReaction = 0;
					dispatchEvent(new ReactionEvent(ReactionEvent.START_REACTION, reactionToPlay));
				}
			}
			dispatchEvent(new Event(ScoreKeeper.HITS_UPDATED));
			
			if (_selectionIndex != _introIndex && _totalHits >= _numHitsToFinish)
			{
				dispatchEvent(new Event(ScoreKeeper.GAME_OVER));
				setTimeout(function():void {
					dispatchEvent(new Event(ScoreKeeper.HIDE_CHEAP_SHOT));
				}, 800);
			}
			
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