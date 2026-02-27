import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/ads%20controller/interstitial_add_controller.dart';
import 'package:pix_hunt_project/Controllers/cloud%20db%20controller/user_db_riverpod.dart';
import 'package:pix_hunt_project/Models/downloads_image_model.dart';
import 'package:pix_hunt_project/Models/pictures_model.dart';
import 'package:pix_hunt_project/core/Utils/internet_checker_util.dart';
import 'package:pix_hunt_project/core/Utils/toast.dart';
import 'package:pix_hunt_project/core/Widgets/custom%20btns/app_main_btn.dart';
import 'package:pix_hunt_project/core/constants/constant_colors.dart';
import 'package:pix_hunt_project/core/injectors/injectors.dart';
import 'package:pix_hunt_project/core/typedefs/typedefs.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';

class ViewCardDetailDownloadBtn extends ConsumerWidget {
  const ViewCardDetailDownloadBtn({
    super.key,
    required this.firstNotifier,
    required this.scaleDownloadBtn,
    required this.fadeDownloadBtn,
    required this.photos,
  });
  final ValueNotifier<ImageModel> firstNotifier;
  final Animation<double> scaleDownloadBtn;
  final Animation<double> fadeDownloadBtn;
  final Photos photos;

  @override
  Widget build(BuildContext context, ref) {
    ref.listen(interstitialAdProvider, (previous, next) async {
      if (next is LoadingInterstitialAdsState) {
        EasyLoading.show(dismissOnTap: false);
      }
      if (next is LoadedInterstitialAdsState) {
        EasyLoading.dismiss();
      }
      if (next is OnCloseInterstitialAdsState) {
        String id = DateTime.now().microsecondsSinceEpoch.toString();

        var result = await ref
            .read(userDbProvider.notifier)
            .addDownloadedPhotos(
              DownloadsImageModel(
                photographer: photos.photographer ?? '',
                title: photos.title ?? '',
                imgUrl: firstNotifier.value.imgPath,
                pixels: firstNotifier.value.pixels,
                id: id,
                date: DateTime.now().toString(),
              ),
              AppLocalizations.of(context)?.downloading ?? '',
              AppLocalizations.of(context)?.imageSavedToGallery ?? '',
            );

        if (result != null) {
          ToastUtils.showToast(result.message);
        }
      }
      if (next is ErrorInterstitialAdsState) {
        EasyLoading.dismiss();
      }
    });
    return SliverSafeArea(
      top: false,
      sliver: SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        sliver: SliverToBoxAdapter(
          child: Consumer(
            builder: (context, ref, _) {
              var interstitialAd = ref.watch(interstitialAdProvider);
              return ValueListenableBuilder(
                valueListenable: firstNotifier,
                builder: (context, value, _) {
                  return ScaleTransition(
                    scale: scaleDownloadBtn,
                    child: FadeTransition(
                      opacity: fadeDownloadBtn,
                      child: AppMainBtn(
                        color:
                            (interstitialAd is LoadingInterstitialAdsState)
                                ? Colors.grey.withAlpha(50)
                                : ConstantColors.appColor,
                        widgetOrTitle: WidgetOrTitle.title,
                        btnTitle:
                            '${AppLocalizations.of(context)?.download ?? ''} (${value.pixels})',
                        onTap:
                            (interstitialAd is LoadingInterstitialAdsState)
                                ? () {}
                                : (interstitialAd is ErrorInterstitialAdsState)
                                ? () async {
                                  var internet =
                                      await getIt<InternetCheckerUtil>()
                                          .checkInternet();
                                  if (!internet) return;
                                  String id =
                                      DateTime.now().microsecondsSinceEpoch
                                          .toString();

                                  var result = await ref
                                      .read(userDbProvider.notifier)
                                      .addDownloadedPhotos(
                                        DownloadsImageModel(
                                          photographer:
                                              photos.photographer ?? '',
                                          title: photos.title ?? '',
                                          imgUrl: firstNotifier.value.imgPath,
                                          pixels: firstNotifier.value.pixels,
                                          id: id,
                                          date: DateTime.now().toString(),
                                        ),
                                        AppLocalizations.of(
                                              context,
                                            )?.downloading ??
                                            '',
                                        AppLocalizations.of(
                                              context,
                                            )?.imageSavedToGallery ??
                                            '',
                                      );

                                  if (result != null) {
                                    ToastUtils.showToast(result.message);
                                  }
                                }
                                : () async {
                                  var internet =
                                      await getIt<InternetCheckerUtil>()
                                          .checkInternet();
                                  if (!internet) return;

                                  if (interstitialAd
                                      is LoadedInterstitialAdsState) {
                                    await interstitialAd.interstitialAd.show();
                                  } else if (interstitialAd
                                      is ErrorInterstitialAdsState) {
                                    ToastUtils.showToast(
                                      interstitialAd.error,
                                      color: Colors.red,
                                    );
                                  }
                                },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
