import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/data.dart';
import 'business_bottom_sheet.dart';

class LedgerPageHeader extends StatelessWidget {
  const LedgerPageHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Consumer<DataModel>(
              builder: (context, value, child) {
                return value.activePlan == 'Premium'
                    ? Positioned(
                        top: -17,
                        child: Image.asset(
                          'assets/images/crown.png',
                          width: 23.0,
                        ),
                      )
                    : const SizedBox.shrink();
              },
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Colors.black), // Back arrow icon
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
        const SizedBox(width: 1.0),
        const Text(
          'Ledger',
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        const SizedBox(width: 20.0),
        GestureDetector(
          onTap: () => showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            builder: (context) {
              return const BusinessBottomSheet();
            },
          ),
          child: const CircleAvatar(
            radius: 16.5,
            backgroundImage: AssetImage('assets/images/user.png'),
          ),
        )
      ],
    );
  }
}
