package com.visualgoodness.compbeatdown.events 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class HitEvent extends Event
	{
		public static const HIT_COMPLETE:String = "hitComplete";
		public static const REACTION_COMPLETE:String = "reactionComplete";
		public static const R_HIT:String = "gloveRHit";
		public static const L_HIT:String = "gloveLHit";		
		
		public var anchor:MovieClip;
		
		public function HitEvent(type:String, anchor:MovieClip)
		{
			this.anchor = anchor;
			super(type, true, false);
		}
	}
}