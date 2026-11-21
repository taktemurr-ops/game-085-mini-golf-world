import 'package:flutter/material.dart';

import 'package:studio_core/app/arcade_stage.dart';
import 'package:studio_core/app/game_api.dart';
import 'package:studio_core/core/game_rules.dart';
import 'shot_engine.dart';
import 'shot_view.dart';
import 'rules.dart';

final gameConfig = GameConfig(
  gameId: 'game-085-mini-golf-world',
  title: const ['Mini Golf Dünyası', 'Mini Golf World', 'Minigolf-Welt', 'Mundo Mini Golf', 'Monde du Mini-Golf'],
  tagline: const ['Engelleri aş, deliğe az vuruşla gir!', 'Beat the obstacles in as few strokes as possible!', 'Wenige Schläge, viele Hindernisse!', '¡Menos golpes, más obstáculos!', 'Moins de coups, plus d\'obstacles !'],
  seedColor: const Color(0xFF52B788),
  icon: Icons.golf_course,
  rules: MiniGolfRules(),
  buildPlay: (ctx) => ArcadeStage(
    ctx: ctx,
    create: () => ShotSim((ctx.generated as GeneratedLevel<ShotLevel>).puzzle),
    paint: paintShot,
    sound: shotSound,
    boosterIcon: Icons.undo,
    boosterLabel: (l) => l == 'tr' ? 'Mulligan (-1 vuruş)' : 'Mulligan (-1 stroke)',
    howTo: const ['Ekrana bas, geri çek ve bırak: çektiğin uzunluk gücü, ters yön atış yönünü belirler. Klavye: ok tuşları + boşluk.', 'Press, pull back and release: the length sets the power, the opposite direction is the shot. Keys: arrows + space.', 'Drücken, zurückziehen, loslassen.', 'Pulsa, tira hacia atrás y suelta.', 'Appuyez, tirez en arrière et relâchez.'],
  ),
  tutorial: const [
    TutorialStep(Icons.open_with, ['Geri çekip bırak: sapan gibi.', 'Pull back and release like a slingshot.', 'Wie eine Schleuder.', 'Como un tirachinas.', 'Comme un lance-pierre.']),
    TutorialStep(Icons.water_drop, ['Su = +1 vuruş, kum topu yavaşlatır.', 'Water = +1 stroke, sand slows the ball.', 'Wasser = +1 Schlag.', 'Agua = +1 golpe.', 'Eau = +1 coup.']),
    TutorialStep(Icons.flag, ['Par veya altında bitir: 3 yıldız.', 'Finish at par or better for 3 stars.', 'Par = 3 Sterne.', 'Par = 3 estrellas.', 'Par = 3 étoiles.']),
  ],
);
