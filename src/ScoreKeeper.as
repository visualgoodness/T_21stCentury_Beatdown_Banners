package
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.setTimeout;

	public class ScoreKeeper extends EventDispatcher
	{
		public static const HITS_UPDATED:String = "hitsUpdated";
		public static const SHOW_CHEAP_SHOT:String = "showCheapShot";
		public static const HIDE_CHEAP_SHOT:String = "hideCheapShot";
		
		private var _hits:int;
		private var _maxHits:int;
		private var _hitsToRevelCheapShot:int = 5;
		private var _totalHits:int;
		
		public function hit():void
		{
			_hits++;
			_totalHits++;
			if (_totalHits == _hitsToRevelCheapShot)
			{
				dispatchEvent(new Event(ScoreKeeper.SHOW_CHEAP_SHOT));
				setTimeout(function():void { dispatchEvent(new Event(ScoreKeeper.HIDE_CHEAP_SHOT))}, 4000);
			}
			if (_hits > _maxHits) _hits = 0;
			dispatchEvent(new Event(ScoreKeeper.HITS_UPDATED));
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