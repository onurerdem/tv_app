import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tv_app/features/authentication/presentation/pages/sign_in_page.dart';
import 'package:tv_app/features/series/presentation/widgets/show_onboarding_dialog.dart';
import '../widgets/show_exit_dialog.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      "title": "Discover Series",
      "description": "Find your favorite series and check out the details.",
      "image": "assets/images/undraw_video-streaming_cckz.svg"
    },
    {
      "title": "Follow Series",
      "description": "Keep track of new episodes and air dates.",
      "image": "assets/images/undraw_online-video_ecqg.svg"
    },
    {
      "title": "List Easily",
      "description": "Easily list your favorite series.",
      "image": "assets/images/undraw_home-cinema_jdm1.svg"
    },
  ];

  void _storeOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingCompleted', true);
  }

  void _navigateToSeries() async {
    final confirm = await showOnboardingDialog(context);
    if (confirm != true) {
      return;
    }
    _storeOnboardingCompleted();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SignInPage()),
    );
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        } else if (!didPop) {
          if (_currentPage == 0) {
            showExitDialog(context);
          } else {
            _previousPage();
          }
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  final data = _onboardingData[index];
                  return OrientationBuilder(
                    builder: (context, orientation) {
                      if (orientation == Orientation.portrait) {
                        return _buildPortraitLayout(context, data);
                      } else {
                        return _buildLandscapeLayout(context, data);
                      }
                    },
                  );
                },
              ),
            ),
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _onboardingData.length,
            (index) => _buildDot(index),
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _buildNavigationButtons(),
        ),
        SizedBox(height: MediaQuery.of(context).padding.bottom),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      minimumSize: const Size(0, 50),
    );
    if (_currentPage == 0) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _nextPage,
            style: buttonStyle,
            child: const Text("Next"),
          ),
        ),
      );
    } else if (_currentPage == _onboardingData.length - 1) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: _previousPage,
              style: buttonStyle,
              child: const Text("Previous"),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: _navigateToSeries,
              style: buttonStyle,
              child: const Text("Get Started"),
            ),
          )
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: _previousPage,
              style: buttonStyle,
              child: const Text("Previous"),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: _nextPage,
              style: buttonStyle,
              child: const Text("Next"),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildDot(int index) {
    return GestureDetector(
      onTap: () => _goToPage(index),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        height: 10,
        width: _currentPage == index ? 20 : 10,
        decoration: BoxDecoration(
          color: _currentPage == index ? Colors.blue : Colors.grey,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

Widget _buildPortraitLayout(BuildContext context, Map<String, String> data) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SvgPicture.asset(
        data["image"]!,
        height: MediaQuery.of(context).size.height / 3.33,
        semanticsLabel: data["title"]!,
      ),
      const SizedBox(height: 20),
      Text(
        data["title"]!,
        style: Theme.of(context)
            .textTheme
            .headlineMedium
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 10),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Text(
          data["description"]!,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    ],
  );
}

Widget _buildLandscapeLayout(BuildContext context, Map<String, String> data) {
  return Padding(
    padding:
        const EdgeInsets.only(top: 20.0, bottom: 15.0, left: 20.0, right: 20.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Spacer(
          flex: 1,
        ),
        Expanded(
          flex: 5,
          child: SvgPicture.asset(
            data["image"]!,
            semanticsLabel: data["title"]!,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          flex: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                data["title"]!,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                data["description"]!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
        Spacer(
          flex: 1,
        ),
      ],
    ),
  );
}
