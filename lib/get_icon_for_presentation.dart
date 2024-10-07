import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vector_graphics/vector_graphics.dart';

class GetIconForPresentation {
  static Widget getIcon(String presentacion, {double size = 40}) {
    String assetName =
        'blister_pills_round_x14.svg.vec'; // Ícono por defecto para Tableta

    switch (presentacion.toLowerCase()) {
      case 'tableta':
        assetName = 'assets/blister_pills_round_x14.svg.vec';
        break;
      case 'bulbo':
        assetName = 'assets/noun-vial-1514423.svg.vec';
        break;
      case 'ampolleta':
        assetName = 'assets/noun-ampoule-576049.svg.vec';
        break;
      case 'cápsula':
        assetName = 'assets/blister_pills_oval_x14.svg.vec';
        break;
      case 'polvo':
        assetName = 'assets/noun-powder-3965085.svg.vec';
        break;
      case 'crema':
        assetName = 'assets/noun-ointment-7077420.svg.vec';
        break;
      case 'gotas':
        assetName = 'assets/noun-drops-6111347.svg.vec';
        break;
      case 'suspensión':
        assetName = 'assets/noun-ampoule-5507231.svg.vec';
        break;
      case 'gel oftálmico':
        assetName = 'assets/noun-eye-drops-5449985.svg.vec';
        break;
      case 'ungüento':
        assetName = 'assets/noun-ointment-6278252.svg.vec';
        break;
      case 'frasco':
        assetName = 'assets/noun-empty-vial-1514423.svg.vec';
        break;
      case 'solución oral':
        assetName = 'assets/noun-liquid-medicine-5575677.svg.vec';
        break;
      case 'polvo para suspensión oral':
        assetName = 'assets/noun-oral-suspension-6179229.svg.vec';
        break;
      case 'colirio':
        assetName = 'assets/noun-eye-drops-5449985.svg.vec';
        break;
      case 'aerosol':
        assetName = 'assets/noun-spray-5481885.svg.vec';
        break;
      case 'tableta revestida':
        assetName = 'assets/blister_pills_oval_x14.svg.vec';
        break;
      case 'champú':
        assetName = 'assets/noun-shampoo-7245733.svg.vec';
        break;
      case 'ungüento oftálmico':
        assetName = 'assets/noun-eye-drops-5449985.svg.vec';
        break;
      case 'jarabe':
        assetName = 'assets/noun-syrup-6891159.svg.vec';
        break;
      case 'óvulo':
        assetName = 'assets/noun-suppository-3100011.svg.vec';
        break;
      case 'elixir':
        assetName = 'assets/noun-elixir-4931044.svg.vec';
        break;
      case 'supositorio':
        assetName = 'assets/noun-suppository-6363058.svg.vec';
        break;
      case 'crema vaginal':
        assetName = 'assets/noun-ointment-7190825.svg.vec';
        break;
      case 'ungüento rectal':
        assetName = 'assets/noun-ointment-7190825.svg.vec';
        break;
      case 'tableta masticable':
        assetName = 'assets/noun-chewable-tablet-6179236.svg.vec';
        break;
      case 'líquido':
        assetName = 'assets/noun-liquid-5143724.svg.vec';
        break;
      case 'vial':
        assetName = 'assets/noun-vial-1514423.svg.vec';
        break;
      case 'tableta vaginal':
        assetName = 'assets/noun-suppository-3100011.svg.vec';
        break;
      case 'spray anestésico':
        assetName = 'assets/noun-spray-5481885.svg.vec';
        break;
      case 'jalea':
        assetName = 'assets/noun-ointment-7190825.svg.vec';
        break;
      case 'carpule':
        assetName = 'assets/noun-anesthetic-cartridges-5694748.svg.vec';
        break;
      case 'loción':
        assetName = 'assets/noun-lotion-5956008.svg.vec';
        break;
      case 'gas':
        assetName = 'assets/noun-air-6314787.svg.vec';
        break;
      case 'solución':
        assetName = 'assets/noun-liquid-medicine-5575677.svg.vec';
        break;
      case 'liofilizado para inyección iv':
        assetName = 'assets/noun-ampoule-5507231.svg.vec';
        break;
      default:
        assetName =
            'assets/info.svg.vec'; // Ícono por defecto si no se encuentra la presentación
        break;
    }

    return SvgPicture(
      AssetBytesLoader(assetName),
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(
          Colors.blueGrey[900] ?? Colors.black, BlendMode.srcIn),
    );
  }
}
