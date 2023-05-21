import 'package:flutter/material.dart';

class AppFutureBuilder<T> extends StatefulWidget {
  final Future<T> future;
  final Widget Function(bool isCompleted, T? data) builder;
  const AppFutureBuilder(
      {super.key, required this.future, required this.builder});

  @override
  State<AppFutureBuilder<T>> createState() => _AppFutureBuilderState<T>();
}

class _AppFutureBuilderState<T> extends State<AppFutureBuilder<T>> {
  late bool isCompleted;
  late T? data;

  Future<void> getFuture() async {
    await widget.future.then((value) {
      setState(() {
        data = value;
        isCompleted = true;
        print("datat in future $data");
      });
    });
  }

  @override
  void initState() {
    super.initState();
    isCompleted = false;
    data = null;
    print("future inin state");
    getFuture();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(isCompleted, data);
  }
}
