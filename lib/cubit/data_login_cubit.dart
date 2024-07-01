import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'data_login_state.dart';

class DataLoginCubit extends Cubit<DataLoginState> {
  DataLoginCubit() : super(const DataLoginInitial());

  void setProfile(String roles, int idUser){
    emit(DataLoginState(roles: roles, idUser: idUser));
  }
}