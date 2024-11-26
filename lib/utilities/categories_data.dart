import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'constants.dart';

List<Map<String, dynamic>> categories = [
  {
    'id': Uuid().v4(),
    'iconData': Icons.money_outlined,
    'iconColor': kColorGreen,
    'inputText': 'Salary',
  },
  {
    'id': Uuid().v4(),
    'iconData': Icons.house_outlined,
    'iconColor': kColorOlive,
    'inputText': 'Household',
  },
  {
    'id': Uuid().v4(),
    'iconData': Icons.shopping_cart_outlined,
    'iconColor': kColorOrange,
    'inputText': 'Grocery',
  },
  {
    'id': Uuid().v4(),
    'iconData': Icons.health_and_safety_outlined,
    'iconColor': kColorTurquoise,
    'inputText': 'Health',
  },
  {
    'id': Uuid().v4(),
    'iconData': Icons.extension_outlined,
    'iconColor': kColorCoral,
    'inputText': 'Entertainment',
  },
  {
    'id': Uuid().v4(),
    'iconData': Icons.coffee_outlined,
    'iconColor': kColorBrown,
    'inputText': 'Coffee',
  },
  {
    'id': Uuid().v4(),
    'iconData': Icons.restaurant_outlined,
    'iconColor': kColorSoftRed,
    'inputText': 'Restaurant',
  },
  {
    'id': Uuid().v4(),
    'iconData': Icons.local_taxi_outlined,
    'iconColor': kColorYellow,
    'inputText': 'Taxi',
  },
  {
    'id': Uuid().v4(),
    'iconData': Icons.bed_outlined,
    'iconColor': kColorOliveGreen,
    'inputText': 'Hotel',
  },
  {
    'id': Uuid().v4(),
    'iconData': Icons.shopping_bag_outlined,
    'iconColor': kColorPurple,
    'inputText': 'Shopping',
  },
  {
    'id': Uuid().v4(),
    'iconData': Icons.language_outlined,
    'iconColor': kColorPink,
    'inputText': 'Internet',
  },
  {
    'id': Uuid().v4(),
    'iconData': Icons.redeem_outlined,
    'iconColor': kColorLavender,
    'inputText': 'Gift',
  },
  {
    'id': Uuid().v4(),
    'iconData': Icons.airplanemode_active_outlined,
    'iconColor': kColorDeepSkyBlue,
    'inputText': 'Flights',
  },
  {
    'id': Uuid().v4(),
    'iconData': Icons.local_gas_station_outlined,
    'iconColor': kColorRust,
    'inputText': 'Petrol',
  },
  {
    'id': Uuid().v4(),
    'iconData': Icons.local_atm_outlined,
    'iconColor': kColorAmber,
    'inputText': 'Cash Deposit',
  },
  {
    'id': Uuid().v4(),
    'iconData': Icons.local_atm,
    'iconColor': kColorTeal,
    'inputText': 'Cash Withdrawal',
  },
];
