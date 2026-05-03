import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/gig.dart';
import '../providers/app_state.dart';
import '../theme/wp_theme.dart';

class PostGigSheet extends ConsumerStatefulWidget {
  const PostGigSheet({super.key});

  @override
  ConsumerState<PostGigSheet> createState() => _PostGigSheetState();
}

class _PostGigSheetState extends ConsumerState<PostGigSheet> {
  final _titleCtrl = TextEditingController();
  final _budgetCtrl = TextEditingController();
  final _timelineCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _selectedIndustry = '';
  String _selectedUrgency = 'Low';
  bool _isLoading = false;

  final List<String> _industries = [
    'Research', 'Creative', 'Tech', 'Writing', 'Logistics'
  ];

  final Map<String, String> _industryEmojis = {
    'Research': '🔬',
    'Creative': '🎨',
    'Tech': '💻',
    'Writing': '✍️',
    'Logistics': '📦',
  };

  @override
  void dispose() {
    _titleCtrl.dispose();
    _budgetCtrl.dispose();
    _timelineCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  bool get _isValid =>
      _titleCtrl.text.trim().isNotEmpty &&
      _budgetCtrl.text.trim().isNotEmpty &&
      _timelineCtrl.text.trim().isNotEmpty &&
      _selectedIndustry.isNotEmpty &&
      _descCtrl.text.trim().isNotEmpty;

  void _submitGig() async {
    if (!_isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill all required fields'),
          backgroundColor: WPTheme.black,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));

    final gig = Gig(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      poster: 'You',
      college: 'Anna University',
      budget: double.tryParse(_budgetCtrl.text.trim()) ?? 0,
      industry: _selectedIndustry,
      urgency: _selectedUrgency,
      emoji: _industryEmojis[_selectedIndustry] ?? '📋',
      timeline: _timelineCtrl.text.trim(),
      postedAt: DateTime.now(),
    );

    ref.read(appStateProvider).addGig(gig);

    if (mounted) {
      Navigator.pop(context);
      HapticFeedback.mediumImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('🐼 Gig launched successfully!'),
          backgroundColor: WPTheme.black,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      maxChildSize: 0.97,
      minChildSize: 0.5,
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: WPTheme.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              _buildSheetHandle(),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSheetHeader(),
                      const SizedBox(height: 28),
                      _buildField(
                        label: 'GIG TITLE',
                        hint: 'Enter your gig title',
                        controller: _titleCtrl,
                        icon: Icons.title_rounded,
                      ),
                      const SizedBox(height: 20),
                      _buildField(
                        label: 'BUDGET (₹)',
                        hint: 'Enter your budget (₹10 – ₹50,000)',
                        controller: _budgetCtrl,
                        icon: Icons.currency_rupee_rounded,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      _buildField(
                        label: 'TIMELINE',
                        hint: 'e.g. 2 Days, 1 Week',
                        controller: _timelineCtrl,
                        icon: Icons.timer_outlined,
                      ),
                      const SizedBox(height: 20),
                      _buildIndustryPicker(),
                      const SizedBox(height: 20),
                      _buildField(
                        label: 'DESCRIPTION',
                        hint: 'Clearly outline the deliverable...',
                        controller: _descCtrl,
                        icon: Icons.description_outlined,
                        maxLines: 5,
                      ),
                      const SizedBox(height: 20),
                      _buildUrgencyPicker(),
                      const SizedBox(height: 8),
                      _buildEscrowNote(),
                      const SizedBox(height: 28),
                      _buildLaunchButton(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSheetHandle() {
    return Column(
      children: [
        const SizedBox(height: 12),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: WPTheme.lightGrey,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _buildSheetHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('POST GIG', style: WPTheme.label(13, color: WPTheme.midGrey)),
            const SizedBox(height: 4),
            Text('CREATE A NEW\nOPPORTUNITY', style: WPTheme.display(26)),
          ],
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: WPTheme.offWhite,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.close, size: 18, color: WPTheme.darkGrey),
          ),
        ),
      ],
    );
  }

  Widget _buildField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: WPTheme.label(11)),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: WPTheme.offWhite,
            borderRadius: BorderRadius.circular(maxLines > 1 ? 16 : 50),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            onChanged: (_) => setState(() {}),
            style: WPTheme.body(15),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: WPTheme.body(14, color: WPTheme.midGrey),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: Icon(icon, color: WPTheme.midGrey, size: 18),
              ),
              prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                  vertical: maxLines > 1 ? 16 : 14, horizontal: maxLines > 1 ? 16 : 0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIndustryPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('FIELD', style: WPTheme.label(11)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _industries.map((ind) {
            final isSelected = ind == _selectedIndustry;
            return GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() => _selectedIndustry = ind);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? WPTheme.black : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? WPTheme.black : WPTheme.lightGrey,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_industryEmojis[ind] ?? '📋',
                        style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                    Text(
                      ind.toUpperCase(),
                      style: WPTheme.label(11,
                          color: isSelected ? WPTheme.white : WPTheme.darkGrey),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildUrgencyPicker() {
    final urgencies = ['Low', 'Medium', 'Priority'];
    final colors = [WPTheme.urgencyLow, WPTheme.urgencyMid, WPTheme.urgencyHigh];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('URGENCY', style: WPTheme.label(11)),
        const SizedBox(height: 10),
        Row(
          children: List.generate(urgencies.length, (i) {
            final u = urgencies[i];
            final isSelected = u == _selectedUrgency;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _selectedUrgency = u);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.only(right: i < 2 ? 8 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? WPTheme.black : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? WPTheme.black : WPTheme.lightGrey,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Text(
                      u.toUpperCase(),
                      style: WPTheme.label(11,
                          color: isSelected ? WPTheme.white : WPTheme.darkGrey),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildEscrowNote() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: WPTheme.bambooLight.withOpacity(0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: WPTheme.bambooLight, width: 1),
      ),
      child: Row(
        children: [
          const Text('🔒', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Budget is locked in escrow and released only after you approve the work.',
              style: WPTheme.body(12, color: WPTheme.darkGrey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLaunchButton() {
    return GestureDetector(
      onTap: _isLoading ? null : _submitGig,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: _isValid ? WPTheme.black : WPTheme.lightGrey,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: WPTheme.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  '🐼  LAUNCH GIG',
                  style: WPTheme.label(15,
                      color: _isValid ? WPTheme.white : WPTheme.midGrey),
                ),
        ),
      ),
    );
  }
}
