
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pix_hunt_project/Models/dowloads_items_model.dart';
import 'package:pix_hunt_project/providers/app_provider_objects.dart';


final downloadHistoryStreamProvider = StreamProvider.autoDispose<List<DownloadsItem>>((ref,) {
 var cloudRep = ref.read(cloudDbRepositoryProviderObject);

  return cloudRep.downloadHistoryStream();
});
