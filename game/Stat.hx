class Stat {
  public static var hair:Int = 0;
  public static var triangles:Int = 0;
  public static var renderCalls:Int = 0;
  public static var ts:Float = 0;

  public static function show():Void {
    js.Browser.document.querySelector("#stats").innerText = 'hair: $hair, triangles: $triangles, renderCalls: $renderCalls, ts: $ts';
  }
}
