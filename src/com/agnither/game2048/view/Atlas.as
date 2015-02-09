/**
 * Created by kirillvirich on 09.02.15.
 */
package com.agnither.game2048.view {
import com.agnither.utils.gui.atlas.AtlasBuilder;
import com.agnither.utils.gui.atlas.AtlasData;

import flash.display.BitmapData;
import flash.display.Shape;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

import starling.textures.Texture;
import starling.textures.TextureAtlas;

public class Atlas {

    private static function getBackTexture():BitmapData {
        var shape: Shape = new Shape();
        shape.graphics.beginFill(0xDDC9A0);
        shape.graphics.drawRect(0, 0, 400, 400);

        var bd: BitmapData = new BitmapData(400, 400, true, 0);
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

    private static function getTextTexture(value: String, size: int, width: int, height: int):BitmapData {
        var tf: TextField = new TextField();
        tf.autoSize = TextFieldAutoSize.LEFT;
        tf.defaultTextFormat = new TextFormat("Verdana", size, 0xFFFFFF, true, null, null, null, null, TextFormatAlign.CENTER);
        tf.text = value;

        var bd: BitmapData = new BitmapData(width, height, true, 0);
        bd.draw(tf, new Matrix(1,0,0,1, (width-tf.width)/2, (height-tf.height)/2));
        return bd;
    }

    public static function buildAtlas():TextureAtlas {
        var textures: Object = {};
        textures.back = getBackTexture();
        textures.cell = getCellTexture();
        for (var i:int = 1; i < 21; i++) {
            var value: int = Math.pow(2, i);
            textures[value] = getTextTexture(String(value), 26, 100, 100);
        }
        textures.gameover = getTextTexture("Game Over", 60, 400, 400);

        var atlas: AtlasData = AtlasBuilder.buildAtlas("atlas", textures, true);
        var texture: Texture = Texture.fromBitmapData(atlas.texture);
        var xml: XML = AtlasBuilder.getTextureXml(atlas);

        var textureAtlas: TextureAtlas = new TextureAtlas(texture, xml);
        return textureAtlas;
    }

}
}
