import 'primary_secondary_actions_constants.dart';

class PrimarySecondaryActionsDataModel {
  final List<InstancyContentActionsEnum>? primaryActions;
  final List<InstancyContentActionsEnum>? secondaryActions;

  const PrimarySecondaryActionsDataModel({
    this.primaryActions,
    this.secondaryActions,
  });
}