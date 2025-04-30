import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:space_botato/main.dart';

final waveProvider = StateProvider<int>((_) => 1);
final gameStateProvider = StateProvider<GameState>((_) => GameState.menu);
