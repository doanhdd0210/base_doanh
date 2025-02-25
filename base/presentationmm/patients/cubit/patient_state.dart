part of 'patient_cubit.dart';

@freezed
class PatientState with _$PatientState {
  const factory PatientState.initial({
    @Default([]) List<PatientModel> patients,
    @Default([]) List<ThresholdModel> threshold,
}) = _Initial;
}
