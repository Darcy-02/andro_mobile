import 'package:flutter/material.dart';
import 'theme_colors.dart';
import 'login_page.dart';
import 'user_store.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final ThemeMode themeMode;

  const RegisterPage({
    super.key,
    required this.onToggleTheme,
    required this.themeMode,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool _showPassword = false;
  bool _showConfirm = false;
  String _errorMessage = '';

  bool get _isDark => widget.themeMode == ThemeMode.dark;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _register() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirm.isEmpty) {
      setState(() => _errorMessage = 'Please fill in all fields.');
      return;
    }
    if (!email.contains('@')) {
      setState(() => _errorMessage = 'Enter an email address.');
      return;
    }
    if (password.length < 6) {
      setState(() => _errorMessage = 'Password must be at least 6 characters.');
      return;
    }
    if (password != confirm) {
      setState(() => _errorMessage = 'Passwords do not match.');
      return;
    }
    if (UserStore.emailExists(email)) {
      setState(() => _errorMessage = 'This email is already registered.');
      return;
    }

    UserStore.addUser(name: name, email: email, password: password);
    setState(() => _errorMessage = '');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Account created! Sign in to Enter Andro Galaxy.'),
        backgroundColor: _isDark
            ? AndroColors.darkAccent
            : AndroColors.lightAccent,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bg = _isDark
        ? AndroColors.darkBackground
        : AndroColors.lightBackground;
    final surface = _isDark
        ? AndroColors.darkSurface
        : AndroColors.lightSurface;
    final accent = _isDark ? AndroColors.darkAccent : AndroColors.lightAccent;
    final text = _isDark ? AndroColors.darkText : AndroColors.lightText;
    final sub = _isDark
        ? AndroColors.darkSecondary
        : AndroColors.lightSecondary;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        foregroundColor: text,
        elevation: 0,
        title: Text(
          'Create account',
          style: TextStyle(color: text, fontWeight: FontWeight.bold),
        ),
        actions: [
          GestureDetector(
            onTap: widget.onToggleTheme,
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: sub.withOpacity(0.3)),
              ),
              child: Icon(
                _isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                color: sub,
                size: 18,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Form card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(_isDark ? 0.25 : 0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Full Name', sub),
                    const SizedBox(height: 6),
                    _buildTextField(
                      controller: _nameController,
                      hint: 'Input your full name',
                      icon: Icons.person_outline,
                      bg: bg,
                      text: text,
                      sub: sub,
                      accent: accent,
                    ),

                    const SizedBox(height: 18),

                    _buildLabel('Email', sub),
                    const SizedBox(height: 6),
                    _buildTextField(
                      controller: _emailController,
                      hint: 'you@email.com',
                      icon: Icons.mail_outline,
                      keyboard: TextInputType.emailAddress,
                      bg: bg,
                      text: text,
                      sub: sub,
                      accent: accent,
                    ),

                    const SizedBox(height: 18),

                    _buildLabel('Password', sub),
                    const SizedBox(height: 6),
                    _buildTextField(
                      controller: _passwordController,
                      hint: '••••••••',
                      icon: Icons.lock_outline,
                      obscure: !_showPassword,
                      bg: bg,
                      text: text,
                      sub: sub,
                      accent: accent,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: sub,
                          size: 20,
                        ),
                        onPressed: () =>
                            setState(() => _showPassword = !_showPassword),
                      ),
                    ),

                    const SizedBox(height: 18),

                    _buildLabel('Confirm Password', sub),
                    const SizedBox(height: 6),
                    _buildTextField(
                      controller: _confirmController,
                      hint: '••••••••',
                      icon: Icons.lock_outline,
                      obscure: !_showConfirm,
                      bg: bg,
                      text: text,
                      sub: sub,
                      accent: accent,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showConfirm
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: sub,
                          size: 20,
                        ),
                        onPressed: () =>
                            setState(() => _showConfirm = !_showConfirm),
                      ),
                    ),

                    if (_errorMessage.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        _errorMessage,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Register button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Create Account',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Link to login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: TextStyle(color: sub, fontSize: 13),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(
                            onToggleTheme: widget.onToggleTheme,
                            themeMode: widget.themeMode,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Sign in',
                      style: TextStyle(
                        color: accent,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, Color color) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required Color bg,
    required Color text,
    required Color sub,
    required Color accent,
    bool obscure = false,
    TextInputType keyboard = TextInputType.text,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboard,
      style: TextStyle(color: text, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: sub.withOpacity(0.5), fontSize: 14),
        prefixIcon: Icon(icon, color: accent, size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: bg,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: accent, width: 1.5),
        ),
      ),
    );
  }
}
