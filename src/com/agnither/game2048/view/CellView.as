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
import starling.events.Event;
import starling.text.TextField;
import starling.textures.Texture;

public class CellView extends Sprite {

    private static var cellTexture: Texture = getTexture();
    private static function getTexture():Texture {
        var shape: Shape = new Shape();
        shape.graphics.beginFill(0xCCCCCC);
        shape.graphics.drawRoundRect(10, 10, 80, 80, 20);

        var bd: BitmapData = new BitmapData(100, 100, true, 0);
        bd.draw(shape);
        return Texture.fromBitmapData(bd);
    }

    private var _cell: Cell;

    private var _image: Image;
    private var _value: TextField;

    public function get value():String {
        return _value.text;
    }
    public function set value(text: String):void {
        _value.text = text;
        _value.visible = true;
        _image.visible = false;
    }

    public function CellView(cell: Cell) {
        _cell = cell;
        _cell.addEventListener(Cell.FILL, handleFill);

        _image = new Image(cellTexture);
        addChild(_image);

        _value = new TextField(100, 100, "", "Verdana", 30, 0, true);
        _value.pivotX = _value.width/2;
        _value.pivotY = _value.height/2;
        _value.x = _value.pivotX;
        _value.y = _value.pivotY;
        addChild(_value);
    }

    private function handleFill(e: Event):void {
        _value.scaleX = 0;
        _value.scaleY = 0;
        update();
        Starling.juggler.tween(_value, 0.3, {scaleX: 1, scaleY: 1, transition: Transitions.EASE_OUT});
    }

    public function update():void {
        _value.text = String(_cell.value);
        _value.visible = _cell.value>0;
    }
}
}
