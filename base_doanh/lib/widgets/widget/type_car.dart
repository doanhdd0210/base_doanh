import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gen_crm/src/app_const.dart';
import '../../../../api_resfull/dio_provider.dart';
import '../../../../bloc/add_service_voucher/add_service_bloc.dart';
import '../../../../models/model_item_add.dart';
import '../../../../src/models/model_generator/add_customer.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/widget_text.dart';
import '../../widget/widget_label.dart';
import 'select_car.dart';

class TypeCarBase extends StatefulWidget {
  const TypeCarBase({
    Key? key,
    required this.data,
    required this.bloc,
    required this.function,
    required this.addData,
  }) : super(key: key);
  final CustomerIndividualItemData data;
  final ServiceVoucherBloc bloc;
  final Function(String v) function;
  final List<ModelItemAdd> addData;
  @override
  State<TypeCarBase> createState() => _TypeCarBaseState();
}

class _TypeCarBaseState extends State<TypeCarBase> {
  String idDF = '';

  void getId() {
    final List<ModelItemAdd> dataSelect = widget.addData;
    dataSelect.forEach((element) {
      element.data.forEach((value) {
        if (value.label == widget.data.field_parent?.field_value) {
          if (value.value != null && value.value != '' && idDF != value.value)
            getDataApi(value.value.toString());
        }
      });
    });
  }

  Future<void> getDataApi(String id) async {
    idDF = id;
    try {
      var dio = DioProvider.dio;
      var response = await dio.request(
        '${widget.data.field_parent?.field_url}?${widget.data.field_parent?.field_keyparam}=$id',
        options: Options(
          method: 'GET',
        ),
      );

      if (response.statusCode == 200) {
        if (response.data['data'] != null) {
          widget.bloc.loaiXe.add(response.data['data']);
        }
      }
    } catch (e) {
      throw e;
    }
  }

  @override
  void initState() {
    if (widget.data.field_set_value != '' &&
        widget.data.field_set_value != null) {
      widget.bloc.loaiXe.add(widget.data.field_set_value);
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TypeCarBase oldWidget) {
    if (widget.data.field_parent != null) getId();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: marginBottomFrom,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          GestureDetector(
            onTap: () {
              showBottomGenCRM(
                isDismissible: false,
                enableDrag: false,
                child: const SelectCar(),
              );
            },
            child: StreamBuilder<String>(
                stream: widget.bloc.loaiXe,
                builder: (context, snapshot) {
                  if (widget.bloc.loaiXe.value.trim() != '') {
                    widget.function(widget.bloc.loaiXe.value);
                  }
                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: COLORS.WHITE,
                      borderRadius: BorderRadius.circular(
                        4,
                      ),
                      border: Border.all(
                        color: COLORS.GREY,
                      ),
                    ),
                    padding: paddingBaseForm,
                    child: widget.bloc.loaiXe.value != ''
                        ? WidgetText(
                            title: widget.bloc.loaiXe.value,
                            style: AppStyle.DEFAULT_14_BOLD,
                          )
                        : widgetLabel(widget.data),
                  );
                }),
          ),
          StreamBuilder<String>(
              stream: widget.bloc.loaiXe,
              builder: (context, snapshot) {
                if (snapshot.data != '')
                  return WidgetLabelPo(data: widget.data);
                return const SizedBox.shrink();
              }),
        ],
      ),
    );
  }
}
