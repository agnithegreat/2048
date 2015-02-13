/**
 * Created by desktop on 11.02.2015.
 */
package com.agnither.game2048.storage {
import com.agnither.utils.gui.font.CharsetUtil;

import view.field.BackGraphics;
import view.field.CellGraphics;
import view.field.HiderGraphics;

public class MockAtlas extends Atlas {

    public function MockAtlas() {
        addGraphics("back", new BackGraphics());
        addGraphics("cell", new CellGraphics());
        addGraphics("hider", new HiderGraphics());

        addFont("numbers", CharsetUtil.getChars("0-9"), "Verdana", 28, 0xFFFFFF, true);
        addFont("gameover", CharsetUtil.getChars("A-Za-z "), "Verdana", 60, 0xFFFFFF, true);

        build();
    }
}
}
