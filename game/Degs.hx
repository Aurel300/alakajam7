abstract Degs(Float) to Float {
  @:from public static inline function fromDegrees(x:Float):Degs {
    return new Degs((x / 180) * Math.PI);
  }

  inline function new(rads:Float) {
    this = rads;
  }
}
