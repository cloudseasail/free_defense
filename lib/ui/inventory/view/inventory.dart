import '../../../game_controller/game_controller.dart';
import '../../../ui/inventory/bloc/inventory_bloc.dart';

import '../../../weapon/weapon_component.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Inventory extends StatefulWidget {
  const Inventory({Key? key}) : super(key: key);

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<InventoryBloc>().state;
    final List<WeaponType> weapons = state.listWeapons;
    return Material(
      child: SizedBox(
        height: 100,
        child: Row(children: [
          ...[
            for (int i = 0; i < weapons.length; i++)
              GestureDetector(
                onTap: () {
                  if (weapons[i] != state.weapon) {
                    final controller = context.read<GameController>();
                    controller.send(controller, GameControl.weaponSelected);
                    context
                        .read<InventoryBloc>()
                        .add(InvWeaponSelected(weapons[i]));
                  }
                },
                child: Opacity(
                  opacity: weapons[i] == state.weapon ? 1.0 : 0.4,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox.fromSize(
                        size: const Size(64, 64),
                        child: Image.asset(
                            'assets/images/weapon/${state.weaponPath[i]}.png'),
                      ),
                      Container(
                        color: Colors.white,
                        width: 64,
                        height: 30,
                        child: Text(
                          '${weapons[i].name} \n ${state.weaponCost.isNotEmpty ? state.weaponCost[i] : "empty"}',
                          style: TextStyle(
                              color: weapons[i] == state.weapon
                                  ? Colors.black
                                  : Colors.black54),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ]
              .expand((w) => [
                    w,
                    const SizedBox(
                      width: 40,
                    )
                  ])
              .toList()
            ..insert(
              0,
              const SizedBox(
                width: 40,
              ),
            )
        ]),
      ),
    );
  }
}
