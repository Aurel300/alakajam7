abstract Quad(Array<Float>) from Array<Float> to Array<Float> {
  public inline function new(width:Float, height:Float) {
    this = [
      -width / 2.0, -height / 2.0, 0.0,
       width / 2.0, -height / 2.0, 0.0,
      -width / 2.0,  height / 2.0, 0.0,
       width / 2.0,  height / 2.0, 0.0,
       0.0, 0.0, 1.0
    ];
  }

  public inline function copy():Quad {
    return (this.copy():Quad);
  }

  public inline function sortZ(viewC:Float, viewS:Float):Float {
    return
      this[    0] * -viewS + this[    2] * viewC +
      this[3 + 0] * -viewS + this[3 + 2] * viewC +
      this[6 + 0] * -viewS + this[6 + 2] * viewC +
      this[9 + 0] * -viewS + this[9 + 2] * viewC;
  }

  public function reset(width:Float, height:Float):Void {
    this[0]  = -width / 2.0;
    this[1]  = -height / 2.0;
    this[2]  = 0.0;
    this[3]  =  width / 2.0;
    this[4]  = -height / 2.0;
    this[5]  = 0.0;
    this[6]  = -width / 2.0;
    this[7]  =  height / 2.0;
    this[8]  = 0.0;
    this[9]  =  width / 2.0;
    this[10] =  height / 2.0;
    this[11] = 0.0;
    this[12] = 0.0;
    this[13] = 0.0;
    this[14] = 1.0;
  }

  public function rotY(angle:Float):Void {
    var s = Math.sin(angle);
    var c = Math.cos(angle);
    for (i in 0...5) {
      var x = this[i * 3 + 0];
      var z = this[i * 3 + 2];
      this[i * 3 + 0] = x * c + z * s;
      this[i * 3 + 2] = x * -s + z * c;
    }
  }

  public function rotZ(angle:Float):Void {
    var s = Math.sin(angle);
    var c = Math.cos(angle);
    for (i in 0...5) {
      var x = this[i * 3 + 0];
      var y = this[i * 3 + 1];
      this[i * 3 + 0] = x * c + y * -s;
      this[i * 3 + 1] = x * s + y * c;
    }
  }

  public function tr(x:Float, y:Float, z:Float):Void {
    for (i in 0...4) {
      this[i * 3 + 0] += x;
      this[i * 3 + 1] += y;
      this[i * 3 + 2] += z;
    }
  }

  public function view(viewC:Float, viewS:Float):Array<Float> {
    for (i in 0...4) {
      View.viewBuf[i * 3 + 0] = this[i * 3 + 0] * viewC + this[i * 3 + 2] * viewS;
      View.viewBuf[i * 3 + 1] = this[i * 3 + 1] + View.y;
      View.viewBuf[i * 3 + 2] = this[i * 3 + 0] * -viewS + this[i * 3 + 2] * viewC;
    }
    View.viewBuf[12 + 0] = this[12 + 0] * viewC + this[12 + 2] * viewS;
    View.viewBuf[12 + 1] = this[12 + 1];
    View.viewBuf[12 + 2] = this[12 + 0] * -viewS + this[12 + 2] * viewC;
    return View.viewBuf;
  }
}
