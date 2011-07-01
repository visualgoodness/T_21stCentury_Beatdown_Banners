package com.visualgoodness.compbeatdown
{
	import com.visualgoodness.compbeatdown.controller.BoxingInputManager;
	import com.visualgoodness.compbeatdown.events.HitEvent;
	import com.visualgoodness.compbeatdown.events.PanelEvent;
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
		public static const INSTRUCTION_DISPLAY_DURATION:int = 8000;
		
		private var _bag:IBag;
		private var _gloves:Gloves;
		private var _score:ScoreKeeper;
		private var _panel:Panel;
		private var _inputManager:BoxingInputManager;
		private var _startMenu:StartMenu;
		private var _instructionsPanel:InstructionsPanel;
		private var _currentPunch:int;
		private var _shouldHideInstructions:Boolean = false;
		
		public function Main()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_bag = this["bag_mc"] as IBag;
			_instructionsPanel = this["instructions_panel_mc"] as InstructionsPanel;
			_instructionsPanel.delegate = this;
			_instructionsPanel["panel_body_mc"].addEventListener(PanelEvent.CONTROLS_SHOWN, controlsShown);
			_instructionsPanel["panel_body_mc"].addEventListener(PanelEvent.CONTROLS_HAVE_SHOWN_ONCE, controlsHaveShownOnce);
			_gloves = this["gloves_mc"] as Gloves;
			_panel = this["panel_mc"] as Panel;
			_startMenu = this["start_menu_mc"] as StartMenu;
			_startMenu.delegate = this;
			addEventListener(StartMenu.START_MENU_WILL_SHOW, _startMenu.willShow);
			_score = new ScoreKeeper();
			_score.addEventListener(ScoreKeeper.GAME_OVER, gameOver);
			_score.addEventListener(ScoreKeeper.SHOW_CHEAP_SHOT, showCheapShotInstrPanel);
			_score.addEventListener(ScoreKeeper.HIDE_CHEAP_SHOT, hideCheapShotInstrPanel);
			_inputManager = new BoxingInputManager(this, this["mouse_hit_mc"] as MovieClip);
			_panel.scoreKeeper = _score;
			_bag.scoreKeeper = _score;
			_gloves.addEventListener(HitEvent.L_HIT, hit);
			_gloves.addEventListener(HitEvent.R_HIT, hit);
		}
		
		private function showCheapShotInstrPanel(e:Event):void
		{
			_instructionsPanel.show(InstructionsPanel.CHEAP_SHOT);
		}
		
		private function hideCheapShotInstrPanel(e:Event):void
		{
			_instructionsPanel.hide();
		}
		
		private function controlsShown(e:PanelEvent):void
		{
			_instructionsPanel["panel_body_mc"].removeEventListener(PanelEvent.CONTROLS_SHOWN, controlsShown);
			activateInputs();
		}
		
		private function controlsHaveShownOnce(e:PanelEvent):void
		{
			_shouldHideInstructions = true;
		}
		
		public function userIsIdle():void
		{
			if (_instructionsPanel.state != InstructionsPanel.CHEAP_SHOT &&
				_score.shouldShowInstructions)
			{
				_instructionsPanel.show(InstructionsPanel.CONTROLS);
				setTimeout(function():void {
					_inputManager.idleNotificationComplete();
					hideInstructions();
				}, Main.INSTRUCTION_DISPLAY_DURATION);
			}
		}
		
		private function hideInstructions():void
		{
			if (_instructionsPanel.state != InstructionsPanel.CHEAP_SHOT)
				_instructionsPanel.hide();
		}
		
		public function playAgain():void
		{
			gotoAndPlay("playAgain");
		}
		
		private function gameOver(e:Event):void
		{
			setTimeout(function():void {
				_instructionsPanel.show(InstructionsPanel.PLAY_AGAIN);
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
			if (_shouldHideInstructions) hideInstructions();
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