class Spin {
  static var spins:Array<Spin> = [];
  public static var stars:Array<Star> = [];
  static var deltaMax = 800.;

  public static function tick(delta:Float):Void {
    for (s in spins)
      s.tickI(delta);
    for (s in stars)
      s.tick(delta);
  }

  var y:Float;
  var angle:Float;
  var draw:Draw;
  var phase:Float = 0.0;
  var cw:Bool;

  public function new(pole:Pole, cw:Bool) {
    y = pole.bump.y;
    angle = pole.bump.angle;
    this.cw = cw;
    draw = {texture: Faux.textures['spin${cw ? 0 : 1}'], quad: new Quad(1, 1)};
    Faux.draw.push(draw);
    spins.push(this);
    for (i in 0...10) new Star(pole);
  }

  public function tickI(delta:Float):Void {
    var size = .7 + (phase / deltaMax) * .2;
    draw.quad.reset(size, size);
    draw.quad.rotZ((phase / deltaMax + Math.pow(phase / deltaMax, 2) * 1.3) * (cw ? -1 : 1));
    draw.quad.tr(0, -y, 1.5 + (phase / deltaMax) * 0.2);
    draw.quad.rotY(angle);
    draw.alpha = 1 - (phase / deltaMax);

    phase += delta;
    if (phase >= deltaMax) {
      draw.keep = false;
      spins.remove(this);
    }
  }
}

class Star {
  var y:Float;
  var angle:Float;
  var draw:Draw;
  var phase:Float = 0.0;
  var kind:Int;
  var rollV:Float;
  var yV:Float;
  var angleV:Float;
  var deltaMax:Float;
  var inAlpha:Float;

  public function new(pole:Pole) {
    y = pole.bump.y + Dice.bifloat(0.15);
    yV = -.04 + Dice.bifloat(0.06);
    angle = pole.bump.angle + Dice.bifloat(0.15);
    angleV = Dice.bifloat(0.035);
    draw = {texture: Faux.textures['star${Dice.mod(4)}'], quad: new Quad(1, 1)};
    rollV = Dice.bifloat(3);
    deltaMax = 600. + Dice.float(200);
    inAlpha = .5 + Dice.float(.5);
    Faux.draw.push(draw);
    Spin.stars.push(this);
  }

  public function tick(delta:Float):Void {
    y += yV;
    yV += 0.002;
    angle += angleV;

    var size = .5 - (phase / deltaMax) * .2;
    draw.quad.reset(size, size);
    draw.quad.rotZ((phase / deltaMax) * rollV);
    draw.quad.tr(0, -y, 1.5 + (phase / deltaMax) * 0.2);
    draw.quad.rotY(angle);
    draw.alpha = (1 - (phase / deltaMax)) * inAlpha;

    phase += delta;
    if (phase >= deltaMax) {
      draw.keep = false;
      Spin.stars.remove(this);
    }
  }
}
