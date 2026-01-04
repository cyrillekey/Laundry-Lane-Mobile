import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});
  static const String routeName = "/Onboarding";

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController pageController = PageController(initialPage: 0);
  int currentPage = 0;
  List services = [
    {
      "image": "assets/images/laundry.png",
      "tagline": ["Doorstep", " Pickup ", " & Fresh Laundry Service"],
      "description":
          "We collect your laundry from your doorstep at your preferred time. No more trips to the laundromat.",
    },
    {
      "image": "assets/images/ironing.png",
      "tagline": ["Hassle-Free", " Delivery ", "for Clean Clothes"],
      "description":
          "Get your freshly cleaned and folded clothes delivered back to you. Convenient, fast, and reliable.",
    },
    {
      "image": "assets/images/image.png",
      "tagline": ["Smart Laundry", " Service", ", Tailored to You"],
      "description":
          "Choose your wash preferences, schedule, and detergent options. A laundry experience made just for you.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(117, 164, 136, 1)),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.81,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(36),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: PageView.builder(
                      itemCount: services.length,
                      itemBuilder:
                          (context, index) => Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Image.asset(
                                  services[index]['image'],
                                  fit: BoxFit.cover,
                                  width: MediaQuery.of(context).size.width,
                                ),
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: RichText(
                                  text: TextSpan(
                                    style: GoogleFonts.almarai(
                                      height: 1.3,
                                      color: Color.fromRGBO(30, 30, 30, 1),
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: services[index]['tagline'][0],
                                      ),
                                      TextSpan(
                                        text: services[index]['tagline'][1],
                                        style: GoogleFonts.almarai(
                                          color: Color.fromRGBO(
                                            117,
                                            164,
                                            136,
                                            1,
                                          ),
                                          fontSize: 28,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      TextSpan(
                                        text: services[index]['tagline'][2],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  services[index]['description'],
                                  style: GoogleFonts.almarai(
                                    color: Color.fromRGBO(117, 117, 117, 1),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      onPageChanged: (value) {
                        setState(() {
                          currentPage = value;
                        });
                      },
                      controller: pageController,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SmoothIndicator(
                      offset: currentPage.toDouble(),
                      count: services.length,
                      size: Size(10, 10),
                      effect: ExpandingDotsEffect(dotWidth: 6, dotHeight: 6),
                    ),
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ),
            Spacer(),
            InkWell(
              onTap: () {
                Navigator.of(context).pushReplacementNamed("/login");
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(30, 30, 30, 1),
                  borderRadius: BorderRadius.circular(16),
                ),
                height: 60,
                width: MediaQuery.of(context).size.width * 0.7,
                child: Text(
                  "Let's Start",
                  style: GoogleFonts.almarai(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
