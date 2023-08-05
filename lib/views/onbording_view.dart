import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linktree/assets.dart';
import 'package:linktree/constants.dart';
import 'package:linktree/views/login_view.dart';
import 'package:linktree/views/widgets/secondary_button_widget.dart';

class OnBoardingView extends StatelessWidget {
  static String id = '/onBoardingView';

  const OnBoardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Spacer(),
            SvgPicture.asset(AssetsData.onBoardingImage),
            const Text(
              'Just one Scan for everything',
              style: TextStyle(
                  fontSize: 16,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            SecondaryButtonWidget(
              text: 'Get Started',
              width: double.infinity,
              onTap: () {
                Navigator.pushNamed(context, LoginView.id);
              },
            ),
            const Spacer()
          ],
        ),
      ),
    );
  }
}
