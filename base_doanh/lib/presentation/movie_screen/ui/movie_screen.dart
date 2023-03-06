import 'package:base_doanh/domain/model/movie_model.dart';
import 'package:base_doanh/generated/l10n.dart';
import 'package:base_doanh/presentation/movie_screen/cubit/movie_cubit.dart';
import 'package:base_doanh/presentation/movie_screen/widget/item_movie.dart';
import 'package:base_doanh/utils/constants/image_asset.dart';
import 'package:base_doanh/utils/style_utils.dart';
import 'package:base_doanh/widgets/app_bar.dart';
import 'package:base_doanh/widgets/button/back_app_bar_button.dart';
import 'package:base_doanh/widgets/listview/list_load_infinity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({Key? key}) : super(key: key);

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  late MovieCubit cubit;
  @override
  void initState() {
    cubit = MovieCubit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottomOpacity: 0.0,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            SvgPicture.asset(ImageAssets.icBack),
            spaceW8,
            Text(
              S.current.back,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 24,right: 24),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.current.popular_list,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              spaceH24,
              Expanded(
                child: ListLoadInfinity<MovieModel>(
                  isList: false,
                  itemBuilder: (item, _) {
                    return ItemMovie(
                      movieModel: item,
                    );
                  },
                  errorWidget: (retry, e) {
                    return Container();
                  },
                  callData: (page, __, ___) async {
                    return cubit.getListMovie(page: page);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
