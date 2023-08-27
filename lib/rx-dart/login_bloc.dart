class LoginBloc extends Object with Validators implements BaseBloc {
  final _mobileController = BehaviorSubject<String>.seeded("74785637");
  final _passWordController = BehaviorSubject<String>.seeded("Aahana@2014");
  final _isLoading = BehaviorSubject<bool>();
  final _isObscure = BehaviorSubject<bool>.seeded(true);
  final CustomLogger customLogger = CustomLogger();
  final LoginRepository loginRepository = LoginRepository();
  AppStorage appStorage = getIt<AppStorage>();

  @override
  dispose() {
    customLogger.logger(name: "dispose 14", msg: "Disposed");
    _mobileController.close();
    _passWordController.close();
    _isLoading.close();
  }

  ///input
  Function(String) get mobChanged => _mobileController.sink.add;

  Function(String) get passChanged => _passWordController.sink.add;

  Function(bool) get obscuredTapped => _isObscure.sink.add;

  /// output
  Stream<String> get mobileStream =>
      _mobileController.stream.transform(mobileValidator);

  Stream<String> get passwordStream =>
      _passWordController.stream.transform(passwordValidator);

  Stream<bool> get isLoading => _isLoading.stream;

  Stream<bool> get isSubmitCheck =>
      Rx.combineLatest2(mobileStream, passwordStream, (a, b) => true);

  Stream<bool> get isObscure => _isObscure.stream;

  setLoading(bool value) {
    _isLoading.sink.add(value);
  }

  submit(BuildContext context) {
    setLoading(true);
    loginRepository
        .login(mob: _mobileController.value, pass: _passWordController.value)
        .then((value) {
      setLoading(false);
      value.fold((l) {
        CustomSnackBar.showSnackBar(context: context, msg: l.error);
      }, (r) {
        if (r.status ?? false) {
          appStorage.setLogin = true;
          appStorage.setAccessToken = r.result!.accessToken ?? "";
          Navigator.pushNamed(context, AppRoutes.dashboard);
        } else {
          print('msg: ${r.result?.msg}');
          CustomSnackBar.showSnackBar(
              context: context, msg: r.result?.msg ?? "");
        }
      });
    });
  }
}
