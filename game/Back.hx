class Back {
  public var clouds:Array<Cloud>;

  public function new() {
    var q = new Quad(6.1, 30);
    q.tr(0, -10, -5);
    Faux.back.push({texture: Faux.textures["sky"], quad: q, turn: false});
    clouds = [
      new Cloud(0, -2,   2.3, -3,   .05),
      new Cloud(1,  3.9, 1.5, -3.2, .015),
      new Cloud(2, -3,   0.2, -3.1, .04)
    ];
  }

  public function tick():Void {
    for (c in clouds)
      c.tick();
  }
}

class Cloud {
  public var draw:Draw;
  public var vx:Float;
  public var x:Float;
  public var y:Float;
  public var z:Float;

  public function new(n:Int, x:Float, y:Float, z:Float, vx:Float) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.vx = vx;
    var q = new Quad(3, 1.5);
    q.tr(x, y, z);
    draw = {texture: Faux.textures['cloud$n'], quad: q, turn: false};
    Faux.back.push(draw);
  }

  public function tick():Void {
    x += vx;
    if (x >= 4.5) x = -4.5;
    draw.quad.reset(3, 1.5);
    draw.quad.tr(x, y, z);
  }
}
