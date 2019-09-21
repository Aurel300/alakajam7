class Main {
  public static function main():Void
    js.Browser.window.onload = () -> co({
      suspend((_, w) -> Load.all(w));
      input = new Input(js.Browser.document.body);
      Faux.init();
      game = new Game();
      new Rate(tick);
    }).run().tick();

  public static var game:Game;
  public static var input:Input;

  public static function tick(delta:Float):Void {
    game.tickLogic(delta);
    game.tickRender(delta);
    Stat.show();
  }
}
