import 'package:flutter/material.dart';
import 'package:auth0_flutter/auth0_flutter.dart'; // Import the Auth0 package
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/auth/presentation/providers/providers.dart';
import 'package:teslo_shop/features/shared/shared.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: size.width,
                height: size.width / 1.6, // Adjust the height as needed
                child: Image.asset(
                  'assets/images/miTribu.png',
                  fit: BoxFit.fill, // Fill the assigned space
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: size.height - 260, // 80 los dos sizebox y 100 el ícono
                width: double.infinity,
                decoration: BoxDecoration(
                  color: scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(100)),
                ),
                child: const _LoginForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends ConsumerWidget {
  const _LoginForm();

  void openDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false, // No se puede cerrar con el botón de atrás
      context: context,
      builder: (context) { // builder se construye en tiempo de ejecución
        return AlertDialog(
          title: const Text('Términos y condiciones de uso'),
          // content: const SingleChildScrollView (child: Text('Al utilizar cualquiera de los servicios de Mi Tribu, usted acepta las siguientes condiciones de uso:\n \na. Derechos de autor\nMi Tribu tiene los derechos de autor y de uso exclusivo sobre todo el material en formato PDF, imágenes, videos grabados, actividades grabadas, sesiones por Zoom y creaciones relacionadas a las usuarias. Se prohíbe expresamente cualquier distribución con fines comerciales o mal uso del material por parte de los tratantes, así como su compartición con personas ajenas a la comunidad.\n \nb. Sana Convivencia\nEn nuestro servicio promovemos una cultura de sana convivencia y de responsabilidad con los demás. Esto implica un trato cortés hacia todas las personas, tanto pares como matronas u otros profesionales de Mi Tribu, el mantenimiento de un ambiente de respeto dentro de la comunidad y el acatamiento de las reglas establecidas. En el caso de las teleconsultas ofrecidad por Mi Tribu, es importante mantener la misma formalidad que en las consultas presenciales: ser puntual, respetuoso, concentrado y brindar atención exclusiva. Asegúrate de tener una buena conexión y privacidad, evitando interrupciones y distracciones. Estas medidas son esenciales para garantizar una experiencia positiva y constructiva para todos los profesionales y pacientes en nuestra plataforma. Cualquier acto que se considere no cumple lo anteriormente dicho, puede significar la desvinculación inmediata con Mi Tribu. \n \nc. Derechos de Mi Tribu \nMi Tribu tiene la facultad de no admitir la participación de tratantes, según criterios internos de exclusión, que puedan influir en la correcta prestación de nuestros servicios. Nos comprometemos a ofrecer los servicios especificados en cada plan o teleconsulta; no obstante, es importante tener en cuenta que las usuarias involucradas, pueden cambiar con el tiempo. Además, nos reservamos el derecho de cancelar eventos o ajustar fechas según sea necesario para mantener la calidad y efectividad de nuestros servicios.')),
          content: SingleChildScrollView(
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium, // Estilo predeterminado
                children: const [
                  TextSpan(
                    text: 'Al utilizar cualquiera de los servicios de Mi Tribu, usted acepta las siguientes condiciones de uso:\n\n',
                  ),
                  TextSpan(
                    text: 'a. Derechos de autor\n\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: 'Mi Tribu tiene los derechos de autor y de uso exclusivo sobre todo el material en formato PDF, imágenes, videos grabados, actividades grabadas, sesiones por Zoom y creaciones relacionadas a las usuarias. Se prohíbe expresamente cualquier distribución con fines comerciales o mal uso del material por parte de los tratantes, así como su compartición con personas ajenas a la comunidad.\n\n',
                  ),
                  TextSpan(
                    text: 'b. Sana Convivencia\n\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: 'En nuestro servicio promovemos una cultura de sana convivencia y de responsabilidad con los demás. Esto implica un trato cortés hacia todas las personas, tanto pares como matronas u otros profesionales de Mi Tribu, el mantenimiento de un ambiente de respeto dentro de la comunidad y el acatamiento de las reglas establecidas.\n\nEn el caso de las teleconsultas ofrecidad por Mi Tribu, es importante mantener la misma formalidad que en las consultas presenciales: ser puntual, respetuoso, concentrado y brindar atención exclusiva. Asegúrate de tener una buena conexión y privacidad, evitando interrupciones y distracciones.\n\nEstas medidas son esenciales para garantizar una experiencia positiva y constructiva para todos los profesionales y pacientes en nuestra plataforma. Cualquier acto que se considere no cumple lo anteriormente dicho, puede significar la desvinculación inmediata con Mi Tribu.\n\n',
                  ),
                  TextSpan(
                    text: 'c. Derechos de Mi Tribu\n\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: 'Mi Tribu tiene la facultad de no admitir la participación de tratantes, según criterios internos de exclusión, que puedan influir en la correcta prestación de nuestros servicios.\n\nNos comprometemos a ofrecer los servicios especificados en cada plan o teleconsulta; no obstante, es importante tener en cuenta que las usuarias involucradas, pueden cambiar con el tiempo.\n\nAdemás, nos reservamos el derecho de cancelar eventos o ajustar fechas según sea necesario para mantener la calidad y efectividad de nuestros servicios.',
                  ),
                ],
              ),
            ),
          ),
          actions: [
            FilledButton(onPressed: () {
              Navigator.of(context).pop();
            }, child: const Text('Confirmar')) // FilledButton es un widget personalizado (ver carpeta widgets/c
          ],
        );
      },
    );
  }

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> saveCredentials(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('savedEmail', email); // Save the email locally
  }

  Future<void> loginWithAuth0(BuildContext context, WidgetRef ref) async {
    final auth0 = Auth0(dotenv.env["AUTH0_DOMAIN"]!, dotenv.env['AUTH0_CLIENT_ID']!);

    // Determine the platform-specific redirect URL
    final redirectUrl = Platform.isAndroid
      ? 'flutterdemo://dev-s4822gfw7v8k0olc.us.auth0.com/android/com.example.teslo_shop/callback'
      : 'flutterdemo://dev-s4822gfw7v8k0olc.us.auth0.com/ios/com.example.teslo_shop/callback'; // Update this with your iOS callback URL


    try {
      final credentials = await auth0.webAuthentication(scheme: dotenv.env['AUTH0_CUSTOM_SCHEME']).login(
        audience: 'stork_api',
          scopes: {'openid', 'profile', 'email'},
          redirectUrl: redirectUrl,
          useHTTPS: true,
          parameters: {
            'prompt': 'login',
            'audience': 'stork_api',
            'scope': 'openid profile email',
            'redirect_uri': redirectUrl,
          },
      );
      final email = credentials.user.email ?? 'default@email.com'; // Provide a default email

      print(credentials.accessToken);


      ref.read(loginFormProvider.notifier).loginAuth0(email, credentials.accessToken);

      // Save credentials locally, if needed
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setString('auth0_id_token', credentials.idToken);
      await prefs.setString('auth0_access_token', credentials.accessToken);
      // String accessToken = credentials.accessToken;
      // print(accessToken);

      showSnackbar(context, 'Login successful');
    } catch (e) {
      showSnackbar(context, 'Login failed: $e');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final loginForm = ref.watch(loginFormProvider);

    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage.isEmpty) return;
      showSnackbar(context, next.errorMessage);
    });

    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          const SizedBox(height: 5),
          Center(
            child: Text(
              'Mi Tribu Stork',
              style: textStyles.titleLarge?.copyWith(
                color: const Color.fromRGBO(89, 89, 89, 1),
              ),
            ),
          ),
          Text(
            'Seguimiento de Pacientes',
            style: textStyles.bodyLarge?.copyWith(
              color: const Color.fromRGBO(127, 127, 127, 1),
            ),
          ),
          const SizedBox(height: 120),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: CustomFilledButton(
              text: 'Iniciar Sesión',
              buttonColor: const Color.fromARGB(255, 29, 138, 146),
              onPressed: () => loginWithAuth0(context, ref),
            ),
          ),
          const Spacer(flex: 2),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                  'Al registrarte en la aplicación, estás aceptando nuestros'),
              TextButton(
                onPressed: () => openDialog(context),
                child: const Text(
                  'Términos y condiciones de uso',
                  style: TextStyle(
                      color: Color.fromRGBO(29, 138, 146, 1)),
                ),
              )
            ],
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
