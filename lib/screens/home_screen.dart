import 'package:flutter/material.dart';
import '../models/cv_model.dart';
import '../services/cv_service.dart';
import 'cv_form_screen.dart';
import 'cv_preview_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CvService cvService = CvService();
  int currentIndex = 0;
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'CV Project',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
          currentIndex == 0
              ? 'Your CV Portfolio'
              : currentIndex == 1
                  ? 'Talent Community'
                  : 'Notifications',
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CvFormScreen()),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: _CurvedBottomBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      body: IndexedStack(
        index: currentIndex,
        children: [
          _buildHomeTab(),
          _buildCommunityTab(),
          _buildNotificationsTab(),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    return StreamBuilder<List<CvModel>>(
      stream: cvService.getCvs(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final cvs = snapshot.data!;

        if (cvs.isEmpty) {
          return const Center(
            child: Text('No CVs yet. Tap + to add one.'),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          itemCount: cvs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final cv = cvs[index];

            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.black.withOpacity(0.06),
                border: Border.all(
                  color: Colors.black.withOpacity(0.08),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.blue.withOpacity(0.2),
                    ),
                    child: const Icon(
                      Icons.description,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CvPreviewScreen(cv: cv),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cv.fullName.isEmpty ? 'Unnamed CV' : cv.fullName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            cv.jobTitle.isEmpty ? 'Professional CV' : cv.jobTitle,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CvFormScreen(cv: cv),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit, color: Colors.orange),
                  ),
                  IconButton(
                    onPressed: () async {
                      await cvService.deleteCv(cv.id);
                    },
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCommunityTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search creators...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.black.withOpacity(0.06),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value.trim().toLowerCase();
              });
            },
          ),
        ),
        Expanded(
          child: StreamBuilder<List<CvModel>>(
            stream: cvService.getPublicCvs(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final all = snapshot.data!;
              final filtered = all.where((cv) {
                final fullName = cv.fullName.toLowerCase();
                final jobTitle = cv.jobTitle.toLowerCase();
                return fullName.contains(searchQuery) || jobTitle.contains(searchQuery);
              }).toList();

              if (filtered.isEmpty) {
                return const Center(child: Text('No public CVs found.'));
              }

              return GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
                itemCount: filtered.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.86,
                ),
                itemBuilder: (context, index) {
                  final cv = filtered[index];

                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.black.withOpacity(0.06),
                      border: Border.all(color: Colors.black.withOpacity(0.08)),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.black.withOpacity(0.08),
                          child: const Icon(Icons.person, color: Colors.black54),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          cv.fullName.isEmpty ? 'User' : cv.fullName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          cv.jobTitle.isEmpty ? 'Professional CV' : cv.jobTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FutureBuilder<bool>(
                              future: cvService.isLiked(cv),
                              builder: (context, likeSnapshot) {
                                final liked = likeSnapshot.data ?? false;

                                return InkWell(
                                  onTap: () async {
                                    await cvService.toggleLike(cv);
                                    setState(() {});
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        liked ? Icons.favorite : Icons.favorite_border,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${cv.likesCount}',
                                        style: const TextStyle(fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CvPreviewScreen(cv: cv),
                                  ),
                                );
                              },
                              child: const Text('View'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationsTab() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: cvService.getNotifications(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final notifications = snapshot.data!;

        if (notifications.isEmpty) {
          return const Center(child: Text('No notifications yet.'));
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          itemCount: notifications.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = notifications[index];
            final fromName = (item['fromName'] ?? 'Someone').toString();
            final cvName = (item['cvName'] ?? 'your CV').toString();

            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.black.withOpacity(0.06),
                border: Border.all(color: Colors.black.withOpacity(0.08)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.08),
                    child: const Icon(Icons.favorite, color: Colors.red),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '$fromName liked your CV ($cvName)',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _CurvedBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _CurvedBottomBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = Colors.deepPurple.withOpacity(0.25);

    return SizedBox(
      height: 80,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _WavePainter(color: bg),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navIcon(Icons.home, 0),
                  const SizedBox(width: 60),
                  _navIcon(Icons.groups, 1),
                  _navIcon(Icons.notifications, 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navIcon(IconData icon, int index) {
    final selected = currentIndex == index;

    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(30),
      child: CircleAvatar(
        radius: 22,
        backgroundColor: selected ? Colors.white : Colors.white.withOpacity(0.7),
        child: Icon(
          icon,
          color: selected ? Colors.deepPurple : Colors.black54,
        ),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  final Color color;

  _WavePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    final path = Path();
    path.moveTo(0, 18);
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 18);
    path.quadraticBezierTo(size.width * 0.42, 26, size.width * 0.45, 30);
    path.quadraticBezierTo(size.width * 0.50, 38, size.width * 0.55, 30);
    path.quadraticBezierTo(size.width * 0.58, 26, size.width * 0.65, 18);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 18);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}