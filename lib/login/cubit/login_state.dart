part of 'login_cubit.dart';

enum StatusLogin { login, register, success, loading }

class LoginState extends Equatable {
  const LoginState({
    this.status = StatusLogin.login,
    this.isError = false,
    this.errorName = '',
    this.appNames,
    this.currentName,
    this.currentUser,
    this.currentPassword,
    this.activateCurrent = false,
  });

  final StatusLogin status;
  final bool isError;
  final String errorName;
  final List<String>? appNames;
  final String? currentName;
  final String? currentUser;
  final String? currentPassword;
  final bool activateCurrent;

  @override
  List<Object?> get props => [
        status,
        isError,
        errorName,
        appNames,
        currentName,
        currentUser,
        currentPassword,
        activateCurrent
      ];

  LoginState copyWith({
    StatusLogin? status,
    bool? isError,
    String? errorName,
    List<String>? appNames,
    String? currentName,
    String? currentUser,
    String? currentPassword,
    bool? activateCurrent,
  }) {
    return LoginState(
      status: status ?? this.status,
      isError: isError ?? this.isError,
      errorName: errorName ?? this.errorName,
      appNames: appNames ?? this.appNames,
      currentName: currentName ?? this.currentName,
      currentUser: currentUser ?? this.currentUser,
      currentPassword: currentPassword ?? this.currentPassword,
      activateCurrent: activateCurrent ?? this.activateCurrent,
    );
  }
}
