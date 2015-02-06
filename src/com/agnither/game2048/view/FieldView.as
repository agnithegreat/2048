/**
 * Created by kirillvirich on 06.02.15.
 */
package com.agnither.game2048.view {
import com.agnither.game2048.model.Cell;
import com.agnither.game2048.model.Field;

import flash.utils.Dictionary;

import starling.animation.Transitions;
import starling.core.Starling;
import starling.display.Sprite;
import starling.events.Event;

public class FieldView extends Sprite {

    private var _field: Field;

    private var _cellsDict: Dictionary;
    private var _cells: Vector.<CellView>;

    private var _container: Sprite;
    private var _phantomContainer: Sprite;

    public function FieldView(field: Field) {
        _field = field;

        _container = new Sprite();
        addChild(_container);

        _phantomContainer = new Sprite();
        addChild(_phantomContainer);

        _cellsDict = new Dictionary();
        _cells = new <CellView>[];
        for (var i:int = 0; i < _field.cells.length; i++) {
            var cell: Cell = _field.cells[i];
            cell.addEventListener(Cell.MOVE, handleMove);
            var cellView: CellView = new CellView(cell);
            cellView.x = cell.x * 100;
            cellView.y = cell.y * 100;
            _container.addChild(cellView);
            _cells.push(cellView);
            _cellsDict[cell] = cellView;
        }
    }

    private function handleMove(e: Event):void {
        var cell: Cell = e.currentTarget as Cell;
        var target: Cell = e.data as Cell;

        var cellView: CellView = _cellsDict[cell];
        var targetView: CellView = _cellsDict[target];

        var phantomView: CellView = new CellView(cell);
        phantomView.x = cell.x * 100;
        phantomView.y = cell.y * 100;
        phantomView.value = cellView.value;
        _phantomContainer.addChild(phantomView);

        cellView.update();

        Starling.juggler.tween(phantomView, 0.2, {x: targetView.x, y: targetView.y, transition: Transitions.EASE_OUT, onComplete: function ():void {
            targetView.update();

            _phantomContainer.removeChild(phantomView);
        }});
    }
}
}
