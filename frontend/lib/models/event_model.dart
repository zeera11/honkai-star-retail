import 'package:flutter/material.dart';

import 'item_model.dart';

class EventData {
  final String id;

  final String title;

  final String subtitle;

  final String bannerImage;

  final Color primaryColor;

  final Color secondaryColor;

  final List<Item> items;

  const EventData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.bannerImage,
    required this.primaryColor,
    required this.secondaryColor,
    required this.items,
  });
}
