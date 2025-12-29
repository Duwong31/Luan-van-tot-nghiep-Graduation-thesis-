import 'package:Celes/data/models/api_response.dart';
import 'package:Celes/data/models/home_model.dart';
import 'package:Celes/data/repositories/home_repository.dart';
import 'package:Celes/utils/api_exception.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ==================== HOME STATES ====================

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final HomeData homeData;
  final String message;

  HomeLoaded({
    required this.homeData,
    required this.message,
  });
}

class HomeError extends HomeState {
  final String errorMessage;
  final String? errorCode;

  HomeError({
    required this.errorMessage,
    this.errorCode,
  });
}

// ==================== HOME CUBIT ====================

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _homeRepository = HomeRepository();

  HomeCubit() : super(HomeInitial());

  Future<void> fetchHomeData() async {
    emit(HomeLoading());

    try {
      final ApiResponse<HomeData> response =
          await _homeRepository.getHomeData();

      if (response.success && response.data != null) {
        emit(HomeLoaded(
          homeData: response.data!,
          message: response.message,
        ));
      } else {
        emit(HomeError(
          errorMessage: response.message,
          errorCode: response.code,
        ));
      }
    } on ApiException catch (e) {
      emit(HomeError(
        errorMessage: e.message,
        errorCode: e.code,
      ));
    } catch (e) {
      emit(HomeError(
        errorMessage: 'An unexpected error occurred: ${e.toString()}',
      ));
    }
  }

  void resetState() {
    emit(HomeInitial());
  }

  Future<void> refreshHomeData() async {
    await fetchHomeData();
  }
}
