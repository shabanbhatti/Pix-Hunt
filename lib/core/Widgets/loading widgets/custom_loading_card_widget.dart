import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomLoadingCardsWidget extends StatelessWidget {
  const CustomLoadingCardsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.all(5),
      child: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Colors.grey.withAlpha(50),
        ),
        child: Padding(
          padding: EdgeInsets.all(7),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 25,

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Skeletonizer(
                    enabled: true,
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.grey[300],
                    ),
                  ),
                ),
              ),
              Spacer(flex: 1),
              const Expanded(
                flex: 10,
                child: Text(
                  'this should be the title of the loading card widget, and this is.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const Expanded(
                flex: 5,
                child: Text(
                  'Shaban Bhatti Sb',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
              const Expanded(
                flex: 7,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.favorite, color: Colors.grey, size: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
