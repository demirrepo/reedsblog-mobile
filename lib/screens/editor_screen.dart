import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditorScreen extends StatefulWidget {
  final String docId;
  final String currentTitle;
  final String currentContent;

  const EditorScreen({
    super.key,
    required this.docId,
    required this.currentContent,
    required this.currentTitle,
  });

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.currentTitle);
    _contentController = TextEditingController(text: widget.currentContent);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _updatePost() async {
    setState(() {
      _isSaving = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.docId)
          .update({
            'title': _titleController.text.trim(),
            'content': _contentController.text.trim(),
          });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Post updated successfully!",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Error: $e",
              style: const TextStyle(color: Colors.red),
            ),
          ),
        );
      }
    } finally {
      if (mounted)
        setState(() {
          _isSaving = false;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Edit Post",
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: TextButton(
              onPressed: _isSaving ? null : _updatePost,
              child:
                  _isSaving
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Color(0xFF166534),
                          strokeWidth: 2,
                        ),
                      )
                      : Text(
                        "SAVE",
                        style: GoogleFonts.inter(
                          color: Color(0xFF166534),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              maxLines: null,
              controller: _titleController,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                hintText: "Post title",
                hintStyle: GoogleFonts.inter(
                  color: Colors.grey,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                border: InputBorder.none,
              ),
            ),
            const Divider(color: Color(0xFF1E293B), thickness: 2),
            const SizedBox(height: 10),

            // Content field
            Expanded(
              child: TextField(
                maxLines: null,
                controller: _contentController,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.6,
                ),
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: "Start writing...",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
