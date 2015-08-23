package objects;

import luxe.Entity;
import luxe.Vector;
import luxe.importers.tiled.TiledObjectGroup;

class PeopleSpawn extends Entity{

  public static var countPeople = 0;
  var spawTime = 80;
  var spawTimer = 80;
  var direction : String;

  public function new(object:TiledObject){

    super({
      pos: new Vector(object.pos.x, object.pos.y)
    });

    direction = object.properties['spawto'];

  }

  override function ondestroy(){

    countPeople = 0;

  }

  override function update(dt:Float){

    if(spawTimer < 0 && countPeople < 10){
      new People(pos.x, pos.y, direction);
      spawTimer = spawTime;
      countPeople++;
    }

    spawTimer--;

  }

}