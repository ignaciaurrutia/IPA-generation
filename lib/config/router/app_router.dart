import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/auth/auth.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/health_provider/presentation/screens/screens.dart';
import 'package:teslo_shop/features/products/products.dart';
import 'package:teslo_shop/features/shared/shared.dart';
import 'app_router_notifier.dart';

final goRouterProvider = Provider((ref) {

  final goRouterNotifier = ref.read(goRouterNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: goRouterNotifier,
    routes: [
      ///* Primera pantalla
      GoRoute(
        path: '/splash',
        builder: (context, state) => const CheckAuthStatusScreen(),
      ),

      ///* Auth Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      ///* Product Routes
      GoRoute(
        path: '/',
        builder: (context, state) {
          final isAdmin = ref.watch(authProvider).user?.isAdmin ?? false;
          return PatientsScreen(isAdmin: isAdmin);
          },
      ),
      GoRoute(
        path: '/patient/:email',
        builder: (context, state) {
          final isAdmin = ref.watch(authProvider).user?.isAdmin ?? false;
          return PatientScreen(
            patientEmail: Email.dirty(state.pathParameters['email'] ?? 'no-email'),
            isAdmin: isAdmin,
          );
        },
      ),
      GoRoute(
        path: '/patient_edit/:email', // /patient_edit/new
        builder: (context, state) => PatientEditScreen(
          patientEmail: Email.dirty(state.pathParameters['email'] ?? 'no-email'),
          request: state.pathParameters['email'] != 'new' ? 'PUT' : 'POST'
        ),
      ),

      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminScreen(),
      ),
      GoRoute(
        path: '/health_provider/:email', // /health_provider/new
        builder: (context, state) => HealthProviderEditViewScreen(
          healthProviderEmail: state.pathParameters['email'] ?? 'no-email',
          request: state.pathParameters['email'] != 'new' ? 'PUT' : 'POST',
        ),
      ),

    ],

    redirect: (context, state) {
      
      final isGoingTo = state.matchedLocation;
      final authStatus = goRouterNotifier.authStatus;

      if ( isGoingTo == '/splash' && authStatus == AuthStatus.checking ) return null;

      if ( authStatus == AuthStatus.notAuthenticated ) {
        if ( isGoingTo == '/login' || isGoingTo == '/register' ) return null;

        return '/login';
      }

      if ( authStatus == AuthStatus.authenticated ) {
        if ( isGoingTo == '/login' || isGoingTo == '/register' || isGoingTo == '/splash' ){
            final isAdmin = ref.watch( authProvider ).user?.isAdmin;
           if (isAdmin!) {
            return '/admin';
           }
           return '/';
        }
      }


      return null;
    },
  );
});