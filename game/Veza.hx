class Veza {
  public var layers:Array<Layer> = [];
  public var curHeight:Float = 0.0;

  public function new() {
    push();
  }

  public function tick():Void {
    View.turn = View.turn.lerp(game.hair.end.angle +  Math.PI * .5, .9);
    var needMore = true;
    for (l in layers) {
      if (l.y > View.y + 3.5)
        needMore = false;
      if (!l.shown && l.y <= View.y + 2.5)
        l.show();
    }
    if (needMore)
      push();
    while (layers.length > 0 && layers[0].y < View.y - 2.5)
      shift();
  }

  public function push():Void {
    var layer = new Layer(1.2, 15, 0.3, curHeight, "brick");
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

  public function new(radius:Float, count:Int, height:Float, y:Float, tex:String):Void {
    this.y = y;
    radius -= Dice.float(.04);
    var brickWidth = 2 * (radius + 0.07) * Math.tan(Math.PI / count);
    var offset = Dice.float(Math.PI * 2);
    var xOffset = Dice.bifloat(0.02);
    var zOffset = Dice.bifloat(0.02);
    bricks = [ for (i in 0...count) {
      if (Dice.float(1.0) < 0.02)
        continue;
      for (out in 0...2) {
        var quad = new Quad(brickWidth, height);
        quad.tr(xOffset, -y, radius - (out * .05) + zOffset);
        quad.rotY((i / count) * (Math.PI * 2) + offset);
        var num = out;
        if (out == 0 && Dice.float(1) < 0.05)
          num = 2 + Dice.mod(2);
        else
          num = Dice.float(1) < .9 ? 0 : 4;
        {texture: Faux.textures['$tex$num'], quad: quad, show: false};
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
