import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FavLoadingWidget extends StatelessWidget {
  const FavLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),

      child: Card(
        child: Padding(
          padding: EdgeInsets.all(7),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 20,

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
              Expanded(
                flex: 10,
                child: Text(
                  'scbsdjbjvbsduifbvsduifbvsdjifbvzsdjibvjisdbvjiadfbvdjibvdjiscbsdjbjvbsduifbvsduifbvsdjifbvzsdjibvjisdbvjiadfbvdjibvdji',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 5,
                child: Text(
                  'vzsdjibvjisdbvjiadfbvdjibvdji',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.favorite, color: Colors.indigo, size: 30),
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
