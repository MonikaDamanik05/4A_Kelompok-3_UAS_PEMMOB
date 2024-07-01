part of 'data_login_cubit.dart';


@immutable
class DataLoginState {
  final String roles;
  final int idUser;

 const DataLoginState({required this.roles, required this.idUser});
}

final class DataLoginInitial extends DataLoginState {
  const DataLoginInitial() : super(idUser: 0, roles: 'umum' );
}