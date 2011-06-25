package com.visualgoodness.compbeatdown.view
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class Glove extends MovieClip
	{
		public var startPos:Point;
		public var targPos:Point;
		public var easing:Number = 10;
		public var hitting:Boolean = false;
		public var gloveBody:MovieClip;
		
		public function Glove()
		{
			gloveBody = this["glove"];
			startPos = new Point(this.x, this.y);
			targPos = new Point(startPos.x, startPos.y);
		}
		
		public function set gloveFrame(value:int):void
		{
			gloveBody.gotoAndStop(value);
		}
		
		public function get gloveFrame():int
		{
			return gloveBody.currentFrame;
		}
		
		public function update():void
		{
			if (hitting) easing = 2;
			else easing = 10;
			
			x += (targPos.x - x) / easing;
			y += (targPos.y - y) / easing;
		}
	}
}