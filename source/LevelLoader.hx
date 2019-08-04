package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;

import flixel.addons.editors.tiled.TiledLayer;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.tile.FlxTilemap;

class LevelLoader
{
    public static function loadLevel(state:PlayState, level:String)
    {
        var tiledMap = new TiledMap('assets/data/' + level + '.tmx');

        var mainLayer:TiledTileLayer = cast tiledMap.getLayer('main');
        state.map = new FlxTilemap();
        state.map.loadMapFromArray(mainLayer.tileArray, tiledMap.width, tiledMap.height, AssetPaths.tiles__png, 16, 16, 1);

        var bgLayer:TiledTileLayer = cast tiledMap.getLayer('bg');
        var bgMap = new FlxTilemap();
        bgMap.loadMapFromArray(bgLayer.tileArray, tiledMap.width, tiledMap.height, AssetPaths.tiles__png, 16, 16, 1);
        bgMap.solid = false;

        var wallDecorLayer:TiledTileLayer = cast tiledMap.getLayer('wall_decor');
        var decorMap = new FlxTilemap();
        decorMap.loadMapFromArray(wallDecorLayer.tileArray, tiledMap.width, tiledMap.height, AssetPaths.tiles__png, 16, 16, 1);
        decorMap.solid = false;

        // Add BG map before the state.map, or else the background will be drawn over the stage
        state.add(bgMap);
        state.add(state.map);
        state.add(decorMap);

        if (tiledMap.getLayer('player') != null) {
            var playerLayer:TiledObjectLayer = cast tiledMap.getLayer('player');
            var playerPos:TiledObject = playerLayer.objects[0];
            state.player.setPosition(playerPos.x, playerPos.y - 16);
        }
    }
}