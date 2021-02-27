import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'dart:async';
import 'package:flutter_quotebook/utils/UtilsImporter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quotebook/model/UserBean.dart';

class FirebaseAuthUtils {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FacebookLogin facebookSignIn = new FacebookLogin();

  Future<UserBean> googleLogin(BuildContext context) async {
    UserBean bean;
    User user;
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    try {
      user = (await _auth.signInWithCredential(credential)).user;
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = await _auth.currentUser;
      assert(user.uid == currentUser.uid);
    } on PlatformException catch (e) {
      UtilsImporter().commanUtils.showToast(e.message, context);
    }
    if (user != null) {
      bean = new UserBean(user.displayName, user.email, user.photoURL, true,
          user.uid, 'google', '');
    } else {
      bean = new UserBean('', '', UtilsImporter().stringUtils.userPlaceHolder,
          false, '', 'facebook', '');
    }

    print('===Google Login: ' + bean.fullname);
    return bean;
  }

  // Future<UserBean> facebookLogin(BuildContext context) async {
  //   UserBean bean;
  //   final FacebookLoginResult result =
  //       await facebookSignIn.logInWithReadPermissions(['email']);
  //   User user;
  //   switch (result.status) {
  //     case FacebookLoginStatus.loggedIn:
  //       final AuthCredential credential = FacebookAuthProvider.credential(
  //         accessToken: result.accessToken.token,
  //       );
  //       user = (await _auth.signInWithCredential(credential)).user;
  //       assert(user.email != null);
  //       assert(user.displayName != null);
  //       assert(!user.isAnonymous);
  //       assert(await user.getIdToken() != null);
  //
  //       final User currentUser = await _auth.currentUser;
  //       assert(user.uid == currentUser.uid);
  //
  //       if (user != null) {
  //         bean = new UserBean(user.displayName, user.email,
  //             user.photoUrl + '?type=large', true, user.uid, 'facebook', '');
  //       } else {
  //         bean = new UserBean(
  //             '',
  //             '',
  //             UtilsImporter().stringUtils.userPlaceHolder,
  //             false,
  //             '',
  //             'facebook',
  //             '');
  //       }
  //
  //       break;
  //     case FacebookLoginStatus.cancelledByUser:
  //       UtilsImporter()
  //           .commanUtils
  //           .showToast('Login cancelled by the user.', context);
  //       bean = new UserBean('', '', UtilsImporter().stringUtils.userPlaceHolder,
  //           false, '', 'facebook', '');
  //
  //       break;
  //     case FacebookLoginStatus.error:
  //       UtilsImporter().commanUtils.showToast(
  //           'Something went wrong with the login process.\n'
  //           'Here\'s the error Facebook gave us: ${result.errorMessage}',
  //           context);
  //       bean = new UserBean('', '', UtilsImporter().stringUtils.userPlaceHolder,
  //           false, '', 'facebook', '');
  //       break;
  //   }
  //   print('===Facebook Login: ' + bean.fullname);
  //   return bean;
  // }

  Future<UserBean> signUpWithEmail(
      String email, String password, BuildContext context) async {
    // marked async
    UserBean bean;
    User user;
    String errorMessage;
    print("==Login Email: " + email);
    print("==Login Password: " + password);
    try {
      user = (await _auth.createUserWithEmailAndPassword(
        email: email,
        password: email,
      ))
          .user;
    } on PlatformException catch (error) {
      errorMessage = error.message;
    } finally {
      if (user != null) {
        bean = new UserBean(
            '',
            user.email,
            UtilsImporter().stringUtils.userPlaceHolder,
            true,
            user.uid,
            'email',
            '');
      } else {
        UtilsImporter().commanUtils.showToast(errorMessage, context);
        bean = new UserBean('', '', UtilsImporter().stringUtils.userPlaceHolder,
            false, '', 'email', '');
      }
      // sign in successful!
      // ex: bring the user to the home page
    }

    return bean;
  }

  Future<UserBean> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    UserBean bean;
    User user;
    try {
      user = (await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      )).user;
    } on PlatformException catch (error) {
      UtilsImporter().commanUtils.showToast(error.message, context);
    }

    if (user != null) {
      bean = new UserBean(
          '',
          user.email,
          UtilsImporter().stringUtils.userPlaceHolder,
          true,
          user.uid,
          'email',
          '');
    } else {
      bean = new UserBean('', '', UtilsImporter().stringUtils.userPlaceHolder,
          false, '', 'email', '');
    }

    return bean;
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
