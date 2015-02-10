/**
 * Created by kirillvirich on 29.01.15.
 */
package com.agnither.game2048 {
import com.agnither.game2048.enums.DirectionEnum;
import com.agnither.game2048.model.Field;
import com.agnither.game2048.view.Atlas;
import com.agnither.game2048.view.FieldView;

import flash.ui.Keyboard;

import starling.core.Starling;

import starling.display.Image;

import starling.display.Sprite;
import starling.events.KeyboardEvent;
import starling.text.TextField;
import starling.textures.TextureAtlas;

public class Application extends Sprite implements IStartable {

    private var _field: Field;
    private var _fieldView: FieldView;

    public function start():void {
        var atlas: TextureAtlas = Atlas.buildAtlas();

        var tf1: TextField = new TextField(600, 100, "Game Over", "gameover", -1, 0xFFFFFF);
        tf1.batchable = true;
        addChild(tf1);

        var tf2: TextField = new TextField(600, 100, "Game Over", "Verdana", 60, 0xFFFFFF, true);
        addChild(tf2);
        tf2.visible = false;

        Starling.juggler.repeatCall(function ():void {
            tf1.visible = !tf1.visible;
            tf2.visible = !tf2.visible;
        }, 0.4);

        var atlasView: Image = new Image(atlas.texture);
        atlasView.y = 100;
        addChild(atlasView);
    }

//    public function start():void {
//        _field = new Field();
//        _field.init();
//
//        _fieldView = new FieldView(_field);
//        addChild(_fieldView);
//
//        _field.start();
//
//        stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
//    }

    private function handleKeyDown(e: KeyboardEvent):void {
        switch (e.keyCode) {
            case Keyboard.LEFT:
                _field.move(DirectionEnum.LEFT);
                break;
            case Keyboard.RIGHT:
                _field.move(DirectionEnum.RIGHT);
                break;
            case Keyboard.UP:
                _field.move(DirectionEnum.UP);
                break;
            case Keyboard.DOWN:
                _field.move(DirectionEnum.DOWN);
                break;
            default:
                return;
        }
    }
}
}
