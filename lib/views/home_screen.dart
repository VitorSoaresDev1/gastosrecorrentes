import 'package:flutter/material.dart';
import 'package:gastosrecorrentes/components/home_screen/bill_card.dart';
import 'package:gastosrecorrentes/components/shared/error_view_widget.dart';
import 'package:gastosrecorrentes/components/shared/loading_widget.dart';
import 'package:gastosrecorrentes/helpers/functions_helper.dart';
import 'package:gastosrecorrentes/services/local/multi_language.dart';
import 'package:gastosrecorrentes/services/local/navigation_service.dart';
import 'package:gastosrecorrentes/services/remote/api_request_status.dart';
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
    return Scaffold(
      appBar: AppBar(title: Text(MultiLanguage.translate("activeBills"))),
      floatingActionButton: FloatingActionButton(
        onPressed: () => NavigationService.openCreateBillScreen(context),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
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
