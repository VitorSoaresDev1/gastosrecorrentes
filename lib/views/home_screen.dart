import 'package:flutter/material.dart';
import 'package:gastosrecorrentes/components/home_screen/bill_card.dart';
import 'package:gastosrecorrentes/components/home_screen/settings_drop_down_menu.dart';
import 'package:gastosrecorrentes/components/shared/error_view_widget.dart';
import 'package:gastosrecorrentes/components/shared/loading_widget.dart';
import 'package:gastosrecorrentes/helpers/functions_helper.dart';
import 'package:gastosrecorrentes/services/local/multi_language.dart';
import 'package:gastosrecorrentes/services/local/navigation_service.dart';
import 'package:gastosrecorrentes/services/remote/api_request_status.dart';
import 'package:gastosrecorrentes/view_models/init_app_view_model.dart';
import 'package:gastosrecorrentes/view_models/users_view_model.dart';
import 'package:provider/provider.dart';
import 'package:gastosrecorrentes/view_models/bills_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    scheduleCall(() async {
      final billsViewModel = Provider.of<BillsViewModel>(context, listen: false);
      final usersViewModel = Provider.of<UsersViewModel>(context, listen: false);
      billsViewModel.getRegisteredBills(usersViewModel.user!.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final billsViewModel = context.watch<BillsViewModel>();
    final initAppViewModel = context.watch<InitAppViewModel>();
    initAppViewModel.language;
    return Scaffold(
      appBar: AppBar(
        title: Text(MultiLanguage.translate("activeBills")),
        actions: const [SettingsDropdownMenu()],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => NavigationService.openCreateBillScreen(context),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: Container(
        height: kBottomNavigationBarHeight,
        color: Colors.grey[50],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
          child: Builder(
            builder: ((context) {
              switch (billsViewModel.listBills.status) {
                case ApiRequestStatus.loading:
                  return const LoadingWidget();
                case ApiRequestStatus.error:
                  String errorText = translateErrors(billsViewModel.listBills.message);
                  return ErrorViewWidget(errorText: errorText);
                case ApiRequestStatus.completed:
                  return ListView.separated(
                    itemCount: billsViewModel.listBills.data!.length,
                    separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10),
                    padding: const EdgeInsets.only(bottom: 72, top: 8),
                    itemBuilder: (context, index) => BillCard(
                      bill: billsViewModel.listBills.data![index],
                      onTap: () {
                        billsViewModel.setCurrentSelectedBill = billsViewModel.listBills.data![index];
                        NavigationService.openBillDetailsScreen(context);
                      },
                    ),
                  );
                default:
              }
              return Container();
            }),
          ),
        ),
      ),
    );
  }
}
