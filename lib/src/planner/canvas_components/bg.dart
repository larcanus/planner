import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_svg/flame_svg.dart';

class BG extends PositionComponent with Tappable {
  late final Sprite bgSprite;
  late final FlameGame game;
  late Svg svgInstance;

  late final SvgComponent svgCopm;

  BG(this.game, position) : super(position: position);


  @override
  Future<void> onLoad() async {
    super.onLoad();
    bgSprite = Sprite(game.images.fromCache('back-1.png'));
    // Svg.load(fileName, cache: assets);
    svgInstance = await game.loadSvg('images/back-1.svg');
    svgCopm = SvgComponent(
      svg: svgInstance,
      position: Vector2.all(100),
      size: Vector2.all(100),
    );
  }

  getSVG(){
    return svgCopm;
  }
  @override
  void render(Canvas canvas) {
    svgInstance.renderPosition(canvas, Vector2(100, 200), Vector2.all(300));

    bgSprite.renderRect(
        canvas,
        const Rect.fromLTWH(
          0.0,
          123,
          119,
          123,
        ));
  }
}
