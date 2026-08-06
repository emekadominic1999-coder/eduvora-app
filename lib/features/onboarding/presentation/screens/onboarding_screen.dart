import 'package:flutter/material.dart';

import '../../../../core/data/academic_structure.dart';
import '../../../../core/data/nigerian_institutions.dart';
import '../../../../core/models/institution.dart';
import '../../../../core/models/student_profile.dart';
import '../../../../core/state/session_controller.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';
import '../../../../core/widgets/eduvora_logo.dart';
import '../../../../core/widgets/institution_crest.dart';
import '../../../home/presentation/screens/home_shell.dart';

/// Five short steps that establish a student's academic identity.
///
/// Every content feed in Eduvora filters against what is chosen here, so the
/// flow is deliberately unhurried: institution type, then the institution
/// itself (searchable across every school in Nigeria), then faculty,
/// department and level.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, this.editing = false});

  /// When true the screen is being used to amend an existing profile rather
  /// than to complete first-time setup.
  final bool editing;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pages = PageController();
  final TextEditingController _search = TextEditingController();
  final TextEditingController _matric = TextEditingController();

  int _step = 0;
  static const int _lastStep = 4;

  InstitutionType? _type;
  Institution? _institution;
  Faculty? _faculty;
  String? _department;
  String? _level;

  String _query = '';
  String? _stateFilter;
  Ownership? _ownershipFilter;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final StudentProfile? existing = sessionController.profile;
    if (existing != null && existing.institutionName.isNotEmpty) {
      _type = existing.institutionType;
      _institution = NigerianInstitutions.byName(existing.institutionName);
      _faculty = AcademicStructure.facultyByName(
        existing.institutionType,
        existing.faculty,
        institutionName: existing.institutionName,
      );
      _department = existing.department.isEmpty ? null : existing.department;
      _level = existing.level.isEmpty ? null : existing.level;
      _matric.text = existing.matricNumber;
    }
  }

  @override
  void dispose() {
    _pages.dispose();
    _search.dispose();
    _matric.dispose();
    super.dispose();
  }

  bool get _canAdvance {
    switch (_step) {
      case 0:
        return _type != null;
      case 1:
        return _institution != null;
      case 2:
        return _faculty != null;
      case 3:
        return _department != null;
      case 4:
        return _level != null;
      default:
        return false;
    }
  }

  void _next() {
    if (!_canAdvance) return;
    if (_step == _lastStep) {
      _finish();
      return;
    }
    setState(() => _step++);
    _pages.animateToPage(
      _step,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
    _search.clear();
    _query = '';
  }

  void _back() {
    if (_step == 0) {
      if (widget.editing) Navigator.of(context).maybePop();
      return;
    }
    setState(() => _step--);
    _pages.animateToPage(
      _step,
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
    );
    _search.clear();
    _query = '';
  }

  Future<void> _finish() async {
    final StudentProfile? current = sessionController.profile;
    if (current == null || _institution == null) return;

    setState(() => _saving = true);
    try {
      final StudentProfile updated = current
          .withInstitution(_institution!)
          .copyWith(
            faculty: _faculty?.name ?? '',
            department: _department ?? '',
            level: _level ?? '',
            matricNumber: _matric.text.trim(),
          );
      await sessionController.saveProfile(updated);
      if (!mounted) return;

      if (widget.editing) {
        Navigator.of(context).pop(true);
        showEduvoraSnack(context, 'Your academic details have been updated.');
      } else {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute<void>(builder: (_) => const HomeShell()),
          (Route<dynamic> _) => false,
        );
      }
    } catch (error) {
      if (!mounted) return;
      showEduvoraSnack(
        context,
        SessionController.describeError(error),
        isError: true,
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  // ---------------------------------------------------------------- build

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.editing && _step == 0,
      onPopInvokedWithResult: (bool didPop, _) {
        if (!didPop && _step > 0) _back();
      },
      child: Scaffold(
        backgroundColor: AppColours.background,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              _header(),
              Expanded(
                child: PageView(
                  controller: _pages,
                  physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    _typeStep(),
                    _institutionStep(),
                    _facultyStep(),
                    _departmentStep(),
                    _levelStep(),
                  ],
                ),
              ),
              _footerBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    const List<String> titles = <String>[
      'What kind of institution do you attend?',
      'Find your institution',
      'Choose your faculty',
      'Choose your department',
      'What level are you in?',
    ];
    const List<String> subtitles = <String>[
      'This decides how your levels and schools of study are labelled.',
      'Search by name, abbreviation or state — every Nigerian institution is here.',
      'Your faculty narrows the departments and the CBT papers you are offered.',
      'Everything you see in Eduvora will be filtered to this department.',
      'Almost there. Your level keeps your library relevant.',
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.md,
        AppSpacing.screenPadding,
        AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              if (_step > 0 || widget.editing)
                IconButton(
                  onPressed: _back,
                  icon: const Icon(Icons.arrow_back_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColours.surface,
                    padding: const EdgeInsets.all(9),
                  ),
                )
              else
                const EduvoraLogo(size: 38),
              const Spacer(),
              Text(
                'Step ${_step + 1} of ${_lastStep + 1}',
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: AppColours.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: List<Widget>.generate(_lastStep + 1, (int i) {
              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 260),
                  height: 5,
                  margin: EdgeInsets.only(right: i == _lastStep ? 0 : 5),
                  decoration: BoxDecoration(
                    color: i <= _step ? AppColours.primary : AppColours.border,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(titles[_step], style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 5),
          Text(subtitles[_step], style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  // -------------------------------------------------------------- step 0

  Widget _typeStep() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.md,
        AppSpacing.screenPadding,
        AppSpacing.xl,
      ),
      children: InstitutionType.values.map((InstitutionType type) {
        final bool selected = _type == type;
        final int count = NigerianInstitutions.countOf(type);
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: EduvoraCard(
            onTap: () => setState(() {
              _type = type;
              _institution = null;
              _faculty = null;
              _department = null;
              _level = null;
            }),
            padding: const EdgeInsets.all(AppSpacing.lg),
            border: Border.all(
              color: selected ? AppColours.primary : AppColours.border,
              width: selected ? 1.8 : 1,
            ),
            shadows: selected ? AppShadows.card : AppShadows.subtle,
            child: Row(
              children: <Widget>[
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColours.primary
                        : AppColours.primaryTint,
                    borderRadius: AppRadii.md,
                  ),
                  child: Icon(
                    type.icon,
                    size: 24,
                    color: selected ? Colors.white : AppColours.primary,
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        type.plural,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '$count listed · '
                        '${AcademicStructure.levelsFor(type).length} levels',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Icon(
                  selected
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: selected
                      ? AppColours.primary
                      : AppColours.borderStrong,
                  size: 22,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // -------------------------------------------------------------- step 1

  Widget _institutionStep() {
    final List<Institution> results = NigerianInstitutions.search(
      _query,
      type: _type,
      state: _stateFilter,
      ownership: _ownershipFilter,
    );

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            AppSpacing.md,
            AppSpacing.screenPadding,
            AppSpacing.md,
          ),
          child: SearchField(
            controller: _search,
            hint: 'e.g. UNILAG, Federal Poly Nekede, Kano',
            onChanged: (String v) => setState(() => _query = v),
          ),
        ),
        SizedBox(
          height: 38,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
            ),
            children: <Widget>[
              _miniChip(
                label: _ownershipFilter?.label ?? 'All ownership',
                active: _ownershipFilter != null,
                onTap: _pickOwnership,
              ),
              const SizedBox(width: AppSpacing.sm),
              _miniChip(
                label: _stateFilter ?? 'All states',
                active: _stateFilter != null,
                onTap: _pickState,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            AppSpacing.md,
            AppSpacing.screenPadding,
            AppSpacing.sm,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${results.length} '
              '${results.length == 1 ? 'institution' : 'institutions'} found',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),
        Expanded(
          child: results.isEmpty
              ? const EmptyState(
                  icon: Icons.search_off_rounded,
                  title: 'No match yet',
                  message:
                      'Try a shorter search, or clear the state and ownership '
                      'filters.',
                  compact: true,
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding,
                    0,
                    AppSpacing.screenPadding,
                    AppSpacing.xl,
                  ),
                  itemCount: results.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (BuildContext context, int index) {
                    final Institution i = results[index];
                    final bool selected = _institution == i;
                    return EduvoraCard(
                      onTap: () => setState(() {
                        _institution = i;
                        _faculty = null;
                        _department = null;
                        _level = null;
                      }),
                      padding: const EdgeInsets.all(AppSpacing.md),
                      shadows: AppShadows.subtle,
                      border: Border.all(
                        color: selected
                            ? AppColours.primary
                            : AppColours.border,
                        width: selected ? 1.7 : 1,
                      ),
                      child: Row(
                        children: <Widget>[
                          InstitutionCrest.of(i, size: 40),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  i.name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    height: 1.3,
                                    fontWeight: FontWeight.w600,
                                    color: AppColours.text,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: <Widget>[
                                    Pill(
                                      label: i.ownership.label,
                                      dense: true,
                                      colour: i.ownership == Ownership.federal
                                          ? AppColours.primary
                                          : i.ownership == Ownership.state
                                          ? AppColours.info
                                          : AppColours.accent,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      i.state,
                                      style: const TextStyle(
                                        fontSize: 11.5,
                                        color: AppColours.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (selected)
                            const Icon(
                              Icons.check_circle_rounded,
                              color: AppColours.primary,
                              size: 21,
                            ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _miniChip({
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    return Material(
      color: active ? AppColours.primaryTint : AppColours.surfaceMuted,
      borderRadius: AppRadii.pill,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.pill,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: active ? AppColours.primary : AppColours.textMuted,
                ),
              ),
              const SizedBox(width: 3),
              Icon(
                Icons.expand_more_rounded,
                size: 16,
                color: active ? AppColours.primary : AppColours.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickOwnership() async {
    final Ownership? picked = await _pickFromSheet<Ownership>(
      title: 'Ownership',
      values: Ownership.values,
      labelOf: (Ownership o) => o.label,
      selected: _ownershipFilter,
      allLabel: 'All ownership',
    );
    setState(() => _ownershipFilter = picked);
  }

  Future<void> _pickState() async {
    final String? picked = await _pickFromSheet<String>(
      title: 'State',
      values: NigerianInstitutions.states,
      labelOf: (String s) => s,
      selected: _stateFilter,
      allLabel: 'All states',
    );
    setState(() => _stateFilter = picked);
  }

  Future<T?> _pickFromSheet<T>({
    required String title,
    required List<T> values,
    required String Function(T) labelOf,
    required T? selected,
    required String allLabel,
  }) {
    return showModalBottomSheet<T?>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          builder: (BuildContext context, ScrollController controller) {
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.xl,
                    AppSpacing.sm,
                    AppSpacing.xl,
                    AppSpacing.md,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    controller: controller,
                    padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                    children: <Widget>[
                      ListTile(
                        title: Text(allLabel),
                        trailing: selected == null
                            ? const Icon(
                                Icons.check_rounded,
                                color: AppColours.primary,
                              )
                            : null,
                        onTap: () => Navigator.of(context).pop(null),
                      ),
                      ...values.map(
                        (T v) => ListTile(
                          title: Text(labelOf(v)),
                          trailing: v == selected
                              ? const Icon(
                                  Icons.check_rounded,
                                  color: AppColours.primary,
                                )
                              : null,
                          onTap: () => Navigator.of(context).pop(v),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // -------------------------------------------------------------- step 2

  Widget _facultyStep() {
    final InstitutionType type = _type ?? InstitutionType.university;
    final List<Faculty> faculties = AcademicStructure.facultiesForInstitution(
      _institution?.name ?? '',
      type,
    );

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.md,
        AppSpacing.screenPadding,
        AppSpacing.xl,
      ),
      itemCount: faculties.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (BuildContext context, int index) {
        final Faculty f = faculties[index];
        final bool selected = _faculty?.name == f.name;
        return EduvoraCard(
          onTap: () => setState(() {
            _faculty = f;
            _department = null;
          }),
          padding: const EdgeInsets.all(AppSpacing.md),
          shadows: AppShadows.subtle,
          border: Border.all(
            color: selected ? AppColours.primary : AppColours.border,
            width: selected ? 1.7 : 1,
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: f.colour.withValues(alpha: selected ? 1 : 0.11),
                  borderRadius: AppRadii.sm,
                ),
                child: Icon(
                  f.icon,
                  size: 21,
                  color: selected ? Colors.white : f.colour,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      f.name,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.3,
                        fontWeight: FontWeight.w600,
                        color: AppColours.text,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${f.departments.length} departments',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              if (selected)
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColours.primary,
                  size: 21,
                ),
            ],
          ),
        );
      },
    );
  }

  // -------------------------------------------------------------- step 3

  Widget _departmentStep() {
    final List<String> departments = _faculty?.departments ?? <String>[];
    final List<String> results = _query.trim().isEmpty
        ? departments
        : departments
              .where(
                (String d) =>
                    d.toLowerCase().contains(_query.trim().toLowerCase()),
              )
              .toList();

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            AppSpacing.md,
            AppSpacing.screenPadding,
            AppSpacing.md,
          ),
          child: SearchField(
            controller: _search,
            hint: 'Search departments',
            onChanged: (String v) => setState(() => _query = v),
          ),
        ),
        Expanded(
          child: results.isEmpty
              ? const EmptyState(
                  icon: Icons.school_outlined,
                  title: 'No department matches',
                  message:
                      'Try a different word, or go back and change the '
                      'faculty.',
                  compact: true,
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding,
                    0,
                    AppSpacing.screenPadding,
                    AppSpacing.xl,
                  ),
                  itemCount: results.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (BuildContext context, int index) {
                    final String d = results[index];
                    final bool selected = _department == d;
                    return EduvoraCard(
                      onTap: () => setState(() => _department = d),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.md,
                      ),
                      shadows: AppShadows.subtle,
                      border: Border.all(
                        color: selected
                            ? AppColours.primary
                            : AppColours.border,
                        width: selected ? 1.7 : 1,
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              d,
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.35,
                                fontWeight: selected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: selected
                                    ? AppColours.primary
                                    : AppColours.text,
                              ),
                            ),
                          ),
                          Icon(
                            selected
                                ? Icons.check_circle_rounded
                                : Icons.radio_button_unchecked_rounded,
                            size: 20,
                            color: selected
                                ? AppColours.primary
                                : AppColours.borderStrong,
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // -------------------------------------------------------------- step 4

  Widget _levelStep() {
    final InstitutionType type = _type ?? InstitutionType.university;
    final List<String> levels = AcademicStructure.levelsFor(type);

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.md,
        AppSpacing.screenPadding,
        AppSpacing.xl,
      ),
      children: <Widget>[
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: levels.map((String level) {
            final bool selected = _level == level;
            return GestureDetector(
              onTap: () => setState(() => _level = level),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: selected ? AppColours.primary : AppColours.surface,
                  borderRadius: AppRadii.md,
                  border: Border.all(
                    color: selected ? AppColours.primary : AppColours.border,
                    width: selected ? 1.7 : 1,
                  ),
                  boxShadow: AppShadows.subtle,
                ),
                child: Text(
                  level,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected ? Colors.white : AppColours.text,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: AppSpacing.xxl),
        Text(
          'Matriculation number',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 4),
        Text(
          'Optional — it simply appears on your profile.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: _matric,
          textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(
            hintText: 'e.g. ENG/2021/0345',
            prefixIcon: Icon(Icons.badge_outlined, size: 20),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        if (_institution != null && _department != null) _summaryCard(),
      ],
    );
  }

  Widget _summaryCard() {
    return EduvoraCard(
      colour: AppColours.primaryTint,
      shadows: const <BoxShadow>[],
      border: Border.all(color: AppColours.primarySoft),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(
                Icons.verified_rounded,
                size: 18,
                color: AppColours.primary,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Your Eduvora profile',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: AppColours.primaryDeep),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _summaryRow('Institution', _institution!.name),
          _summaryRow(
            AcademicStructure.facultyLabelFor(
              _type ?? InstitutionType.university,
            ),
            _faculty?.name ?? '—',
          ),
          _summaryRow('Department', _department ?? '—'),
          _summaryRow('Level', _level ?? 'Not chosen yet'),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 92,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AppColours.textMuted,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12.5,
                height: 1.4,
                fontWeight: FontWeight.w600,
                color: AppColours.primaryDeep,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------- footer

  Widget _footerBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.md,
        AppSpacing.screenPadding,
        AppSpacing.lg,
      ),
      decoration: const BoxDecoration(
        color: AppColours.surface,
        border: Border(top: BorderSide(color: AppColours.border)),
      ),
      child: FilledButton(
        onPressed: (_canAdvance && !_saving) ? _next : null,
        child: _saving
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(_step == _lastStep ? 'Enter Eduvora' : 'Continue'),
      ),
    );
  }
}
