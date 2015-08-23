package objects;

import luxe.Entity;
import luxe.Vector;
import luxe.importers.tiled.TiledObjectGroup;

class PeopleSpawn extends Entity{

  public static var countPeople = 0;
  var spawTime = 80;
  var spawTimer = 80;
  var direction : String;
  var entities : Array<Entity>;

  public function new(object:TiledObject){

    super({
      pos: new Vector(object.pos.x, object.pos.y)
    });

    entities = [];

    direction = object.properties['spawto'];

  }

  override function ondestroy(){
    for( entity in entities ){
      if(entity != null){
        Luxe.scene.remove( entity );
        entity.destroy();
        entity = null;
      }
    }
  }

  override function update(dt:Float){

    if(spawTimer < 0 && countPeople < 10){
      entities.push(new People(pos.x, pos.y, direction));
      spawTimer = spawTime;
      countPeople++;
    }

    spawTimer--;

  }

}