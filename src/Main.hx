
import luxe.Input;
import luxe.Parcel;
import luxe.ParcelProgress;
import luxe.States;
import luxe.Color;
import phoenix.Texture;
import phoenix.Camera;

import nape.geom.Vec2;

import states.Game;

class Main extends luxe.Game {

    public static var state: States;

    override function config(config:luxe.AppConfig) {

        return config;

    } //config

    override function ready() {

         var parcel = new Parcel({
            fonts: [
                { id:'assets/fonts/SEN.fnt' },
            ],
            texts:[
                { id: 'assets/map-0.tmx' }
            ],
            jsons:[
                { id: 'assets/jsons/player_animation.json'},
                { id: 'assets/jsons/heart_animation.json'}
            ],
            textures : [
                { id:'assets/tiles.png'},
                { id:'assets/images/player.png'},
                { id:'assets/images/heart.png'},
                { id:'assets/images/people.png'}
            ],
            sounds : [
                {
                    id : 'assets/sounds/shot.ogg',
                    name : 'shot',
                    is_stream : false
                },
                {
                    id : 'assets/sounds/hurt.ogg',
                    name : 'hurt',
                    is_stream : false
                }
            ]
        });

        new ParcelProgress({
            parcel      : parcel,
            background  : new Color(1,1,1,0.85),
            oncomplete  : onLoaded
        });

        phoenix.Texture.default_filter = FilterType.nearest;

        state = new States({ name:'state' });

        parcel.load();

    } //ready

    function onLoaded(_){

        Luxe.physics.nape.space.gravity = new Vec2(0, 0);

        state.add( new Game() );

        Main.state.set('game');

    } //onLoaded

    override function onkeyup( e:KeyEvent ) {

        if(e.keycode == Key.escape) {
            Luxe.shutdown();
        }

    } //onkeyup

    override function update(dt:Float) {

        Luxe.camera.pos = Luxe.camera.pos.int();

    } //update


} //Main
