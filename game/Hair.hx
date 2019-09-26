class Hair {
  public static var gravity:Float = 0.025;

  public var end:Segment;

  public function new():Void {
    var segments = [for (i in 0...10) new Segment(i * 0.1, -Math.PI * .5, i == 0)]; // i * 0.2) ];
    for (i in 0...segments.length) {
      if (i > 0)
        segments[i].prev = segments[i - 1];
      if (i < segments.length - 1)
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
      if (cur.prev == null && cur.next != null && cur.y < View.y - View.safeY)
        cur.remove();
      cur = cur.prev;
    }
    Stat.hair = dist;
  }
}

class Segment {
  public var draw:Draw;
  //public var draw2:Draw;
  public var y:Float;
  public var angle:Float;
  public var prev:Segment;
  public var next:Segment;
  public var roll:Float = 0.0;
  public var endDist:Int = 0;
  public var support:Int = 0;
  public var head:Bool;

  public function new(y:Float, angle:Float, head:Bool):Void {
    this.y = y;
    this.angle = angle;
    this.head = head;
    var tex = head ? "head" : 'hair${Dice.mod(3)}';
    draw = {texture: Faux.textures[tex], quad: new Quad(0, 0)};
    //draw2 = {texture: Faux.textures['dark$tex'], quad: new Quad(0, 0)};
    Faux.draw.push(draw);
    //Faux.draw.push(draw2);
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
    //draw2.keep = false;
  }

  public function tick():Void {
    if (!head && !game.ending && game.started && Dice.float(1.0) < .02) {
      var tex = 'hair${Dice.mod(3)}';
      draw.texture = Faux.textures[tex];
      //draw2.texture = Faux.textures['dark$tex'];
    }
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
      if (game.ending || !game.started)
        grav = 0;
      y = y.lerp(avgY + Hair.gravity * grav, lerpRate);
      angle = angle.lerp(avgAngle, lerpRate);
      if (splitDist < 0.18)
        remove();
      else if (splitDist > 0.22) {
        var mid = new Segment(avgY, avgAngle, false);
        mid.endDist = endDist;
        mid.roll = prev.roll;
        prev.next = mid;
        mid.prev = prev;
        prev = mid;
        mid.next = this;
      }
    } else if (prev != null) {
      var dx1 = angle - prev.angle;
      var dy1 = y - prev.y;
      var anglePrev = Math.atan2(dy1, dx1);
      roll = roll.lerpAngle(-anglePrev, .4);
    } else if (head) {
      var dx2 = angle - next.angle;
      var dy2 = y - next.y;
      var angleNext = Math.atan2(dy2, dx2);
      angleNext -= Math.PI;
      if (angleNext < -Math.PI) angleNext += Math.PI * 2;
      roll = roll.lerpAngle(-angleNext, .4);
    }
    var minDist = endDist > 50 ? 50 : endDist;
    draw.quad.reset(head ? .5 : .3, .5);
    draw.quad.rotZ(roll);
    draw.quad.tr(0, -y, 1.4 - minDist * 0.001 + (head ? .02 : 0));
    draw.quad.rotY(angle);
    //draw2.quad.reset(.3, .5);
    //draw2.quad.rotZ(roll);
    //draw2.quad.tr(0, -y, 1.41 - minDist * 0.001);
    //draw2.quad.rotY(angle);
    //draw2.alpha = (minDist / 50) * .7;
    support = 0;
  }
}
