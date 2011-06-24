package com.visualgoodness.compbeatdown.view
{
	import com.visualgoodness.controller.VGKeyboard;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import com.visualgoodness.compbeatdown.model.ScoreKeeper;
	
	public class Bag extends MovieClip
	{
		private var _parts:Array 			= [];
		private var _point:Point 			= new Point();
		private var _angle:Number 			= 0;
		private var _dist:Number 			= 0;
		private var _speed:Number 			= 0.2;
		private var _targDist:Number		= 0;
		private var _hitTarget:BagPart;
		
		public function Bag()
		{
			for(var i:uint = 0; i < numChildren; i++)
			{
				_parts.push(getChildAt(i) as BagPart);
			}
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		public function set scoreKeeper(value:ScoreKeeper):void {}
			
		public function hitWithLoc(key:int, anchor:MovieClip):void {}
		
		public function hit(key:int):void
		{
			if (_hitTarget == null) _hitTarget = _parts[0] as BagPart;
			var direction:Number = 0;
			if (key == VGKeyboard.LEFT) direction = -1;
			else direction = 1;
			_hitTarget.vr += 6 * direction;
			var p:BagPart = _parts[0] as BagPart;
			_parts[0].vr += 4 * direction;
		}
		
		private function update(e:Event):void
		{
			var i:uint = 0;
			var p:BagPart;
			
			for(i = 0; i < _parts.length; i++)
			{
				p = _parts[i] as BagPart;
				
				var spring:Number = 0.4;
				var dr:Number = 0 - p.rotation;
				var ar:Number = dr * spring;
				p.vr += ar;
				p.update();
			}
			
			for(i = 0; i < _parts.length; i++)
			{
				p = _parts[i] as BagPart;
				p.rotation *= 0.8;
				if (i == 0)
				{
					//p.x = Math.sin(_angle) * _dist;
					//_targDist += (_dist - _targDist) / 40;
					//p.rotation = Math.cos(_angle) * _targDist;
				}
				else
				{
					var p0:BagPart = _parts[i-1] as BagPart;
					p.x = p0.getPin().x;
					p.y = p0.getPin().y;
					p.rotation += (p0.rotation - p.rotation) / 10;
				}
			}
			//_dist *= 0.9;
			//_speed *= 0.95;
		}
	}
}