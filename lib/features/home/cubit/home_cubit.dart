import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pulse_pro/features/home/view/widgets/dock/dock_controller.dart';
import 'package:pulse_pro/repositories/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pulse_pro/repositories/authentication_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required this.authenticationRepository}) : super(HomeInitial());

  final AuthenticationRepository authenticationRepository;
  final DockController dockController = DockController();

  Future<void> signOut() async {
    FirebaseAuth.instance.signOut();
  }

}