package
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class BagPart extends MovieClip
	{
		public var anchor:MovieClip;
		public var vr:Number = 0;
		
		public function BagPart()
		{
			anchor = this["anchor_mc"] as MovieClip;
		}
		
		public function update():void
		{
			rotation += vr;
		}
		
		public function getPin():Point
		{
			var angle:Number = rotation * Math.PI / 180;
			var xPos:Number = x - Math.sin(angle) * anchor.y;
			var yPos:Number = y + Math.cos(angle) * anchor.y;
			return new Point(xPos, yPos);
		}
	}
}