import js.html.Image;
import howler.Howl;

class Load {
  public static var images:Map<String, Image> = [];
  public static var sounds:Map<String, Howl> = [];

  public static function all(cb:Void->Void):Void {
    var done = 0;
    var need = 0;
    for (id in [
      "cloud0",
      "cloud1",
      "cloud2",
      "darkhair0",
      "darkhair1",
      "darkhair2",
      "floor",
      "hair0",
      "hair1",
      "hair2",
      "head",
      "brick0",
      "brick1",
      "brick2",
      "brick3",
      "brick4",
      "pole0",
      "pole1",
      "pole2",
      "pole3",
      "princess0",
      "princess1",
      "roof",
      "spin0",
      "spin1",
      "sky",
      "star0",
      "star1",
      "star2",
      "star3",
    ]) {
      haxe.Timer.delay(() -> image('png/$id.png', img -> {
        js.Browser.document.querySelector("#game .load i").innerText = 'Loading ... $done / $need';
        images[id] = img;
        done++;
        if (done >= need)
          cb();
      }), 1);
      need++;
    }
    for (id in [
      "best",
      "combo1",
      "combo2",
      "combo3",
      "combo4",
      "combo5",
      "combo6",
      "combofail",
      "music",
      "start",
    ]) {
      sound(id);
    }
  }

  public static function image(url:String, cb:Image->Void):Void {
    var image = new Image();
    image.onload = () -> cb(image);
    image.src = url;
  }

  public static function sound(id:String):Void {
    var options:HowlOptions = {};
    options.src = ['wav/$id.wav'];
    options.autoplay = false;
    if (id == "music")
      options.loop = true;
    sounds[id] = new Howl(options);
  }
}
