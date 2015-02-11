/**
 * Created by kirillvirich on 29.01.15.
 */
package com.agnither.game2048 {
import com.agnither.game2048.enums.DirectionEnum;
import com.agnither.game2048.model.Field;
import com.agnither.game2048.storage.MockAtlas;
import com.agnither.game2048.storage.Resources;
import com.agnither.game2048.view.FieldView;
import com.utils.MemoryTracker;

import flash.ui.Keyboard;

import starling.display.Sprite;
import starling.events.KeyboardEvent;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class Application extends Sprite implements IStartable {

    private var _field: Field;
    private var _fieldView: FieldView;

    public function start():void {
        Resources.init(new MockAtlas());

        newGame();

        stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);

        stage.addEventListener(TouchEvent.TOUCH, handleTouch);
    }

    private function newGame():void {
        _field = new Field();
        _field.init();

        _fieldView = new FieldView(_field);
        addChild(_fieldView);

        _field.start();
    }

    private function endGame():void {
        _fieldView.destroy();
        _fieldView = null;

        _field.destroy();
        _field = null;
    }

    private function restartGame():void {
        endGame();
        newGame();
    }

    private function handleKeyDown(e: KeyboardEvent):void {
        MemoryTracker.logTracking();

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

    private function handleTouch(e: TouchEvent):void {
        var touch: Touch = e.getTouch(stage, TouchPhase.BEGAN);
        if (touch && _field && _field.isGameOver) {
            restartGame();
        }
    }
}
}
