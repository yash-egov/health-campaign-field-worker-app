import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:digit_data_model/data_model.dart';

import 'package:complaints/blocs/complaints_inbox/complaints_inbox.dart';
import 'package:complaints/utils/utils.dart';
import '/utils/extensions/context_utility.dart';

@RoutePage()
class ComplaintsInboxWrapperPage extends StatelessWidget {
  const ComplaintsInboxWrapperPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text("Hii");


  }
}
