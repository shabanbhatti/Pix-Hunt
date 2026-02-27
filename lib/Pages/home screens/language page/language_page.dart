import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/language%20controller/language_riverpod.dart';
import 'package:pix_hunt_project/core/Widgets/custom_sliver_appbar.dart';
import 'package:pix_hunt_project/core/constants/constant_colors.dart';
import 'package:pix_hunt_project/core/constants/constant_languages_list.dart';
import 'package:pix_hunt_project/core/typedefs/typedefs.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';

class LanguagePage extends ConsumerStatefulWidget {
  const LanguagePage({super.key, required this.languageNotifier});
  static const String pageName = '/language_page';
  final ValueNotifier<String> languageNotifier;
  @override
  ConsumerState<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends ConsumerState<LanguagePage> {
  final GlobalKey<SliverAnimatedListState> _listKey =
      GlobalKey<SliverAnimatedListState>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAnimation();
    });
  }

  void _startAnimation() async {
    for (int i = 0; i < ConstantLanguagesList.languagesList.length; i++) {
      await Future.delayed(const Duration(milliseconds: 80));
      _listKey.currentState?.insertItem(i);
    }
  }

  @override
  Widget build(BuildContext context) {
    var lng = AppLocalizations.of(context);
    return Scaffold(
      body: Center(
        child: CustomScrollView(
          slivers: [
            CustomSliverAppBar(title: lng?.language ?? ''),
            SliverToBoxAdapter(
              child: ListTile(
                leading: const Icon(Icons.language),
                title: Text(lng?.select_language ?? ''),
              ),
            ),
            SliverSafeArea(
              top: false,
              sliver: ValueListenableBuilder(
                valueListenable: widget.languageNotifier,
                builder: (context, value, child) {
                  return SliverAnimatedList(
                    key: _listKey,
                    initialItemCount: 0,
                    itemBuilder: (context, index, animation) {
                      var lngModel = ConstantLanguagesList.languagesList[index];
                      return _animatedTile(lngModel, value, animation, index);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _animatedTile(
    LanguageModel lngModel,
    String value,
    Animation<double> animation,
    int index,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
      child: FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween(begin: 0.95, end: 1.0).animate(animation),
          child: myTile(lngModel, value),
        ),
      ),
    );
  }

  Widget myTile(LanguageModel lngModel, String value) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 7, vertical: 5),
      child: Material(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: Container(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  (lngModel.code == value)
                      ? ConstantColors.appColor
                      : Colors.grey,
              width: (lngModel.code == value) ? 2 : 0.5,
            ),

            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: ListTile(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            style: ListTileStyle.drawer,

            trailing:
                (lngModel.code == value)
                    ? Icon(Icons.check, color: ConstantColors.appColor)
                    : null,
            onTap: () {
              ref
                  .read(languageProvider.notifier)
                  .languageToggled(lngModel.code);
              widget.languageNotifier.value = lngModel.code;
            },
            leading: Text(lngModel.flag, style: const TextStyle(fontSize: 30)),
            title: Text(lngModel.language),
          ),
        ),
      ),
    );
  }
}
