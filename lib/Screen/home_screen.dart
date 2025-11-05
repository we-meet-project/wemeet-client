import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wemeet_client/Manager/PermissionManager.dart';
import 'package:wemeet_client/ViewModel/home_view_model.dart';
import 'package:wemeet_client/di/dependency_factory.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel(
        permissionManager: context.read<Permissionmanager>(),
        factory: context.read<DependencyFactory>(),
      ),
      child: Scaffold(
        appBar: AppBar(title: const Text("View 알람 테스트")),
        body: Consumer<HomeViewModel>(
          builder: (context, viewModel, child) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: viewModel.state == ViewState.loading
                        ? null
                        : () {
                            viewModel.run();
                          },
                    child: const Text("Hello"),
                  ),
                  const SizedBox(height: 16),

                  if (viewModel.state == ViewState.loading)
                    const Center(child: CircularProgressIndicator())
                  else
                    Text(
                      viewModel.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: viewModel.state == ViewState.error
                            ? Colors.red
                            : Colors.green,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
