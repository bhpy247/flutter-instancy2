import 'package:flutter_instancy_2/configs/app_constants.dart';

import 'primary_secondary_actions_constants.dart';
import 'primary_secondary_actions_data_model.dart';

class PrimarySecondaryActionsConfigs {
  //ContentType>MediaType>ViewType>{ScreenType : PrimarySecondaryActionsDataModel}
  static Map<int, Map<int, Map<int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>>> primarySecondaryActions =
      <int, Map<int, Map<int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>>>{
    InstancyObjectTypes.contentObject: <int, Map<int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>>{
      InstancyMediaTypes.microLearning: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.Notes,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.Notes,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.Notes,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.Notes,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
      InstancyMediaTypes.learningModule: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.Notes,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.Notes,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.Notes,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.Notes,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
    },
    InstancyObjectTypes.assessment: <int, Map<int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>>{
      InstancyMediaTypes.test: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.Notes,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.Notes,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.Notes,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.Notes,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
      InstancyMediaTypes.survey: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.Notes,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.Notes,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.Notes,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.Notes,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
    },
    InstancyObjectTypes.track: <int, Map<int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>>{
      InstancyMediaTypes.track: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.Notes,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.Notes,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.Notes,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.Notes,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
    },
    InstancyObjectTypes.mediaResource: <int, Map<int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>>{
      InstancyMediaTypes.image: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.Notes,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.Notes,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.Notes,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.Notes,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
        },
      },
      InstancyMediaTypes.video: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.Notes,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.Notes,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.Notes,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.Notes,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
        },
      },
      InstancyMediaTypes.audio: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.Notes,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.Notes,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.Notes,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.Notes,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
        },
      },
      InstancyMediaTypes.embedAudio: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.Notes,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.Notes,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.Notes,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.Notes,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
        },
      },
      InstancyMediaTypes.embedVideo: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.Notes,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.Notes,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.Notes,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.Notes,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
        },
      },
    },
    InstancyObjectTypes.document: <int, Map<int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>>{
      InstancyMediaTypes.word: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
        },
      },
      InstancyMediaTypes.pDF: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
        },
      },
      InstancyMediaTypes.excel: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
        },
      },
      InstancyMediaTypes.ppt: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
        },
      },
      InstancyMediaTypes.mpp: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
        },
      },
      InstancyMediaTypes.visioTypes: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
              InstancyContentActionsEnum.Download,
            ],
          ),
        },
      },
    },
    InstancyObjectTypes.dictionaryGlossary: <int, Map<int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>>{
      InstancyMediaTypes.none: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
    },
    InstancyObjectTypes.html: <int, Map<int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>>{
      InstancyMediaTypes.htmlZIPFile: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
      InstancyMediaTypes.singleHTMLFile: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
    },
    InstancyObjectTypes.scorm1_2: <int, Map<int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>>{
      InstancyMediaTypes.scorm: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
      InstancyMediaTypes.scorm2004: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
    },
    InstancyObjectTypes.aICC: <int, Map<int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>>{
      InstancyMediaTypes.none: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
    },
    InstancyObjectTypes.reference: <int, Map<int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>>{
      InstancyMediaTypes.onlineCourse: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
      InstancyMediaTypes.classroomCourse: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
      InstancyMediaTypes.virtualClassroom: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
      InstancyMediaTypes.url: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
      InstancyMediaTypes.liveMeeting: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
      InstancyMediaTypes.recording: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
      InstancyMediaTypes.book: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
      InstancyMediaTypes.document: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
      InstancyMediaTypes.conference: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
      InstancyMediaTypes.videoReference: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
      InstancyMediaTypes.audioReference: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
      InstancyMediaTypes.webLink: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
      InstancyMediaTypes.blendedOnlineClassroom: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
      InstancyMediaTypes.assessorService: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
      InstancyMediaTypes.imageReference: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
      InstancyMediaTypes.teachingSlidesReference: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
      InstancyMediaTypes.animationReference: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
      InstancyMediaTypes.psyTechAssessment: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
      InstancyMediaTypes.dISCAssessment: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
      InstancyMediaTypes.corpAcademy: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
      InstancyMediaTypes.comingSoon: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.IAmInterested,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.NA,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.IAmInterested,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.NA,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.IAmInterested,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.NA,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.IAmInterested,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.NA,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
      InstancyMediaTypes.contactUs: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.ContactUs,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.NA,
            ],
            secondaryActions: <InstancyContentActionsEnum>[],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.ContactUs,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.NA,
            ],
            secondaryActions: <InstancyContentActionsEnum>[],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.ContactUs,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.NA,
            ],
            secondaryActions: <InstancyContentActionsEnum>[],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.ContactUs,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.NA,
            ],
            secondaryActions: <InstancyContentActionsEnum>[],
          ),
        },
      },
      InstancyMediaTypes.assessment24x7: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
    },
    InstancyObjectTypes.webPage: <int, Map<int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>>{
      InstancyMediaTypes.none: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
    },
    InstancyObjectTypes.certificate: <int, Map<int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>>{
      InstancyMediaTypes.none: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
    },
    InstancyObjectTypes.events: <int, Map<int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>>{
      InstancyMediaTypes.classroomEvent: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Enroll,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToWaitList,
              InstancyContentActionsEnum.ViewResources,
              InstancyContentActionsEnum.CancelEnrollment,
              InstancyContentActionsEnum.Reschedule,
              InstancyContentActionsEnum.ReEnrollmentHistory,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Enroll,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.ViewSessions,
              InstancyContentActionsEnum.CancelEnrollment,
              InstancyContentActionsEnum.Reschedule,
              InstancyContentActionsEnum.AddToCalender,
              InstancyContentActionsEnum.ViewResources,
              InstancyContentActionsEnum.ViewRecording,
              InstancyContentActionsEnum.ViewQRCode,
              InstancyContentActionsEnum.Delete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Enroll,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToWaitList,
              InstancyContentActionsEnum.ViewResources,
              InstancyContentActionsEnum.ViewRecording,
              InstancyContentActionsEnum.CancelEnrollment,
              InstancyContentActionsEnum.Reschedule,
              InstancyContentActionsEnum.ReEnrollmentHistory,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Enroll,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.ViewSessions,
              InstancyContentActionsEnum.CancelEnrollment,
              InstancyContentActionsEnum.Reschedule,
              InstancyContentActionsEnum.AddToCalender,
              InstancyContentActionsEnum.ViewResources,
              InstancyContentActionsEnum.ViewRecording,
              InstancyContentActionsEnum.ViewQRCode,
              InstancyContentActionsEnum.Delete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Enroll,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToWaitList,
              InstancyContentActionsEnum.ViewResources,
              InstancyContentActionsEnum.CancelEnrollment,
              InstancyContentActionsEnum.Reschedule,
              InstancyContentActionsEnum.ReEnrollmentHistory,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Enroll,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.ViewSessions,
              InstancyContentActionsEnum.CancelEnrollment,
              InstancyContentActionsEnum.Reschedule,
              InstancyContentActionsEnum.AddToCalender,
              InstancyContentActionsEnum.ViewResources,
              InstancyContentActionsEnum.ViewRecording,
              InstancyContentActionsEnum.ViewQRCode,
              InstancyContentActionsEnum.Delete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Enroll,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToWaitList,
              InstancyContentActionsEnum.ViewResources,
              InstancyContentActionsEnum.CancelEnrollment,
              InstancyContentActionsEnum.Reschedule,
              InstancyContentActionsEnum.ReEnrollmentHistory,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Enroll,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.ViewSessions,
              InstancyContentActionsEnum.CancelEnrollment,
              InstancyContentActionsEnum.Reschedule,
              InstancyContentActionsEnum.AddToCalender,
              InstancyContentActionsEnum.ViewResources,
              InstancyContentActionsEnum.ViewRecording,
              InstancyContentActionsEnum.ViewQRCode,
              InstancyContentActionsEnum.Delete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
      InstancyMediaTypes.virtualClassroomEvent: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Enroll,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToWaitList,
              InstancyContentActionsEnum.ViewResources,
              InstancyContentActionsEnum.CancelEnrollment,
              InstancyContentActionsEnum.Reschedule,
              InstancyContentActionsEnum.ReEnrollmentHistory,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Enroll,
              InstancyContentActionsEnum.Join,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.ViewSessions,
              InstancyContentActionsEnum.CancelEnrollment,
              InstancyContentActionsEnum.Reschedule,
              InstancyContentActionsEnum.AddToCalender,
              InstancyContentActionsEnum.ViewResources,
              InstancyContentActionsEnum.ViewRecording,
              InstancyContentActionsEnum.ViewQRCode,
              InstancyContentActionsEnum.Delete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Enroll,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToWaitList,
              InstancyContentActionsEnum.ViewResources,
              InstancyContentActionsEnum.CancelEnrollment,
              InstancyContentActionsEnum.Reschedule,
              InstancyContentActionsEnum.ReEnrollmentHistory,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Enroll,
              InstancyContentActionsEnum.Join,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.ViewSessions,
              InstancyContentActionsEnum.CancelEnrollment,
              InstancyContentActionsEnum.Reschedule,
              InstancyContentActionsEnum.AddToCalender,
              InstancyContentActionsEnum.ViewResources,
              InstancyContentActionsEnum.ViewRecording,
              InstancyContentActionsEnum.ViewQRCode,
              InstancyContentActionsEnum.Delete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Enroll,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToWaitList,
              InstancyContentActionsEnum.ViewResources,
              InstancyContentActionsEnum.CancelEnrollment,
              InstancyContentActionsEnum.Reschedule,
              InstancyContentActionsEnum.ReEnrollmentHistory,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Enroll,
              InstancyContentActionsEnum.Join,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.ViewSessions,
              InstancyContentActionsEnum.CancelEnrollment,
              InstancyContentActionsEnum.Reschedule,
              InstancyContentActionsEnum.AddToCalender,
              InstancyContentActionsEnum.ViewResources,
              InstancyContentActionsEnum.ViewRecording,
              InstancyContentActionsEnum.ViewQRCode,
              InstancyContentActionsEnum.Delete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Enroll,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToWaitList,
              InstancyContentActionsEnum.ViewResources,
              InstancyContentActionsEnum.CancelEnrollment,
              InstancyContentActionsEnum.Reschedule,
              InstancyContentActionsEnum.ReEnrollmentHistory,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Enroll,
              InstancyContentActionsEnum.Join,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.ViewSessions,
              InstancyContentActionsEnum.CancelEnrollment,
              InstancyContentActionsEnum.Reschedule,
              InstancyContentActionsEnum.AddToCalender,
              InstancyContentActionsEnum.ViewResources,
              InstancyContentActionsEnum.ViewRecording,
              InstancyContentActionsEnum.ViewQRCode,
              InstancyContentActionsEnum.Delete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
      InstancyMediaTypes.networkingInPersonEvent: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Enroll,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToWaitList,
              InstancyContentActionsEnum.ViewResources,
              InstancyContentActionsEnum.CancelEnrollment,
              InstancyContentActionsEnum.Reschedule,
              InstancyContentActionsEnum.ReEnrollmentHistory,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Enroll,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.ViewSessions,
              InstancyContentActionsEnum.CancelEnrollment,
              InstancyContentActionsEnum.Reschedule,
              InstancyContentActionsEnum.AddToCalender,
              InstancyContentActionsEnum.ViewResources,
              InstancyContentActionsEnum.ViewQRCode,
              InstancyContentActionsEnum.Delete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Enroll,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToWaitList,
              InstancyContentActionsEnum.ViewResources,
              InstancyContentActionsEnum.CancelEnrollment,
              InstancyContentActionsEnum.Reschedule,
              InstancyContentActionsEnum.ReEnrollmentHistory,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Enroll,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.ViewSessions,
              InstancyContentActionsEnum.CancelEnrollment,
              InstancyContentActionsEnum.Reschedule,
              InstancyContentActionsEnum.AddToCalender,
              InstancyContentActionsEnum.ViewResources,
              InstancyContentActionsEnum.ViewQRCode,
              InstancyContentActionsEnum.Delete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Enroll,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToWaitList,
              InstancyContentActionsEnum.ViewResources,
              InstancyContentActionsEnum.CancelEnrollment,
              InstancyContentActionsEnum.Reschedule,
              InstancyContentActionsEnum.ReEnrollmentHistory,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Enroll,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.ViewSessions,
              InstancyContentActionsEnum.CancelEnrollment,
              InstancyContentActionsEnum.Reschedule,
              InstancyContentActionsEnum.AddToCalender,
              InstancyContentActionsEnum.ViewResources,
              InstancyContentActionsEnum.ViewQRCode,
              InstancyContentActionsEnum.Delete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Enroll,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToWaitList,
              InstancyContentActionsEnum.ViewResources,
              InstancyContentActionsEnum.CancelEnrollment,
              InstancyContentActionsEnum.Reschedule,
              InstancyContentActionsEnum.ReEnrollmentHistory,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Enroll,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.ViewSessions,
              InstancyContentActionsEnum.CancelEnrollment,
              InstancyContentActionsEnum.Reschedule,
              InstancyContentActionsEnum.AddToCalender,
              InstancyContentActionsEnum.ViewResources,
              InstancyContentActionsEnum.ViewQRCode,
              InstancyContentActionsEnum.Delete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
      InstancyMediaTypes.labInPersonEvent: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Enroll,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToWaitList,
              InstancyContentActionsEnum.ViewResources,
              InstancyContentActionsEnum.CancelEnrollment,
              InstancyContentActionsEnum.Reschedule,
              InstancyContentActionsEnum.ReEnrollmentHistory,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Enroll,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.ViewSessions,
              InstancyContentActionsEnum.CancelEnrollment,
              InstancyContentActionsEnum.Reschedule,
              InstancyContentActionsEnum.AddToCalender,
              InstancyContentActionsEnum.ViewResources,
              InstancyContentActionsEnum.ViewQRCode,
              InstancyContentActionsEnum.Delete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Enroll,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToWaitList,
              InstancyContentActionsEnum.ViewResources,
              InstancyContentActionsEnum.CancelEnrollment,
              InstancyContentActionsEnum.Reschedule,
              InstancyContentActionsEnum.ReEnrollmentHistory,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Enroll,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.ViewSessions,
              InstancyContentActionsEnum.CancelEnrollment,
              InstancyContentActionsEnum.Reschedule,
              InstancyContentActionsEnum.AddToCalender,
              InstancyContentActionsEnum.ViewResources,
              InstancyContentActionsEnum.ViewQRCode,
              InstancyContentActionsEnum.Delete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Enroll,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToWaitList,
              InstancyContentActionsEnum.ViewResources,
              InstancyContentActionsEnum.CancelEnrollment,
              InstancyContentActionsEnum.Reschedule,
              InstancyContentActionsEnum.ReEnrollmentHistory,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Enroll,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.ViewSessions,
              InstancyContentActionsEnum.CancelEnrollment,
              InstancyContentActionsEnum.Reschedule,
              InstancyContentActionsEnum.AddToCalender,
              InstancyContentActionsEnum.ViewResources,
              InstancyContentActionsEnum.ViewQRCode,
              InstancyContentActionsEnum.Delete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Enroll,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToWaitList,
              InstancyContentActionsEnum.ViewResources,
              InstancyContentActionsEnum.CancelEnrollment,
              InstancyContentActionsEnum.Reschedule,
              InstancyContentActionsEnum.ReEnrollmentHistory,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Enroll,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.ViewSessions,
              InstancyContentActionsEnum.CancelEnrollment,
              InstancyContentActionsEnum.Reschedule,
              InstancyContentActionsEnum.AddToCalender,
              InstancyContentActionsEnum.ViewResources,
              InstancyContentActionsEnum.ViewQRCode,
              InstancyContentActionsEnum.Delete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
      InstancyMediaTypes.projectInPersonEvent: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Enroll,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToWaitList,
              InstancyContentActionsEnum.ViewResources,
              InstancyContentActionsEnum.CancelEnrollment,
              InstancyContentActionsEnum.Reschedule,
              InstancyContentActionsEnum.ReEnrollmentHistory,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Enroll,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.ViewSessions,
              InstancyContentActionsEnum.CancelEnrollment,
              InstancyContentActionsEnum.Reschedule,
              InstancyContentActionsEnum.AddToCalender,
              InstancyContentActionsEnum.ViewResources,
              InstancyContentActionsEnum.ViewQRCode,
              InstancyContentActionsEnum.Delete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Enroll,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToWaitList,
              InstancyContentActionsEnum.ViewResources,
              InstancyContentActionsEnum.CancelEnrollment,
              InstancyContentActionsEnum.Reschedule,
              InstancyContentActionsEnum.ReEnrollmentHistory,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Enroll,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.ViewSessions,
              InstancyContentActionsEnum.CancelEnrollment,
              InstancyContentActionsEnum.Reschedule,
              InstancyContentActionsEnum.AddToCalender,
              InstancyContentActionsEnum.ViewResources,
              InstancyContentActionsEnum.ViewQRCode,
              InstancyContentActionsEnum.Delete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Enroll,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToWaitList,
              InstancyContentActionsEnum.ViewResources,
              InstancyContentActionsEnum.CancelEnrollment,
              InstancyContentActionsEnum.Reschedule,
              InstancyContentActionsEnum.ReEnrollmentHistory,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Enroll,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.ViewSessions,
              InstancyContentActionsEnum.CancelEnrollment,
              InstancyContentActionsEnum.Reschedule,
              InstancyContentActionsEnum.AddToCalender,
              InstancyContentActionsEnum.ViewResources,
              InstancyContentActionsEnum.ViewQRCode,
              InstancyContentActionsEnum.Delete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Enroll,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToWaitList,
              InstancyContentActionsEnum.ViewResources,
              InstancyContentActionsEnum.CancelEnrollment,
              InstancyContentActionsEnum.Reschedule,
              InstancyContentActionsEnum.ReEnrollmentHistory,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Enroll,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.ViewSessions,
              InstancyContentActionsEnum.CancelEnrollment,
              InstancyContentActionsEnum.Reschedule,
              InstancyContentActionsEnum.AddToCalender,
              InstancyContentActionsEnum.ViewResources,
              InstancyContentActionsEnum.ViewQRCode,
              InstancyContentActionsEnum.Delete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
      InstancyMediaTypes.fieldTripInPersonEvent: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Enroll,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToWaitList,
              InstancyContentActionsEnum.ViewResources,
              InstancyContentActionsEnum.CancelEnrollment,
              InstancyContentActionsEnum.Reschedule,
              InstancyContentActionsEnum.ReEnrollmentHistory,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Enroll,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.ViewSessions,
              InstancyContentActionsEnum.CancelEnrollment,
              InstancyContentActionsEnum.Reschedule,
              InstancyContentActionsEnum.AddToCalender,
              InstancyContentActionsEnum.ViewResources,
              InstancyContentActionsEnum.ViewQRCode,
              InstancyContentActionsEnum.Delete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Enroll,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToWaitList,
              InstancyContentActionsEnum.ViewResources,
              InstancyContentActionsEnum.CancelEnrollment,
              InstancyContentActionsEnum.Reschedule,
              InstancyContentActionsEnum.ReEnrollmentHistory,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Enroll,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.ViewSessions,
              InstancyContentActionsEnum.CancelEnrollment,
              InstancyContentActionsEnum.Reschedule,
              InstancyContentActionsEnum.AddToCalender,
              InstancyContentActionsEnum.ViewResources,
              InstancyContentActionsEnum.ViewQRCode,
              InstancyContentActionsEnum.Delete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Enroll,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToWaitList,
              InstancyContentActionsEnum.ViewResources,
              InstancyContentActionsEnum.CancelEnrollment,
              InstancyContentActionsEnum.Reschedule,
              InstancyContentActionsEnum.ReEnrollmentHistory,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Enroll,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.ViewSessions,
              InstancyContentActionsEnum.CancelEnrollment,
              InstancyContentActionsEnum.Reschedule,
              InstancyContentActionsEnum.AddToCalender,
              InstancyContentActionsEnum.ViewResources,
              InstancyContentActionsEnum.ViewQRCode,
              InstancyContentActionsEnum.Delete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Enroll,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToWaitList,
              InstancyContentActionsEnum.ViewResources,
              InstancyContentActionsEnum.CancelEnrollment,
              InstancyContentActionsEnum.Reschedule,
              InstancyContentActionsEnum.ReEnrollmentHistory,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Enroll,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.ViewSessions,
              InstancyContentActionsEnum.CancelEnrollment,
              InstancyContentActionsEnum.Reschedule,
              InstancyContentActionsEnum.AddToCalender,
              InstancyContentActionsEnum.ViewResources,
              InstancyContentActionsEnum.ViewQRCode,
              InstancyContentActionsEnum.Delete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
    },
    InstancyObjectTypes.xApi: <int, Map<int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>>{
      InstancyMediaTypes.none: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
    },
    InstancyObjectTypes.externalContent: <int, Map<int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>>{
      InstancyMediaTypes.externalSCORM: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
      InstancyMediaTypes.externalxAPI: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
      InstancyMediaTypes.externalDocument: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
      InstancyMediaTypes.externalMedia: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
      InstancyMediaTypes.externalTrackList: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
      InstancyMediaTypes.externalReference: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.SetComplete,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
      InstancyMediaTypes.cmi5: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
    },
    InstancyObjectTypes.externalTraining: <int, Map<int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>>{
      InstancyMediaTypes.none: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.NA,
            ],
            secondaryActions: <InstancyContentActionsEnum>[],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.NA,
            ],
            secondaryActions: <InstancyContentActionsEnum>[],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.NA,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.NA,
            ],
            secondaryActions: <InstancyContentActionsEnum>[],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.NA,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.NA,
            ],
            secondaryActions: <InstancyContentActionsEnum>[],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.NA,
            ],
            secondaryActions: <InstancyContentActionsEnum>[],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.NA,
            ],
            secondaryActions: <InstancyContentActionsEnum>[],
          ),
        },
      },
    },
    InstancyObjectTypes.physicalProduct: <int, Map<int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>>{
      InstancyMediaTypes.none: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.NA,
            ],
            secondaryActions: <InstancyContentActionsEnum>[],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.NA,
            ],
            secondaryActions: <InstancyContentActionsEnum>[],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
            ],
            secondaryActions: <InstancyContentActionsEnum>[],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
            ],
            secondaryActions: <InstancyContentActionsEnum>[],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.NA,
            ],
            secondaryActions: <InstancyContentActionsEnum>[],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.NA,
            ],
            secondaryActions: <InstancyContentActionsEnum>[],
          ),
        },
      },
    },
    InstancyObjectTypes.cmi5: <int, Map<int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>>{
      InstancyMediaTypes.none: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
      InstancyMediaTypes.cmi5: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
    },
    InstancyObjectTypes.assignment: <int, Map<int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>>{
      InstancyMediaTypes.none: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.Report,
              InstancyContentActionsEnum.ViewCertificate,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
    },
    InstancyObjectTypes.courseBot: <int, Map<int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>>{
      InstancyMediaTypes.none: <int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>{
        ViewTypesForContent.View: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.Subscription: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ECommerce: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.Buy,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
        ViewTypesForContent.ViewAndAddToMyLearning: <InstancyContentScreenType, PrimarySecondaryActionsDataModel>{
          InstancyContentScreenType.Catalog: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.AddToWishlist,
              InstancyContentActionsEnum.RemoveFromWishlist,
              InstancyContentActionsEnum.AddToMyLearning,
              InstancyContentActionsEnum.RecommendTo,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
          InstancyContentScreenType.MyLearning: PrimarySecondaryActionsDataModel(
            primaryActions: [
              InstancyContentActionsEnum.View,
              InstancyContentActionsEnum.Details,
            ],
            secondaryActions: <InstancyContentActionsEnum>[
              InstancyContentActionsEnum.Details,
              InstancyContentActionsEnum.Archive,
              InstancyContentActionsEnum.Unarchive,
              InstancyContentActionsEnum.ShareToConnections,
              InstancyContentActionsEnum.ShareWithPeople,
              InstancyContentActionsEnum.Share,
            ],
          ),
        },
      },
    },
  };
}
