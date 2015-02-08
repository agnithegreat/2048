/**
 * Created by kirillvirich on 06.02.15.
 */
package com.agnither.game2048.view {
import com.agnither.game2048.model.Cell;
import com.agnither.game2048.model.Field;

import flash.utils.Dictionary;

import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;

public class FieldView extends Sprite {

    private var _field: Field;

    private var _cellsDict: Dictionary;
    private var _cells: Vector.<CellView>;

    private var _back: Quad;
    private var _container: Sprite;
    private var _phantomContainer: Sprite;

    private var _tweens: Vector.<Tween>;

    private var _gameOver: TextField;

    public function FieldView(field: Field) {
        _field = field;
        _field.addEventListener(Field.FORCE_UPDATE, handleForceUpdate);
        _field.addEventListener(Field.GAME_OVER, handleGameOver);

        _back = new Quad(400, 400, 0xDDC9A0);
        addChild(_back);

        _container = new Sprite();
        addChild(_container);

        _phantomContainer = new Sprite();
        addChild(_phantomContainer);

        _cellsDict = new Dictionary();
        _cells = new <CellView>[];
        for (var i:int = 0; i < _field.cells.length; i++) {
            var cell: Cell = _field.cells[i];
            cell.addEventListener(Cell.FILL, handleFill);
            cell.addEventListener(Cell.MOVE, handleMove);
            var cellView: CellView = new CellView(cell);
            cellView.x = cell.x * 100;
            cellView.y = cell.y * 100;
            _container.addChild(cellView);
            _cells.push(cellView);
            _cellsDict[cell] = cellView;
        }

        _tweens = new <Tween>[];

        _gameOver = new TextField(400, 400, "Game Over", "Verdana", 60, 0xFFFFFF, true);
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
        phantomView.value = target.value;
        _phantomContainer.addChild(phantomView);

        cellView.update();

        var tween: Tween = Starling.juggler.tween(phantomView, 0.2, {x: targetView.x, y: targetView.y, transition: Transitions.EASE_OUT, onComplete: function ():void {
            targetView.update();
            phantomView.destroy();
        }}) as Tween;

        _tweens.push(tween);
    }

    private function handleForceUpdate(e: Event):void {
        while (_tweens.length > 0) {
            var tween:Tween = _tweens.shift();
            tween.advanceTime(tween.totalTime);
        }
    }

    private function handleGameOver(e: Event):void {
        _gameOver.visible = true;
    }

    public function destroy():void {
        for (var i:int = 0; i < _field.cells.length; i++) {
            var cell: Cell = _field.cells[i];
            cell.removeEventListener(Cell.FILL, handleFill);
            cell.removeEventListener(Cell.MOVE, handleMove);
            _cellsDict[cell].destroy();
        }

        _cells = null;
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

        _gameOver.removeFromParent(true);
        _gameOver = null;

        removeFromParent(true);
    }
}
}
