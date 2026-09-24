import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/services/activity_repository.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';

/// Owner-only: how many students have the app open right now, and how many
/// were active today / this week / this month. Counts only.
class LiveUsersScreen extends StatefulWidget {
  const LiveUsersScreen({super.key});

  @override
  State<LiveUsersScreen> createState() => _LiveUsersScreenState();
}

class _LiveUsersScreenState extends State<LiveUsersScreen> {
  static const ActivityRepository _activity = ActivityRepository();

  ActiveUserCounts? _counts;
  String? _error;
  bool _loading = true;
  DateTime? _updated;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _load();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) => _load());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final ActiveUserCounts counts = await _activity.ownerCounts();
      if (!mounted) return;
      setState(() {
        _counts = counts;
        _error = null;
        _loading = false;
        _updated = DateTime.now();
      });
    } catch (error) {
      if (!mounted) return;
      final String text = error.toString();
      setState(() {
        _loading = false;
        _error = text.contains('not allowed')
            ? 'This screen is only for the Eduvora owner account.'
            : (text.contains('owner_active_users') ||
                      text.contains('PGRST202'))
                  ? 'The database step has not been run yet. Run the '
                        'ACTIVE_USERS.sql script in Supabase once, then '
                        'refresh.'
                  : 'Could not load the numbers. Check your connection and '
                        'try again.';
      });
    }
  }

  String _clock(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}:${t.second.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    final ActiveUserCounts? c = _counts;

    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(
        title: const Text('Live users'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              setState(() => _loading = true);
              _load();
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColours.border),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              children: <Widget>[
                if (_loading && c == null)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (c == null)
                  EduvoraCard(
                    child: Text(_error ?? 'No data yet.', style: text.bodyMedium),
                  )
                else ...<Widget>[
                  EduvoraCard(
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Color(0xFF16A34A),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Online now',
                              style: text.titleSmall?.copyWith(
                                color: AppColours.textMuted,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          '${c.onlineNow}',
                          style: const TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.w800,
                            height: 1.05,
                            color: AppColours.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'students with the app open in the last 6 minutes',
                          textAlign: TextAlign.center,
                          style: text.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: <Widget>[
                      Expanded(child: _stat('Today', c.activeToday, 'last 24 hours')),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(child: _stat('This week', c.active7Days, 'last 7 days')),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(child: _stat('This month', c.active30Days, 'last 30 days')),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  EduvoraCard(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text('Registered students', style: text.bodyMedium),
                        ),
                        Text(
                          '${c.totalUsers}',
                          style: text.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'A student is counted after opening the app once since this '
                    'feature went live, so the numbers start low and grow. '
                    'Only you can see this screen, and it shows counts only '
                    '— never names or emails.${_updated == null ? '' : '\nUpdated ${_clock(_updated!)} · refreshes every 30 seconds.'}',
                    style: text.bodySmall?.copyWith(color: AppColours.textFaint),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _stat(String label, int value, String sub) {
    return EduvoraCard(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.sm,
      ),
      child: Column(
        children: <Widget>[
          Text(
            '$value',
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),
          Text(
            sub,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10.5, color: AppColours.textFaint),
          ),
        ],
      ),
    );
  }
}
