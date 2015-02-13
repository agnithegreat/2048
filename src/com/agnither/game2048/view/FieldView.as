/**
 * Created by kirillvirich on 06.02.15.
 */
package com.agnither.game2048.view {
import com.agnither.game2048.model.Cell;
import com.agnither.game2048.model.Field;
import com.agnither.utils.gui.components.AbstractComponent;
import com.agnither.utils.gui.components.Label;
import com.agnither.utils.gui.components.Screen;

import flash.utils.Dictionary;

import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.events.Event;

import view.field.FieldViewMC;

public dynamic class FieldView extends Screen {

    private var _field: Field;

    private var _cellsDict: Dictionary;

    private var _container: AbstractComponent;
    private var _phantomContainer: AbstractComponent;
    private var _hider: AbstractComponent;
    private var _gameOver: Label;

    private var _tweens: Vector.<Tween>;

    public function FieldView(field: Field) {
        _field = field;
    }

    override protected function initialize():void {
        createFromFlash(FieldViewMC);

        _field.addEventListener(Field.FORCE_UPDATE, handleForceUpdate);
        _field.addEventListener(Field.GAME_OVER, handleGameOver);

        _container = this.container;
        _phantomContainer = this.phantomContainer;

        _hider = this.hider;
        _hider.visible = false;
        _gameOver = _hider.gameover;
        _gameOver.text = "Game Over";

        _cellsDict = new Dictionary();
        for (var i:int = 0; i < _field.cells.length; i++) {
            var cell: Cell = _field.cells[i];
            cell.addEventListener(Cell.FILL, handleFill);
            cell.addEventListener(Cell.MOVE, handleMove);
            var cellView: CellView = new CellView(cell);
            cellView.x = cell.x * 100;
            cellView.y = cell.y * 100;
            _container.addChild(cellView);
            _cellsDict[cell] = cellView;
        }

        _tweens = new <Tween>[];
    }

    private function handleFill(e: Event):void {
        var cell: Cell = e.currentTarget as Cell;
        var cellView: CellView = _cellsDict[cell];
        cellView.appear();
    }

    private function handleMove(e: Event):void {
        var cell: Cell = e.currentTarget as Cell;
        var target: Cell = e.data as Cell;

        var cellView: CellView = _cellsDict[cell];
        var targetView: CellView = _cellsDict[target];

        var phantomView: CellView = new CellView(cell);
        phantomView.x = cell.x * 100;
        phantomView.y = cell.y * 100;
        _phantomContainer.addChild(phantomView);
        phantomView.value = target.value;

        cellView.update();

        var tween: Tween = Starling.juggler.tween(phantomView, 0.2, {x: targetView.x, y: targetView.y,
                transition: Transitions.EASE_OUT, onComplete: onTweenComplete, onCompleteArgs: [targetView, phantomView]}) as Tween;
        _tweens.push(tween);

        targetView = null;
        phantomView = null;
    }

    private function onTweenComplete(targetView: CellView, phantomView: CellView):void {
        targetView.update();
        phantomView.destroy();
    }

    private function handleForceUpdate(e: Event):void {
        while (_tweens.length > 0) {
            var tween:Tween = _tweens.shift();
            tween.advanceTime(tween.totalTime);
        }
    }

    private function handleGameOver(e: Event):void {
        _hider.visible = true;
        _gameOver.visible = true;
    }

    override public function destroy():void {
        super.destroy();

        for (var cell: Cell in _cellsDict) {
            cell.removeEventListener(Cell.FILL, handleFill);
            cell.removeEventListener(Cell.MOVE, handleMove);
            _cellsDict[cell].destroy();
            delete _cellsDict[cell];
            cell = null;
        }
        _cellsDict = null;

        _field.removeEventListener(Field.FORCE_UPDATE, handleForceUpdate);
        _field.removeEventListener(Field.GAME_OVER, handleGameOver);
        _field = null;

        _container = null;
        _phantomContainer = null;
        _hider = null;
        _gameOver = null;

        removeFromParent(true);
    }
}
}
