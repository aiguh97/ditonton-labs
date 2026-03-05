import 'package:flutter/material.dart';

class CounterWidget extends StatefulWidget {
  final int initialValue;
  const CounterWidget({Key? key, this.initialValue = 0}) : super(key: key);

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  late int _count;

  @override
  void initState() {
    super.initState();
    _count = widget.initialValue;
  }

  void _increment() => setState(() => _count++);
  void _decrement() => setState(() => _count--);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Count: $_count', key: const Key('counterText')),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              key: const Key('decrementButton'),
              onPressed: _decrement,
              child: const Icon(Icons.remove),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              key: const Key('incrementButton'),
              onPressed: _increment,
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ],
    );
  }
}
