import 'package:auto_route/auto_route.dart';
import 'package:azmod/presentation/patients/ui/patient_ipad_screen.dart';
import 'package:azmod/presentation/patients/ui/patient_mobile_screen.dart';
import 'package:azmod/widgets/common/screen_builder.dart';
import 'package:flutter/material.dart';

@RoutePage()
class PatientsScreen extends StatelessWidget {
  const PatientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScreenBuilder(
      ipadScreen: PatientsIpadScreen(),
      mobileScreen: PatientsMobileScreen(),
    );
  }
}
