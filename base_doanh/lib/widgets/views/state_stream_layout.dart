import 'package:flutter/material.dart';
import 'package:hapycar/data/exception/app_exception.dart';
import 'package:hapycar/widgets/views/state_layout.dart';

class StateStreamLayout extends StatelessWidget {
  final Stream<StateLayout> stream;
  final Widget child;
  final AppException error;
  final Function() retry;
  final dynamic textEmpty;

  const StateStreamLayout({
    required this.stream,
    required this.child,
    required this.error,
    required this.retry,
    required this.textEmpty,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<StateLayout>(
      stream: stream,
      builder: (context, snapshot) {
        return StateFullLayout(
          retry: retry,
          textEmpty: textEmpty,
          stateLayout: snapshot.data ?? StateLayout.showLoading,
          error: error,
          child: child,
        );
      },
    );
  }
}
