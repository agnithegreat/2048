/**
 * Created by kirillvirich on 06.02.15.
 */
package com.agnither.game2048.view {
import com.agnither.game2048.model.Cell;
import com.agnither.game2048.model.Field;
import com.agnither.game2048.storage.Resources;
import com.agnither.utils.gui.components.Screen;

import flash.utils.Dictionary;

import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;

public class FieldView extends Screen {

    private var _field: Field;

    private var _cellsDict: Dictionary;

    private var _back: Image;
    private var _container: Sprite;
    private var _phantomContainer: Sprite;

    private var _tweens: Vector.<Tween>;

    private var _hider: Image;
    private var _gameOver: TextField;

    public function FieldView(field: Field) {
        _field = field;
    }

    override protected function initialize():void {
        _field.addEventListener(Field.FORCE_UPDATE, handleForceUpdate);
        _field.addEventListener(Field.GAME_OVER, handleGameOver);

        _back = new Image(Resources.getTexture("back"));
        _back.width = 400;
        _back.height = 400;
        addChild(_back);

        _container = new Sprite();
        addChild(_container);

        _phantomContainer = new Sprite();
        addChild(_phantomContainer);

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

        _hider = new Image(Resources.getTexture("hider"));
        _hider.width = 400;
        _hider.height = 400;
        _hider.visible = false;
        addChild(_hider);

        _gameOver = new TextField(400, 400, "Game Over", "gameover", -1, 0xFFFFFF);
        _gameOver.batchable = true;
        _gameOver.visible = false;
        addChild(_gameOver);
    }

    private function handleFill(e: Event):void {
        var cell: Cell = e.currentTarget as Cell;
        _cellsDict[cell].appear();
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
        for (var cell: Cell in _cellsDict) {
            cell.removeEventListener(Cell.FILL, handleFill);
            cell.removeEventListener(Cell.MOVE, handleMove);
            _cellsDict[cell].destroy();
            delete _cellsDict[cell];
            cell = null;
        }
        _cellsDict = null;

        _back.removeFromParent(true);
        _back = null;

        _container.removeFromParent(true);
        _container = null;

        _phantomContainer.removeFromParent(true);
        _phantomContainer = null;

        _field.removeEventListener(Field.FORCE_UPDATE, handleForceUpdate);
        _field.removeEventListener(Field.GAME_OVER, handleGameOver);
        _field = null;

        _hider.removeFromParent(true);
        _hider = null;

        _gameOver.removeFromParent(true);
        _gameOver = null;

        removeFromParent(true);

        super.destroy();
    }
}
}
