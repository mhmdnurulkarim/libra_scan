import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class RegisterController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nikController = TextEditingController();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var isLoading = false.obs;

  Future<void> register() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final nik = nikController.text.trim();
    final nama = nameController.text.trim();
    final alamat = addressController.text.trim();
    final nomor_hp = phoneController.text.trim();

    if ([email, password, nik, nama, alamat, nomor_hp].any((e) => e.isEmpty)) {
      Get.snackbar(
        'Error',
        'Semua field wajib diisi',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Buat akun di Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user_id = userCredential.user?.uid;
      final roleRef = _firestore.collection('role').doc('anggota');

      // Simpan data tambahan ke Firestore
      await _firestore.collection('user').doc(user_id).set({
        'user_id': user_id,
        'email': email,
        'nik': nik,
        'nama': nama,
        'alamat': alamat,
        'nomor_hp': nomor_hp,
        'role': roleRef,
        'status': true,
        'tgl_registrasi': FieldValue.serverTimestamp(),
      });

      Get.snackbar(
        'Sukses',
        'Pendaftaran berhasil!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      await Future.delayed(const Duration(seconds: 1));
      Get.offNamed('/login');

    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Error',
        e.message ?? 'Gagal mendaftar',
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat mendaftar',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

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
      return userCredential.user;
    } catch (e) {
      print("Google login error: $e");
      Get.snackbar(
        'Gagal login via Google',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
