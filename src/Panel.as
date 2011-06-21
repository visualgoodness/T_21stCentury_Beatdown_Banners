package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Panel extends MovieClip
	{
		private var _numberStrip:MovieClip;
		private var _rowHeight:Number;
		private var _row:int;
		private var _numberStripStartY:Number;
		private var _scoreKeeper:ScoreKeeper;
		private var _numSlots:int;
		private var _cheapShotPanel:MovieClip;
		
		public function Panel()
		{
			_numberStrip = this["panel_top"]["text_group_mc"]["number_strip_mc"] as MovieClip;
			_numberStripStartY = _numberStrip.y;
			_rowHeight = MovieClip(_numberStrip["row_height_mc"]).height;
			_cheapShotPanel = this["panel_sm_mc"] as MovieClip;
			_cheapShotPanel.visible = false;
		}
		
		public function set scoreKeeper(value:ScoreKeeper):void
		{
			_scoreKeeper = value;
			_scoreKeeper.addEventListener(ScoreKeeper.HITS_UPDATED, scoreUpdated);
			_scoreKeeper.addEventListener(ScoreKeeper.HIDE_CHEAP_SHOT, hideCheapShot);
			_scoreKeeper.addEventListener(ScoreKeeper.SHOW_CHEAP_SHOT, showCheapShot);
			_scoreKeeper.maxHits = _numberStrip.height / _rowHeight;
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
		
		private function scoreUpdated(e:Event):void
		{
			_numberStrip.y = _numberStripStartY - (_scoreKeeper.hits * _rowHeight);
		}
	}
}