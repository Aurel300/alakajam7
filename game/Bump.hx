@:structInit
class Bump {
  public var y:Float;
  public var angle:Float;
  public var radius:Float;

  public var collide:Bool = false;

  public function check(hair:Hair.Segment):Void {
    var dy = hair.y - y;
    var dx = hair.angle.angleDistSign(angle);
    if (dy.abs() <= radius && dx.abs() <= radius) {
      var d = Math.sqrt(dx * dx + dy * dy);
      if (d <= radius) {
        if (collide) {
          hair.y += radius * dy / d - dy;
          hair.angle += radius * dx / d - dx;
          hair.support++;
        }
      }
    }
  }
}

class Pole {
  var bump:Bump;
  var draw:Draw;

  public function new(y:Float, angle:Float) {
    bump = {y: y, angle: angle, radius: 0.25, collide: true};
    game.phys.push(bump);
    var q = new Quad(0.1, 0.1);
    q.tr(0, -y, 1.45);
    q.rotY(angle);
    draw = {texture: Faux.textures["test"], quad: q};
    Faux.draw.push(draw);
  }
}
