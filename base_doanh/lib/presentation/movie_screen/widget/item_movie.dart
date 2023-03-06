import 'package:base_doanh/domain/model/movie_model.dart';
import 'package:base_doanh/utils/constants/api_constants.dart';
import 'package:base_doanh/utils/constants/image_asset.dart';
import 'package:flutter/material.dart';

class ItemMovie extends StatelessWidget {
  final MovieModel movieModel;
  const ItemMovie({Key? key, required this.movieModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: double.maxFinite,
          decoration: BoxDecoration(
            color: Colors.grey,
            boxShadow: [
              BoxShadow(
                offset: Offset(5, 5),
                color: Colors.black45,
                blurRadius: 5,
              )
            ],
            borderRadius: BorderRadius.circular(6),
          ),
          clipBehavior: Clip.hardEdge,
          child: Image.network(
            ApiConstants.URL_IMG_MOVIE + movieModel.posterPath,
            fit: BoxFit.fitHeight,
            errorBuilder: ErrorImageBase,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
          ),
        ),
        Positioned(
            left: 12,
            bottom: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: (MediaQuery.of(context).size.width / 2.6),
                  child: Text(
                    movieModel.year.year.toString(),
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 20,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ),
                SizedBox(
                  width: (MediaQuery.of(context).size.width / 2.6),
                  child: Text(
                    movieModel.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            )),
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.orange,
                  Colors.red.shade600,
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      movieModel.voteAverage.toString().substring(0, 1),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        height: 1,
                      ),
                    ),
                  ),
                  if (movieModel.voteAverage.toString().length > 2)
                    Text(
                      movieModel.voteAverage.toString().substring(1, 3),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        height: 1.15,
                      ),
                    ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
