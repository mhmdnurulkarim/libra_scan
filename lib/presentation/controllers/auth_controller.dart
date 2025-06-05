import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:libra_scan/presentation/widgets/snackbar.dart';
import 'package:libra_scan/common/constants/color_constans.dart';

import '../../data/share_preference.dart';

class AuthController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final ninController = TextEditingController();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();

  var isLoading = false.obs;
  var isFromGoogle = false;
  String? userId;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// LOGIN - Email dan Password
  Future<void> loginWithEmail() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if ([email, password].any((e) => e.isEmpty)) {
      MySnackBar.show(
        title: 'Peringatan',
        message: 'Email dan kata sandi wajib diisi',
        backgroundColor: Colors.orange,
        fontColor: Colors.white,
        icon: Icons.warning_amber_rounded,
      );
      return;
    }

    try {
      isLoading.value = true;

      // Login ke Firebase Auth
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw FirebaseAuthException(code: 'invalid-user', message: 'User tidak ditemukan');
      }

      final userId = user.uid;

      // Ambil data user utama
      final userDoc = await _firestore.collection('user').doc(userId).get();
      if (!userDoc.exists) {
        MySnackBar.show(
          title: 'Error',
          message: 'Data pengguna tidak ditemukan.',
          backgroundColor: Colors.red,
          fontColor: Colors.white,
          icon: Icons.error_outline,
        );
        return;
      }
      final userData = userDoc.data()!;

      // Ambil akun user dari subkoleksi account
      final accountSnap = await _firestore
          .collection('user')
          .doc(userId)
          .collection('account')
          .limit(1)
          .get();

      if (accountSnap.docs.isEmpty) {
        MySnackBar.show(
          title: 'Error',
          message: 'Data akun tidak ditemukan.',
          backgroundColor: Colors.red,
          fontColor: Colors.white,
          icon: Icons.error_outline,
        );
        return;
      }

      final accountData = accountSnap.docs.first.data();

      // Cek status akun
      if (accountData['status'] != true) {
        MySnackBar.show(
          title: 'Akun Nonaktif',
          message: 'Akun Anda telah dinonaktifkan.',
          backgroundColor: Colors.red,
          fontColor: Colors.white,
          icon: Icons.block,
        );
        return;
      }

      // Simpan data lokal
      await saveLoggedInUserData(
        userId: userId,
        userData: userData,
        accountData: accountData,
      );

      // Pindah ke halaman utama
      Get.offAllNamed('/main');
    } catch (e) {
      MySnackBar.show(
        title: 'Login Gagal',
        message: e is FirebaseAuthException ? e.message ?? 'Terjadi kesalahan saat login.' : e.toString(),
        backgroundColor: Colors.red,
        fontColor: Colors.white,
        icon: Icons.error_outline,
      );
    } finally {
      isLoading.value = false;
    }
  }


  /// LOGIN - Google
  Future<void> loginWithGoogle() async {
    try {
      isLoading.value = true;

      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        throw FirebaseAuthException(code: 'sign-in-cancelled', message: 'Login dibatalkan oleh pengguna.');
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user == null || user.email == null) {
        throw FirebaseAuthException(code: 'user-not-found', message: 'Data pengguna tidak ditemukan.');
      }

      final userId = user.uid;
      isFromGoogle = true;
      emailController.text = user.email!;

      // Cek apakah user sudah ada di Firestore
      final userDoc = await _firestore.collection('user').doc(userId).get();

      if (userDoc.exists) {
        final userData = userDoc.data()!;

        final accountSnap = await _firestore
            .collection('user')
            .doc(userId)
            .collection('account')
            .limit(1)
            .get();

        if (accountSnap.docs.isEmpty) {
          MySnackBar.show(
            title: 'Error',
            message: 'Data akun tidak ditemukan.',
            backgroundColor: Colors.red,
            fontColor: Colors.white,
            icon: Icons.error_outline,
          );
          return;
        }

        final accountData = accountSnap.docs.first.data();

        // Cek apakah akun aktif
        if (accountData['status'] != true) {
          MySnackBar.show(
            title: 'Akun Nonaktif',
            message: 'Akun Anda telah dinonaktifkan.',
            backgroundColor: Colors.red,
            fontColor: Colors.white,
            icon: Icons.block,
          );
          return;
        }

        // Simpan data lokal
        await saveLoggedInUserData(
          userId: userId,
          userData: userData,
          accountData: accountData,
        );

        Get.offAllNamed('/main');
      } else {
        // User baru, arahkan ke register detail
        Get.offAllNamed('/register-detail', arguments: {
          'email': user.email!,
          'user_id': userId,
        });
      }
    } catch (e) {
      MySnackBar.show(
        title: 'Google Sign-In Gagal',
        message: e is FirebaseAuthException ? e.message ?? 'Terjadi kesalahan saat login.' : e.toString(),
        backgroundColor: Colors.red,
        fontColor: Colors.white,
        icon: Icons.login,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// REGISTER - Email dan Password
  Future<void> registerWithEmail() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final nin = ninController.text.trim();
    final name = nameController.text.trim();
    final address = addressController.text.trim();
    final phone = phoneController.text.trim();

    if ([email, password, nin, name, address, phone].any((e) => e.isEmpty)) {
      MySnackBar.show(
        title: 'Peringatan',
        message: 'Semua field wajib diisi',
        backgroundColor: Colors.orange,
        fontColor: Colors.white,
        icon: Icons.warning,
      );
      return;
    }

    try {
      isLoading.value = true;

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userId = userCredential.user?.uid;
      final roleRef = _firestore.collection('role').doc('anggota');

      await _firestore.collection('user').doc(userId).set({
        'user_id': userId,
        'nin': nin,
        'name': name,
        'address': address,
        'phone_number': phone,
        'registration_date': FieldValue.serverTimestamp(),
      });

      final accountRef = await _firestore
          .collection('user')
          .doc(userId)
          .collection('account')
          .add({
        'email': email,
        'role_id': roleRef,
        'status': true,
      });

      await accountRef.update({
        'account_id': accountRef.id,
      });

      MySnackBar.show(
        title: 'Sukses',
        message: 'Pendaftaran berhasil!',
        backgroundColor: Colors.green,
        fontColor: Colors.white,
        icon: Icons.check_circle_outline,
      );

      Get.offNamed('/login');
    } catch (e) {
      MySnackBar.show(
        title: 'Gagal Mendaftar',
        message: e.toString(),
        backgroundColor: Colors.red,
        fontColor: Colors.white,
        icon: Icons.error_outline,
      );
      return;
    } finally {
      isLoading.value = false;
    }
  }

  /// REGISTER - Google (lanjutan)
  Future<void> registerWithGoogle() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final nin = ninController.text.trim();
    final name = nameController.text.trim();
    final address = addressController.text.trim();
    final phone = phoneController.text.trim();

    if ([email, password, nin, name, address, phone].any((e) => e.isEmpty)) {
      MySnackBar.show(
        title: 'Peringatan',
        message: 'Semua data wajib diisi',
        backgroundColor: Colors.orange,
        fontColor: Colors.white,
        icon: Icons.warning,
      );
      return;
    }

    try {
      isLoading.value = true;

      final roleRef = _firestore.collection('role').doc('anggota');

      await _firestore.collection('user').doc(userId).set({
        'user_id': userId,
        'nin': nin,
        'name': name,
        'address': address,
        'phone_number': phone,
        'registration_date': FieldValue.serverTimestamp(),
      });

      final accountRef = await _firestore
          .collection('user')
          .doc(userId)
          .collection('account')
          .add({
        'email': email,
        'role_id': roleRef,
        'status': true,
      });

      await accountRef.update({
        'account_id': accountRef.id,
      });

      // Tautkan email-password ke Google account
      final currentUser = _auth.currentUser;
      final emailCredential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );

      await currentUser?.linkWithCredential(emailCredential);

      MySnackBar.show(
        title: 'Sukses',
        message: 'Akun Google berhasil ditautkan!',
        backgroundColor: Colors.green,
        fontColor: Colors.white,
        icon: Icons.check_circle_outline,
      );

      Get.offAllNamed('/main');
    } catch (e) {
      MySnackBar.show(
        title: 'Gagal',
        message: e.toString(),
        backgroundColor: Colors.red,
        fontColor: Colors.white,
        icon: Icons.error_outline,
      );
      return;
    } finally {
      isLoading.value = false;
    }
  }

  /// RESET PASSWORD
  Future<void> forgotPassword() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      MySnackBar.show(
        title: "Error",
        message: "Email wajib diisi",
        backgroundColor: Colors.red,
        fontColor: Colors.white,
        icon: Icons.email_outlined,
      );
      return;
    }

    try {
      isLoading.value = true;
      await _auth.sendPasswordResetEmail(email: email);
      MySnackBar.show(
        title: "Berhasil",
        message: "Link reset telah dikirim",
        backgroundColor: Colors.green,
        fontColor: Colors.white,
        icon: Icons.check_circle_outline,
      );
      Get.offNamed('/login');
    } catch (e) {
      MySnackBar.show(
        title: "Gagal",
        message: e.toString(),
        backgroundColor: Colors.red,
        fontColor: Colors.white,
        icon: Icons.error_outline,
      );
      return;

    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveLoggedInUserData({
    required String userId,
    required Map<String, dynamic> userData,
    required Map<String, dynamic> accountData,
  }) async {
    await LocalStorage.saveUserData({
      'user_id': userId,
      'nin': userData['nin'] ?? '',
      'name': userData['name'] ?? '',
      'address': userData['address'] ?? '',
      'phone_number': userData['phone_number'] ?? '',
      'email': accountData['email'] ?? '',
      'role_id': accountData['role_id'] is DocumentReference
          ? (accountData['role_id'] as DocumentReference).id
          : accountData['role_id'],
      'status': '${accountData['status']}',
    });
  }


  /// LOGOUT
  Future<void> logout() async {
    try {
      isLoading.value = true;

      await _auth.signOut();
      if (isFromGoogle) {
        final googleSignIn = GoogleSignIn();
        if (await googleSignIn.isSignedIn()) {
          await googleSignIn.signOut();
        }
        isFromGoogle = false;
      }

      await LocalStorage.clearUserData();

      emailController.clear();
      passwordController.clear();
      ninController.clear();
      nameController.clear();
      addressController.clear();
      phoneController.clear();
      userId = null;

      MySnackBar.show(
        title: 'Logout',
        message: 'Berhasil keluar dari akun',
        backgroundColor: Colors.green,
        fontColor: Colors.white,
        icon: Icons.logout,
      );

      Get.offAllNamed('/login');
    } catch (e) {
      MySnackBar.show(
        title: 'Gagal Logout',
        message: e.toString(),
        backgroundColor: Colors.red,
        fontColor: Colors.white,
        icon: Icons.error_outline,
      );
    } finally {
      isLoading.value = false;
    }
  }
}