class Veza {
  public var layers:Array<Layer> = [];
  public var curHeight:Float = -7.4;
  public var count:Int = 0;
  public var endY:Float = 10000000.;

  public static var limit:Int = 374;

  public function new() {
    for (i in 0...21) {
      var layer = new Layer(0.3 + (i / 20) * .7, 10 + i, 0.6, curHeight, "brick", 0.45);
      count++;
      curHeight += 0.4;
      layers.push(layer);
    }
    curHeight -= 0.45;
    var q = new Quad(.7, .7);
    q.tr(0, curHeight - .6, 1.15);
    q.rotY((-90:Degs));
    Faux.draw.push({texture: Faux.textures["princess0"], quad: q});
  }

  public function tick():Void {
    View.turn = View.turn.lerp(game.hair.end.angle +  Math.PI * .5, .9);
    var needMore = true;
    for (l in layers) {
      if (l.y > View.y + View.safeY + 1)
        needMore = false;
      if (!l.shown && l.y <= View.y + View.safeY)
        l.show();
    }
    if (needMore)
      push();
    while (layers.length > 0 && layers[0].y < View.y - View.safeY)
      shift();
  }

  public function push():Void {
    if (count == limit) {
      var q = new Quad(9, 9);
      q.rotX((-90:Degs));
      endY = curHeight;
      q.tr(0, -curHeight, 0);
      Faux.draw.push({texture: Faux.textures["floor"], quad: q});
      count++;
    }
    if (count > limit)
      return;
    var layer = new Layer(1.2, count % 15 == 5 ? 30 : 15, 0.3, curHeight, "brick");
    if (Rune.spawn.exists(count)) {
      for (pos in Rune.spawn[count]) {
        new Pole(curHeight + 0.15, pos);
      }
    }
    count++;
    Stat.floors = count;
    curHeight += 0.3;
    layers.push(layer);
  }

  public inline function shift():Void {
    layers.shift().remove();
  }
}

class Layer {
  public var bricks:Array<Draw> = [];
  public final y:Float;
  public var shown:Bool = false;

  public function new(radius:Float, count:Int, height:Float, y:Float, tex:String, ?brickWidth:Float):Void {
    this.y = y;
    var reg = brickWidth == null;
    if (reg)
      radius -= Dice.float(.04);
    if (brickWidth == null)
      brickWidth = 2 * (radius + 0.02) * Math.tan(Math.PI / count);
    var offset = reg ? Dice.float(Math.PI * 2) : 0;
    var xOffset = reg ? Dice.bifloat(0.02) : 0;
    var zOffset = reg ? Dice.bifloat(0.02) : 0;
    bricks = [ for (i in 0...count) {
      if (Dice.float(1.0) < 0.02)
        continue;
      for (out in 0...2) {
        var quad = new Quad(brickWidth, height);
        quad.tr(xOffset, -y, radius - (out * .05) + zOffset);
        quad.rotY((i / count) * (Math.PI * 2) + offset);
        if (reg) {
          var num = out;
          if (out == 0 && Dice.float(1) < 0.05)
            num = 2 + Dice.mod(2);
          else
            num = Dice.float(1) < .9 ? 0 : 4;
          {texture: Faux.textures['$tex$num'], quad: quad, show: false};
        } else {
          {texture: Faux.textures["roof"], quad: quad, show: true};
        }
      }
    } ];
    for (b in bricks)
      Faux.draw.push(b);
  }

  public function remove():Void {
    for (b in bricks)
      b.keep = false;
  }

  public function show():Void {
    shown = true;
    for (b in bricks)
      b.show = true;
  }
}
