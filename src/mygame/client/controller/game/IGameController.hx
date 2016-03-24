package mygame.client.controller.game;

import legion.entity.Player;
import mygame.game.action.IAction;

import mygame.client.model.Model;

interface IGameController {
	
	public function action_add( oAction :IAction ) :Void;
	
	public function model_get() :Model;
}