class Play {
  public static function play(id:String):Void {
    Load.sounds[id].play();
  }

  public static function combo(n:Int):Void {
    for (i in 0...n) {
      var id = (i + 1) < 6 ? (i + 1) : (6 - ((i + 1) % 1));
      haxe.Timer.delay(() -> play('combo$id'), i * 180);
    }
  }

  public static function setMusic(on:Bool):Void {
    Load.sounds["music"].volume(on ? 1. : 0.);
  }

  public static function setSfx(on:Bool):Void {
    for (id => snd in Load.sounds) {
      if (id == "music")
        continue;
      snd.volume(on ? 1. : 0.);
    }
  }
}
