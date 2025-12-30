import 'package:Celes/data/models/api_response.dart';
import 'package:Celes/data/models/seat_model.dart';
import 'package:Celes/data/models/showtime_seats_model.dart';
import 'package:Celes/data/repositories/showtime_repository.dart';
import 'package:Celes/utils/api_exception.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ==================== SHOWTIME SEATS STATES ====================

abstract class ShowtimeSeatsState {}

class ShowtimeSeatsInitial extends ShowtimeSeatsState {}

class ShowtimeSeatsLoading extends ShowtimeSeatsState {}

class ShowtimeSeatsLoaded extends ShowtimeSeatsState {
  final ShowtimeSeatsData seatsData;
  final String message;
  final Set<int> selectedSeatIds;

  ShowtimeSeatsLoaded({
    required this.seatsData,
    required this.message,
    this.selectedSeatIds = const {},
  });

  /// Check if there are any seats
  bool get hasSeats => seatsData.hasSeats;

  /// Get all seats
  List<Seat> get seats => seatsData.seats;

  /// Get seats by row
  List<SeatRow> get seatsByRow => seatsData.seatsByRow;

  /// Get summary
  SeatsSummary get summary => seatsData.summary;

  /// Get ticket price
  int get ticketPrice => seatsData.ticketPrice;

  /// Get selected seats
  List<Seat> get selectedSeats =>
      seats.where((s) => selectedSeatIds.contains(s.id)).toList();

  /// Get total price for selected seats
  int get totalPrice => selectedSeats.length * ticketPrice;

  /// Get formatted total price
  String get formattedTotalPrice {
    return '${totalPrice.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )} VND';
  }

  /// Copy with new selected seats
  ShowtimeSeatsLoaded copyWith({Set<int>? selectedSeatIds}) {
    return ShowtimeSeatsLoaded(
      seatsData: seatsData,
      message: message,
      selectedSeatIds: selectedSeatIds ?? this.selectedSeatIds,
    );
  }
}

class ShowtimeSeatsEmpty extends ShowtimeSeatsState {
  final String message;

  ShowtimeSeatsEmpty({required this.message});
}

class ShowtimeSeatsError extends ShowtimeSeatsState {
  final String errorMessage;
  final String? errorCode;

  ShowtimeSeatsError({
    required this.errorMessage,
    this.errorCode,
  });
}

// ==================== SHOWTIME SEATS CUBIT ====================

class ShowtimeSeatsCubit extends Cubit<ShowtimeSeatsState> {
  final ShowtimeRepository _showtimeRepository = ShowtimeRepository();

  ShowtimeSeatsCubit() : super(ShowtimeSeatsInitial());

  /// Lấy danh sách ghế của suất chiếu
  Future<void> fetchShowtimeSeats(int showtimeId) async {
    emit(ShowtimeSeatsLoading());

    try {
      final ApiResponse<ShowtimeSeatsData> response =
          await _showtimeRepository.getShowtimeSeats(showtimeId);

      if (response.success && response.data != null) {
        final data = response.data!;

        if (data.hasSeats) {
          emit(ShowtimeSeatsLoaded(
            seatsData: data,
            message: response.message,
          ));
        } else {
          emit(ShowtimeSeatsEmpty(
            message: 'Không có ghế nào cho suất chiếu này',
          ));
        }
      } else {
        emit(ShowtimeSeatsError(
          errorMessage: response.message,
          errorCode: response.code,
        ));
      }
    } on ApiException catch (e) {
      emit(ShowtimeSeatsError(
        errorMessage: e.message,
        errorCode: e.code,
      ));
    } catch (e) {
      emit(ShowtimeSeatsError(
        errorMessage: 'Có lỗi xảy ra: ${e.toString()}',
      ));
    }
  }

  /// Toggle seat selection
  void toggleSeatSelection(int seatId) {
    final currentState = state;
    if (currentState is ShowtimeSeatsLoaded) {
      // Check if seat is available
      final seat = currentState.seats.firstWhere(
        (s) => s.id == seatId,
        orElse: () => throw Exception('Seat not found'),
      );

      if (!seat.isAvailable) return;

      final newSelectedIds = Set<int>.from(currentState.selectedSeatIds);
      if (newSelectedIds.contains(seatId)) {
        newSelectedIds.remove(seatId);
      } else {
        newSelectedIds.add(seatId);
      }

      emit(currentState.copyWith(selectedSeatIds: newSelectedIds));
    }
  }

  /// Clear all selected seats
  void clearSelection() {
    final currentState = state;
    if (currentState is ShowtimeSeatsLoaded) {
      emit(currentState.copyWith(selectedSeatIds: {}));
    }
  }

  /// Reset state
  void resetState() {
    emit(ShowtimeSeatsInitial());
  }
}
