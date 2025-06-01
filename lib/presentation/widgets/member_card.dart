import 'package:flutter/material.dart';

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
        color: Colors.pink.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.person, size: 48),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nin),
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(email),
                Text(phoneNumber),
                Text(role.toLowerCase()),
                const SizedBox(height: 12),
                Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 40, child: Placeholder()),
                      const SizedBox(height: 4),
                      Text(userId),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}