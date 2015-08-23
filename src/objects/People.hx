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


class People extends Sprite {

    public var body : Body;
    var type : CbType = new CbType();
    public var facing : String;
    public var anim : SpriteAnimation;
    var speed : Int = 100;
    var moving : Bool = false;
    var shotTime : Int = 0;

    public function new (X:Float, Y:Float, Direction:String){

        super({
            size: new Vector(16, 24),
            pos: new Vector(X, Y),
            texture: Luxe.resources.texture('assets/images/people.png'),
            name: 'people',
            name_unique: true,
            depth: 3,
            centered: false
        });

        facing = 'right';

        body = new Body(BodyType.DYNAMIC);
        body.allowRotation = false;

        var core = new Polygon( Polygon.rect(0, 8, 16, 16) );

        core.cbTypes.add(type);
        core.cbTypes.add(Game.peopleType);
        core.filter.collisionGroup = 4;

        body.shapes.add( core );
        body.position.setxy(pos.x, pos.y);

        Luxe.physics.nape.space.listeners.add(new InteractionListener(
            CbEvent.BEGIN, InteractionType.COLLISION,
            type,
            Game.heartType,
            bulletCollides
        ));

        if(Direction == 'left'){
            body.velocity.x = -100;
        } else if(Direction == 'right'){
            body.velocity.x += -100;
        }

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

    function distance(a:Vector, b:Vector) {
        return Math.sqrt(Math.pow( a.x - b.x, 2) + Math.pow( a.y - b.y, 2));
    };

    function angle(a:Vector, b:Vector) {
        var dx:Float = (b.x) - (a.x);
        var dy:Float = (b.y) - (a.y);

        return Math.atan2(dy, dx);
    };



    function bulletCollides(cb:InteractionCallback) {
        Game.score++;
        Game.scoreText.text = Std.string(Game.score);

        //heart
        cb.int2.userData.collide();
        visible = false;
        body.space = null;
        #if !no_debug_console
        Game.drawer.remove(body);
        #end
        PeopleSpawn.countPeople--;
        Luxe.audio.play("hurt");
        destroy();

    }



    override function update(dt:Float) {

        super.update(dt);

        moving = false;

        var dist:Float = distance( pos, Player.position );
        if(dist > 60){
            var a:Float = angle( pos, Player.position );
            body.velocity.x = Math.cos(a) * 60;
            body.velocity.y = Math.sin(a) * 60;
        } else {
            var a:Float = angle( Player.position, pos );
            body.velocity.x = Math.cos(a) * 60;
            body.velocity.y = Math.sin(a) * 60;
        }

        if(dist < 58){
            if(body.velocity.x < 1){
            moving = true;
            flipx = true;
            } else if(body.velocity.x > 1){
                moving = true;
                flipx = false;
            }
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