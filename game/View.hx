class View {
  public static var safeY:Float = 3.5;

  public static var y:Float;
  public static var backY:Float;
  public static var turn:Float;
  public static var viewBuf:Array<Float> = [ for (i in 0...15) 0.0 ];

  public static function reset():Void {
    y = 0.0;
    backY = 0.0;
    turn = 0.0;
  }
}
