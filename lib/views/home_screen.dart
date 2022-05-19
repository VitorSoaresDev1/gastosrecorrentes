import 'package:flutter/material.dart';
import 'package:gastosrecorrentes/components/home_screen/bill_card.dart';
import 'package:gastosrecorrentes/helpers/date_helper.dart';
import 'package:gastosrecorrentes/services/multi_language.dart';
import 'package:gastosrecorrentes/shared/text_styles.dart';
import 'package:provider/provider.dart';
import 'package:gastosrecorrentes/view_models/bills_view_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final billsViewModel = context.watch<BillsViewModel>();
    return Scaffold(
      appBar: AppBar(title: Text(MultiLanguage.translate("appTitle"))),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(DateHelper.formatMMMMYYYY(DateTime.now()), style: TextStyles.titles()),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.separated(
                  itemCount: billsViewModel.listBills.length,
                  separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) => BillCard(bill: billsViewModel.listBills[index]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
