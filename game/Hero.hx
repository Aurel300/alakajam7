class Hero {
  var y:Float;
  var angle:Float = 0.0;
  var draw:Draw;
  var phase = 0.0;

  public function new(y:Float, angle:Float) {
    this.y = y;
    this.angle = (angle + Math.PI).normaliseAngle();
    draw = {texture: Faux.textures["princess1"], quad: new Quad(1, 1)};
    Faux.draw.push(draw);
  }

  public function tick():Void {
    phase += angle.angleDist(game.hair.end.angle) * .2 + .01;
    angle = angle.normaliseAngle().lerpAngle(game.hair.end.angle.normaliseAngle(), .95);
    draw.quad.reset(1.1, 1.1);
    draw.quad.rotZ(Math.sin(phase) * .5);
    draw.quad.tr(0, -y, 1.5);
    draw.quad.rotY(angle);
  }
}
