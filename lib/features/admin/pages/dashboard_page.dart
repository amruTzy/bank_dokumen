import 'package:flutter/material.dart';
import 'package:bank_dokumen/features/auth/page/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 90,
              width: double.infinity,
              color: const Color(0xFF15C029),
              padding: const EdgeInsets.only(left: 16, top: 20),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Menu Admin',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.folder),
              title: const Text('Data Dokumen'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('Manajemen User'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.receipt_long),
              title: const Text('Log Aktivitas'),
              onTap: () {},
            ),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Konfirmasi Logout'),
                  content: const Text('Apakah Anda yakin ingin logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Batal'),
                    ),
                    ElevatedButton(
                      onPressed: () => _logout(context),
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF15C029),
        elevation: 0,
        title: const Text("Dashboard Admin"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBox(),
              const SizedBox(height: 16),
              Wrap(
                spacing: 25.0,
                runSpacing: 17.0,
                children: [
                  _buildStatCard('Total Dokumen', '120', Icons.insert_drive_file, Colors.blue),
                  _buildStatCard('Kategori', '6', Icons.category, Colors.orange),
                  _buildStatCard('Total User', '15', Icons.people, Colors.green),
                  _buildStatCard('Login Hari Ini', '5', Icons.login, Colors.purple),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Log Aktivitas Terbaru', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _buildActivityLog(),
              const SizedBox(height: 24),
              const Text('Dokumen Terbaru', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _buildRecentDocs(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: const Row(
        children: [
          Icon(Icons.search, color: Colors.grey),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari dokumen...',
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(title, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityLog() {
    return Column(
      children: [
        _logTile('admin menambahkan user baru', '08 April 10:12'),
        _logTile('user01 mengunggah dokumen', '08 April 10:45'),
      ],
    );
  }

  Widget _logTile(String action, String time) {
    return ListTile(
      leading: const Icon(Icons.bolt),
      title: Text(action),
      subtitle: Text(time),
    );
  }

  Widget _buildRecentDocs() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.description),
          title: const Text('Surat Keterangan.pdf'),
          subtitle: const Text('Diunggah oleh user01'),
        ),
        ListTile(
          leading: const Icon(Icons.description),
          title: const Text('Data Karyawan.xlsx'),
          subtitle: const Text('Diunggah oleh admin'),
        ),
      ],
    );
  }
}
