import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/models/in_app_purchase/data_model/ecommerce_order_dto_model.dart';

class EcommerceOrderCard extends StatelessWidget {
  final EcommerceOrderDTOModel model;

  const EcommerceOrderCard({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return Container(
      // color: Colors.red,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: themeData.colorScheme.primary.withAlpha(100),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.card_membership,
              color: themeData.primaryColor,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            model.ItemName,
                            style: themeData.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            model.PurchasedDate,
                            style: themeData.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: themeData.textTheme.labelSmall!.color?.withAlpha(100),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          "${model.CurrencySign}${model.Price} ",
                          style: themeData.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          model.PaymentType,
                          style: themeData.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: themeData.textTheme.labelSmall!.color?.withAlpha(100),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Container(
                  width: double.maxFinite,
                  height: 1,
                  color: themeData.colorScheme.onBackground.withAlpha(20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
