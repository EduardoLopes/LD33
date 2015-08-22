
import luxe.Input;
import luxe.Parcel;
import luxe.ParcelProgress;
import luxe.States;
import luxe.Color;
import phoenix.Texture;
import phoenix.Camera;

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
            textures : [
                { id:'assets/tiles.png'}
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

        state.add( new Game() );

        Main.state.set('game');

    } //onLoaded

    override function onkeyup( e:KeyEvent ) {

        if(e.keycode == Key.escape) {
            Luxe.shutdown();
        }

    } //onkeyup

    override function update(dt:Float) {

    } //update


} //Main
