package
{
	import flash.events.Event;
	
	public class ReactionEvent extends Event
	{
		public static const REACTION_COMPLETE:String = "reactionComplete";
		public static const START_REACTION:String = "startReaction";
		
		public var index:int;
		
		public function ReactionEvent(type:String, index:int)
		{
			this.index = index;
			super(type);
		}
	}
}