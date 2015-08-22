package states;

import luxe.States;
import luxe.Input;
import luxe.Vector;
import luxe.Color;
import luxe.Sprite;
import luxe.Input;
import luxe.Entity;
import luxe.tilemaps.Tilemap;
import luxe.importers.tiled.TiledMap;

import nape.phys.Body;
import nape.phys.BodyType;
import nape.callbacks.CbType;
import nape.shape.Polygon;

#if !no_debug_console
import luxe.physics.nape.DebugDraw;
#end

import objects.Player;

class Game extends State {

    #if !no_debug_console
    public static var drawer : DebugDraw;
    #end
    var tilemap : TiledMap;
    var tilemapBody : Body;
    public static var tilemapType : CbType;
    var scale : Int = 1;
    var entities:Array<Entity>;

    public function new() {

        super({ name:'game' });

    } //new

    override function onenter<T>(_:T) {

        Luxe.renderer.clear_color = new Color().rgb(0x21313e);

        #if !no_debug_console
            drawer = new DebugDraw({
                depth: 100
            });
            Luxe.physics.nape.debugdraw = drawer;
        #end

        entities = [];

        tilemapType = new CbType();
        tilemapBody = new Body(BodyType.STATIC);
        tilemapBody.cbTypes.add(tilemapType);

        var res = Luxe.resources.text('assets/map-0.tmx');
        tilemap = new TiledMap({
            tiled_file_data : res.asset.text,
            pos : new Vector(0,0)
        });

        tilemap.display({ visible: true, scale:1, grid:false, depth: 1 });

        var bounds = tilemap.layer('collision').bounds_fitted();
        for(bound in bounds) {
            bound.x *= tilemap.tile_width * scale;
            bound.y *= tilemap.tile_height * scale;
            bound.w *= tilemap.tile_width * scale;
            bound.h *= tilemap.tile_height * scale;
            var shape = new Polygon( Polygon.rect(bound.x, bound.y, bound.w, bound.h) );
            shape.filter.collisionGroup = 4;
            //shape.filter.collisionMask = ~(1|2);
            tilemapBody.shapes.add( shape );
        }

        tilemapBody.space = Luxe.physics.nape.space;

        for(objectsLayer in tilemap.tiledmap_data.object_groups){
            for(object in objectsLayer.objects){

                entities.push(
                    Type.createInstance( Type.resolveClass( 'objects.'+object.type ), [object])
                );

            }
        }


        #if !no_debug_console
            Game.drawer.add(tilemapBody);
            Luxe.physics.nape.draw = false;
        #end

        connect_input();

    } //onenter

    override function onkeyup(e:KeyEvent) {
        if(e.keycode == Key.key_0) {
            Luxe.physics.nape.draw = !Luxe.physics.nape.draw;
            trace(Luxe.physics.nape.draw);
        }
    }

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