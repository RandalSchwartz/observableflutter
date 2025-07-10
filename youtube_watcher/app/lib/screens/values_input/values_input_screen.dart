import 'package:app/router.dart';
import 'package:app/screens/screens.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' hide RadioGroup;

class ValuesInputScreen extends StatefulWidget {
  const ValuesInputScreen({super.key});

  @override
  State<ValuesInputScreen> createState() => _ValuesInputScreenState();
}

class _ValuesInputScreenState extends State<ValuesInputScreen> {
  final _apiKeyController = TextEditingController();
  final _videoIdController = TextEditingController();

  late final ValuesRepository _valuesRepo;

  @override
  void initState() {
    _valuesRepo = GetIt.I<ValuesRepository>();
    _apiKeyController.text = _valuesRepo.apiKey ?? '';
    _videoIdController.text = _valuesRepo.videoId ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Spacer(),
            _TextInputWidget(
              display: 'API Key',
              obscureText: true,
              controller: _apiKeyController,
            ),
            SizedBox(height: 24),
            _TextInputWidget(
              display: 'Video Id',
              controller: _videoIdController,
            ),
            SizedBox(height: 24),
            Button.primary(
              onPressed: () {
                _valuesRepo.setApiKey(
                  _apiKeyController.text.isEmpty
                      ? null
                      : _apiKeyController.text,
                );
                _valuesRepo.setVideoId(
                  _videoIdController.text.isEmpty
                      ? null
                      : _videoIdController.text,
                );
                if (_videoIdController.text.isNotEmpty &&
                    _apiKeyController.text.isNotEmpty) {
                  context.go(chatScreenRoute.path);
                }
              },
              child: Text('Save'),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _videoIdController.dispose();
    super.dispose();
  }
}

class _TextInputWidget extends StatelessWidget {
  const _TextInputWidget({
    required this.display,
    required this.controller,
    this.obscureText = false,
    super.key,
  });

  final String display;
  final TextEditingController controller;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Text(display),
          SizedBox(height: 16),
          TextField(
            controller: controller,
            obscureText: obscureText,
          ),
        ],
      ),
    );
  }
}
