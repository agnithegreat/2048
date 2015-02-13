/**
 * Created by kirillvirich on 06.02.15.
 */
package com.agnither.game2048.view {
import com.agnither.game2048.model.Cell;
import com.agnither.utils.gui.components.AbstractComponent;
import com.agnither.utils.gui.components.Label;

import starling.animation.Transitions;
import starling.core.Starling;

import view.field.CellViewMC;

public dynamic class CellView extends AbstractComponent {

    private var _cell: Cell;

    private var _container: AbstractComponent;
    private var _label: Label;

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
        createFromFlash(CellViewMC);

        _container = this.container;
        _label = _container.numbers;

        _value = 0;

        _container.visible = false;
    }

    public function appear():void {
        _container.scaleX = 0;
        _container.scaleY = 0;
        update();
        Starling.juggler.tween(_container, 0.3, {scaleX: 1, scaleY: 1, transition: Transitions.EASE_OUT});
    }

    public function update():void {
        if (_cell) {
            value = _cell.value;
            visible = _cell.value>0;
        }
    }

    override public function destroy():void {
        super.destroy();

        _cell = null;

        _container = null;
        _label = null;

        removeFromParent(true);
    }
}
}
