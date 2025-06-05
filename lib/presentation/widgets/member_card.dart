import 'package:flutter/material.dart';
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
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.person, size: 48, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nin,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: ColorConstant.fontColor(context),
                  ),
                ),
                Text(
                  email,
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  phoneNumber,
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  role.toLowerCase(),
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 12),
                Column(
                  children: [
                    Container(
                      height: 40,
                      color: Colors.grey[300],
                      child: const Center(child: Text('Barcode')),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userId,
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
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
