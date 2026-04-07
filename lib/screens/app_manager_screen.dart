import 'package:flutter/material.dart';

class AppManagerScreen extends StatefulWidget {
  const AppManagerScreen({super.key});

  @override
  State<AppManagerScreen> createState() => _AppManagerScreenState();
}

class _AppManagerScreenState extends State<AppManagerScreen> {
  final List<_AppInfo> _apps = [
    _AppInfo('YouTube', Icons.play_circle_fill, Colors.red, 120, 45, false),
    _AppInfo('TikTok', Icons.music_note, Colors.black, 60, 30, false),
    _AppInfo('Instagram', Icons.camera_alt, Colors.purple, 90, 20, false),
    _AppInfo('WhatsApp', Icons.message, Colors.green, 0, 15, false),
    _AppInfo('Chrome', Icons.public, Colors.blue, 180, 25, false),
    _AppInfo('Snapchat', Icons.catching_pokemon, Colors.yellow.shade700, 45, 10, true),
    _AppInfo('Twitter', Icons.tag, Colors.lightBlue, 60, 5, false),
    _AppInfo('Roblox', Icons.videogame_asset, Colors.red.shade700, 90, 55, false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Manager'),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: const Color(0xFFF0F4F8),
      body: Column(
        children: [
          // Summary bar
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F1B2D), Color(0xFF162544)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _SummaryItem(
                  label: 'Total Apps',
                  value: '${_apps.length}',
                  icon: Icons.apps,
                ),
                Container(width: 1, height: 40, color: Colors.white24),
                _SummaryItem(
                  label: 'Blocked',
                  value: '${_apps.where((a) => a.isBlocked).length}',
                  icon: Icons.block,
                ),
                Container(width: 1, height: 40, color: Colors.white24),
                _SummaryItem(
                  label: 'With Limits',
                  value: '${_apps.where((a) => a.limitMin > 0).length}',
                  icon: Icons.timer,
                ),
              ],
            ),
          ),

          // App list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _apps.length,
              itemBuilder: (context, index) {
                final app = _apps[index];
                return _AppTile(
                  app: app,
                  onBlockChanged: (val) {
                    setState(() => app.isBlocked = val);
                  },
                  onLimitChanged: (min) {
                    setState(() => app.limitMin = min);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AppInfo {
  final String name;
  final IconData icon;
  final Color color;
  int limitMin;
  final int usedMin;
  bool isBlocked;

  _AppInfo(this.name, this.icon, this.color, this.limitMin, this.usedMin, this.isBlocked);
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _SummaryItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF00B4D8), size: 20),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 11),
        ),
      ],
    );
  }
}

class _AppTile extends StatelessWidget {
  final _AppInfo app;
  final ValueChanged<bool> onBlockChanged;
  final ValueChanged<int> onLimitChanged;

  const _AppTile({
    required this.app,
    required this.onBlockChanged,
    required this.onLimitChanged,
  });

  @override
  Widget build(BuildContext context) {
    final progress = app.limitMin > 0 ? app.usedMin / app.limitMin : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: app.isBlocked
            ? Border.all(color: const Color(0xFFEF4444).withOpacity(0.3))
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: app.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(app.icon, color: app.color, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      app.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E293B),
                        decoration:
                            app.isBlocked ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    const SizedBox(height: 2),
                    if (app.isBlocked)
                      const Text(
                        'Blocked',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFEF4444),
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    else if (app.limitMin > 0)
                      Text(
                        '${app.usedMin}m / ${app.limitMin}m used',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      )
                    else
                      const Text(
                        'No limit set',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF10B981),
                        ),
                      ),
                  ],
                ),
              ),
              // Block toggle
              Switch(
                value: app.isBlocked,
                onChanged: onBlockChanged,
                activeColor: const Color(0xFFEF4444),
                inactiveThumbColor: const Color(0xFF10B981),
                inactiveTrackColor: const Color(0xFF10B981).withOpacity(0.3),
              ),
            ],
          ),
          // Usage bar
          if (!app.isBlocked && app.limitMin > 0) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                minHeight: 5,
                backgroundColor: const Color(0xFFE2E8F0),
                valueColor: AlwaysStoppedAnimation(
                  progress > 0.8
                      ? const Color(0xFFEF4444)
                      : const Color(0xFF00B4D8),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
