import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const secondaryColor = Color(0xFF5593f8);
const primaryColor = Color(0xFF48c9e2);

final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
final DateFormat formatDate = DateFormat('yyyy-MM-dd H:mm');
const tokenStoreName = "access_token";