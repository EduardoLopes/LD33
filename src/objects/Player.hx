package objects;

import luxe.Sprite;
import luxe.Vector;
import luxe.components.sprite.SpriteAnimation;

import nape.phys.Body;
import nape.shape.Polygon;
import nape.phys.BodyType;
import nape.phys.Material;
import nape.callbacks.CbEvent;
import nape.callbacks.CbType;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;

import luxe.importers.tiled.TiledObjectGroup;
import luxe.structural.Pool;
import states.Game;
import objects.Heart;


class Player extends Sprite {

    public var body : Body;
    public static var type : CbType = new CbType();
    public var facing : String;
    public var anim : SpriteAnimation;
    var speed : Int = 100;
    var moving : Bool = false;
    var shotTime : Int = 0;

    public function new (object:TiledObject){

        super({
            size: new Vector(16, 24),
            pos: new Vector(object.pos.x, object.pos.y),
            texture: Luxe.resources.texture('assets/images/player.png'),
            name: object.name,
            depth: 3,
            centered: false
        });

        facing = 'left';

        body = new Body(BodyType.DYNAMIC);
        body.allowRotation = false;

        var core = new Polygon( Polygon.rect(0, 8, 16, 16) );

        core.cbTypes.add(type);
        core.filter.collisionGroup = 1;
        core.filter.collisionMask = ~2;

        body.shapes.add( core );
        body.position.setxy(pos.x, pos.y);

        var anim_object = Luxe.resources.json('assets/jsons/player_animation.json');
        anim = add( new SpriteAnimation({ name:'anim' }) );
        anim.add_from_json_object( anim_object.asset.json );
        anim.animation = 'walk';
        anim.play();

        body.space = Luxe.physics.nape.space;
        #if !no_debug_console
        Game.drawer.add(body);
        #end
    }

    override function update(dt:Float) {

        super.update(dt);

        moving = false;

        if(Luxe.input.inputdown('left')) {
            body.velocity.x = -speed;
            moving = true;
            if(!Luxe.input.inputdown('action')){
                flipx = true;
                facing = 'left';
            }

        } else if(Luxe.input.inputdown('right')) {
            body.velocity.x = speed;
            moving = true;
            if(!Luxe.input.inputdown('action')){
            flipx = false;
            facing = 'right';
            }

        }

        if(Luxe.input.inputdown('up')) {
            body.velocity.y = -speed;
            moving = true;
        } else if(Luxe.input.inputdown('down')) {
            body.velocity.y = speed;
            moving = true;
        }

        if(Luxe.input.inputdown('action') && shotTime > 20) {

            new Heart(pos.x, pos.y, facing);
            shotTime = 0;

        }

        if(moving) {

            if(anim.animation != 'walk') {
                anim.animation = 'walk';
            }

            if(anim.playing == false){
                anim.play();
            }

        } else {

            if(anim.animation != 'idle') {
                anim.animation = 'idle';
            }

            if(anim.playing == false){
                anim.play();
            }

        }

        shotTime++;

        body.velocity.x *= 0.8;
        body.velocity.y *= 0.8;

        pos.x = body.position.x;
        pos.y = body.position.y;

        pos = pos.int();

    }

}