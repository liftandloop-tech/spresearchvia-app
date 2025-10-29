import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spresearchvia2/controllers/auth.controller.dart';
import 'package:spresearchvia2/controllers/user.controller.dart';
import 'package:spresearchvia2/controllers/kyc.controller.dart';
import 'package:spresearchvia2/controllers/plan_purchase.controller.dart';
import 'package:spresearchvia2/controllers/report.controller.dart';
import 'package:spresearchvia2/services/storage.service.dart';

Future<void> startup() async {
  await WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetStorage for local data persistence
  await StorageService.init();

  // Initialize GetX Controllers
  Get.put(AuthController());
  Get.put(UserController());
  Get.put(KycController());
  Get.put(PlanPurchaseController());
  Get.put(ReportController());
}
