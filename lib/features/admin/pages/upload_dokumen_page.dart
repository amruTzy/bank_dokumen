import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

class UploadDokumenPage extends StatefulWidget {
  const UploadDokumenPage({super.key});

  @override
  State<UploadDokumenPage> createState() => _UploadDokumenPageState();
}

class _UploadDokumenPageState extends State<UploadDokumenPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _judulController = TextEditingController();

  String? selectedKategori;
  List<String> kategoriList = [];
  Map<String, String> kategoriMap = {};

  XFile? selectedFile;

  @override
  void initState() {
    super.initState();
    fetchKategori();
  }

  Future<void> fetchKategori() async {
    final snapshot = await FirebaseFirestore.instance.collection('categories').get();
    final List<String> listBaru = [];

    for (var doc in snapshot.docs) {
      final data = doc.data();
      if (data.containsKey('name') && data['name'] != null) {
        final name = data['name'];
        listBaru.add(name);
        kategoriMap[doc.id] = name;
      }
    }

    setState(() {
      kategoriList = listBaru;
    });
  }

  Future<void> pickFile() async {
    const XTypeGroup typeGroup = XTypeGroup(
      label: 'dokumen',
      extensions: ['pdf', 'doc', 'docx'],
    );
    final XFile? file = await openFile(acceptedTypeGroups: [typeGroup]);

    if (file != null) {
      setState(() {
        selectedFile = file;
      });
    }
  }

  Future<void> uploadDokumen() async {
    if (!_formKey.currentState!.validate() || selectedFile == null || selectedKategori == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lengkapi semua data dan pilih file!")),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('documents').add({
      'title': _judulController.text,
      'category': kategoriMap.entries
          .firstWhere((entry) => entry.value == selectedKategori!)
          .key,
      'uploadedBy': 'User Lokal',
      'filePath': selectedFile!.path,
      'uploadedAt': Timestamp.now(),
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Dokumen"),
        backgroundColor: const Color(0xFF15C029),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _judulController,
                decoration: const InputDecoration(
                  labelText: "Judul Dokumen",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'Judul wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedKategori,
                decoration: const InputDecoration(
                  labelText: "Pilih Kategori",
                  border: OutlineInputBorder(),
                ),
                items: kategoriList
                    .map((kategori) => DropdownMenuItem(
                  value: kategori,
                  child: Text(kategori),
                ))
                    .toList(),
                onChanged: (value) => setState(() => selectedKategori = value),
                validator: (value) =>
                value == null ? 'Kategori wajib dipilih' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: pickFile,
                icon: const Icon(Icons.attach_file),
                label: Text(selectedFile != null
                    ? "File: ${selectedFile!.name}"
                    : "Pilih File"),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: uploadDokumen,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF15C029),
                ),
                child: const Text("Upload Dokumen"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
