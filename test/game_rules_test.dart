import 'package:flutter_test/flutter_test.dart';
import 'package:studio_core/core/arcade.dart';
import 'package:studio_core/core/level_plan.dart';
import 'package:game_085_mini_golf_world/game/rules.dart';
import 'package:game_085_mini_golf_world/game/shot_engine.dart';

void main() {
  final rules = MiniGolfRules();
  final planner = LevelPlanner(gameId: rules.gameId, optionalMechanics: rules.optionalMechanics);

  ShotSim fresh([int n = 1]) => ShotSim(rules.build(planner.spec(n)).puzzle);

  test('drag and release fires a shot, a tiny tap does not', () {
    final s = fresh();
    if (s.usesReticle) {
      s.tick(const ArcadeInput(down: true, x: 500, y: 650));
      s.tick(const ArcadeInput(down: false, x: 500, y: 650));
      expect(s.shots, 0, reason: 'too short a hold');
      for (var i = 0; i < 10; i++) {
        s.tick(const ArcadeInput(down: true, x: 500, y: 650));
      }
      s.tick(const ArcadeInput(down: false, x: 500, y: 650));
      expect(s.shots, 1);
    } else {
      s.tick(const ArcadeInput(down: true, x: 500, y: 800));
      s.tick(const ArcadeInput(down: true, x: 503, y: 805));
      s.tick(const ArcadeInput(down: false, x: 503, y: 805));
      expect(s.shots, 0, reason: 'too short a drag');
      s.tick(const ArcadeInput(down: true, x: 500, y: 800));
      s.tick(const ArcadeInput(down: true, x: 500, y: 1000));
      s.tick(const ArcadeInput(down: false, x: 500, y: 1000));
      expect(s.shots, 1);
      expect(s.phase, 1);
    }
  });

  test('failing a round costs a life and restarts the same layout', () {
    final s = fresh(3);
    final before = s.goalText;
    s.roundFailed();
    expect(s.lives, 2);
    expect(s.goalText, before);
    expect(s.over, isFalse);
  });

  test('autopilot clears the first ten levels without losing a life', () {
    for (var n = 1; n <= 10; n++) {
      final s = fresh(n);
      final r = runBot(s, rules.bot, 60 * 60 * 6);
      expect(r.won, isTrue, reason: 'level $n');
      expect(s.stars, greaterThanOrEqualTo(1));
    }
  });

  test('golf: a putt straight into the cup holes out; water costs a stroke', () {
    final s = fresh() as GolfSim;
    s.hole.walls.clear();
    s.hole.sand.clear();
    s.hole.water.clear();
    final b = Disc(s.hole.hx, s.hole.hy + 120, kGolfBallR, 1, 0)..vy = -8;
    var res = 0;
    for (var i = 0; i < 200 && res == 0; i++) {
      res = GolfSim.stepBall(s.hole, b, null);
    }
    expect(res, 1);
    s.hole.water.add(Box(100, 900, 900, 1000));
    final w = Disc(500, 1100, kGolfBallR, 1, 0)..vy = -20;
    res = 0;
    for (var i = 0; i < 200 && res == 0; i++) {
      res = GolfSim.stepBall(s.hole, w, null);
    }
    expect(res, 2);
  });
}
