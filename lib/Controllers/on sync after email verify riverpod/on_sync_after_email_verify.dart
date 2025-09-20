import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/providers/app_provider_objects.dart';
import 'package:pix_hunt_project/repository/cloud_db_repository.dart';

final onSyncAfterEmailVerifyProvider =
    StateNotifierProvider<OnSyncAfterEmailVerifyStateNotifier, String>((ref) {
      return OnSyncAfterEmailVerifyStateNotifier(
        cloudDbRepository: ref.read(cloudDbRepositoryProviderObject),
      );
    });

class OnSyncAfterEmailVerifyStateNotifier extends StateNotifier<String> {
  CloudDbRepository cloudDbRepository;
  OnSyncAfterEmailVerifyStateNotifier({required this.cloudDbRepository})
    : super('');

  Future<bool> syncEmailAfterVerification() async {
    try {
      await cloudDbRepository.syncEmailAfterVerification();
      return true;
    } catch (e) {
      log(e.toString());
      state = e.toString();
      return false;
    }
  }
}
