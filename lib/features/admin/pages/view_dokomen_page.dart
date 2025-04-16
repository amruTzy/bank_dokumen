import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bank_dokumen/features/admin/pages/upload_dokumen_page.dart';

class DataDokumenPage extends StatefulWidget {
  const DataDokumenPage({super.key});

  @override
  State<DataDokumenPage> createState() => _DataDokumenPageState();
}

class _DataDokumenPageState extends State<DataDokumenPage> {
  String selectedKategori = 'Semua';
  List<String> kategoriList = ['Semua'];
  bool isLoadingKategori = true;

  // ✅ Map ID kategori ke nama kategori
  Map<String, String> kategoriMap = {};

  @override
  void initState() {
    super.initState();
    fetchKategori();
  }

  Future<void> fetchKategori() async {
    try {
      final snapshot =
      await FirebaseFirestore.instance.collection('categories').get();
      final List<String> listBaru = ['Semua'];

      for (var doc in snapshot.docs) {
        final data = doc.data();

        if (data.containsKey('name') && data['name'] != null) {
          final name = data['name'];
          listBaru.add(name);
          kategoriMap[doc.id] = name;
        } else {
          debugPrint("⚠️ Dokumen '${doc.id}' tidak punya field 'name'.");
        }
      }

      setState(() {
        kategoriList = listBaru;
        isLoadingKategori = false;
      });
    } catch (e) {
      debugPrint("❌ Error saat ambil kategori: $e");
      setState(() {
        isLoadingKategori = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("File Manager"),
        backgroundColor: const Color(0xFF15C029),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchAndFilter(),
            const SizedBox(height: 16),
            Expanded(child: _buildDokumenList()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF15C029),
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const UploadDokumenPage()),
          );
        },
      ),

    );

  }

  Widget _buildSearchAndFilter() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Cari dokumen...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            ),
            onChanged: (value) {
              // Optional: fitur pencarian
            },
          ),
        ),
        const SizedBox(width: 12),
        isLoadingKategori
            ? const CircularProgressIndicator()
            : DropdownButton<String>(
          value: selectedKategori,
          items: kategoriList
              .map((kategori) => DropdownMenuItem(
            value: kategori,
            child: Text(kategori),
          ))
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedKategori = value!;
              debugPrint('🔽 Dipilih kategori: $selectedKategori');
            });
          },
        ),
      ],
    );
  }

  Widget _buildDokumenList() {
    final query = FirebaseFirestore.instance.collection('documents');

    // 🔍 Kategori filtering fix
    final stream = selectedKategori == 'Semua'
        ? query.snapshots()
        : query
        .where(
      'category',
      isEqualTo: kategoriMap.entries
          .firstWhere((entry) => entry.value == selectedKategori,
          orElse: () => const MapEntry('', ''))
          .key,
    )
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final dokumenList = snapshot.data!.docs;

        if (dokumenList.isEmpty) {
          return const Center(child: Text("Tidak ada dokumen."));
        }

        return ListView.builder(
          itemCount: dokumenList.length,
          itemBuilder: (context, index) {
            final doc = dokumenList[index];
            final kategoriId = doc['category'];
            final kategoriNama = kategoriMap[kategoriId] ?? kategoriId;

            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                leading: const Icon(Icons.insert_drive_file),
                title: Text(doc['title']),
                subtitle: Text(
                    'Kategori: $kategoriNama\nDiunggah oleh ${doc['uploadedBy']}'),
                isThreeLine: true,
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    // Action: Lihat / Hapus / Download
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'lihat', child: Text('Lihat')),
                    const PopupMenuItem(
                        value: 'download', child: Text('Download')),
                    const PopupMenuItem(value: 'hapus', child: Text('Hapus')),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
