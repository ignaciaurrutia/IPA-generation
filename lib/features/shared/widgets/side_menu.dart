import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/shared/shared.dart';
import 'package:teslo_shop/features/products/presentation/functions/side_bar_filter.dart';
import 'package:go_router/go_router.dart';


class SideMenu extends ConsumerStatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const SideMenu({
    super.key,
    required this.scaffoldKey,
  });

  @override
  SideMenuState createState() => SideMenuState();
}

class SideMenuState extends ConsumerState<SideMenu> {
  @override
  Widget build(BuildContext context) {
    final hasNotch = MediaQuery.of(context).viewPadding.top > 35;
    final textStyles = Theme.of(context).textTheme;
    final navDrawerIndex = ref.watch(filterProvider).index;
    final email = ref.watch(authProvider).user?.email ?? "";
    final isAdmin = ref.watch(authProvider).user?.isAdmin ?? false;

    return NavigationDrawer(
      elevation: 1,
      selectedIndex: navDrawerIndex,
      onDestinationSelected: (value) {
        setState(() {
          ref.read(filterProvider.notifier).setFilter(FilterOption.values[value]);
        });
        widget.scaffoldKey.currentState?.closeDrawer();
      },
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20, hasNotch ? 0 : 20, 16, 0),
          child: Text('Ordenar por', style: textStyles.titleMedium),
        ),
        const SizedBox(height: 30),
        const NavigationDrawerDestination(
          icon: Icon(Icons.home_outlined),
          label: Text('Apellidos A - Z'),
        ),
        const SizedBox(height: 10),
        const NavigationDrawerDestination(
          icon: Icon(Icons.arrow_downward),
          label: Text('Fecha de parto descendente'),
        ),
        const SizedBox(height: 10),
        const NavigationDrawerDestination(
          icon: Icon(Icons.arrow_upward),
          label: Text('Fecha de parto ascendente'),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
          child: Divider(),
        ),
        // const Padding(
        //   padding: EdgeInsets.fromLTRB(28, 10, 16, 10),
        //   child: Text('Otras opciones'),
        // ),
        if (!isAdmin)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomFilledButton(
              onPressed: () {
                GoRouter.of(context).push('/health_provider/$email');
              },
              text: 'Mi Perfil',
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomFilledButton(
            onPressed: () {
              ref.read(authProvider.notifier).logout();
            },
            text: 'Cerrar sesión',
          ),
        ),
      ],
    );
  }
}