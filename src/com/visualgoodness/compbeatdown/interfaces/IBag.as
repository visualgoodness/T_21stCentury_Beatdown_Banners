package com.visualgoodness.compbeatdown.interfaces
{
	import flash.display.MovieClip;
	import flash.events.IEventDispatcher;
	import com.visualgoodness.compbeatdown.model.ScoreKeeper;
	
	public interface IBag extends IEventDispatcher
	{
		function hit(key:int):void;
		function hitWithLoc(key:int, anchor:MovieClip):void;
		function set scoreKeeper(value:ScoreKeeper):void;
	}
}