/**
 * Created by kirillvirich on 06.02.15.
 */
package com.agnither.game2048.view {
import com.agnither.game2048.model.Cell;

import flash.display.BitmapData;
import flash.display.Shape;

import starling.animation.Transitions;
import starling.core.Starling;
import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.textures.Texture;

public class CellView extends Sprite {

    private static var cellTexture: Texture = getTexture();
    private static function getTexture():Texture {
        var shape: Shape = new Shape();
        shape.graphics.beginFill(0xe2b120);
        shape.graphics.drawRoundRect(10, 10, 80, 80, 30);

        var bd: BitmapData = new BitmapData(100, 100, true, 0);
        bd.draw(shape);
        return Texture.fromBitmapData(bd);
    }

    private var _cell: Cell;

    private var _container: Sprite;
    private var _image: Image;
    private var _value: TextField;

    public function get value():int {
        return int(_value.text);
    }
    public function set value(text: int):void {
        _value.text = String(text);
        _container.visible = true;
    }

    public function CellView(cell: Cell) {
        _cell = cell;

        _container = new Sprite();
        addChild(_container);

        _image = new Image(cellTexture);
        _container.addChild(_image);

        _value = new TextField(100, 100, "", "Verdana", 26, 0xFFFFFF, true);
        _container.addChild(_value);

        _container.pivotX = _container.width/2;
        _container.pivotY = _container.height/2;
        _container.x = _container.pivotX;
        _container.y = _container.pivotY;
        _container.visible = false;
    }

    public function appear():void {
        _container.scaleX = 0;
        _container.scaleY = 0;
        update();
        Starling.juggler.tween(_container, 0.3, {scaleX: 1, scaleY: 1, transition: Transitions.EASE_OUT});
    }

    public function update():void {
        value = _cell.value;
        _container.visible = _cell.value>0;
    }

    public function destroy():void {
        _image.removeFromParent(true);
        _image = null;

        _value.removeFromParent(true);
        _value = null;

        _container.removeFromParent(true);
        _container = null;

        _cell = null;

        removeFromParent(true);
    }
}
}
