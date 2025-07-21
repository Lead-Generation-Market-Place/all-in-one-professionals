import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../config/localization/locale_provider.dart';
import '../config/themes/theme_provider.dart';

List<SingleChildWidget> appProviders = [
  ChangeNotifierProvider(create: (_) => ThemeProvider()),
  ChangeNotifierProvider(create: (_) => LocaleProvider()),
];
