import 'package:auto_route/auto_route.dart';
import 'package:azmod/config/base/app_cubit.dart';
import 'package:azmod/config/resources/color.dart';
import 'package:azmod/config/resources/dimen.dart';
import 'package:azmod/config/resources/images.dart';
import 'package:azmod/config/routes/app_router.gr.dart';
import 'package:azmod/config/themes/app_color_theme.dart';
import 'package:azmod/domain/locals/secure_store/auth_storage.dart';
import 'package:azmod/domain/model/authentication/user_model.dart';
import 'package:azmod/domain/model/patient/patient_model.dart';
import 'package:azmod/domain/model/threshold/threshold_model.dart';
import 'package:azmod/domain/model/update_log_detail/update_log_detail_model.dart';
import 'package:azmod/domain/repository/dt_timer_repository.dart';
import 'package:azmod/domain/repository/master/thresold_repository.dart';
import 'package:azmod/domain/repository/update_log_detail_repository.dart';
import 'package:azmod/domain/repository/update_log_repository.dart';
import 'package:azmod/domain/singleton/patient_singleton.dart';
import 'package:azmod/domain/singleton/user_singleton.dart';
import 'package:azmod/generated/l10n.dart';
import 'package:azmod/presentation/patients/cubit/patient_cubit.dart';
import 'package:azmod/presentation/patients/ui/timer_dialog.dart';
import 'package:azmod/utils/constants/app_constants.dart';
import 'package:azmod/utils/device_manger.dart';
import 'package:azmod/utils/extensions/context_ext.dart';
import 'package:azmod/utils/extensions/widget_ext.dart';
import 'package:azmod/widgets/countdown/countdown_widget.dart';
import 'package:azmod/widgets/side_menu/side_menu_type.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';

class PatientsMobileScreen extends StatefulWidget {
  const PatientsMobileScreen({super.key});

  @override
  State<PatientsMobileScreen> createState() => _PatientsMobileScreenState();
}

class _PatientsMobileScreenState extends State<PatientsMobileScreen> {
  double height = 32;
  final floatingSize = 48;
  final floatingMargin = 18.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    height = (MediaQuery.sizeOf(context).height - kToolbarHeight - 16) / 9.5;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => PatientCubit(
          updateLogRepo: context.read<UpdateLogRepository>(),
          updateLogDetailRepo: context.read<UpdateLogDetailRepository>(),
          thresholdRepository: context.read<ThresholdRepository>(),
          timerRepository: context.read<DTTimerRepository>(),
        )..initData(),
        child: Container(
          color: context.color.surfaceContainer,
          child: CustomScrollView(
            slivers: [
              _buildAppBar(),
              SliverToBoxAdapter(
                child: Builder(builder: (context) {
                  return Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: context.color.surface,
                            borderRadius: BorderRadius.circular(10)),
                        clipBehavior: Clip.hardEdge,
                        child: _buildTable(context),
                      ),
                      _buildFloating()
                    ],
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloating() {
    return Positioned(
      bottom: floatingMargin,
      right: floatingMargin,
      child: Builder(builder: (context) {
        return FloatingActionButton(
          mini: true,
          onPressed: () async {
            await context.read<PatientCubit>().createPatient();
            context.read<PatientCubit>().getPatients();
          },
          child: Text(
            S.current.add,
            style: context.typography.bodyText2
                ?.copyWith(color: AppStaticColor.textLightWhite),
          ),
        );
      }),
    );
  }

  Widget _buildTable(BuildContext context) {
    return Row(
      children: [
        _buildTableHeader(context),
        BlocBuilder<PatientCubit, PatientState>(builder: (context, state) {
          final patients = state.patients;
          final threshold = state.threshold;
          return Scrollbar(
            scrollbarOrientation: ScrollbarOrientation.bottom,
            child: Builder(builder: (context) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  ...patients
                      .map((x) => _buildTableItem(context, x, threshold)),
                  SizedBox(
                    width: floatingMargin + floatingSize,
                  )
                ]),
              );
            }),
          ).expanded();
        }),
      ],
    );
  }

  Widget _buildTableItem(
    BuildContext context,
    PatientModel value,
    List<ThresholdModel> threshold,
  ) {
    return GestureDetector(
      onTap: () async {
        PatientSingleton.instance.patientId = value.incidentNo;
        DeviceUtils.getDeviceId().then((value) {
          PatientSingleton.instance.deviceId = value;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDataTile(
            value.name ?? S.current.noData,
          ),
          _buildDataTile(
            value.pulseRate?.toString() ?? S.current.noData,
            textColor: getVitalColor(
              valueKey: PatientVitalKeyName.pulseRate,
              value: value.pulseRate,
              threshold: threshold,
            ),
          ),
          _buildDataTile(
            value.noBloodPressure.toString() == ToggleValue.selected
                ? S.current.noPressure
                : '${value.bloodPressureD?.toString() ?? S.current.noData}/'
                    '${value.bloodPressureS?.toString() ?? S.current.noData}',
            textColor: getBloodSureColor(
              threshold: threshold,
              maxValue: value.bloodPressureD,
              minValue: value.bloodPressureS,
            ),
          ),
          _buildDataTile(
            value.respiratoryRate?.toString() ?? S.current.noData,
            textColor: getVitalColor(
              valueKey: PatientVitalKeyName.respiratoryRate,
              threshold: threshold,
              value: value.respiratoryRate,
            ),
          ),
          _buildDataTile(
            value.spO2?.toString() ?? S.current.noData,
            textColor: getVitalColor(
              threshold: threshold,
              valueKey: PatientVitalKeyName.spO2,
              value: value.spO2,
            ),
          ),
          _buildHandleOffButton(value.incidentNo),
          _buildTriage(
            value.triageType ?? '',
          ),
          _buildDataTile(
            S.current.noData,
          ),
          _buildTimerButton(value, context),
        ],
      ),
    );
  }

  Widget _buildTimerButton(PatientModel value, BuildContext context) {
    final side = BorderSide(color: context.color.outline, width: 1);

    return Container(
      width: 100,
      height: height * 1.5,
      decoration: BoxDecoration(
        border: Border(
          right: side,
        ),
      ),
      padding: const EdgeInsets.all(2),
      child: value.timerFromDate != null
          ? _buildSelectedTimerButton(value)
          : _buildSetTimerButton(value),
    );
  }

  Widget _buildSelectedTimerButton(PatientModel value) {
    final endTime = value.timerFromDate!.add(Duration(
        hours: value.timerConfiguredTime?.hour ?? 2,
        minutes: value.timerConfiguredTime?.minute ?? 0));
    return FittedBox(
      child: Column(
        children: [
          CountdownWidget(
            endTime: endTime,
            timeTextStyle: context.typography.caption?.copyWith(
                color: endTime.isBefore(DateTime.now())
                    ? context.color.error
                    : context.color.primary,
                fontWeight: FontWeight.w600),
          ),
          Builder(
            builder: (context) {
              return OutlinedButton(
                onPressed: () async {
                  final result = await showDialog<Map<String, dynamic>>(
                    context: context,
                    builder: (_) => TimerDialog(
                      initDate: value.timerFromDate,
                      initTime: value.timerConfiguredTime,
                      onDelete: () {
                        onDeleteTimer(value.incidentNo, context);
                      },
                    ),
                  );
                  if (result?["date"] == null || !mounted) return;

                  onAddTimer(
                      incidentNo: value.incidentNo,
                      patientName: value.name,
                      newDate: result!["date"]!,
                      newTime: TimeOfDay(
                        hour: result["time"]?.hour ?? 2,
                        minute: result["time"]?.minute ?? 0,
                      ),
                      context: context);
                },
                style: context.style.smallButton
                    .merge(context.style.primaryOutlinedButton),
                child: Text(
                  S.current.changeOrDelete,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void onDeleteTimer(String incidentNo, BuildContext context) {
    final patientsCubit = context.read<PatientCubit>();
    final appCubit = context.read<AppCubit>();
    patientsCubit.deleteTimer(incidentNo);
    appCubit.stopAlarm(id: incidentNo.hashCode);
  }

  void onAddTimer({
    required String incidentNo,String? patientName, required DateTime newDate, required TimeOfDay newTime,
    required BuildContext context,
  }) {
    final patientsCubit = context.read<PatientCubit>();
    final appCubit = context.read<AppCubit>();
    patientsCubit.addTimer(incidentNo, newDate, newTime);
    appCubit.addAlarmSchedule(incidentNo: incidentNo,
        date: newDate.add(Duration(hours: newTime.hour, minutes: newTime.minute)), patientName: patientName);
  }

  Widget _buildSetTimerButton(PatientModel value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9.0),
      child: Builder(builder: (context) {
        return ElevatedButton(
          onPressed: () async {
            final result = await showDialog<Map<String, dynamic>>(
              context: context,
              builder: (_) => TimerDialog(
                initDate: value.timerFromDate,
                initTime: value.timerConfiguredTime,
              ),
            );
            if (result?["date"] == null || !mounted) return;

            onAddTimer(
              incidentNo: value.incidentNo,
              patientName: value.name,
              newDate: result!["date"]!,
              newTime: TimeOfDay(
                hour: result["time"]?.hour ?? 2,
                minute: result["time"]?.minute ?? 0,
              ),
              context: context,
            );
          },
          style: context.style.primaryButton.merge(context.style.smallButton),
          child: Text(
            S.current.set,
            style: TextStyle(color: context.color.onSurface),
          ),
        );
      }),
    );
  }

  Widget _buildTriage(String type) {
    final updateLogType =
        UpdateLogDetailNameTypeX.updateLogFromEnglishName(type);
    final side = BorderSide(color: context.color.outline, width: 1);
    return Container(
      width: 100,
      height: height,
      decoration: BoxDecoration(
        border: Border(
          bottom: side,
          right: side,
        ),
      ),
      padding: const EdgeInsets.all(2),
      child: updateLogType == null
          ? Center(
              child: Text(
              S.current.noData,
              style: context.typography.bodyText2,
            ))
          : ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: updateLogType.selectedTriageColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              ),
              child: Text(updateLogType.itemName,
                  style:
                      TextStyle(color: updateLogType.selectedTriageTextColor)),
            ),
    );
  }

  Widget _buildTableHeader(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeaderTile(S.current.patientName, radiusTop: true),
        _buildHeaderTile(S.current.hr),
        _buildHeaderTile(S.current.bp),
        _buildHeaderTile(S.current.rr),
        _buildHeaderTile(S.current.spo2),
        _buildHeaderTile(S.current.handoff),
        _buildHeaderTile(S.current.triage),
        _buildHeaderTile(S.current.locationEng),
        _buildHeaderTile(
          S.current.timer,
          borderBottom: false,
          radiusBottom: true,
          isLargeHeight: true,
        ),
      ],
    );
  }

  Widget _buildHeaderTile(
    String text, {
    bool borderBottom = true,
    bool radiusTop = false,
    bool radiusBottom = false,
    bool isLargeHeight = false,
  }) {
    final side = BorderSide(color: context.color.outline, width: 1);
    return Container(
      width: 116,
      height: isLargeHeight ? height * 1.5 : height,
      decoration: BoxDecoration(
          color: context.color.tertiary,
          border: Border(
              bottom: borderBottom ? side : BorderSide.none, right: side),
          borderRadius: BorderRadius.only(
            topLeft: radiusTop ? const Radius.circular(10) : Radius.zero,
            bottomLeft: radiusBottom ? const Radius.circular(10) : Radius.zero,
          )),
      child: Center(child: Text(text, style: context.typography.bodyText2)),
    );
  }

  Widget _buildDataTile(
    String text, {
    bool borderBottom = true,
    Color? textColor,
  }) {
    final side = BorderSide(color: context.color.outline, width: 1);
    return Container(
      width: 100,
      height: height,
      decoration: BoxDecoration(
        border: Border(
          bottom: borderBottom ? side : BorderSide.none,
          right: side,
        ),
      ),
      child: Center(
          child: Text(
        text,
        style: context.typography.bodyText2?.copyWith(
          color: textColor,
        ),
        textAlign: TextAlign.center,
      )),
    );
  }

  Color? getBloodSureColor({
    int? minValue,
    int? maxValue,
    required List<ThresholdModel> threshold,
  }) {
    if (minValue == null && maxValue == null) return null;

    if (minValue == null) {
      return getVitalColor(
        threshold: threshold,
        value: maxValue,
        valueKey: PatientVitalKeyName.bloodPressureD,
      );
    }
    if (maxValue == null) {
      return getVitalColor(
        threshold: threshold,
        value: maxValue,
        valueKey: PatientVitalKeyName.bloodPressureS,
      );
    }
    final bloodMaxThreshold = threshold.firstWhereOrNull(
      (threshold) => threshold.engName == PatientVitalKeyName.bloodPressureD,
    );
    final bloodMinThreshold = threshold.firstWhereOrNull(
      (threshold) => threshold.engName == PatientVitalKeyName.bloodPressureS,
    );
    if (maxValue > (bloodMaxThreshold?.errorMax ?? 0) ||
        maxValue < (bloodMaxThreshold?.errorMin ?? 0) ||
        minValue > (bloodMinThreshold?.errorMax ?? 0) ||
        minValue < (bloodMinThreshold?.errorMin ?? 0)) {
      return AppColorTheme.instance.errorColor();
    }

    if (maxValue > (bloodMaxThreshold?.warningMax ?? 0) ||
        maxValue < (bloodMaxThreshold?.warningMin ?? 0) ||
        minValue > (bloodMinThreshold?.warningMax ?? 0) ||
        minValue < (bloodMinThreshold?.warningMin ?? 0)) {
      return AppColorTheme.instance.warningColor();
    }
    return null;
  }

  Color? getVitalColor({
    String? valueKey,
    int? value,
    required List<ThresholdModel> threshold,
  }) {
    if (valueKey == null || value == null) return null;

    final currentThreshold = threshold.firstWhereOrNull(
      (threshold) => threshold.engName == valueKey,
    );
    if (currentThreshold == null ||
        currentThreshold.errorMax == null ||
        currentThreshold.errorMin == null ||
        currentThreshold.warningMax == null ||
        currentThreshold.warningMin == null) return null;

    if (value > currentThreshold.errorMax! ||
        value < currentThreshold.errorMin!) {
      return AppColorTheme.instance.errorColor();
    }
    if (value > currentThreshold.warningMax! ||
        value < currentThreshold.warningMin!) {
      return AppColorTheme.instance.warningColor();
    }
    return null;
  }

  Widget _buildHandleOffButton(String incidentNo) {
    final side = BorderSide(color: context.color.outline, width: 1);

    return Container(
      width: 100,
      height: height,
      decoration: BoxDecoration(
        border: Border(
          bottom: side,
          right: side,
        ),
      ),
      padding: const EdgeInsets.all(2),
      child: ElevatedButton(
        onPressed: () {
          onHandleOffPressed(incidentNo);
        },
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(
                color: AppColorTheme.instance.inputOutlinedEnabledBorder()),
          ),
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        ),
        child: Text(
          S.current.handoff,
          style: TextStyle(color: context.color.onSurface),
        ),
      ),
    );
  }

  void onHandleOffPressed(String incidentNo) {
    PatientSingleton.instance.patientId = incidentNo;
    DeviceUtils.getDeviceId().then((value) {
      PatientSingleton.instance.deviceId = value;
    });
  }

  final actions = [S.current.switchLanguage, 'Download DB', 'Logout'];

  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: context.color.surface,
      title: AppBar(
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
        title: _logo(),
        backgroundColor: context.color.surface,
        elevation: 0,
        actions: [
          if (UserSingleton.instance.roleType == RoleType.role2) ...[
            spaceW24,
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ElevatedButton(
                onPressed: () {
                },
                style: context.style.primaryButton,
                child: Text(
                  S.current.map,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
          spaceW24,
          PopupMenuButton<String>(
            onSelected: (valueChoice) {
              onClickActionMenu(valueChoice, context);
            },
            itemBuilder: (_) {
              return actions.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      pinned: false,
      floating: true,
    );
  }

  void showPopupChangeLanguage(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return UnconstrainedBox(
            child: SizedBox(
              width: 250,
              child: Dialog(
                child: dialog(context),
              ),
            ),
          );
        });
  }

  Widget dialog(BuildContext context) {
    final currentLanguage = context.read<AppCubit>().state.currentLanguage;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: SizedBox(
        width: 100,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            spaceH8,
            InkWell(
              onTap: () {
                context.read<AppCubit>().changeLanguage('ja');
                context.router.maybePop();
              },
              child: Text(S.current.japanese,
                  style: TextStyle(
                      color: currentLanguage == 'ja'
                          ? context.color.primary
                          : context.color.onSurface)),
            ),
            spaceH8,
            const Divider(),
            spaceH8,
            InkWell(
                onTap: () {
                  context.read<AppCubit>().changeLanguage('en');
                  context.router.maybePop();
                },
                child: Text(
                  S.current.english,
                  style: TextStyle(
                      color: currentLanguage == 'en'
                          ? context.color.primary
                          : context.color.onSurface),
                )),
            spaceH8,
          ],
        ),
      ),
    );
  }

  Widget _logo() {
    return SizedBox(
      height: context.read<AppCubit>().appBarHeight,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              spaceH8,
              SvgPicture.asset(
                ImageAssets.zollLogSvg,
                height: 30,
                fit: BoxFit.contain,
              ),
              Text(
                'an Asahi Kasei company',
                style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w300,
                    color: context.color.onSurface),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void onClickActionMenu(String action, BuildContext context) {
    if (action == S.current.switchLanguage) {
      showPopupChangeLanguage(context);
      return;
    }
    if (action == 'Download DB') {
      shareDbFile();
      return;
    }
    SecureStorage.instance.clearAuthData();
    context.router.replaceAll([const LoginRoute()]);
  }

  Future<void> shareDbFile() async {
    final dbPath = path.join(await getDatabasesPath(), 'MyDatabase.db');
    Share.shareXFiles([XFile(dbPath)], text: 'Database');
  }
}
