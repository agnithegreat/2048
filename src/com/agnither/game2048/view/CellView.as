/**
 * Created by kirillvirich on 06.02.15.
 */
package com.agnither.game2048.view {
import com.agnither.game2048.model.Cell;
import com.agnither.game2048.storage.Resources;
import com.agnither.utils.gui.components.AbstractComponent;
import com.utils.MemoryTracker;

import starling.animation.Transitions;
import starling.core.Starling;
import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;

public class CellView extends AbstractComponent {

    private var _cell: Cell;

    private var _container: Sprite;
    private var _image: Image;
    private var _label: TextField;

    private var _value: int;
    public function get value():int {
        return _value;
    }
    public function set value(val: int):void {
        _value = val;

        if (_value) {
            _label.text = String(_value);
        }
        _container.visible = true;
    }

    public function CellView(cell: Cell) {
        _cell = cell;
    }

    override protected function initialize():void {
        _container = new Sprite();
        addChild(_container);

        _image = new Image(Resources.getTexture("cell"));
        _container.addChild(_image);

        _value = 0;

        _label = new TextField(100, 100, "", "numbers", -1, 0xFFFFFF);
        _label.batchable = true;
        _container.addChild(_label);

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

    override public function destroy():void {
        _image.removeFromParent(true);
        _image = null;

        _label.removeChildren(0, 0, true);
        _label.removeFromParent(true);
        _label = null;

        _container.removeFromParent(true);
        _container = null;

        _cell = null;

        removeFromParent(true);

        super.destroy();
    }
}
}
