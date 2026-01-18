import 'package:flutter/material.dart';
import '../../services/session_service.dart';

// ===== WARNA SUPPLIFY =====
const Color primaryBlue = Color(0xFF0A2540);
const Color teal = Color(0xFF2EC4B6);
const Color background = Color(0xFFF7F9FC);

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  String? userName;
  String? userEmail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final name = await SessionService.getUserName();
    final email = await SessionService.getUserEmail();

    setState(() {
      userName = name ?? 'Admin Supplify';
      userEmail = email ?? 'admin@supplify.com';
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // ===== PROFILE CARD =====
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // ===== AVATAR =====
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [primaryBlue, teal],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: teal.withOpacity(0.3),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.admin_panel_settings,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ===== NAMA =====
                        Text(
                          userName ?? 'Admin Supplify',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: primaryBlue,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // ===== EMAIL =====
                        Text(
                          userEmail ?? 'admin@supplify.com',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // ===== BADGE =====
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: teal.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.verified,
                                size: 18,
                                color: teal,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Admin Terpercaya',
                                style: TextStyle(
                                  color: teal,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ===== MENU SETTINGS =====
                  const Text(
                    'Pengaturan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Menu items
                  _ProfileMenuItem(
                    icon: Icons.person,
                    title: 'Edit Profil',
                    subtitle: 'Ubah data pribadi Anda',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fitur Edit Profil akan segera tersedia'),
                        ),
                      );
                    },
                  ),

                  _ProfileMenuItem(
                    icon: Icons.lock,
                    title: 'Ubah Password',
                    subtitle: 'Tingkatkan keamanan akun',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fitur Ubah Password akan segera tersedia'),
                        ),
                      );
                    },
                  ),

                  _ProfileMenuItem(
                    icon: Icons.notifications,
                    title: 'Notifikasi',
                    subtitle: 'Atur preferensi notifikasi',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fitur Notifikasi akan segera tersedia'),
                        ),
                      );
                    },
                  ),

                  _ProfileMenuItem(
                    icon: Icons.help,
                    title: 'Bantuan & Support',
                    subtitle: 'Hubungi tim support kami',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fitur Support akan segera tersedia'),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 28),

                  // ===== LOGOUT BUTTON =====
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await SessionService.logout();
                        if (!mounted) return;
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login',
                          (route) => false,
                        );
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ===== VERSION =====
                  Text(
                    'Supplify v1.0.0',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            );
  }
}

// ================= PROFILE MENU ITEM =================
class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        leading: CircleAvatar(
          backgroundColor: teal.withOpacity(0.15),
          child: Icon(icon, color: teal),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: primaryBlue,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
