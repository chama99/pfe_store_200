class ModelUser {
  String email;
  String password;
  String role;
  String urlimg;
  ModelUser(
      {required this.email,
      required this.password,
      required this.role,
      required this.urlimg});
  // ignore: unused_element
  String get getemail => email;
  // ignore: unused_element
  String get getpassword => password;
  // ignore: unused_element
  String get getrole => role;
  // ignore: unused_element
  String get geturlimg => urlimg;
  set setemail(e) => email = e;
  set setpassword(p) => password = p;
  set setrole(r) => role = r;
  set seturlimg(u) => urlimg = u;
}
