import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reedsblog/screens/createpost_screen.dart';
import 'package:reedsblog/screens/editor_screen.dart';

class ManagementScreen extends StatelessWidget {
  const ManagementScreen({super.key});

  // Helper function to calculate reading time
  int _calculateReadingTime(String content) {
    // Average reading speed is about 200 words per minute
    final wordCount = content.trim().split(RegExp(r'\s+')).length;
    final readTime = (wordCount / 200).ceil();
    return readTime == 0 ? 1 : readTime; // Guarantee at least a "1 min read"
  }

  void confirmDelete(BuildContext context, String docId, String title) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          title: Text(
            "Delete Post",
            style: GoogleFonts.inter(color: Colors.white),
          ),
          content: Text(
            "Are you sure you want to delete '$title'? This cannot be undone!",
            style: GoogleFonts.inter(color: Colors.grey),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text("CANCEL", style: TextStyle(color: Colors.white)),
            ),

            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);

                await FirebaseFirestore.instance
                    .collection('posts')
                    .doc(docId)
                    .delete();

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Post deleted.",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }
              },
              child: const Text(
                "DELETE",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('posts')
                .orderBy('createdAt', descending: true) // Sorts newest first!
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF166534)),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Error loading posts.",
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No posts found. Time to write!",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final posts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              var post = posts[index];

              // 1. Get the Title
              String title = post['title'] ?? 'Untitled Post';

              // 2. Format the Date from Firestore Timestamp
              String formattedDate = 'Unknown Date';
              if (post['createdAt'] != null) {
                Timestamp timestamp = post['createdAt'] as Timestamp;
                DateTime dateTime = timestamp.toDate();
                formattedDate = DateFormat(
                  'MMM d, yyyy',
                ).format(dateTime); // e.g., Feb 26, 2026
              }

              // 3. Calculate Reading Time from the Content
              String content = post['content'] ?? '';
              int readTime = _calculateReadingTime(content);

              return Card(
                color: const Color(0xFF1E293B),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => EditorScreen(
                              docId: post.id,
                              currentTitle: title,
                              currentContent: content,
                            ),
                      ),
                    );
                  },
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),

                  title: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),

                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Text(
                      "$formattedDate • $readTime min read",
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ),

                  trailing: PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.grey),
                    color: const Color(0xFF0F172A), // Dark navy menu background
                    onSelected: (value) {
                      if (value == 'delete') {
                        // Trigger the dialog we just created!
                        confirmDelete(context, post.id, title);
                      }
                    },
                    itemBuilder:
                        (BuildContext context) => [
                          const PopupMenuItem<String>(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Delete Post",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                  ),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF166534),
        foregroundColor: Colors.white,
        elevation: 4,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreatePostScreen()),
          );
        },
        child: Icon(Icons.add),
        shape: CircleBorder(),
      ),
    );
  }
}
