import 'package:flutter/material.dart';

import 'summary_card.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        ),
        home: const SignUpScreen(),
      );
}

const groups = ['IT-2301', 'IT-2302', 'IT-2303', 'IT-2304', 'IT-2305'];

/// dd.mm.yyyy with padLeft.
String formatDate(DateTime d) {
  final day = d.day.toString().padLeft(2, '0');
  final month = d.month.toString().padLeft(2, '0');
  return '$day.$month.${d.year}';
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Controllers, the focus node and the key are created ONCE, as fields of
  // State, and disposed here. Never in build().
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _birthText = TextEditingController();
  final _emailFocus = FocusNode();

  // The values of the inputs that are not typing.
  String? _group;
  DateTime? _birth;
  bool _agreed = false;
  int _passwordLength = 0;
  bool _done = false;

  @override
  void dispose() {
    for (final c in [_name, _email, _password, _confirm, _birthText]) {
      c.dispose();
    }
    _emailFocus.dispose();
    super.dispose();
  }

  // ---- Level 3: a tap on the empty background folds the keyboard ----
  void _unfocus(PointerDownEvent _) =>
      FocusManager.instance.primaryFocus?.unfocus();

  // ---- Level 2: validators. null = fine, String = show this. ----
  // The parameter is String?, so null is handled honestly (no null-assert).
  String? _validateName(String? v) =>
      (v ?? '').trim().length < 2 ? 'Name is too short' : null;

  String? _validateEmail(String? v) {
    final s = (v ?? '').trim();
    final at = s.indexOf('@');
    if (at == -1 || s.indexOf('.', at) == -1) return 'Email looks wrong';
    return null;
  }

  String? _validatePassword(String? v) =>
      (v ?? '').length < 8 ? 'Password is too short' : null;

  // A validator that reads another controller.
  String? _validateConfirm(String? v) =>
      v != _password.text ? 'Passwords do not match' : null;

  String? _validateGroup(String? g) => g == null ? 'Choose a group' : null;

  String? _validateBirth(String? _) =>
      _birth == null ? 'Pick your date of birth' : null;

  // ---- Level 4: the date picker ----
  Future<void> _pickBirth() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birth ?? DateTime(2005),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    // Cancel returns null: keep the old value. mounted: we may be gone.
    if (picked == null || !mounted) return;
    setState(() {
      _birth = picked;
      _birthText.text = formatDate(picked);
    });
  }

  // ---- The Sign up handler ----
  void _submit() {
    // The one bang allowed in this project: the Form is built by now.
    if (!_formKey.currentState!.validate()) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account created')),
    );
    setState(() => _done = true);
  }

  // ---- Level 5: Start over ----
  void _startOver() {
    // _formKey.currentState is null here: the Form is not on screen while
    // the summary is shown. So we only reset our own values.
    setState(() {
      for (final c in [_name, _email, _password, _confirm, _birthText]) {
        c.clear();
      }
      _group = null;
      _birth = null;
      _agreed = false;
      _passwordLength = 0;
      _done = false;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Sign up')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: _done ? _summary() : _form(),
        ),
      );

  Widget _summary() {
    // A local copy lets Dart prove it is not null: no bang needed.
    final birth = _birth;
    return Column(
      children: [
        SummaryCard(
          name: _name.text,
          email: _email.text,
          group: _group ?? '',
          birth: birth == null ? '' : formatDate(birth),
        ),
        const SizedBox(height: 16),
        TextButton(onPressed: _startOver, child: const Text('Start over')),
      ],
    );
  }

  Widget _form() => Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Name'),
              textInputAction: TextInputAction.next,
              // A specific target, not the default "next".
              onFieldSubmitted: (_) => _emailFocus.requestFocus(),
              onTapOutside: _unfocus,
              validator: _validateName,
            ),
            TextFormField(
              controller: _email,
              focusNode: _emailFocus,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'name@kbtu.kz',
              ),
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              textInputAction: TextInputAction.next,
              onTapOutside: _unfocus,
              validator: _validateEmail,
            ),
            TextFormField(
              controller: _password,
              decoration: const InputDecoration(
                labelText: 'Password',
                helperText: 'At least 8 characters',
              ),
              obscureText: true,
              textInputAction: TextInputAction.next,
              // value in, onChanged out, setState closes the loop.
              onChanged: (v) => setState(() => _passwordLength = v.length),
              onTapOutside: _unfocus,
              validator: _validatePassword,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('$_passwordLength of 8'),
            ),
            TextFormField(
              controller: _confirm,
              decoration: const InputDecoration(labelText: 'Confirm password'),
              obscureText: true,
              textInputAction: TextInputAction.done,
              // Same method as the button; the button is disabled until the
              // checkbox is ticked, so the keyboard must respect that too.
              onFieldSubmitted: (_) {
                if (_agreed) _submit();
              },
              onTapOutside: _unfocus,
              validator: _validateConfirm,
            ),
            DropdownButtonFormField<String>(
              initialValue: _group,
              decoration: const InputDecoration(labelText: 'Group'),
              items: [
                for (final g in groups)
                  DropdownMenuItem(value: g, child: Text(g)),
              ],
              onChanged: (g) => setState(() => _group = g),
              validator: _validateGroup,
            ),
            TextFormField(
              controller: _birthText,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Date of birth',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: _pickBirth,
              onTapOutside: _unfocus,
              validator: _validateBirth,
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('I agree to the rules'),
              value: _agreed,
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (v) => setState(() => _agreed = v ?? false),
            ),
            // A fixed gap, not a Spacer: a Spacer needs a bounded parent and
            // a scroll view is not one.
            const SizedBox(height: 24),
            FilledButton(
              // null = disabled: the framework greys the button for us.
              onPressed: _agreed ? _submit : null,
              child: const Text('Sign up'),
            ),
          ],
        ),
      );
}
