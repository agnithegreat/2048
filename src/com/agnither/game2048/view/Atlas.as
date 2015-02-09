/**
 * Created by kirillvirich on 09.02.15.
 */
package com.agnither.game2048.view {
import com.agnither.utils.gui.atlas.AtlasData;
import com.agnither.utils.gui.atlas.TextureAtlasBuilder;
import com.agnither.utils.gui.font.FontBuilder;
import com.agnither.utils.gui.font.FontData;

import flash.display.BitmapData;
import flash.display.Shape;

import starling.text.BitmapFont;
import starling.text.TextField;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

public class Atlas {

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

    public static function buildAtlas():TextureAtlas {
        var textures: Object = {};
        textures.back = getBackTexture();
        textures.cell = getCellTexture();

        var numbers: FontData = FontBuilder.buildFontFromChars("1234567890", "Verdana", 26, 0xFFFFFF, true);
        textures.numbers = numbers.texture;

        var gameover: FontData = FontBuilder.buildFontFromChars("Game Over", "Verdana", 60, 0xFFFFFF, true);
        textures.gameover = gameover.texture;

        var atlas: AtlasData = TextureAtlasBuilder.buildTextureAtlas(textures, 2);
        var texture: Texture = Texture.fromBitmapData(atlas.texture);
        var xml: XML = TextureAtlasBuilder.getTextureXml(atlas);

        var textureAtlas: TextureAtlas = new TextureAtlas(texture, xml);

        TextField.registerBitmapFont(new BitmapFont(textureAtlas.getTexture("numbers"), numbers.xml), "numbers");
        TextField.registerBitmapFont(new BitmapFont(textureAtlas.getTexture("gameover"), gameover.xml), "gameover");

        return textureAtlas;
    }

}
}
