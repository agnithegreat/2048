/**
 * Created by kirillvirich on 06.02.15.
 */
package com.agnither.game2048.model {
import com.agnither.game2048.enums.DirectionEnum;
import com.agnither.game2048.utils.array2d.Array2D;

import flash.utils.Dictionary;

import starling.events.Event;

public class Field {

    private static var base: int = 2;
    private static var size: int = 4;

    private var _cellsDict: Dictionary;
    private var _cells: Vector.<Cell>;
    public function get cells():Vector.<Cell> {
        return _cells;
    }

    private var _empty: Vector.<Cell>;

    private var _field: Array2D;

    public function Field() {
    }

    public function init():void {
        _cellsDict = new Dictionary();
        _cells = new <Cell>[];
        _empty = new <Cell>[];

        _field = new Array2D();
        _field.setSize(size, size);

        var field: Array = _field.field;
        for (var i:int = 0; i < field.length; i++) {
            var cell: Cell = new Cell(field[i]);
            cell.addEventListener(Cell.UPDATE_VALUE, handleUpdateValue);
            _cellsDict[field[i]] = cell;
            _cells.push(cell);
            _empty.push(cell);
        }
    }

    public function move(direction: DirectionEnum):void {
        switch (direction) {
            case DirectionEnum.UP:
                _field.rotateField(0, Array2D.DIRECTION_CW);
                break;
            case DirectionEnum.DOWN:
                _field.rotateField(2, Array2D.DIRECTION_CW);
                break;
            case DirectionEnum.LEFT:
                _field.rotateField(1, Array2D.DIRECTION_CCW);
                break;
            case DirectionEnum.RIGHT:
                _field.rotateField(1, Array2D.DIRECTION_CW);
                break;
        }

        var moved: Boolean = false;

        for (var i:int = 0; i < size; i++) {
            var column: Array = _field.getRotatedColumn(i);
            for (var j:int = 0; j < column.length-1; j++) {
                var current: Cell = _cellsDict[column[j]];

                var next: Cell = null;
                var count: int = j+1;
                while (!next && count < column.length) {
                    var nextStep: Cell = _cellsDict[column[count]];
                    if (nextStep.value) {
                        next = nextStep;
                    } else {
                        count++;
                    }
                }

                if (next) {
                    if (!current.value || current.value == next.value) {
                        if (!current.value) {
                            j--;
                        }

                        current.combine(next);
                        moved = true;
                    }
                }
            }
        }

        if (moved) {
            newStep();
        }
    }

    public function newStep():void {
        if (_empty.length > 0) {
            var rand: int = _empty.length * Math.random();
            var cell: Cell = _empty[rand];
            cell.fill(base);
        } else {
            throw new Error("Game Over!");
        }
    }

    private function handleUpdateValue(e: Event):void {
        var cell: Cell = e.currentTarget as Cell;
        if (cell.value) {
            var index: int = _empty.indexOf(cell);
            if (index>=0) {
                _empty.splice(index, 1);
            }
        } else {
            _empty.push(cell);
        }
    }
}
}
