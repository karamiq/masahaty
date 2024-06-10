
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class ErrorNotifications extends StatelessWidget {
   ErrorNotifications({
    required snapshot,
    super.key,
  });
  dynamic snapshot;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Error: ${snapshot.error}'),
    );
  }
}
