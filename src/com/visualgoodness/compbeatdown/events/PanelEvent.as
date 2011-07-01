package com.visualgoodness.compbeatdown.events
{
	import flash.events.Event;
	import flash.geom.Point;
	
	public class PanelEvent extends Event
	{
		public static var PANEL_HIDDEN:String = "panelHidden";
		public static var SHOW_PANEL:String = "showPanel";
		public static var HIDE_PANEL:String = "hidePanel";
		public static var BALL_THROWN:String = "ballThrown";
		public static var BALL_GRABBED:String = "ballGrabbed";
		public static var ANIMATION_COMPLETE:String = "animationComplete";
		public static var HIDE_BASKET:String = "hideBasket";
		public static var SFX_BALLOON_STRETCH:String = "sfxBalloonStretch";
		public static var SHOW_BASKET:String = "showBasket";
		public static var USER_INACTION:String = "userInaction";
		public static var TOO_MANY_MISSES:String = "tooManyMisses";
		public static var CONTROLS_HAVE_SHOWN_ONCE:String = "controlsHaveShownOnce";
		public static var CONTROLS_SHOWN:String = "controlsShown";
		
		public var index:int;
		public var loc:Point;
		
		public function PanelEvent(type:String, index:int = -1, loc:Point = null)
		{
			this.loc = loc;
			this.index = index;
			super(type);
		}
	}
}