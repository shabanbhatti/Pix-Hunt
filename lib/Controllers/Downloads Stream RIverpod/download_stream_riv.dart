import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pix_hunt_project/Models/dowloads_items_model.dart';
import 'package:pix_hunt_project/core/injectors/injectors.dart';
import 'package:pix_hunt_project/repository/cloud_db_repository.dart';

final downloadHistoryStreamProvider =
    StreamProvider.autoDispose<List<DownloadsItem>>((ref) {
      var cloudRep = getIt<CloudDbRepository>();

      return cloudRep.downloadHistoryStream();
    });
