/**
 * Created by kirillvirich on 06.02.15.
 */
package com.agnither.game2048.model {
import com.agnither.game2048.utils.array2d.Array2DCell;

import starling.events.EventDispatcher;

public class Cell extends EventDispatcher {

    public static const FILL: String = "fill_Cell";
    public static const MOVE: String = "move_Cell";

    public static const UPDATE_VALUE: String = "update_value_Cell";

    private var _cell: Array2DCell;
    public function get x():int {
        return _cell.x;
    }
    public function get y():int {
        return _cell.y;
    }
    public function get value():int {
        return _cell.value;
    }

    public function Cell(cell: Array2DCell) {
        _cell = cell;
    }

    private function setValue(value: int):void {
        if (_cell.value != value) {
            _cell.value = value;
            dispatchEventWith(UPDATE_VALUE);
        }
    }

    public function fill(value: int):void {
        setValue(value);

        dispatchEventWith(FILL);
    }

    public function combine(cell: Cell):void {
        var newValue: int = value + cell.value;
        cell.empty();
        setValue(newValue);
        cell.move(this);
    }

    public function move(cell: Cell):void {
        dispatchEventWith(MOVE, false, cell);
    }

    public function empty():void {
        setValue(0);
    }

    public function destroy():void {
        _cell = null;
    }
}
}
