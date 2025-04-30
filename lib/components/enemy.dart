import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:space_botato/core/providers.dart';

class Enemy extends Component with RiverpodComponentMixin {
  late int wave;

  @override
  void onMount() {
    // 1) Enregistrer le watcher au build du GameWidget
    addToGameWidgetBuild(() {
      wave = ref.watch(waveProvider);
    });
    // 2) Finaliser le montage (injection des listeners, etc.)
    super.onMount();
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Ici 'wave' est mis à jour automatiquement
    // Exemple de logique :
    // position += (playerPos - position).normalized() * baseSpeed * wave * dt;
  }
}
