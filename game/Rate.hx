class Rate {
  var lastTs:Float = 0.0;
  var cb:Float->Void;

  public function new(cb:Float->Void) {
    this.cb = cb;
    js.Browser.window.requestAnimationFrame(tick1);
  }

  function tick1(ts:Float):Void {
    cb(0.0);
    lastTs = ts;
    js.Browser.window.requestAnimationFrame(tick2);
  }

  function tick2(ts:Float):Void {
    var delta = ts - lastTs;
    if (delta > 40.)
      delta = 40.;
    Stat.ts = delta;
    cb(delta);
    lastTs = ts;
    js.Browser.window.requestAnimationFrame(tick2);
  }
}
