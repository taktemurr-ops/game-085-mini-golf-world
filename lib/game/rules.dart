import '../core/arcade.dart';
import '../core/level_plan.dart';
import '../core/missions.dart';
import '../core/stats.dart';
import 'shot_engine.dart';

class MiniGolfRules extends ArcadeRules<ShotLevel> {
  @override
  String get gameId => 'game-085-mini-golf-world';

  @override
  List<String> get optionalMechanics => const [];

  @override
  List<GameStat> get gameStats => const [
        GameStat('holes_completed', 'Tamamlanan delik', 'Holes completed', scale: 40),
        GameStat('under_par', 'Par altı delik', 'Holes under par', scale: 20),
        GameStat('shots_taken', 'Yapılan atış', 'Shots taken', scale: 300),
        GameStat('hole_in_one', 'Tek vuruşta delik', 'Holes in one', scale: 5),
      ];

  @override
  List<MissionTemplate> get missionTemplates => const [
        MissionTemplate('holes_completed', 'holes_completed', [10, 20, 40]),
        MissionTemplate('under_par', 'under_par', [2, 5, 10], coinReward: 80),
      ];

  @override
  ShotLevel generate(LevelSpec spec) => generateShot(ShotKind.golf, spec);

  @override
  ArcadeMeta metaOf(ShotLevel l) => l.meta;

  @override
  ArcadeSim createSim(ShotLevel l) => ShotSim(l);

  @override
  ArcadeInput bot(ArcadeSim sim) => shotBot(sim);
}

ArcadeRules createRules() => MiniGolfRules();
