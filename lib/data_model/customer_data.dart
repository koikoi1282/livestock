import 'package:equatable/equatable.dart';

enum IndustrialNature {
  manufacturer('動物營養(藥)品製造者'),
  agent('動物營養(藥)品代理商'),
  business('動物營養(藥)品業務'),
  pigFarm('豬場'),
  henFarm('蛋雞場'),
  feedlot('其他畜種飼養場');

  const IndustrialNature(this.name);
  final String name;
}

enum Location {
  taipei('北北基宜'),
  taoyuan('桃竹苗'),
  taichung('中彰投'),
  yunlin('雲嘉南'),
  kaohsiung('高屏'),
  hualien('花東'),
  other('其他國家');

  const Location(this.name);
  final String name;
}

class CustomerData extends Equatable {
  final String name;
  final IndustrialNature industrialNature;
  final Location location;
  final String contactInfomation;

  const CustomerData({
    required this.name,
    required this.industrialNature,
    required this.location,
    required this.contactInfomation,
  });

  Map<String, dynamic> toDbJson() => {
        'name': name,
        'industrialNature': industrialNature.name,
        'location': location.name,
        'contactInfomation': contactInfomation
      };

  @override
  List<Object> get props => [name, industrialNature, location, contactInfomation];
}
