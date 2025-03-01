import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gen_crm/src/models/model_generator/list_car_response.dart';
import 'package:gen_crm/widgets/btn_thao_tac.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../bloc/add_service_voucher/add_service_bloc.dart';
import '../../../../l10n/key_text.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/widget_text.dart';

class SelectCar extends StatefulWidget {
  const SelectCar({Key? key}) : super(key: key);

  @override
  State<SelectCar> createState() => _SelectCarState();
}

class _SelectCarState extends State<SelectCar> {
  late final ServiceVoucherBloc _bloc;
  final ScrollController _controller = ScrollController();

  void _scrollLate() {
    Timer(const Duration(milliseconds: 200), () {
      _controller.animateTo(
        _controller
            .position.maxScrollExtent, // Vị trí đầu trang (điểm xuất phát)
        duration:
            const Duration(milliseconds: 500), // Thời gian cuộn (milliseconds)
        curve: Curves.easeOut, // Loại hiệu ứng cuộn
      );
    });
  }

  @override
  void initState() {
    _bloc = ServiceVoucherBloc.of(context);
    _bloc.getVersionCarInfo();
    super.initState();
  }

  bool _checkNull(String text) {
    return text.trim() != '' && text != 'null';
  }

  @override
  Widget build(BuildContext context) {
    final bool isHang = _checkNull(_bloc.hangXe?.name ?? '');
    final bool isDong = _checkNull(_bloc.dongXe?.name ?? '');
    return Container(
        height: MediaQuery.of(context).size.height * 0.9,
        padding: const EdgeInsets.only(
          top: 25,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 16, right: 16),
          controller: _controller,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  WidgetText(
                    title: getT(KeyT.car_brand),
                    style: AppStyle.DEFAULT_16.copyWith(
                      color: HexColor('0079B5'),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  StreamBuilder<Set<HangXe>>(
                      stream: _bloc.listHangXe,
                      builder: (context, snapshot) {
                        final list = snapshot.data ?? {};
                        return Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: list
                              .map((e) => GestureDetector(
                                    onTap: () {
                                      _bloc.hangXe = HangXe(
                                        name: e.name.toString(),
                                        id: e.id,
                                      );
                                      _bloc.dongXe = HangXe.empty;
                                      _bloc.phienBan = HangXe.empty;
                                      _bloc.getDongXe(e.id.toString());
                                      _scrollLate();
                                      setState(() {});
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: _bloc.hangXe?.name != e.name
                                            ? COLORS.WHITE
                                            : HexColor('0079B5')
                                                .withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: _bloc.hangXe?.name != e.name
                                              ? Colors.grey
                                              : HexColor('0079B5'),
                                          width: 2,
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      child: Text(
                                        e.name.toString(),
                                        style: AppStyle.DEFAULT_14,
                                      ),
                                    ),
                                  ))
                              .toList(),
                        );
                      }),
                ],
              ),
              if (isHang)
                _baseSelect(
                  getT(KeyT.car_series),
                  _bloc.dongXe,
                  _bloc.listDongXe,
                  (HangXe v) {
                    _bloc.dongXe = v;
                    _bloc.phienBan = HangXe.empty;
                    _bloc.getPhienBan(v.name ?? '');
                    _scrollLate();
                    setState(() {});
                  },
                ),
              if (isHang && isDong)
                _baseSelect(
                  getT(KeyT.version),
                  _bloc.phienBan,
                  _bloc.listPhienBan,
                  (HangXe v) {
                    _bloc.phienBan = v;
                    _scrollLate();
                    setState(() {});
                  },
                ),
              const SizedBox(
                height: 32,
              ),
              Container(
                height: 37,
                child: Row(
                  children: [
                    Expanded(
                      child: ButtonSmall(
                          backGround: COLORS.GREY,
                          title: getT(KeyT.close),
                          onTap: () {
                            Navigator.of(context).pop();
                          }),
                    ),
                    AppValue.hSpaceSmall,
                    Expanded(
                      child: ButtonSmall(
                        title: getT(KeyT.select),
                        onTap: () {
                          _bloc.loaiXe.add(
                            (_checkKhongXacDinh(_bloc.hangXe?.name ?? '') +
                                    _checkKhongXacDinh(
                                        _bloc.dongXe?.name ?? '') +
                                    _checkKhongXacDinh(
                                        _bloc.phienBan?.name ?? ''))
                                .trim(),
                          );
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 32,
              )
            ],
          ),
        ));
  }

  Widget _baseSelect(
    String title,
    HangXe? hangXe,
    BehaviorSubject<Set<HangXe>> stream,
    Function function,
  ) {
    return StreamBuilder<Set<HangXe>>(
        stream: stream,
        builder: (context, snapshot) {
          final list = snapshot.data ?? {};
          return list.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    WidgetText(
                      title: title,
                      style: AppStyle.DEFAULT_16.copyWith(
                          color: HexColor('0079B5'),
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: list
                          .map(
                            (e) => GestureDetector(
                              onTap: () {
                                function(e);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: hangXe?.name != e.name
                                      ? COLORS.WHITE
                                      : HexColor('0079B5').withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: hangXe?.name != e.name
                                        ? Colors.grey
                                        : HexColor('0079B5'),
                                    width: 2,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: Text(
                                  e.name ?? '',
                                  style: AppStyle.DEFAULT_14,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                )
              : const SizedBox.shrink();
        });
  }

  String _checkKhongXacDinh(String name) {
    return '${name == '' ? '' : '$name '}';
  }
}
