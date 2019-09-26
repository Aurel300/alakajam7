@:structInit
class Bump {
  public var y:Float;
  public var angle:Float;
  public var radius:Float;

  public var collide:Bool = false;

  public function check(hair:Hair.Segment):Void {
    var dy = hair.y - y;
    var dx = hair.angle.angleDistSign(angle); // * 1.5;
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
