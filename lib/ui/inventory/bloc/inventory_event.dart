part of 'inventory_bloc.dart';

abstract class InventoryEvent extends Equatable {
  const InventoryEvent();
  @override
  List<Object> get props => [];
}

class InvWeaponSelected extends InventoryEvent {
  const InvWeaponSelected(this.type);
  final WeaponType type;
}

class InvSetCost extends InventoryEvent {
  const InvSetCost({required this.cost, required this.index});
  final int cost;
  final int index;
}

class InvAddCost extends InventoryEvent {
  const InvAddCost({required this.index});
  final int index;
}

class InvSubstractCost extends InventoryEvent {
  const InvSubstractCost({required this.index});
  final int index;
}

class InvInit extends InventoryEvent {}

class InvShow extends InventoryEvent {}

class InvHide extends InventoryEvent {}

class InvReset extends InventoryEvent {}
