class User {
  final String uid, email, fullName, photoUrl;
  final bool isEmailVerified;
  final Function sendEmailVerification;

  User({ this.uid, this.email, this.fullName, this.photoUrl, this.isEmailVerified, this.sendEmailVerification });
}
