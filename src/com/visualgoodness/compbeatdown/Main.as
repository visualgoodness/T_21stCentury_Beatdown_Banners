package com.visualgoodness.compbeatdown
{
	import com.visualgoodness.controller.VGKeyboard;
	
	import flash.display.MovieClip;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import com.visualgoodness.compbeatdown.events.HitEvent;
	import com.visualgoodness.compbeatdown.interfaces.IInputDelegate;
	import com.visualgoodness.compbeatdown.interfaces.IInstructionsPanelDelegate;
	import com.visualgoodness.compbeatdown.interfaces.IStartMenuDelegate;
	import com.visualgoodness.compbeatdown.controller.BoxingInputManager;
	import com.visualgoodness.compbeatdown.view.Gloves;
	import com.visualgoodness.compbeatdown.interfaces.IBag;
	import com.visualgoodness.compbeatdown.view.InstructionsPanel;
	import com.visualgoodness.compbeatdown.view.Panel;
	import com.visualgoodness.compbeatdown.model.ScoreKeeper;
	import com.visualgoodness.compbeatdown.view.StartMenu;
	
	public class Main extends MovieClip implements IInputDelegate, IStartMenuDelegate, IInstructionsPanelDelegate
	{
		private var _bag:IBag;
		private var _gloves:Gloves;
		private var _score:ScoreKeeper;
		private var _panel:Panel;
		private var _inputManager:BoxingInputManager;
		private var _startMenu:StartMenu;
		private var _instructionsPanel:InstructionsPanel;
		
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
			_instructionsPanel.showIndex(2);
			_instructionsPanel.show();
			_inputManager.deactivate();
			gotoAndPlay("gameOver");
		}
		
		public function start(selectionIndex:int):void
		{
			_score.selectionIndex = selectionIndex;
			trace("Main :: _score.selectionIndex = " + _score.selectionIndex);
			gotoAndPlay("startGame");
		}
		
		private function activateInputs():void
		{
			_inputManager.activate();
		}
		
		public function swing(punch:int):void
		{
			_gloves.punch(punch);
		}
		
		private function hit(e:HitEvent):void
		{
			_score.hit();
			if (e.type == HitEvent.R_HIT)
			{
				//_bag.hit(VGKeyboard.RIGHT);
				_bag.hitWithLoc(Gloves.JAB_R, e.anchor);
			}
			else if (e.type == HitEvent.L_HIT)
			{
				//_bag.hit(VGKeyboard.LEFT);
				_bag.hitWithLoc(Gloves.JAB_L, e.anchor);
			}
		}
	}
}