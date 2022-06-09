import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gastosrecorrentes/models/bill.dart';
import 'package:gastosrecorrentes/services/local/multi_language.dart';
import 'package:gastosrecorrentes/shared/text_styles.dart';
import 'package:gastosrecorrentes/view_models/bills_view_model.dart';
import 'package:gastosrecorrentes/view_models/users_view_model.dart';
import 'package:provider/provider.dart';

enum MenuItem { changeValue, archiveBill, deleteBill }

class BillDetailDropdownMenu extends StatelessWidget {
  final Bill? bill;
  const BillDetailDropdownMenu({Key? key, this.bill}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BillsViewModel billsViewModel = context.watch<BillsViewModel>();
    UsersViewModel usersViewModel = context.watch<UsersViewModel>();
    return PopupMenuButton(
      itemBuilder: ((context) => MenuItem.values.map(buildMenuItem).toList()),
      color: Colors.indigo,
      elevation: 8,
      icon: const Icon(FontAwesomeIcons.ellipsisVertical),
      iconSize: 20,
      offset: const Offset(0, 40),
      onSelected: (value) async {
        switch (value) {
          //TODO implementar changedefaultvalue && archiveBill
          case MenuItem.changeValue:
          case MenuItem.archiveBill:
            break;
          case MenuItem.deleteBill:
            await billsViewModel.deleteBill(bill!, usersViewModel.user!.id!, context);
            break;
          default:
        }
      },
    );
  }

  PopupMenuItem buildMenuItem(MenuItem value) {
    String item = '';
    switch (value) {
      case MenuItem.changeValue:
        item = MultiLanguage.translate("changeDefaultValue");
        break;
      case MenuItem.archiveBill:
        item = MultiLanguage.translate("archiveBill");
        break;
      case MenuItem.deleteBill:
        item = MultiLanguage.translate("deleteBill");
        break;
      default:
    }
    return PopupMenuItem(
      value: value,
      child: Text(item, style: TextStyles.bodyText(light: true)),
    );
  }
}
