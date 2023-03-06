import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  final String? _message;

  const EmptyView(this._message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        _message ?? '',
        style: const TextStyle(color: Colors.black, fontSize: 16),
      ),
    );
  }
}
