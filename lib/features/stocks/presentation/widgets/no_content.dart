import 'package:flutter/material.dart';

class NoContent extends StatelessWidget {
  const NoContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('No Data Found'),
    );
  }
}
