import js.html.Element;

class Game {
  public static var maxSpeed:Float = 1.0;

  public var speed:Float;
  public var back:Back;
  public var tower:Veza;
  public var hair:Hair;
  public var knot:Knot;
  public var phys:Array<Bump>;
  public var poles:Array<Pole>;
  public var hero:Hero;
  public var ending:Bool;
  public var endingTime:Int;
  public var started:Bool;
  public var score:Int;
  public var scoreAdd:Int;
  public var lastTrick:String;

  var elScore:Element;
  var elScoreAdd:Element;

  var onSound = true;
  var onMusic = true;

  public function new() {
    Main.game = this;
    elScore = el("score");
    elScoreAdd = el("score_add");
    el("load").classList.add("hide");
    play("music");
    el("instruction_start").classList.add("show");
    el("ctrl_sfx").addEventListener("click", () -> {
      Play.setSfx(onSound = !onSound);
      if (onSound)
        el("ctrl_sfx").classList.remove("off");
      else
        el("ctrl_sfx").classList.add("off");
    });
    el("ctrl_music").addEventListener("click", () -> {
      Play.setMusic(onMusic = !onMusic);
      if (onMusic)
        el("ctrl_music").classList.remove("off");
      else
        el("ctrl_music").classList.add("off");
    });
    reset();
  }

  function reset():Void {
    View.reset();
    ending = false;
    endingTime = 0;
    started = false;
    score = 0;
    scoreAdd = 0;
    lastTrick = "";
    speed = 0.5;
    hero = null;
    phys = [];
    poles = [];
    Faux.back = [];
    Faux.draw = [];
    back = new Back();
    tower = new Veza();
    hair = new Hair();
    knot = new Knot();
  }

  function el(cls:String):Element {
    return js.Browser.document.querySelector('#game .$cls');
  }

  public function click():Void {
    if (!started) {
      started = true;
      el("instruction_start").classList.remove("show");
      el("title").classList.add("hide");
      play("start");
    } else if (ending && endingTime > 30) {
      elScore.classList.remove("ending");
      elScore.innerText = "Score: 0";
      el("end").classList.remove("ending");
      reset();
      started = true;
      play("start");
    }
  }

  public function tickLogic(odelta:Float):Void {
    var delta = odelta * speed * 0.001;
    ending = View.y >= tower.endY - 2.0;
    if (ending)
      endingTime++;
    else
      endingTime = 0;

    // controls
    //View.turn += delta.negmod(input.keyboard.held[Key.ArrowLeft], input.keyboard.held[Key.ArrowRight]);
    if (ending) {
      if (hero == null) {
        hero = new Hero(tower.endY - 0.7, hair.end.angle);
        knot.flush();
        if (scoreAdd > 0) {
          score += scoreAdd;
          scoreAdd = 0;
          elScore.classList.remove("active");
          elScoreAdd.innerText = "";
          elScore.innerText = 'Score: $score';
        }
        elScore.classList.add("ending");
        if (score > Save.best) {
          el("end .best").innerText = "New best!";
          el("end .best").classList.add("new");
          play("best");
          Save.save(score);
        } else {
          el("end .best").innerText = 'Best: ${Save.best}';
          el("end .best").classList.remove("new");
        }
        el("end .end_score").innerText = 'Score: $score';
        el("end").classList.add("ending");
      }
      hair.end.y += .04;
    } else if (started) {
      var cdelta = odelta * (0.0005 + speed * 0.0005);
      hair.end.angle += (2.075 * cdelta).negmod(
        input.keyboard.held[Key.KeyA] || input.keyboard.held[Key.ArrowLeft],
        input.keyboard.held[Key.KeyD] || input.keyboard.held[Key.ArrowRight]
      );
      hair.end.y += (3. * cdelta).negmod(
        input.keyboard.held[Key.KeyW] || input.keyboard.held[Key.ArrowUp],
        input.keyboard.held[Key.KeyS] || input.keyboard.held[Key.ArrowDown]
      );
    }
    if (hair.end.y < 0.2) hair.end.y = 0.2;
    var acDelta = delta;
    if (hair.end.y < View.y - 1.5) hair.end.y = View.y - 1.5;
    if (hair.end.y < View.y - 1.3) acDelta *= 0.6;
    if (hair.end.y > View.y + 1.5) hair.end.y = View.y + 1.5;
    if (hair.end.y > View.y + 1.3) acDelta *= 1.4;
    if (hair.end.y > tower.endY - 0.6) hair.end.y = tower.endY - 0.6;

    // scoring
    if (!ending && started) {
      knot.tick();
      if (scoreAdd > 0) {
        for (am in [10000, 1000, 100, 10, 1]) {
          if (scoreAdd >= am * 10) {
            score += am;
            scoreAdd -= am;
            break;
          }
        }
        if (scoreAdd > 0 && scoreAdd < 10) {
          score++;
          scoreAdd--;
        }
        if (scoreAdd == 0) {
          elScore.classList.remove("active");
          elScoreAdd.innerText = "";
        } else {
          elScoreAdd.innerText = '+${scoreAdd} ($lastTrick)';
        }
        elScore.innerText = 'Score: $score';
      }
    }

    //return;

    // progress
    if (!ending && started) {
      View.y += acDelta;
      View.backY += acDelta * .2;
      hair.end.y += acDelta;

      // difficulty
      if (speed < maxSpeed)
        speed += delta * 0.05;
      else
        speed = maxSpeed;
    }
  }

  public function gainScore(v:Int, trick:String):Void {
    scoreAdd += v;
    lastTrick = trick;
    if (scoreAdd > 0)
      elScore.classList.add("active");
  }

  public function tickRender(delta:Float):Void {
    back.tick();
    tower.tick();
    hair.tick();
    if (hero != null)
      hero.tick();
    Spin.tick(delta);
    Faux.ren();
  }
}
