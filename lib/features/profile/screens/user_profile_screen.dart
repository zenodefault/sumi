import 'package:flutter/material.dart';
import '../../../core/app_icons.dart';
import 'package:provider/provider.dart';
import '../../../core/app_colors.dart';
import '../../../core/providers.dart';
import '../../../core/models.dart';
import '../../../core/glass_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  static final Uri _chai4MeUri = Uri.parse('https://chai4.me/zeno');
  bool _isEditing = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  Sex _sex = Sex.other;
  ActivityLevel _activityLevel = ActivityLevel.low;
  String? _lastSyncedUserKey;

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _syncFromUser(User? user) {
    if (user == null) return;
    final nextKey =
        '${user.id}|${user.name}|${user.weight}|${user.heightCm}|${user.age}|'
        '${user.sex}|${user.activityLevel}';
    if (_lastSyncedUserKey == nextKey) {
      return;
    }
    _lastSyncedUserKey = nextKey;
    _nameController.text = user.name;
    _weightController.text = user.weight.toString();
    _heightController.text = user.heightCm.toString();
    _ageController.text = user.age.toString();
    _sex = user.sex;
    _activityLevel = user.activityLevel;
  }

  Future<void> _save(User? user) async {
    final provider = Provider.of<FitnessProvider>(context, listen: false);
    final updated = (user ??
            User(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              name: '',
              weight: 0,
              age: 0,
              sex: Sex.other,
              heightCm: 0,
              activityLevel: ActivityLevel.low,
              createdAt: DateTime.now(),
            ))
        .copyWith(
          name: _nameController.text.trim().isEmpty
              ? 'User'
              : _nameController.text.trim(),
          weight:
              double.tryParse(_weightController.text) ?? (user?.weight ?? 0),
          heightCm:
              double.tryParse(_heightController.text) ?? (user?.heightCm ?? 0),
          age: int.tryParse(_ageController.text) ?? (user?.age ?? 0),
          sex: _sex,
          activityLevel: _activityLevel,
        );
    await provider.updateUser(updated);
    if (mounted) {
      setState(() => _isEditing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    final user = context.select<FitnessProvider, User?>((p) => p.user);
    if (!_isEditing) {
      _syncFromUser(user);
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor:
            isLight ? LightColors.foreground : DarkColors.foreground,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () async {
              if (_isEditing) {
                await _save(user);
              } else {
                setState(() => _isEditing = true);
              }
            },
            icon: AppIcon(_isEditing ? AppIcons.save : AppIcons.edit),
            tooltip: _isEditing ? 'Save' : 'Edit',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GlassCard(
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: isLight
                        ? LightColors.primary.withOpacity(0.1)
                        : DarkColors.primary.withOpacity(0.1),
                    child: AppIcon(
                      AppIcons.user,
                      size: 26,
                      color: isLight ? LightColors.primary : DarkColors.primary,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _isEditing
                            ? TextField(
                                controller: _nameController,
                                decoration:
                                    const InputDecoration(labelText: 'Name'),
                              )
                            : Text(
                                user?.name ?? 'Your Name',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: isLight
                                      ? LightColors.foreground
                                      : DarkColors.foreground,
                                ),
                              ),
                        const SizedBox(height: 4),
                        Text(
                          user == null
                              ? 'Complete your profile'
                              : 'Member since ${user.createdAt.year}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isLight
                                ? LightColors.mutedForeground
                                : DarkColors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Profile details',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: isLight
                    ? LightColors.mutedForeground
                    : DarkColors.mutedForeground,
              ),
            ),
            const SizedBox(height: 8),
            if (_isEditing)
              GlassCard(
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Weight (kg)',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _heightController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Height (cm)',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Age'),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<Sex>(
                      value: _sex,
                      decoration: const InputDecoration(labelText: 'Sex'),
                      items: Sex.values
                          .map(
                            (value) => DropdownMenuItem(
                              value: value,
                              child: Text(value.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _sex = value);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<ActivityLevel>(
                      value: _activityLevel,
                      decoration: const InputDecoration(
                        labelText: 'Activity Level',
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: ActivityLevel.low,
                          child: Text('Low active'),
                        ),
                        DropdownMenuItem(
                          value: ActivityLevel.moderate,
                          child: Text('Moderately active'),
                        ),
                        DropdownMenuItem(
                          value: ActivityLevel.high,
                          child: Text('Highly active'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _activityLevel = value);
                        }
                      },
                    ),
                  ],
                ),
              )
            else
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.start,
                runAlignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: [
                  _statPill(
                    theme,
                    label: 'Weight',
                    value: user == null ? '—' : '${user.weight} kg',
                    isLight: isLight,
                  ),
                  _statPill(
                    theme,
                    label: 'Height',
                    value: user == null ? '—' : '${user.heightCm} cm',
                    isLight: isLight,
                  ),
                  _statPill(
                    theme,
                    label: 'Age',
                    value: user == null ? '—' : '${user.age}',
                    isLight: isLight,
                  ),
                  _statPill(
                    theme,
                    label: 'Sex',
                    value: user == null ? '—' : user.sex.name,
                    isLight: isLight,
                  ),
                  _statPill(
                    theme,
                    label: 'Activity',
                    value: user == null
                        ? '—'
                        : _activityLabel(user.activityLevel),
                    isLight: isLight,
                  ),
                ],
              ),
            const SizedBox(height: 16),
            _buildChai4MeCard(theme, isLight),
          ],
        ),
      ),
    );
  }

  Widget _buildChai4MeCard(ThemeData theme, bool isLight) {
    return GlassCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          await launchUrl(
            _chai4MeUri,
            mode: LaunchMode.externalApplication,
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.dividerColor.withOpacity(0.5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                'https://chai4.me/icons/wordmark.png',
                height: 28,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 10),
              Text(
                '@zeno',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isLight
                      ? LightColors.mutedForeground
                      : DarkColors.mutedForeground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(
    ThemeData theme, {
    required String label,
    required String value,
    required bool isLight,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isLight
                ? LightColors.mutedForeground
                : DarkColors.mutedForeground,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isLight ? LightColors.foreground : DarkColors.foreground,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _statPill(
    ThemeData theme, {
    required String label,
    required String value,
    required bool isLight,
  }) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      borderRadius: 16,
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isLight
                  ? LightColors.mutedForeground
                  : DarkColors.mutedForeground,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isLight ? LightColors.foreground : DarkColors.foreground,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  String _activityLabel(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.low:
        return 'Low active';
      case ActivityLevel.moderate:
        return 'Moderately active';
      case ActivityLevel.high:
        return 'Highly active';
    }
  }
}
