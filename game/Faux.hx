class Faux {
  public static var draw:Array<Draw> = [];
  public static var textures:Map<String, Texture>;

  static var surface:Surface;
  static var tex:Texture;

  public static function init():Void {
    surface = Surface.initCanvas(cast js.Browser.document.querySelector("#surf"));
    textures = [ for (id => img in Load.images) id => {
      var t = new Texture();
      t.load(img);
      t;
    } ];
  }

  static var ang = 0.0;

  public static function ren():Void {
    var viewS = Math.sin(View.turn);
    var viewC = Math.cos(View.turn);

    // sort
    var i = 1;
    var l = draw.length;
    while (i < l) {
      var x = draw[i];
      var xz = x.quad.sortZ(viewS, viewC);
      var j = i -1;
      while (j >= 0 && draw[j].quad.sortZ(viewS, viewC) > xz) {
        draw[j + 1] = draw[j];
        j--;
      }
      draw[j + 1] = x;
      i++;
    }
    surface.render(() -> {
      var i = 0;
      while (i < l) {
        if (!draw[i].keep) {
          draw.splice(i, 1);
          l--;
          continue;
        }
        if (draw[i].show)
          surface.quad(draw[i].texture, draw[i].quad.view(viewS, viewC));
        i++;
      }
    });
  }

  public function new() {
    // create webGL context
  }
  /*
  public function sprite(img:Texture, pos:SpritePos):Void {
    // render loaded texture at pos
  }
  */
}
