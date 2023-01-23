import 'package:film_freak/screens/counter_page/counter_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'counter_page.dart';

class BlocCounterTest extends StatelessWidget {
  const BlocCounterTest({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterBloc(),
      child: const CounterPage(),
    );
  }
}
