import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/currency_model.dart';
import 'package:flutter_instancy_2/models/membership/data_model/member_ship_dto_model.dart';
import 'package:flutter_instancy_2/models/membership/data_model/membership_plan_details_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:provider/provider.dart';

class MembershipSelectionCard extends StatelessWidget {
  final MemberShipDTOModel memberShipDTOModel;
  final void Function({required MembershipPlanDetailsModel membershipPlanDetailsModel})? onMembershipPlanSelected;

  const MembershipSelectionCard({
    super.key,
    required this.memberShipDTOModel,
    this.onMembershipPlanSelected,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: themeData.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: themeData.colorScheme.onBackground.withAlpha(50),
            offset: const Offset(0, 2),
            spreadRadius: 1,
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: themeData.colorScheme.onBackground.withAlpha(30),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.star,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            memberShipDTOModel.DisplayText,
                            style: themeData.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (memberShipDTOModel.MemberShipShortDesc.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Html(
                    data: memberShipDTOModel.MemberShipShortDesc,
                    /*style: themeData.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: themeData.textTheme.labelMedium!.color?.withAlpha(150),
                    ),*/
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.sizeData.width * 0.15,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: themeData.colorScheme.primary.withAlpha(10),
              border: Border(
                top: BorderSide(
                  color: themeData.colorScheme.onBackground.withAlpha(50),
                  width: 1.5,
                ),
              ),
            ),
            child: Column(
              children: memberShipDTOModel.MemberShipPlans.map((MembershipPlanDetailsModel memberShipDetailsModel) {
                return getMembershipDetailsCard(memberShipDetailsModel: memberShipDetailsModel, themeData: themeData, context: context);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget getMembershipDetailsCard({required MembershipPlanDetailsModel memberShipDetailsModel, required BuildContext context, required ThemeData themeData}) {
    CurrencyModel? currencyModel = context.read<AppProvider>().currencyModel.get();

    String durationString = memberShipDetailsModel.DurationType;
    if (memberShipDetailsModel.DurationValue.isNotEmpty && memberShipDetailsModel.DurationType.isNotEmpty) {
      durationString = "${memberShipDetailsModel.DurationValue} ${memberShipDetailsModel.DurationType}";
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7),
      child: InkWell(
        onTap: () {
          if (onMembershipPlanSelected != null) onMembershipPlanSelected!(membershipPlanDetailsModel: memberShipDetailsModel);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: themeData.colorScheme.primary, width: 1.2),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  "${currencyModel?.UserCurrency ?? ""}${memberShipDetailsModel.Amount.toInt()}",
                  style: themeData.textTheme.bodyMedium?.copyWith(
                    color: themeData.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Flexible(
                flex: 3,
                child: Text(
                  durationString,
                  textAlign: TextAlign.end,
                  //We have kept DurationType for Free Plan, because in Free Plan we are getting DurationType as "Free"
                  // memberShipDetailsModel.DurationName.checkNotEmpty ? memberShipDetailsModel.DurationName : memberShipDetailsModel.DurationType,
                  style: themeData.textTheme.bodyMedium?.copyWith(
                    color: themeData.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
