import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/golf_swing.dart';
import '../services/golf_swing_service.dart';

class GolfSwingState {
  final List<GolfSwing> swings;
  final int? currentIndex;
  final bool isLoading;
  final String? errorMessage;

  const GolfSwingState({
    this.swings = const [],
    this.currentIndex,
    this.isLoading = false,
    this.errorMessage,
  });

  GolfSwingState copyWith({
    List<GolfSwing>? swings,
    int? currentIndex,
    bool? isLoading,
    String? errorMessage,
    bool clearCurrentIndex = false,
  }) {
    return GolfSwingState(
      swings: swings ?? this.swings,
      currentIndex: clearCurrentIndex
          ? null
          : (currentIndex ?? this.currentIndex),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  GolfSwing? get currentSwing {
    if (currentIndex != null &&
        currentIndex! >= 0 &&
        currentIndex! < swings.length) {
      return swings[currentIndex!];
    }
    return null;
  }

  bool get hasPrevious => currentIndex != null && currentIndex! > 0;
  bool get hasNext => currentIndex != null && currentIndex! < swings.length - 1;
}

class GolfSwingCubit extends Cubit<GolfSwingState> {
  GolfSwingCubit() : super(const GolfSwingState());

  Future<void> loadSwings() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final swings = await GolfSwingService.loadAllSwings();
      emit(
        state.copyWith(
          swings: swings,
          isLoading: false,
          currentIndex: swings.isNotEmpty ? 0 : null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load swings: $e',
        ),
      );
    }
  }

  void selectSwing(int index) {
    if (index >= 0 && index < state.swings.length) {
      emit(state.copyWith(currentIndex: index));
    }
  }

  void goToPrevious() {
    if (state.hasPrevious) {
      emit(state.copyWith(currentIndex: state.currentIndex! - 1));
    }
  }

  void goToNext() {
    if (state.hasNext) {
      emit(state.copyWith(currentIndex: state.currentIndex! + 1));
    }
  }

    void deleteCurrentSwing() {
    if (state.currentIndex != null) {
      final currentIdx = state.currentIndex!;
      final newSwings = List<GolfSwing>.from(state.swings)
        ..removeAt(currentIdx);

      if (newSwings.isEmpty) {
        // No swings left
        emit(state.copyWith(swings: newSwings, clearCurrentIndex: true));
      } else {
        // Calculate new index for next swing to show
        int newIndex;
        if (currentIdx < newSwings.length) {
          // If there's a swing at the same position (or to the right), use it
          newIndex = currentIdx;
        } else {
          // Otherwise, go to the last swing (to the left)
          newIndex = newSwings.length - 1;
        }

        emit(state.copyWith(swings: newSwings, currentIndex: newIndex));
      }
    }
  }
}
