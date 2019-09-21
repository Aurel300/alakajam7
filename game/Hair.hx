class Hair {
  public static var gravity:Float = 0.025;

  public var end:Segment;

  public function new():Void {
    var segments = [for (i in 0...15) new Segment(i * 0.1, -Math.PI * .5)]; // i * 0.2) ];
    for (i in 0...15) {
      if (i > 0)
        segments[i].prev = segments[i - 1];
      if (i < 15 - 1)
        segments[i].next = segments[i + 1];
    }
    end = segments[segments.length - 1];
  }

  public function tick():Void {
    var cur = end;
    var dist = 0;
    while (cur != null) {
      cur.endDist = dist++;
      cur.tick();
      if (cur.prev == null && cur.next != null && cur.y < View.y - 2.5)
        cur.remove();
      cur = cur.prev;
    }
    Stat.hair = dist;
  }
}

class Segment {
  public var draw:Draw;
  public var y:Float;
  public var angle:Float;
  public var prev:Segment;
  public var next:Segment;
  public var roll:Float = 0.0;
  public var endDist:Int = 0;
  public var support:Int = 0;

  public function new(y:Float, angle:Float):Void {
    this.y = y;
    this.angle = angle;
    draw = {texture: Faux.textures['hair${Dice.mod(3)}'], quad: new Quad(0, 0)};
    Faux.draw.push(draw);
  }

  public function remove():Void {
    if (prev != null && next != null) {
      prev.next = next;
      next.prev = prev;
    } else {
      if (prev != null)
        prev.next = null;
      if (next != null)
        next.prev = null;
    }
    draw.keep = false;
  }

  public function tick():Void {
    if (Dice.float(1.0) < .02)
      draw.texture = Faux.textures['hair${Dice.mod(3)}'];
    for (p in game.phys)
      p.check(this);
    if (prev != null && next != null) {
      var dx1 = angle - prev.angle;
      var dy1 = y - prev.y;
      var dx2 = angle - next.angle;
      var dy2 = y - next.y;
      var avgAngle = (prev.angle + next.angle) * .5;
      var avgY = (prev.y + next.y) * .5;
      var totalDist = dx1.abs() + dy1.abs() + dx2.abs() + dy2.abs();
      var adx = next.angle - prev.angle;
      var ady = next.y - prev.y;
      var splitDist = Math.sqrt(adx * adx + ady * ady);
      var anglePrev = Math.atan2(dy1, dx1);
      var angleNext = Math.atan2(dy2, dx2);
      angleNext -= Math.PI;
      roll = roll.lerpAngle(-(anglePrev.lerpAngle(angleNext, .5)), .4);
      var lerpRate = .5 - .45 * totalDist;
      lerpRate += support * .2;
      if (lerpRate < .05)
        lerpRate = .05;
      else if (lerpRate > .95)
        lerpRate = .95;
      var grav = 1 - endDist / 40;
      if (grav < 0)
        grav = 0;
      y = y.lerp(avgY + Hair.gravity * grav, lerpRate);
      angle = angle.lerp(avgAngle, lerpRate);
      if (splitDist < 0.18)
        remove();
      else if (splitDist > 0.22) {
        var mid = new Segment(avgY, avgAngle);
        mid.endDist = endDist;
        mid.roll = prev.roll;
        prev.next = mid;
        mid.prev = prev;
        prev = mid;
        mid.next = this;
      }
      /*} else if (next != null) {
        var dx2 = angle - next.angle;
        var dy2 = y - next.y;
        var angleNext = Math.atan2(dy2, dx2);
        angleNext -= Math.PI;
        if (angleNext < -Math.PI) angleNext += Math.PI * 2;
        roll = roll.lerpAngle(-angleNext, .4); */
    } else if (prev != null) {
      var dx1 = angle - prev.angle;
      var dy1 = y - prev.y;
      var anglePrev = Math.atan2(dy1, dx1);
      roll = roll.lerpAngle(-anglePrev, .4);
    }
    draw.quad.reset(.3, .5);
    draw.quad.rotZ(roll);
    draw.quad.tr(0, -y, 1.4);
    draw.quad.rotY(angle);
    support = 0;
  }
}
