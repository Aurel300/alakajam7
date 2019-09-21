class Game {
  public static var maxSpeed:Float = 5.0;

  public var speed:Float = 1.0;
  public var tower:Veza;
  public var hair:Hair;
  public var phys:Array<Bump> = [];

  public function new() {
    Main.game = this;
    tower = new Veza();
    hair = new Hair();
    for (i in 0...10)
      new Bump.Pole(.2 + i * .5, i * .5);
  }

  public function tickLogic(delta:Float):Void {
    var delta = delta * speed * 0.001;

    // controls
    View.turn += delta.negmod(input.keyboard.held[Key.ArrowLeft], input.keyboard.held[Key.ArrowRight]);
    hair.end.angle += .02.negmod(input.keyboard.held[Key.KeyA], input.keyboard.held[Key.KeyD]);
    hair.end.y += .02.negmod(input.keyboard.held[Key.KeyW], input.keyboard.held[Key.KeyS]);


    // logic
    View.y += delta;
    hair.end.y += delta;

    // difficulty
    if (speed < maxSpeed)
      speed += delta * 0.001;
    else
      speed = maxSpeed;
  }

  public function tickRender(delta:Float):Void {
    tower.tick();
    hair.tick();
    Faux.ren();
  }
}
