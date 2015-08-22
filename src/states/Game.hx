package states;

import luxe.States;
import luxe.Input;
import luxe.Vector;
import luxe.Color;
import luxe.Sprite;

import luxe.Input;
import luxe.tilemaps.Tilemap;
import luxe.importers.tiled.TiledMap;

class Game extends State {

    var tilemap : TiledMap;
    var scale : Int = 1;

    public function new() {

        super({ name:'game' });

    } //new

    override function onenter<T>(_:T) {

        Luxe.renderer.clear_color = new Color().rgb(0x21313e);

        var res = Luxe.resources.text('assets/maps/map-0.tmx');
        tilemap = new TiledMap({ tiled_file_data:res.asset.text, pos : new Vector(0,0) });
        tilemap.display({ visible: true, scale:1, grid:false, depth: 1 });

        connect_input();

    } //onenter


    function connect_input() {

        Luxe.input.bind_key('left', Key.left);
        Luxe.input.bind_key('left', Key.key_a);

        Luxe.input.bind_key('right', Key.right);
        Luxe.input.bind_key('right', Key.key_d);

        Luxe.input.bind_key('up', Key.key_w);
        Luxe.input.bind_key('up', Key.up);

        Luxe.input.bind_key('down', Key.key_s);
        Luxe.input.bind_key('down', Key.down);

        Luxe.input.bind_key('action', Key.key_z);
        Luxe.input.bind_key('action', Key.space);

    } //connect_input



    override function onleave<T>(_:T) {

    } //onleave

    override function update( dt:Float ) {

        Luxe.camera.pos = Luxe.camera.pos.int();

    } //update

}