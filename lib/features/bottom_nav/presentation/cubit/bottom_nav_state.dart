part of 'bottom_nav_cubit.dart';

abstract class BottomNavState extends Equatable {
  final int index;
  const BottomNavState(this.index);

  @override
  List<Object> get props => [index];
}

class BottomNavInitial extends BottomNavState {
  const BottomNavInitial(super.index);
}

class BottomNavChanged extends BottomNavState {
  const BottomNavChanged(super.index);
}
