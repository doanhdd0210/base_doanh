import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:base_doanh/config/resources/color.dart';
import 'package:base_doanh/config/resources/styles.dart';
import 'package:base_doanh/config/themes/app_theme.dart';
import 'package:base_doanh/generated/l10n.dart';
import 'package:base_doanh/presentation/main_screen/cubit/main_cubit.dart';
import 'package:base_doanh/presentation/main_screen/ui/main_screen.dart';
import 'package:base_doanh/utils/constants/image_asset.dart';
import 'package:base_doanh/utils/style_utils.dart';

@immutable
class CustomBottomHomeAppbar extends StatefulWidget {
  final MainCubit mainCubit;
  final Function(int) onTap;

  const CustomBottomHomeAppbar({
    Key? key,
    required this.mainCubit,
    required this.onTap,
  }) : super(key: key);

  @override
  _CustomBottomHomeAppbarState createState() => _CustomBottomHomeAppbarState();
}

class _CustomBottomHomeAppbarState extends State<CustomBottomHomeAppbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0.r),
          topRight: Radius.circular(16.0.r),
        ),
        border: Border.all(
          width: 1.3.w,
          color: const Color.fromRGBO(255, 255, 255, 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 4,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      width: MediaQuery.of(context).size.width,
      height: 96.h,
      child: StreamBuilder(
        stream: widget.mainCubit.indexStream,
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          return Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    widget.onTap(tabBookTicketIndex);
                    widget.mainCubit.indexSink.add(tabBookTicketIndex);
                  },
                  child: snapshot.data == tabBookTicketIndex
                      ? itemBottomBar(
                          itemSelected(
                            child: ImageAssets.svgAssets(
                              ImageAssets.icTicket,
                              color: AppTheme.getInstance().primaryColor(),
                            ),
                          ),
                          S.current.ok,
                          snapshot.data == tabBookTicketIndex,
                        )
                      : itemBottomBar(
                          ImageAssets.svgAssets(
                            ImageAssets.icTicket,
                            color: colorBlack45,
                          ),
                          S.current.ok,
                          snapshot.data == tabBookTicketIndex,
                        ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    widget.onTap(tabTransshipmentIndex);
                    widget.mainCubit.indexSink.add(tabTransshipmentIndex);
                  },
                  child: snapshot.data == tabTransshipmentIndex
                      ? itemBottomBar(
                          itemSelected(
                            child: ImageAssets.svgAssets(
                              ImageAssets.icTabTrungChuyen,
                              color: AppTheme.getInstance().primaryColor(),
                            ),
                          ),
                          S.current.ok,
                          snapshot.data == tabTransshipmentIndex,
                        )
                      : itemBottomBar(
                          ImageAssets.svgAssets(
                            ImageAssets.icTabTrungChuyen,
                            color: colorBlack45,
                          ),
                          S.current.ok,
                          snapshot.data == tabTransshipmentIndex,
                        ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    widget.onTap(tabGiveTicketIndex);
                    widget.mainCubit.indexSink.add(tabGiveTicketIndex);
                  },
                  child: snapshot.data == tabGiveTicketIndex
                      ? itemBottomBar(
                    itemSelected(
                      child: ImageAssets.svgAssets(
                        ImageAssets.icTabGiaoVe,
                        color: AppTheme.getInstance().primaryColor(),
                      ),
                    ),
                    S.current.ok,
                    snapshot.data == tabGiveTicketIndex,
                  )
                      : itemBottomBar(
                    ImageAssets.svgAssets(
                      ImageAssets.icTabGiaoVe,
                      color: colorBlack45,
                    ),
                    S.current.ok,
                    snapshot.data == tabGiveTicketIndex,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget itemSelected({
    required Widget child,
  }) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(
            45,
          ),
        ),
      ),
      child: child,
    );
  }

  Widget itemBottomBar(Widget child, String value, bool isSelect) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        child,
        spaceH4,
        Text(
          value,
          style: TextStyleCustom.textRegular12.apply(
            color:
                isSelect ? AppTheme.getInstance().primaryColor() : colorBlack45,
          ),
        )
      ],
    );
  }
}
