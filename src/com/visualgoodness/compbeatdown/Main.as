package com.visualgoodness.compbeatdown
{
	import com.visualgoodness.compbeatdown.controller.BoxingInputManager;
	import com.visualgoodness.compbeatdown.events.HitEvent;
	import com.visualgoodness.compbeatdown.interfaces.IBag;
	import com.visualgoodness.compbeatdown.interfaces.IInputDelegate;
	import com.visualgoodness.compbeatdown.interfaces.IInstructionsPanelDelegate;
	import com.visualgoodness.compbeatdown.interfaces.IStartMenuDelegate;
	import com.visualgoodness.compbeatdown.model.ScoreKeeper;
	import com.visualgoodness.compbeatdown.view.Gloves;
	import com.visualgoodness.compbeatdown.view.InstructionsPanel;
	import com.visualgoodness.compbeatdown.view.Panel;
	import com.visualgoodness.compbeatdown.view.StartMenu;
	import com.visualgoodness.controller.VGKeyboard;
	
	import flash.display.MovieClip;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	public class Main extends MovieClip implements IInputDelegate, IStartMenuDelegate, IInstructionsPanelDelegate
	{
		private var _bag:IBag;
		private var _gloves:Gloves;
		private var _score:ScoreKeeper;
		private var _panel:Panel;
		private var _inputManager:BoxingInputManager;
		private var _startMenu:StartMenu;
		private var _instructionsPanel:InstructionsPanel;
		private var _currentPunch:int;
		
		public function Main()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_bag = this["bag_mc"] as IBag;
			_instructionsPanel = this["instructions_panel_mc"] as InstructionsPanel;
			_instructionsPanel.delegate = this;
			_gloves = this["gloves_mc"] as Gloves;
			_panel = this["panel_mc"] as Panel;
			_startMenu = this["start_menu_mc"] as StartMenu;
			_startMenu.delegate = this;
			_score = new ScoreKeeper();
			_score.addEventListener(ScoreKeeper.GAME_OVER, gameOver);
			_inputManager = new BoxingInputManager(this, this["mouse_hit_mc"] as MovieClip);
			_panel.scoreKeeper = _score;
			_bag.scoreKeeper = _score;
			_gloves.addEventListener(HitEvent.L_HIT, hit);
			_gloves.addEventListener(HitEvent.R_HIT, hit);
		}
		
		public function playAgain():void
		{
			gotoAndPlay("playAgain");
		}
		
		private function gameOver(e:Event):void
		{
			setTimeout(function():void {
				_instructionsPanel.showIndex(2);
				_instructionsPanel.show();
				gotoAndPlay("gameOver");
			}, _score.gameOverTimeout);
			
			_inputManager.deactivate();
		}
		
		public function start(selectionIndex:int):void
		{
			_score.selectionIndex = selectionIndex;
			gotoAndPlay("startGame");
		}
		
		private function activateInputs():void
		{
			_inputManager.activate();
		}
		
		public function swing(punch:int):void
		{
			_currentPunch = punch;
			_gloves.punch(cheapShot ? Gloves.CHEAP_SHOT : _currentPunch);
		}
		
		private function get cheapShot():Boolean
		{
			return _score.cheapShotReady && _currentPunch == Gloves.LOW;
		}
		
		private function hit(e:HitEvent):void
		{
			_score.hit(cheapShot);
			_bag.hitWithLoc(cheapShot, e.anchor);
		}
	}
}