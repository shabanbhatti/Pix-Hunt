import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Models/pictures_model.dart';
import 'package:pix_hunt_project/core/errors/failures/failures.dart';
import 'package:pix_hunt_project/core/injectors/injectors.dart';
import 'package:pix_hunt_project/repository/api_repository.dart';

final apiProvider = StateNotifierProvider<ApiStateNotifier, ApiState>((ref) {
  return ApiStateNotifier(apiRepository: getIt<ApiRepository>());
});

class ApiStateNotifier extends StateNotifier<ApiState> {
  ApiRepository apiRepository;
  ApiStateNotifier({required this.apiRepository}) : super(ApiInitial());

  Future<bool> fetchData({String? search, int? pageNumber}) async {
    state = ApiLoading();
    try {
      final data = await apiRepository.fetchData(
        search: search,
        pageNumber: pageNumber,
      );

      if (search == '') {
        state = ApiEmptyState();
      } else {
        state = ApiLoadedSuccessfuly(pexer: data);
      }

      return true;
    } on Failures catch (e) {
      state = ApiError(message: e.message);
      return false;
    }
  }

  Future<bool> fetchFromApi({String? search, int? pageNumber}) async {
    state = ApiLoading();
    try {
      final data = await apiRepository.fetchFromApi(
        search: search,
        pageNumber: pageNumber,
      );

      if (search == '') {
        state = ApiEmptyState();
      } else {
        state = ApiLoadedSuccessfuly(pexer: data);
      }

      return true;
    } on Failures catch (e) {
      state = ApiError(message: e.message);
      return false;
    }
  }

  Future<void> updatePhoto(Photos photos) async {
    try {
      await apiRepository.updatePhoto(photos);
    } on Failures catch (e) {
      state = ApiError(message: e.message);
    }
  }

  Future<void> eraseAll() async {
    state = ApiEmptyState();
  }
}

sealed class ApiState {
  const ApiState();
}

class ApiInitial extends ApiState {
  const ApiInitial();
}

class ApiLoading extends ApiState {
  const ApiLoading();
}

class ApiLoadedSuccessfuly extends ApiState {
  final Pexer pexer;
  const ApiLoadedSuccessfuly({required this.pexer});
}

class ApiEmptyState extends ApiState {
  const ApiEmptyState();
}

class ApiError extends ApiState {
  final int? statusCode; // null for network errors
  final String message;

  const ApiError({this.statusCode, required this.message});
}
