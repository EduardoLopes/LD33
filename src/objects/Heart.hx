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

import states.Game;

class Heart extends Sprite {

    public var body : Body;
    public static var type : CbType = new CbType();
    public var facing : String;
    public var anim : SpriteAnimation;
    var speed : Int = 100;
    var moving : Bool = false;

    public function new (x:Float, y:Float){

        super({
            size: new Vector(15, 12),
            pos: new Vector(x, y),
            texture: Luxe.resources.texture('assets/images/heart.png'),
            name: 'heart',
            name_unique: true,
            depth: 3,
            centered: false
        });

        body = new Body(BodyType.DYNAMIC);
        body.allowRotation = false;
        body.isBullet = true;

        var core = new Polygon( Polygon.rect(0, 0, 15, 12) );
        core.filter.collisionGroup = 2;
        core.filter.collisionMask = ~(1|2);
        core.cbTypes.add(type);

        body.shapes.add( core );
        body.position.setxy(pos.x, pos.y);

        var anim_object = Luxe.resources.json('assets/jsons/heart_animation.json');
        anim = add( new SpriteAnimation({ name:'anim' }) );
        anim.add_from_json_object( anim_object.asset.json );
        anim.animation = 'idle';
        anim.play();

        body.space = Luxe.physics.nape.space;
        #if !no_debug_console
        Game.drawer.add(body);
        #end
    }

    override function update(dt:Float) {

        super.update(dt);

        /*body.velocity.x *= 0.8;
        body.velocity.y *= 0.8;*/

        body.velocity.x -= 20;

        pos.x = body.position.x;
        pos.y = body.position.y;

        pos = pos.int();

    }

}