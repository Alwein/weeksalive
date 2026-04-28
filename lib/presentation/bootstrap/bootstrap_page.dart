import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:weeksalive/presentation/bootstrap/view_model/bootstrap_page_view_model.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';

class BootstrapPage extends StatelessWidget {
  const BootstrapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BootstrapPageViewModel>(
      converter: BootstrapPageViewModel.create,
      builder: (context, viewModel) {
        return const Scaffold(body: Placeholder());
      },
    );
  }
}
