import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gastosrecorrentes/components/home_screen/bill_card.dart';
import 'package:gastosrecorrentes/components/shared/loading_widget.dart';
import 'package:gastosrecorrentes/services/local/multi_language.dart';
import 'package:gastosrecorrentes/services/local/navigation_service.dart';
import 'package:gastosrecorrentes/shared/text_styles.dart';
import 'package:gastosrecorrentes/view_models/bills_view_model.dart';
import 'package:gastosrecorrentes/view_models/init_app_view_model.dart';
import 'package:provider/provider.dart';

class BillsListView extends StatelessWidget {
  const BillsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final billsViewModel = context.watch<BillsViewModel>();
    context.watch<InitAppViewModel>().language;
    return billsViewModel.listBills.data!.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  FontAwesomeIcons.fileCircleMinus,
                  color: Colors.grey[800],
                  size: 100,
                ),
                const SizedBox(height: 16),
                Column(
                  children: [
                    Text(
                      MultiLanguage.translate("emptyBillsList1"),
                      style: TextStyles.bodyText(),
                    ),
                    Text(
                      MultiLanguage.translate("emptyBillsList2"),
                      style: TextStyles.bodyText(),
                    ),
                  ],
                )
              ],
            ),
          )
        : Stack(
            children: [
              ListView.separated(
                itemCount: billsViewModel.listBills.data!.length,
                separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10),
                padding: const EdgeInsets.only(bottom: 72, top: 8),
                itemBuilder: (context, index) => BillCard(
                  bill: billsViewModel.listBills.data![index],
                  onTap: () {
                    billsViewModel.setLoading(true);
                    billsViewModel.setCurrentSelectedBill = billsViewModel.listBills.data![index];
                    NavigationService.openBillDetailsScreen(context);
                    billsViewModel.setLoading(false);
                  },
                ),
              ),
              billsViewModel.loading ? const LoadingWidget() : Container(),
            ],
          );
  }
}
