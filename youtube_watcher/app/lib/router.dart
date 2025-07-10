import 'package:app/screens/screens.dart';
import 'package:go_router/go_router.dart';

final valuesInputRoute = GoRoute(
  path: '/values',
  builder: (context, state) => const ValuesInputScreen(),
);
final chatScreenRoute = GoRoute(
  path: '/chat',
  builder: (context, state) => const ChatScreen(),
);

final appRouter = GoRouter(
  routes: [
    valuesInputRoute,
    chatScreenRoute,
  ],
  initialLocation: valuesInputRoute.path,
);
