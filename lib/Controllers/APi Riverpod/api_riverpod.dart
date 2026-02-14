import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:pix_hunt_project/Models/pexer.dart';
import 'package:pix_hunt_project/core/errors/failures/failures.dart';
import 'package:pix_hunt_project/core/injectors/injectors.dart';
import 'package:pix_hunt_project/repository/api_repository.dart';

final apiProvider = StateNotifierProvider<ApiStateNotifier, ApiState>((ref) {
  return ApiStateNotifier(apiRepository: getIt<ApiRepository>());
});

class ApiStateNotifier extends StateNotifier<ApiState> {
  ApiRepository apiRepository;
  ApiStateNotifier({required this.apiRepository}) : super(ApiInitial());

  Future<bool> fetchApi({String? search, int? pageNumber}) async {
    state = ApiLoading();
    try {
      final data = await apiRepository.fetchApi(
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
