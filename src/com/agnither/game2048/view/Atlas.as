/**
 * Created by kirillvirich on 09.02.15.
 */
package com.agnither.game2048.view {
import com.agnither.utils.gui.atlas.AtlasData;
import com.agnither.utils.gui.atlas.TextureAtlasBuilder;
import com.agnither.utils.gui.font.FontBuilder;
import com.agnither.utils.gui.font.FontData;

import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Shape;
import flash.geom.Matrix;
import flash.geom.Rectangle;

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

    private static function getHiderTexture():BitmapData {
        var shape: Shape = new Shape();
        shape.graphics.beginFill(0, 0.7);
        shape.graphics.drawRect(0, 0, 10, 10);

        var bd: BitmapData = new BitmapData(10, 10, true, 0);
        bd.draw(shape);
        return bd;
    }

    public static function buildAtlas():TextureAtlas {
        var textures: Object = {};
        textures.back = getBackTexture();
        textures.cell = getCellTexture();
        textures.hider = getHiderTexture();

        var numbers: FontData = FontBuilder.buildFontFromChars("1234567890", "Verdana", 26, 0xFFFFFF, true);
        textures.numbers = numbers.texture;

        var gameover: FontData = FontBuilder.buildFontFromChars("Game Over", "Verdana", 60, 0xFFFFFF, true);
        textures.gameover = gameover.texture;

        var atlas: AtlasData = TextureAtlasBuilder.buildTextureAtlas(textures, 2);
        var texture: Texture = Texture.fromBitmapData(atlas.texture, false);
        var xml: XML = TextureAtlasBuilder.getTextureXml(atlas);

        var textureAtlas: TextureAtlas = new TextureAtlas(texture, xml);

        TextField.registerBitmapFont(new BitmapFont(textureAtlas.getTexture("numbers"), numbers.xml), "numbers");
        TextField.registerBitmapFont(new BitmapFont(textureAtlas.getTexture("gameover"), gameover.xml), "gameover");

        numbers.dispose();
        gameover.dispose();
        atlas.dispose();

        return textureAtlas;
    }



    private var _textures: Object = {};

    private var _fonts: Object = {};

    private var _textureAtlas: TextureAtlas;
    public function get created():Boolean {
        return Boolean(_textureAtlas);
    }

    public function getTexture(name: String):Texture {
        return _textureAtlas ? _textureAtlas.getTexture(name) : null;
    }

    public function Atlas() {

    }

    public function addGraphics(name: String, graphics: DisplayObject):void {
        var rect: Rectangle = graphics.getBounds(graphics);

        var bd: BitmapData = new BitmapData(graphics.width, graphics.height);
        bd.draw(graphics, new Matrix(1,0,0,1, -rect.x, -rect.y));

        addBitmapData(name, bd);
    }

    public function addBitmapData(name: String, bitmapData: BitmapData):void {
        _textures[name] = bitmapData;
    }

    public function addFont(name: String, chars: String, font: String, size: int, color: uint, bold: Boolean):void {
        _fonts[name] = [chars, font, size, color, bold];
    }

    public function build():void {
        for (var name: String in _fonts) {
            _fonts[name] = FontBuilder.buildFontFromChars.apply(this, _fonts[name]);
            _textures[name] = font.texture;
        }

        var atlasData: AtlasData = TextureAtlasBuilder.buildTextureAtlas(_textures);
        var texture: Texture = Texture.fromBitmapData(atlasData.texture, false);
        var xml: XML = TextureAtlasBuilder.getTextureXml(atlasData);

        _textureAtlas = new TextureAtlas(texture, xml);

        for (var name: String in _fonts) {
            var font: FontData = _fonts[name];
            texture = getTexture(name);

            TextField.registerBitmapFont(new BitmapFont(texture, font.xml), name);
        }

        disposeTemporaryData();
    }

    private function disposeTemporaryData():void {
        if (_textures) {
            for (var name: String in _textures) {
                var bitmapData: BitmapData = _textures[name];
                if (bitmapData) {
                    bitmapData.dispose();
                }
                delete _textures[name];
            }
            _textures = null;
        }

        if (_fonts) {
            for (name in _fonts) {
                var font: FontData = _fonts[name];
                font.dispose();
                delete _fonts[name];
            }
            _fonts = null;
        }
    }


    public function dispose():void {
        disposeTemporaryData();

        if (_textureAtlas) {
            _textureAtlas.dispose();
            _textureAtlas = null;
        }
    }
}
}
