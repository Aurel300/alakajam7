import js.html.Image;

class Load {
  public static var images:Map<String, Image> = [];

  public static function all(cb:Void->Void):Void {
    var done = 0;
    var need = 0;
    for (id => url in [
      "arrow" => "arrow.png",
      "hair0" => "hair0.png",
      "hair1" => "hair1.png",
      "hair2" => "hair2.png",
      "brick0" => "brick0.png",
      "brick1" => "brick1.png",
      "brick2" => "brick2.png",
      "brick3" => "brick3.png",
      "brick4" => "brick4.png",
      "test" => "test.png",
    ]) {
      haxe.Timer.delay(() -> image(url, img -> {
        images[id] = img;
        done++;
        if (done >= need)
          cb();
      }), 1);
      need++;
    }
  }

  public static function image(url:String, cb:Image->Void):Void {
    var image = new Image();
    image.onload = () -> cb(image);
    image.src = url;
  }

  public static function sound(url:String):Void {
    // load sound into howler object
  }
}
