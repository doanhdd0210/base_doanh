import 'dart:math';

import 'package:azmod/domain/locals/secure_store/auth_storage.dart';
import 'package:azmod/domain/model/authentication/user_model.dart';
import 'package:azmod/domain/model/log_detail/update_log_model.dart';
import 'package:azmod/domain/model/patient/patient_model.dart';
import 'package:azmod/domain/model/threshold/threshold_model.dart';
import 'package:azmod/domain/model/timer/timer_model.dart';
import 'package:azmod/domain/model/update_log_detail/update_log_detail_model.dart';
import 'package:azmod/domain/repository/dt_timer_repository.dart';
import 'package:azmod/domain/repository/master/thresold_repository.dart';
import 'package:azmod/domain/repository/update_log_detail_repository.dart';
import 'package:azmod/domain/repository/update_log_repository.dart';
import 'package:azmod/domain/singleton/patient_singleton.dart';
import 'package:azmod/domain/singleton/user_singleton.dart';
import 'package:azmod/utils/constants/app_constants.dart';
import 'package:azmod/utils/device_manger.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'patient_cubit.freezed.dart';
part 'patient_state.dart';

class PatientCubit extends Cubit<PatientState> {
  PatientCubit({
    required this.updateLogRepo,
    required this.updateLogDetailRepo,
    required this.thresholdRepository,
    required this.timerRepository,
  }) : super(const PatientState.initial());

  final UpdateLogRepository updateLogRepo;
  final UpdateLogDetailRepository updateLogDetailRepo;
  final ThresholdRepository thresholdRepository;
  final DTTimerRepository timerRepository;

  void initData() {
    getPatients();
    getThreshold();
  }

  Future<void> getPatients() async {
    final result = await updateLogRepo.getPatients();
    emit(state.copyWith(patients: result));
  }

  Future<void> getThreshold() async {
    final result = await thresholdRepository.getAllThreshold();
    emit(state.copyWith(threshold: result));
  }

  Future<void> createPatient() async {
    final [deviceID as String, user as UserModel?] = await Future.wait([
      DeviceUtils.getDeviceId(),
      SecureStorage.instance.getAuthData(),
    ]);

    final patientID = await generateUniquePatientID();

    final incidentNo = patientID + generateUniqueNumber();
    final rs = await updateLogRepo.createLog(UpdateLogModel(
        deviceID: deviceID,
        patientID: patientID,
        incidentNo: incidentNo,
        userID: UserSingleton.instance.userId?.toString() ?? ''));
    if (rs > 0) {
      await Future.wait([
        insertFirstResponder(incidentNo,
            '${user?.lastName ?? ''} ${user?.firstName ?? ''}'.trim()),
        insertInjuryDate(incidentNo),
        insertDateOfBird(incidentNo),
      ]);
      PatientSingleton.instance.patientId = incidentNo;
      PatientSingleton.instance.deviceId = deviceID;
    }
  }

  Future<void> insertInjuryDate(String incidentNo) async {
    await updateLogDetailRepo.insertLogDetail(
      updateLogDetail: UpdateLogDetailModel(
        incidentNo: incidentNo,
        screenID: ScreenId.personalInfo,
        updateLogDetailNameType: UpdateLogDetailNameType.injuaryDatetime,
        value: DateTime.now().toIso8601String(),
        timeStamps: DateTime.now().toIso8601String(),
      ),
    );
  }

  Future<void> insertFirstResponder(String incidentNo, String value) async {
    await updateLogDetailRepo.insertLogDetail(
      updateLogDetail: UpdateLogDetailModel(
        incidentNo: incidentNo,
        screenID: ScreenId.personalInfo,
        updateLogDetailNameType: UpdateLogDetailNameType.firstResponder,
        value: value,
        timeStamps: DateTime.now().toIso8601String(),
      ),
    );
  }

  Future<void> insertDateOfBird(String incidentNo) async {
    await updateLogDetailRepo.insertLogDetail(
      updateLogDetail: UpdateLogDetailModel(
        incidentNo: incidentNo,
        screenID: ScreenId.personalInfo,
        updateLogDetailNameType: UpdateLogDetailNameType.dateOfBirth,
        value: DateTime(1990, 1, 1).toIso8601String(),
        timeStamps: DateTime.now().toIso8601String(),
      ),
    );
  }

  Future<String> generateUniquePatientID() async {
    String patientID = await updateLogRepo.getNewPatientID();
    return patientID;
  }

  String generateUniqueNumber() {
    var random = Random();
    int randomNumber = random.nextInt(999999) + 1;
    return randomNumber.toString().padLeft(6, '0');
  }

  Future<void> addTimer(
      String incidentNo, DateTime fromDate, TimeOfDay configuredTime) async {
    final userInfo = await SecureStorage.instance.getAuthData();
    await timerRepository.insertOrUpdateTimer(TimerModel(
      incidentNo: incidentNo,
      from: fromDate,
      updateDatetime: DateTime.now(),
      configuredTime: configuredTime,
      updateUserID: userInfo?.userID,
    ));
    getPatients();
  }

  Future<void> deleteTimer(String incidentNo) async {
    await timerRepository.deleteTimer(incidentNo);
    getPatients();
  }
}

