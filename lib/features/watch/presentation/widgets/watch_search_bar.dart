import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/colors.dart';
import '../bloc/watch_bloc.dart';
import '../bloc/watch_event.dart';

class WatchSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const WatchSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  State<WatchSearchBar> createState() => _WatchSearchBarState();
}

class _WatchSearchBarState extends State<WatchSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
      child: TextField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        onSubmitted: (val) {
          context.read<WatchBloc>().add(SubmitSearch());
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.inputFill,
          hintText: 'TV shows, movies and more',
          hintStyle: const TextStyle(color: AppColors.greyText),
          prefixIcon: const Icon(Icons.search, color: AppColors.darkPurple),
          suffixIcon: IconButton(
            icon: const Icon(Icons.close, color: AppColors.darkPurple),
            onPressed: () {
              context.read<WatchBloc>().add(ToggleSearch());
            },
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
