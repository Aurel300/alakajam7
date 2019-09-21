class Dice {
  public static inline function float(f:Float):Float {
    return Math.random() * f;
  }

  public static inline function mod(n:Int):Int {
    return Math.floor(Math.random() * n);
  }

  public static inline function bifloat(f:Float):Float {
    return Math.random() * (2 * f) - f;
  }

  public static function bool():Bool {
    return Math.random() < .5;
  }
}
