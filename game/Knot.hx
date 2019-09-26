class Knot {
  var stack:Array<Pole> = [];
  var end:Hair.Segment;

  public function new() {
    end = game.hair.end;
  }

  public function tick():Void {
    for (p in game.poles) {
      if (p.active)
        continue;
      if (inRange(p.bump, addRange)) {
        push(p);
        break;
      }
    }
    if (stack.length > 0) {
      var anyInRange = false;
      for (p in stack) {
        if (inRange(p.bump, keepRange))
          anyInRange = true;
      }
      if (!anyInRange) {
        flush();
      } else {
        for (p in stack) {
          var q = quadrant(p.bump);
          if (p.lastQ != q) {
            p.winding += (switch [p.lastQ, q] {
              case [TR, BR]: 1;
              case [TR, TL]: -1;
              case [BR, BL]: 1;
              case [BR, TR]: -1;
              case [BL, TL]: 1;
              case [BL, BR]: -1;
              case [TL, TR]: 1;
              case [TL, BL]: -1;
              case _: 0;
            });
            p.lastQ = q;
          }
        }
      }
    }
  }

  public function flush():Void {
    var mul = 1;
    var lastSign = 0;
    var trick = [];
    for (p in stack) {
      var w = p.winding.abs() + 1;
      if (w >= 4) {
        new Spin(p, p.winding > 0);
        var sign = p.winding > 0 ? 1 : -1;
        var signT = p.winding > 0 ? "CW" : "CCW";
        if (w >= 8)
          trick.push('${w >> 2}x $signT');
        else
          trick.push(signT);
        mul *= (w >> 2);
        if (sign != lastSign) {
          mul *= 2;
          lastSign = sign;
        }
      }
    }
    if (mul != 1) {
      Play.combo(trick.length);
      game.gainScore(20 * mul, trick.join(", "));
    } else
      play("combofail");
    while (stack.length > 0)
      pop();
  }

  function push(pole:Pole):Void {
    if (stack.length > 0)
      stack[stack.length - 1].setTexture(3);
    stack.push(pole);
    pole.active = true;
    pole.initialQ = quadrant(pole.bump);
    pole.lastQ = pole.initialQ;
    pole.winding = 0;
    pole.setTexture(2);
  }

  function pop():Void {
    var pole = stack.pop();
    pole.active = false;
    pole.setTexture(1);
    if (stack.length > 0)
      stack[stack.length - 1].setTexture(2);
  }

  static var keepRange = 1.0;
  static var addRange = 0.45;

  function inRange(bump:Bump, range:Float):Bool {
    var dy = (end.y - bump.y).abs();
    var dx = end.angle.angleDist(bump.angle);
    if (dy > range || dx > range)
      return false;
    var d = Math.sqrt(dy * dy + dx * dx);
    return d <= range;
  }

  function quadrant(bump:Bump):Quadrant {
    var top = (end.y < bump.y);
    var left = end.angle.angleDistSign(bump.angle) < 0;
    return (switch [top, left] {
      case [true, false]: TR;
      case [false, false]: BR;
      case [false, true]: BL;
      case [true, true]: TL;
    });
  }
}

enum Quadrant {
  TR;
  BR;
  BL;
  TL;
}
