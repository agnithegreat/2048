/**
 * Created by kirillvirich on 10.02.15.
 */
package com.agnither.game2048.storage {
import starling.textures.Texture;
import starling.textures.TextureAtlas;

public class Resources {

    private static var _resources: TextureAtlas;

    public static function init(resources: TextureAtlas):void {
        _resources = resources;
    }

    public static function getAtlas():Texture {
        return _resources.texture;
    }

    public static function getTexture(name: String):Texture {
        return _resources ? _resources.getTexture(name) : null;
    }
}
}