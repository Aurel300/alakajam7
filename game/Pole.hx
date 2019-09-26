class Pole {
  public var active:Bool = false;
  public var initialQ:Knot.Quadrant = TR;
  public var lastQ:Knot.Quadrant = TR;
  public var winding:Int;
  public var bump:Bump;
  public var draw1:Draw;
  public var draw2:Draw;

  public function new(y:Float, angle:Float) {
    bump = {y: y, angle: angle, radius: 0.3, collide: true};
    game.phys.push(bump);
    game.poles.push(this);
    var q = new Quad(0.9, 0.9);
    q.tr(0, -y, 1.45);
    q.rotY(angle);
    Faux.draw.push(draw1 = {texture: Faux.textures["pole1"], quad: q});
    var q = new Quad(0.95, 0.95);
    q.tr(0, -y, 1.35);
    q.rotY(angle);
    Faux.draw.push(draw2 = {texture: Faux.textures["pole1"], quad: q});
  }

  public function setTexture(n:Int):Void {
    if (draw1 == null)
      return;
    draw1.texture = Faux.textures['pole$n'];
  }

  public function tick():Void {
    if (bump.y < View.y - View.safeY) {
      draw1.keep = false;
      draw1 = null;
      draw2.keep = false;
      draw2 = null;
    }
  }
}
