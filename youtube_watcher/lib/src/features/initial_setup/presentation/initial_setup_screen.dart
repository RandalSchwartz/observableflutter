import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_watcher/src/features/initial_setup/data/initial_setup_providers.dart';

class InitialSetupScreen extends ConsumerStatefulWidget {
  const InitialSetupScreen({super.key});

  @override
  ConsumerState<InitialSetupScreen> createState() => _InitialSetupScreenState();
}

class _InitialSetupScreenState extends ConsumerState<InitialSetupScreen> {
  final _apiKeyController = TextEditingController();
  final _videoIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final credentialsRepository = ref.read(credentialsRepositoryProvider);
    _apiKeyController.text = credentialsRepository.getApiKey() ?? '';
    _videoIdController.text = credentialsRepository.getVideoId() ?? '';
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _videoIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final credentialsRepository = ref.watch(credentialsRepositoryProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('YouTube Live Chat Viewer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _apiKeyController,
              decoration: const InputDecoration(
                labelText: 'API Key',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _videoIdController,
              decoration: const InputDecoration(
                labelText: 'Video ID',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                credentialsRepository.setApiKey(_apiKeyController.text);
                credentialsRepository.setVideoId(_videoIdController.text);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}