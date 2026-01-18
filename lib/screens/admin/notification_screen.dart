import 'package:flutter/material.dart';

// ===== WARNA SUPPLIFY =====
const Color primaryBlue = Color(0xFF0A2540);
const Color teal = Color(0xFF2EC4B6);
const Color background = Color(0xFFF7F9FC);

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Sample notification data
  final List<Map<String, dynamic>> notifications = [
    {
      'id': 1,
      'title': 'Pesanan Baru',
      'message': 'Ada pesanan baru dari client Alonza Nara',
      'timestamp': '2 jam yang lalu',
      'icon': Icons.shopping_cart,
      'color': teal,
      'read': false,
    },
    {
      'id': 2,
      'title': 'Client Baru Menunggu Approval',
      'message': 'Sugiri Satrio telah mendaftar dan menunggu persetujuan',
      'timestamp': '5 jam yang lalu',
      'icon': Icons.person_add,
      'color': Colors.indigo,
      'read': false,
    },
    {
      'id': 3,
      'title': 'Stok Produk Rendah',
      'message': 'Produk "Mie Instan" stok tinggal 5 item',
      'timestamp': '1 hari yang lalu',
      'icon': Icons.warning,
      'color': Colors.orange,
      'read': true,
    },
    {
      'id': 4,
      'title': 'Pesanan Selesai',
      'message': 'Pesanan #001 telah diselesaikan dan dikirim',
      'timestamp': '2 hari yang lalu',
      'icon': Icons.check_circle,
      'color': Colors.green,
      'read': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return notifications.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_none,
                  size: 64,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  'Tidak ada notifikasi',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
                final notif = notifications[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: notif['read'] ? Colors.grey.shade200 : teal,
                      width: notif['read'] ? 1 : 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ===== ICON =====
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: notif['color'].withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          notif['icon'],
                          color: notif['color'],
                        ),
                      ),

                      const SizedBox(width: 16),

                      // ===== TEXT =====
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    notif['title'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: primaryBlue,
                                    ),
                                  ),
                                ),
                                if (!notif['read'])
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: teal,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              notif['message'],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              notif['timestamp'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
  }
}
