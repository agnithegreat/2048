/**
 * Created by kirillvirich on 29.01.15.
 */
package com.agnither.game2048 {
import com.agnither.game2048.enums.DirectionEnum;
import com.agnither.game2048.model.Field;
import com.agnither.game2048.storage.Resources;
import com.agnither.game2048.view.Atlas;
import com.agnither.game2048.view.FieldView;

import flash.ui.Keyboard;

import starling.display.Sprite;
import starling.events.KeyboardEvent;

public class Application extends Sprite implements IStartable {

    private var _field: Field;
    private var _fieldView: FieldView;

    public function start():void {
        Resources.init(Atlas.buildAtlas());

        _field = new Field();
        _field.init();

        _fieldView = new FieldView(_field);
        addChild(_fieldView);

        _field.start();

        stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
    }

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
