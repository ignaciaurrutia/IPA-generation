import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/shared/shared.dart';
import 'package:teslo_shop/features/products/presentation/functions/side_bar_filter.dart';

class HPSideMenu extends ConsumerStatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const HPSideMenu({
    super.key,
    required this.scaffoldKey,
  });

  @override
  HPSideMenuState createState() => HPSideMenuState();
}

class HPSideMenuState extends ConsumerState<HPSideMenu> {
  @override
  Widget build(BuildContext context) {
    final hasNotch = MediaQuery.of(context).viewPadding.top > 35;
    final textStyles = Theme.of(context).textTheme;
    final navDrawerIndex = ref.watch(filterProvider).index;

    return NavigationDrawer(
      elevation: 1,
      selectedIndex: navDrawerIndex,
      onDestinationSelected: (value) {
        // setState(() {
        //   ref.read(filterProvider.notifier).setFilter(FilterOption.values[value]);
        // });
        widget.scaffoldKey.currentState?.closeDrawer();
      },
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20, hasNotch ? 0 : 20, 16, 0),
          child: Text('Menú', style: textStyles.titleMedium),
        ),
        const SizedBox(height: 30),
        // const NavigationDrawerDestination(
        //   icon: Icon(Icons.home_outlined),
        //   label: Text('Apellidos A - Z'),
        // ),
        // const SizedBox(height: 10),
        // const NavigationDrawerDestination(
        //   icon: Icon(Icons.arrow_downward),
        //   label: Text('Fecha de Parto Descendiente'),
        // ),
        // const SizedBox(height: 10),
        // const NavigationDrawerDestination(
        //   icon: Icon(Icons.arrow_upward),
        //   label: Text('Fecha de Parto Ascendente'),
        // ),
        // const Padding(
        //   padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
        //   child: Divider(),
        // ),
        // const Padding(
        //   padding: EdgeInsets.fromLTRB(28, 10, 16, 10),
        //   child: Text('Otras opciones'),
        // ),
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