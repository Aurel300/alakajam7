class Main {
  public static function main():Void
    js.Browser.window.onload = () -> Load.all(() -> {
      input = new Input(js.Browser.document.body, js.Browser.document.querySelector("#game .click"));
      input.mouse.up.on(e -> game.click());
      Save.init();
      Rune.init();
      Faux.init();
      game = new Game();
      new Rate(tick);
    });

  public static var game:Game;
  public static var input:Input;

  public static function tick(delta:Float):Void {
    game.tickLogic(delta);
    game.tickRender(delta);
    Stat.show();
  }
}
