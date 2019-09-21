class Calc {
  public static inline function lerp(x:Float, y:Float, ratio:Float):Float {
    return x * ratio + y * (1 - ratio);
  }

  public static function lerpAngle(x:Float, y:Float, ratio:Float):Float {
    if ((x - y).abs() >= Math.PI) {
      if (x > y)
        x -= Math.PI * 2;
      else
        y -= Math.PI * 2;
    }
    return normaliseAngle(lerp(x, y, ratio));
  }

  public static function angleDist(x:Float, y:Float):Float {
    x = normaliseAngle(x);
    y = normaliseAngle(y);
    if ((x - y).abs() >= Math.PI) {
      if (x > y)
        x -= Math.PI * 2;
      else
        y -= Math.PI * 2;
    }
    return (x - y).abs();
  }

  public static function angleDistSign(x:Float, y:Float):Float {
    x = normaliseAngle(x);
    y = normaliseAngle(y);
    if ((x - y).abs() >= Math.PI) {
      if (x > y)
        x -= Math.PI * 2;
      else
        y -= Math.PI * 2;
    }
    return x - y;
  }

  public static function sign(x:Float):Float {
    return x < 0 ? -1 : 1;
  }

  public static function normaliseAngle(x:Float):Float {
    return (x + Math.PI) % (Math.PI * 2) - Math.PI;
  }

  public static function negmod(amount:Float, neg:Bool, pos:Bool):Float {
    return neg != pos ? (neg ? -amount : amount) : 0;
  }

  public static inline function abs(x:Float):Float {
    return x < 0 ? -x : x;
  }
}
