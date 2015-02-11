/**
 * Created by desktop on 11.02.2015.
 */
package com.agnither.game2048.storage {
import flash.display.BitmapData;
import flash.display.Shape;

public class MockAtlas extends Atlas {

    public function MockAtlas() {
        addBitmapData("back", getBackTexture());
        addBitmapData("cell", getCellTexture());
        addBitmapData("hider", getHiderTexture());

        addFont("numbers", "1234567890", "Verdana", 26, 0xFFFFFF, true);
        addFont("gameover", "Game Over", "Verdana", 60, 0xFFFFFF, true);

        build();
    }

    private static function getBackTexture():BitmapData {
        var shape: Shape = new Shape();
        shape.graphics.beginFill(0xDDC9A0);
        shape.graphics.drawRect(0, 0, 10, 10);

        var bd: BitmapData = new BitmapData(10, 10, true, 0);
        bd.draw(shape);
        return bd;
    }

    private static function getCellTexture():BitmapData {
        var shape: Shape = new Shape();
        shape.graphics.beginFill(0xE2B120);
        shape.graphics.drawRoundRect(10, 10, 80, 80, 30);

        var bd: BitmapData = new BitmapData(100, 100, true, 0);
        bd.draw(shape);
        return bd;
    }

    private static function getHiderTexture():BitmapData {
        var shape: Shape = new Shape();
        shape.graphics.beginFill(0, 0.7);
        shape.graphics.drawRect(0, 0, 10, 10);

        var bd: BitmapData = new BitmapData(10, 10, true, 0);
        bd.draw(shape);
        return bd;
    }
}
}
