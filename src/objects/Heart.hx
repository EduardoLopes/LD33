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

    public var facing : String;
    public var anim : SpriteAnimation;
    var speed : Int = 100;
    var moving : Bool = false;
    var type : CbType = new CbType();
    var direction : String;

    public function new (x:Float, y:Float, Direction:String){

        super({
            size: new Vector(14, 17),
            pos: new Vector(x, y),
            texture: Luxe.resources.texture('assets/images/heart.png'),
            name: 'heart',
            name_unique: true,
            depth: 3,
            centered: false
        });

        direction = Direction;

        var collidableWith = [Game.tilemapType];

        body = new Body(BodyType.DYNAMIC);
        body.allowRotation = false;
        body.isBullet = true;

        var core = new Polygon( Polygon.rect(0, 1, 14, 15) );
        core.filter.collisionGroup = 2;
        core.filter.collisionMask = ~(1|2);
        core.cbTypes.add(type);

        body.shapes.add( core );

        if(direction == 'left'){
            flipx = false;
            pos.y += 8;
            body.position.setxy(pos.x, pos.y);
        }

        if(direction == 'right'){
            flipx = true;
            pos.x += 4;
            pos.y += 8;
            body.position.setxy(pos.x, pos.y);
        }

        Luxe.physics.nape.space.listeners.add(new InteractionListener(
            CbEvent.BEGIN, InteractionType.COLLISION,
            type,
            collidableWith,
            bulletCollides
        ));

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

    function bulletCollides(cb:InteractionCallback) {

        anim.animation = 'collide';
        anim.play();

        #if !no_debug_console
        Game.drawer.remove(body);
        #end

    }

    override function update(dt:Float) {

        super.update(dt);

        if(!anim.playing && anim.animation == 'collide'){
            body.space = null;
            destroy();
            visible = false;
        }

        /*body.velocity.x *= 0.8;
        body.velocity.y *= 0.8;*/
        if(direction == 'left'){
            body.velocity.x -= 20;
        } else if(direction == 'right'){
            body.velocity.x += 20;
        }


        pos.x = body.position.x;
        pos.y = body.position.y;

        pos = pos.int();


    }

}