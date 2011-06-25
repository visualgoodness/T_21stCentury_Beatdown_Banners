package com.visualgoodness.compbeatdown.view
{
	import com.greensock.TweenNano;
	import com.greensock.easing.Sine;
	import com.visualgoodness.compbeatdown.events.ReactionEvent;
	import com.visualgoodness.compbeatdown.interfaces.IBag;
	import com.visualgoodness.compbeatdown.model.ScoreKeeper;
	import com.visualgoodness.controller.VGKeyboard;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class Bag2 extends MovieClip implements IBag
	{
		private var _hitOverlays:Array = [];
		private var _bagBody:MovieClip;
		
		public var shakeDist:Number 				= 0;
		private var _shakeAngle:Number 				= 0;
		private var _startX:Number 					= 0;
		private var _shakeSpeed:Number 				= 2.5;
		private var _shakeSpread:Number 			= 30;
		private var _defaultShakeDuration:Number	= 0.5;
		private var _longShakeDuration:Number		= 1.5;
		private var _scoreKeeper:ScoreKeeper;
		
		public function Bag2()
		{
			_bagBody = this["bag_body_mc"] as MovieClip;
			_startX = x;
		}
		
		public function set scoreKeeper(value:ScoreKeeper):void
		{
			_scoreKeeper = value;
			_scoreKeeper.addEventListener(ReactionEvent.START_REACTION, playReaction);
			addEventListener(ReactionEvent.REACTION_COMPLETE, reactionComplete);
		}
		
		private function playReaction(e:ReactionEvent):void
		{
			trace("reaction_"+e.index);
			gotoAndPlay("reaction_"+e.index);
		}
		
		private function reactionComplete(e:Event):void
		{
			_scoreKeeper.reactionComplete();
		}
		
		public function hitWithLoc(cheapShot:Boolean, anchor:MovieClip):void
		{
			var h:HitOverlay = new HitOverlay();
			_bagBody.addChild(h);
			var p:Point = anchor.localToGlobal(new Point(anchor.x, anchor.y));
			var q:Point = _bagBody.globalToLocal(p);
			var loc:Number = ((q.x / _bagBody.widthMarker.width) - 0.5) * 1.5;
			loc = loc > 1 ? 1 : loc < -1 ? -1 : loc;
			h.scaleX = 1 - Math.abs(loc);
			h.x = q.x;
			h.y = q.y;
			h.body.rotation = loc * (15 + Math.random() * 30);
			TweenNano.to(h, 1.8, { alpha:0, delay:0.8, onComplete:removeHitOverlay});
			function removeHitOverlay():void {
				_bagBody.removeChild(h);
			}
			_hitOverlays.push(h);
			shake(cheapShot ? _longShakeDuration : _defaultShakeDuration);
		}
		
		private function shake(duration:Number = 0.5):void
		{
			shakeDist = _shakeSpread;
			TweenNano.killTweensOf(this);
			TweenNano.to(this, duration, { shakeDist:0, ease:Sine.easeOut, onUpdate:animateShake });
			function animateShake():void {
				_shakeAngle += _shakeSpeed;
				x += ((_startX + (Math.cos(_shakeAngle) * shakeDist) - x) / 5);
			}
		}
		
		public function hit(key:int):void {}
	}
}