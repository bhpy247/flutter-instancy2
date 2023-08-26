import 'package:flutter_instancy_2/backend/lens_feature/lens_provider.dart';
import 'package:flutter_instancy_2/backend/lens_feature/lens_repository.dart';

import '../../api/api_controller.dart';

class LensController {
  late LensProvider _lensProvider;
  late LensRepository _lensRepository;

  LensController({required LensProvider? lensProvider, LensRepository? repository, ApiController? apiController}) {
    _lensProvider = lensProvider ?? LensProvider();
    _lensRepository = repository ?? LensRepository(apiController: apiController ?? ApiController());
  }

  LensProvider get lensProvider => _lensProvider;

  LensRepository get lensRepository => _lensRepository;
}
