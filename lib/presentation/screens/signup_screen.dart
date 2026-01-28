import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/presentation/providers/wishlist_provider.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/theme_provider.dart';
import '../../core/utils/helpers.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _phone = TextEditingController();

  bool _isLoading = false;
  bool _obscure = true;

  late AnimationController _shakeController;
  late Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnim = Tween<double>(begin: 0, end: 12).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) {
      _shakeController.forward().then((_) => _shakeController.reset());
      return;
    }

    setState(() => _isLoading = true);

    try {
      await context.read<AuthProvider>().register(
            _name.text.trim(),
            _email.text.trim(),
            _password.text,
            _phone.text.trim(),
          );

      context.read<CartProvider>().clearCart();


      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      _shakeController.forward().then((_) => _shakeController.reset());

      String message = "Signup failed";
      if (e.toString().toLowerCase().contains('exist')) {
        message = "User already exists with this email";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final th = context.watch<ThemeProvider>();
    final isDark = th.isDark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [Colors.black, Colors.deepPurple.shade900]
                : [Colors.purple.shade300, Colors.pink.shade300],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: AnimatedBuilder(
              animation: _shakeAnim,
              builder: (_, child) => Transform.translate(
                offset: Offset(_shakeAnim.value, 0),
                child: child,
              ),
              child: Card(
                elevation: 20,
                color: isDark ? Colors.grey[850] : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.purple,
                          child: Icon(Icons.person_add,
                              size: 50, color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Create Account",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),

                        /// NAME
                        TextFormField(
                          controller: _name,
                          decoration: _input(
                            "Full Name",
                            Icons.person,
                            isDark,
                          ),
                          validator: (v) =>
                              v!.isEmpty ? "Enter your name" : null,
                        ),
                        const SizedBox(height: 16),

                        /// EMAIL
                        TextFormField(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: _input(
                            "Email",
                            Icons.email_outlined,
                            isDark,
                          ),
                          validator: (v) {
                            if (v!.isEmpty) return "Enter your email";
                            if (!Helpers.isValidEmail(v)) {
                              return "Enter a valid email";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        /// PASSWORD
                        TextFormField(
                          controller: _password,
                          obscureText: _obscure,
                          decoration: _input(
                            "Password",
                            Icons.lock,
                            isDark,
                          ).copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                  _obscure
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey),
                              onPressed: () =>
                                  setState(() => _obscure = !_obscure),
                            ),
                          ),
                          validator: (v) =>
                              v!.length < 6 ? "Min 6 characters" : null,
                        ),
                        const SizedBox(height: 16),

                        /// PHONE NUMBER ✅ FIXED
                        TextFormField(
                          controller: _phone,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: _input(
                            "Phone Number",
                            Icons.phone,
                            isDark,
                          ).copyWith(counterText: ""),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return "Enter your phone number";
                            }
                            if (!RegExp(r'^[0-9]{10}$').hasMatch(v)) {
                              return "Phone number must be 10 digits";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 26),

                        /// SIGNUP BUTTON
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _signup,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text(
                                    "Create Account",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already have an account? "),
                            TextButton(
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/login'),
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _input(String label, IconData icon, bool isDark) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }
}
