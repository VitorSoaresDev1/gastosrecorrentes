import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gastosrecorrentes/models/bill.dart';
import 'package:gastosrecorrentes/services/local/multi_language.dart';
import 'package:gastosrecorrentes/shared/text_styles.dart';
import 'package:gastosrecorrentes/view_models/init_app_view_model.dart';
import 'package:gastosrecorrentes/view_models/users_view_model.dart';
import 'package:provider/provider.dart';

enum MenuItem { /*changeValue, */ changeLanguage, logOut }

class SettingsDropdownMenu extends StatelessWidget {
  final Bill? bill;
  const SettingsDropdownMenu({Key? key, this.bill}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UsersViewModel usersViewModel = context.watch<UsersViewModel>();
    InitAppViewModel _initAppViewModel = context.watch<InitAppViewModel>();
    return PopupMenuButton(
      itemBuilder: ((context) => MenuItem.values.map(buildMenuItem).toList()),
      color: Colors.indigo,
      elevation: 8,
      icon: const Icon(FontAwesomeIcons.gear),
      iconSize: 18,
      offset: const Offset(0, 40),
      tooltip: MultiLanguage.translate("settings"),
      onSelected: (value) async {
        switch (value) {
          //TO DO implementar changedefaultvalue && archiveBill
          //case MenuItem.changeValue:
          case MenuItem.changeLanguage:
            await _initAppViewModel.showLanguageDialog(context);
            await _initAppViewModel.applyNewLanguage();
            break;
          case MenuItem.logOut:
            await usersViewModel.showLogOutDialog(context);
            break;
          default:
        }
      },
    );
  }

  PopupMenuItem buildMenuItem(MenuItem value) {
    String item = '';
    switch (value) {
      //case MenuItem.changeValue:
      // item = MultiLanguage.translate("changeDefaultValue");
      // break;
      case MenuItem.changeLanguage:
        item = MultiLanguage.translate("changeLanguage");
        break;
      case MenuItem.logOut:
        item = MultiLanguage.translate("logOut");
        break;
      default:
    }
    return PopupMenuItem(
      value: value,
      child: Text(item, style: TextStyles.bodyText(light: true)),
    );
  }
}
