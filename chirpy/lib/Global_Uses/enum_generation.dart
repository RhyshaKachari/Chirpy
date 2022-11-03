enum EmailSignUpResults {
  SignUpCompleted,
  EmailAlreadyPresent,
  SignUpNotCompleted,
}

enum EmailSignInResults {
  SignInCompleted,
  EmailNotVerified,
  EmailOrPasswordInvalid,
  UnexpectedError,
}

enum GoogleSignInResults {
  SignInCompleted,
  SignInNotCompleted,
  UnexpectedError,
  AlreadySignedIn,
}
