import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import '../../common/constants/color_constans.dart';

class MemberCard extends StatelessWidget {
  final String userId;
  final String nin;
  final String name;
  final String email;
  final String phoneNumber;
  final String role;
  final String barcode;

  const MemberCard({
    super.key,
    required this.userId,
    required this.nin,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.role,
    required this.barcode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorConstant.primaryColor(context),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 160,
            decoration: BoxDecoration(
              color: ColorConstant.secondaryColor(context),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.person, size: 72, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NIK: $nin',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
                Text(
                  'Nama: $name',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Email: $email',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Nomor HP: $phoneNumber',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
                Text(
                  'Role: ${role.toLowerCase()}',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
                const SizedBox(height: 12),
                Column(
                  children: [
                    BarcodeWidget(
                      barcode: Barcode.code128(),
                      data: userId,
                      height: 60,
                      backgroundColor: Colors.white,
                      drawText: false,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
