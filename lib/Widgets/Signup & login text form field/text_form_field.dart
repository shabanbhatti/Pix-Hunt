import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmailField extends StatelessWidget {
  const EmailField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.label,
    required this.prefixIcon,

    required this.onFieldSubmitted,
    required this.isForName,
  });
  final TextEditingController controller;
  final FocusNode focusNode;
  final String label;
  final IconData prefixIcon;
  final bool isForName;

  final void Function(String) onFieldSubmitted;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      color: Colors.transparent,
      child: Column(
        children: [
          TextFormField(
            controller: controller,
            focusNode: focusNode,
            validator: (value) {
              if (!isForName) {
                if (value == null || value.isEmpty) {
                  return 'Email is required';
                }
                if (!RegExp(
                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                ).hasMatch(value)) {
                  return 'Enter a valid email address';
                }
                return null;
              } else {
                if (value!.isEmpty) {
                  return 'Name is required';
                } else {
                  return null;
                }
              }
            },
            onFieldSubmitted: onFieldSubmitted,

            decoration: InputDecoration(
              label: Text(label),
              prefixIcon: Icon(prefixIcon),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),

              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.indigo, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------PASSWORD TEXT FIELD-----------------

class PasswordField extends StatelessWidget {
  const PasswordField({
    super.key,
    required this.controller,
    required this.focusNode,

    required this.onFieldSubmitted,
  });
  final TextEditingController controller;
  final FocusNode focusNode;

  final void Function(String) onFieldSubmitted;
  bool isValidPassword(String password) {
    final hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);

    return hasUppercase && hasNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        var isObscure = ref.watch(_obscureProvider.select((value) => value));
        return Container(
          height: 80,
          color: Colors.transparent,

          child: Column(
            children: [
              TextFormField(
                controller: controller,
                obscureText: isObscure,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }
                  if (!RegExp(r'[A-Z]').hasMatch(value)) {
                    return 'Password must contain at least one capital letter';
                  }
                  if (!RegExp(r'[0-9]').hasMatch(value)) {
                    return 'Password must contain at least one number';
                  }
                  return null;
                },
                onFieldSubmitted: onFieldSubmitted,
                focusNode: focusNode,
                decoration: InputDecoration(
                  suffixIcon:
                      (isObscure)
                          ? IconButton(
                            onPressed: () {
                              ref.read(_obscureProvider.notifier).toggled();
                            },
                            icon: Icon(Icons.visibility),
                          )
                          : IconButton(
                            onPressed: () {
                              ref.read(_obscureProvider.notifier).toggled();
                            },
                            icon: Icon(Icons.visibility_off),
                          ),

                  label: Text('Password'),
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.indigo, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ConfirmPasswordField extends StatelessWidget {
  const ConfirmPasswordField({
    super.key,
    required this.controller,
    required this.focusNode,

    required this.onFieldSubmitted,
    required this.validator,
  });
  final TextEditingController controller;
  final FocusNode focusNode;

  final void Function(String) onFieldSubmitted;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      color: Colors.transparent,
      child: Column(
        children: [
          Consumer(
            builder: (context, ref, child) {
              var isObscure = ref.watch(
                _obscureConfirmProvider.select((value) => value),
              );
              return TextFormField(
                controller: controller,
                obscureText: isObscure,
                validator:
                    validator ??
                    (v) {
                      return null;
                    },
                onFieldSubmitted: onFieldSubmitted,
                focusNode: focusNode,
                decoration: InputDecoration(
                  suffixIcon:
                      (isObscure)
                          ? IconButton(
                            onPressed: () {
                              ref
                                  .read(_obscureConfirmProvider.notifier)
                                  .toggled();
                            },
                            icon: Icon(Icons.visibility),
                          )
                          : IconButton(
                            onPressed: () {
                              ref
                                  .read(_obscureConfirmProvider.notifier)
                                  .toggled();
                            },
                            icon: Icon(Icons.visibility_off),
                          ),

                  label: Text('Confirm Password'),
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.indigo, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// -----------RIVERPOD PORTION-----------

final _obscureProvider = StateNotifierProvider<ObscureStateNotifier, bool>((
  ref,
) {
  return ObscureStateNotifier();
});

final _obscureConfirmProvider =
    StateNotifierProvider<ObscureStateNotifier, bool>((ref) {
      return ObscureStateNotifier();
    });

class ObscureStateNotifier extends StateNotifier<bool> {
  ObscureStateNotifier() : super(true);
  void toggled() {
    state = !state;
  }
}
