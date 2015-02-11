/**
 * Created by kirillvirich on 06.02.15.
 */
package com.agnither.game2048.utils.array2d {
public class Array2D {

    public static const DIRECTION_CW: int = 1;
    public static const DIRECTION_CCW: int = -1;

    private var _field: Array;
    private var _rotated: Array;

    public function Array2D() {
        _field = [];
    }

    public function setSize(width: int, height: int):void {
        _field.length = width;
        for (var i:int = 0; i < width; i++) {
            if (!_field[i]) {
                _field[i] = [];
            }
            _field[i].length = height;
            for (var j:int = 0; j < height; j++) {
                if (!_field[i][j]) {
                    _field[i][j] = new Array2DCell(i, j);
                }
            }
        }
    }

    private function getCell(x: int, y: int):Array2DCell {
        try {
            return _field[x][y];
        }
        catch (e: Error) {
            throw new Error("There is no cell with (x="+x+", y="+y+").");
        }
    }

    public function setValue(x: int, y: int, value: int):void {
        getCell(x, y).value = value;
    }

    public function getValue(x: int, y: int):int {
        return getCell(x, y).value;
    }

    public function rotateField(rotation: int, direction: int):void {
        updateRotated(_field);
        for (var i:int = 0; i < rotation; i++) {
            var temp: Array = direction==DIRECTION_CW ? rotateClockwise(_rotated) : rotateCounterClockwise(_rotated);
            updateRotated(temp);
        }
    }

    private function updateRotated(array: Array):void {
        if (_rotated != _field) {
            destroyArray(_rotated);
        }
        _rotated = array;
    }

    public function getRotatedColumn(x: int):Array {
        return _rotated[x];
    }

    public function get field():Array {
        var field: Array = [];
        for (var i:int = 0; i < _field.length; i++) {
            field = field.concat(_field[i]);
        }
        return field;
    }

    private function rotateCounterClockwise(array:Array):Array {
        var transformedArray:Array = new Array();
        var row:int = -1;
        for ( var i:int = array[0].length - 1; i > -1; i-- ) {
            row++;
            transformedArray[row] = new Array();

            for ( var j:int = 0; j < array.length; j++ ) {
                transformedArray[row][j] = array[j][i];
            }
        }
        return transformedArray;
    }
    private function rotateClockwise(array:Array):Array {
        var transformedArray:Array = new Array();
        for ( var i:int = 0; i < array[0].length; i++ ) {
            transformedArray[i] = new Array();

            var transformedArrayColumn:int = -1;
            for ( var j:int = array.length - 1; j > -1; j-- ) {
                transformedArrayColumn++;
                transformedArray[i][transformedArrayColumn] = array[j][i]
            }
        }
        return transformedArray;
    }

    private function destroyArray(array: Array):void {
        if (array) {
            for (var i:int = 0; i < array.length; i++) {
                var row:Array = array[i];
                for (var j:int = 0; j < row.length; j++) {
                    row[i] = null;
                }
                array[i] = null;
            }
        }
    }

    public function destroy():void {
        destroyArray(_rotated);
        _rotated = null;

        destroyArray(_field);
        _field = null;
    }
}
}