import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:yatayat/components/appbar.dart';
import 'package:yatayat/components/bookingHistoryList.dart';
import 'package:yatayat/components/my_booking_card.dart';
import 'package:yatayat/components/vehicle_card.dart';
import 'package:yatayat/components/yatayatDrawer.dart';
import 'package:yatayat/components/yatayat_bottom_navigation.dart';
import 'package:yatayat/lang/localization_service.dart';
import 'package:yatayat/screens/auth/signin_screen.dart';
import 'package:yatayat/screens/booking/book_driver.screen.dart';
import 'package:yatayat/screens/booking/bookingDetails/booking_details_screen.dart';
import 'package:yatayat/services/database.dart';
import 'package:yatayat/shared/constants.dart';
import 'package:yatayat/screens/booking/createBooking/create_booking_screen.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'HomeScreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String lng;

  void initState() {
    super.initState();

    lng = LocalizationService().getCurrentLang();
    //Show Status Bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  //Initialize firebase auth
  final _auth = FirebaseAuth.instance;

  bool loggedIn = false;

  @override
  Widget build(BuildContext context) {
    //Check if use is logged in or not
    if (_auth.currentUser != null) {
      loggedIn = true;
    } else {
      loggedIn = false;
    }

    return loggedIn
        ? Scaffold(
            bottomNavigationBar: YatayatBottomNavigation(index: 0),
            appBar: YatayatAppbar(
              height: 65,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Hamro Yatayat'.tr,
                    style: kAppbarTitleStyle,
                  ),
                  Text(
                    'Hire any Vehicle'.tr,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  )
                ],
              ),
              actionIcon: Icons.translate_rounded,
              onActionClick: () {
                if (lng == 'English') {
                  setState(() {
                    lng = 'Nepali';
                    LocalizationService().changeLocale('Nepali');
                    NepaliUtils(Language.nepali);
                  });
                } else if (lng == 'Nepali') {
                  setState(() {
                    lng = 'English';
                    LocalizationService().changeLocale('English');
                    NepaliUtils(Language.english);
                  });
                }
              },
            ),
            drawer: YatayatDrawer(),
            body: HomePage(),
          )
        : SigninScreen();
  }
}

//HomePage
class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  //Initialize firebase auth
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    //Get details of current user
    final currentUser = _auth.currentUser;

    //Getting stream of bookings from firebase
    final Stream<QuerySnapshot> _bookingStream = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .collection('bookings')
        .orderBy('bookingDate', descending: true)
        .limit(4)
        .snapshots();

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
              boxShadow: [kBoxShadow],
            ),
            child: Database(uid: currentUser.uid).createCrousel(),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Book Now'.tr,
                  style: kComponentTitleStyle,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    VehicleCard(
                      iconPath: 'assets/images/icons/Bus.png',
                      onClick: () => {
                        Navigator.pushNamed(context, CreateBookingScreen.id,
                            arguments: {
                              'vehicle': 'Bus (Normal)',
                              'icon': 'Bus'
                            })
                      },
                      lable: 'Bus'.tr,
                      booking: false,
                    ),
                    VehicleCard(
                      iconPath: 'assets/images/icons/Car.png',
                      onClick: () => {
                        Navigator.pushNamed(context, CreateBookingScreen.id,
                            arguments: {
                              'vehicle': 'Car (Sedan)',
                              'icon': 'Car'
                            })
                      },
                      lable: 'Car'.tr,
                      booking: false,
                    ),
                    VehicleCard(
                      iconPath: 'assets/images/icons/Suv.png',
                      onClick: () => {
                        Navigator.pushNamed(context, CreateBookingScreen.id,
                            arguments: {'vehicle': 'Scorpio', 'icon': 'Suv'})
                      },
                      lable: 'Scorpio'.tr,
                      booking: false,
                    ),
                    VehicleCard(
                      iconPath: 'assets/images/icons/Taxi.png',
                      onClick: () => {
                        Navigator.pushNamed(context, CreateBookingScreen.id,
                            arguments: {'vehicle': 'Taxi', 'icon': 'Taxi'})
                      },
                      lable: 'Taxi'.tr,
                      booking: false,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    VehicleCard(
                      iconPath: 'assets/images/icons/Micro.png',
                      onClick: () => {
                        Navigator.pushNamed(context, CreateBookingScreen.id,
                            arguments: {
                              'vehicle': 'Toyota Hiace',
                              'icon': 'Micro'
                            })
                      },
                      lable: 'Hiace'.tr,
                      booking: false,
                    ),
                    VehicleCard(
                      iconPath: 'assets/images/icons/Jeep.png',
                      onClick: () => {
                        Navigator.pushNamed(context, CreateBookingScreen.id,
                            arguments: {
                              'vehicle': 'TATA Sumo (A/c)',
                              'icon': 'Jeep'
                            })
                      },
                      lable: 'TATA Sumo'.tr,
                      booking: false,
                    ),
                    VehicleCard(
                      iconPath: 'assets/images/icons/Cruiser.png',
                      onClick: () => {
                        Navigator.pushNamed(context, CreateBookingScreen.id,
                            arguments: {
                              'vehicle': 'Landcruiser',
                              'icon': 'Cruiser'
                            })
                      },
                      lable: 'Landcruiser'.tr,
                      booking: false,
                    ),
                    VehicleCard(
                      iconPath: 'assets/images/icons/Driver.png',
                      onClick: () =>
                          {Navigator.pushNamed(context, BookDriver.id)},
                      lable: 'Driver'.tr,
                      booking: false,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'My Bookings'.tr,
                  style: kComponentTitleStyle,
                ),
                SizedBox(
                  height: 15,
                ),
                BookingHistoryList()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
