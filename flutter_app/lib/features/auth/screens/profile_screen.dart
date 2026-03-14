import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final profileAsyncValue = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppTheme.bgApp,
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authControllerProvider.notifier).signOut();
            },
          )
        ],
      ),
      body: profileAsyncValue.when(
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('Profile not found'));
          }
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(userProfileProvider);
            },
            child: ListView(
              padding: const EdgeInsets.all(AppTheme.spaceLG),
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: AppTheme.primaryLight,
                    child: Text(
                      profile['full_name'] != null ? profile['full_name'][0].toUpperCase() : '?',
                      style: AppTheme.headingXL.copyWith(color: AppTheme.primary),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spaceLG),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.spaceLG),
                    child: Column(
                      children: [
                        _ProfileItem(
                          icon: Icons.person_outline,
                          title: 'Full Name',
                          value: profile['full_name'] ?? 'Not set',
                        ),
                        const Divider(),
                        _ProfileItem(
                          icon: Icons.email_outlined,
                          title: 'Email Address',
                          value: profile['email'] ?? user?.email ?? 'Unknown',
                        ),
                        const Divider(),
                        _ProfileItem(
                          icon: Icons.history,
                          title: 'Account Created',
                          value: _formatDate(profile['created_at']),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spaceLG),
                Card(
                  color: AppTheme.blue50,
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.spaceMD),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: AppTheme.primary),
                        const SizedBox(width: AppTheme.spaceMD),
                        Expanded(
                          child: Text(
                            'Your profile is securely stored and private to you in accordance with healthcare data standards.',
                            style: AppTheme.bodySM,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Error loading profile: $err', style: AppTheme.bodyMD),
        ),
      ),
    );
  }

  String _formatDate(String? isoDate) {
    if (isoDate == null) return 'Unknown';
    try {
      final date = DateTime.parse(isoDate).toLocal();
      return '${date.day}-${date.month}-${date.year}';
    } catch (e) {
      return 'Invalid Date';
    }
  }
}

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ProfileItem({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spaceSM),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.slate400),
          const SizedBox(width: AppTheme.spaceMD),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTheme.bodySM),
              Text(value, style: AppTheme.bodyLG.copyWith(fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}
