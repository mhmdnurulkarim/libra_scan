import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:libra_scan/presentation/widgets/snackbar.dart';
import 'package:libra_scan/utils/color_constans.dart';

class AuthController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nikController = TextEditingController();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();

  var isLoading = false.obs;
  var isFromGoogle = false;
  String? userId;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Login menggunakan Email dan Password
  Future<User?> loginWithEmail() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if ([email, password].any((e) => e.isEmpty)) {
      MySnackBar.show(
        title: 'Peringatan',
        message: 'Email dan kata sandi wajib diisi',
        bgColor: ColorConstant.warningColor,
        icon: Icons.warning_amber_rounded,
      );
      return null;
    }

    try {
      isLoading.value = true;
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.offAllNamed('/main');
      return userCredential.user;
    } catch (e) {
      MySnackBar.show(
        title: 'Login Gagal',
        message: e.toString(),
        bgColor: ColorConstant.redColor,
        icon: Icons.error_outline,
      );
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  /// Login menggunakan Google Sign-In
  Future<User?> loginWithGoogle() async {
    try {
      isLoading.value = true;
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user == null || user.email == null) {
        MySnackBar.show(
          title: 'Error',
          message: 'Gagal mendapatkan data pengguna',
          bgColor: ColorConstant.redColor,
          icon: Icons.error,
        );
        return null;
      }

      userId = user.uid;
      emailController.text = user.email!;
      isFromGoogle = true;

      final userDoc = await _firestore.collection('user').doc(userId).get();
      if (userDoc.exists) {
        Get.offAllNamed('/main');
      } else {
        Get.offAllNamed(
          '/register-detail',
          arguments: {'email': user.email!, 'user_id': user.uid},
        );
      }

      return user;
    } catch (e) {
      MySnackBar.show(
        title: 'Google Sign-In Gagal',
        message: e.toString(),
        bgColor: ColorConstant.redColor,
        icon: Icons.login,
      );
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  /// Register dengan Email & Password
  Future<void> registerWithEmail() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final nik = nikController.text.trim();
    final nama = nameController.text.trim();
    final alamat = addressController.text.trim();
    final nomorHp = phoneController.text.trim();

    if ([email, password, nik, nama, alamat, nomorHp].any((e) => e.isEmpty)) {
      MySnackBar.show(
        title: 'Peringatan',
        message: 'Semua field wajib diisi',
        bgColor: ColorConstant.warningColor,
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
        'email': email,
        'nik': nik,
        'nama': nama,
        'alamat': alamat,
        'nomor_hp': nomorHp,
        'role': roleRef,
        'status': true,
        'tgl_registrasi': FieldValue.serverTimestamp(),
      });

      MySnackBar.show(
        title: 'Sukses',
        message: 'Pendaftaran berhasil!',
        bgColor: ColorConstant.greenColor,
        icon: Icons.check_circle_outline,
      );
      Get.offNamed('/login');
    } catch (e) {
      MySnackBar.show(
        title: 'Gagal Mendaftar',
        message: e.toString(),
        bgColor: ColorConstant.redColor,
        icon: Icons.error_outline,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Register tambahan untuk pengguna Google
  Future<void> registerWithGoogle() async {
    final email = emailController.text.trim();
    final nik = nikController.text.trim();
    final nama = nameController.text.trim();
    final alamat = addressController.text.trim();
    final nomorHp = phoneController.text.trim();
    final password = passwordController.text;

    if ([nik, nama, alamat, nomorHp, password].any((e) => e.isEmpty)) {
      MySnackBar.show(
        title: 'Peringatan',
        message: 'Semua field dan password wajib diisi',
        bgColor: ColorConstant.warningColor,
        icon: Icons.warning,
      );
      return;
    }

    try {
      isLoading.value = true;

      // Simpan data pengguna ke Firestore
      await _firestore.collection('user').doc(userId).set({
        'user_id': userId,
        'email': email,
        'nik': nik,
        'nama': nama,
        'alamat': alamat,
        'nomor_hp': nomorHp,
        'role': _firestore.collection('role').doc('anggota'),
        'status': true,
        'tgl_registrasi': FieldValue.serverTimestamp(),
      });

      // Link akun Google dengan Email/Password
      final currentUser = _auth.currentUser;
      final emailCredential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );

      await currentUser?.linkWithCredential(emailCredential);

      MySnackBar.show(
        title: 'Sukses',
        message: 'Akun Google berhasil terhubung ke Email/Password!',
        bgColor: ColorConstant.greenColor,
        icon: Icons.check_circle_outline,
      );

      Get.offAllNamed('/main');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'provider-already-linked') {
        MySnackBar.show(
          title: 'Info',
          message: 'Akun sudah ditautkan sebelumnya.',
          bgColor: Colors.blue,
          icon: Icons.info_outline,
        );
      } else if (e.code == 'email-already-in-use') {
        MySnackBar.show(
          title: 'Gagal',
          message: 'Email sudah digunakan oleh akun lain.',
          bgColor: ColorConstant.redColor,
          icon: Icons.error_outline,
        );
      } else {
        MySnackBar.show(
          title: 'Gagal Menautkan Akun',
          message: e.message ?? 'Terjadi kesalahan',
          bgColor: ColorConstant.redColor,
          icon: Icons.error_outline,
        );
      }
    } catch (e) {
      MySnackBar.show(
        title: 'Gagal Simpan Data',
        message: e.toString(),
        bgColor: ColorConstant.redColor,
        icon: Icons.error_outline,
      );
    } finally {
      isLoading.value = false;
    }
  }


  /// Reset Password
  Future<void> forgotPassword() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      MySnackBar.show(
        title: "Error",
        message: "Email tidak boleh kosong",
        bgColor: ColorConstant.redColor,
        icon: Icons.email_outlined,
      );
      return;
    }

    try {
      isLoading.value = true;
      await _auth.sendPasswordResetEmail(email: email);
      MySnackBar.show(
        title: "Berhasil",
        message: "Link reset telah dikirim ke email",
        bgColor: ColorConstant.greenColor,
        icon: Icons.check_circle_outline,
      );
      Get.offNamed('/login');
    } catch (e) {
      MySnackBar.show(
        title: "Gagal",
        message: e.toString(),
        bgColor: ColorConstant.redColor,
        icon: Icons.error_outline,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;

      // Logout dari FirebaseAuth
      await _auth.signOut();

      // Jika login menggunakan Google, logout dari GoogleSignIn juga
      if (isFromGoogle) {
        final googleSignIn = GoogleSignIn();
        if (await googleSignIn.isSignedIn()) {
          await googleSignIn.signOut();
        }
        isFromGoogle = false;
      }

      // Reset semua controller
      emailController.clear();
      passwordController.clear();
      nikController.clear();
      nameController.clear();
      addressController.clear();
      phoneController.clear();

      userId = null;

      MySnackBar.show(
        title: 'Logout',
        message: 'Berhasil keluar dari akun',
        bgColor: ColorConstant.greenColor,
        icon: Icons.logout,
      );

      Get.offAllNamed('/login');
    } catch (e) {
      MySnackBar.show(
        title: 'Gagal Logout',
        message: e.toString(),
        bgColor: ColorConstant.redColor,
        icon: Icons.error_outline,
      );
    } finally {
      isLoading.value = false;
    }
  }

}
