import 'package:ecommerce_shopping_store/ViewModel/Bloc/theme_bloc/theme_bloc.dart';
import 'package:ecommerce_shopping_store/config/color/colors.dart';
import 'package:ecommerce_shopping_store/config/components/textwidgets.dart';
import 'package:ecommerce_shopping_store/config/enums/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuyerHomeScreen extends StatefulWidget {
  const BuyerHomeScreen({super.key});

  @override
  State<BuyerHomeScreen> createState() => _BuyerHomeScreenState();
}

class _BuyerHomeScreenState extends State<BuyerHomeScreen> {
  
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return Scaffold(
          appBar: AppBar(
            title: AppText(
              'Home',
              color: themeState.theme[appColors.textPrimaryColor]!,
              type: TextType.screenTitles,
            ),
            centerTitle: true,
            backgroundColor: themeState.theme[appColors.primaryColor],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: ProductCategory.values.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: Text('Popular in ' + ProductCategory.values[index].name),
                    );   
                  }
                )
              ],
            ),
          ),
        );
      }
    );
  }
}