enum WheelData {
  wheelData1('這是', Price.price1),
  wheelData2('一些', Price.price1),
  wheelData3('轉盤', Price.price1),
  wheelData4('上的', Price.price2),
  wheelData5('中文', Price.price2),
  wheelData6('名字', Price.price2);

  const WheelData(this.wheelDataName, this.price);
  final String wheelDataName;
  final Price price;
}

enum Price {
  price1('price1'),
  price2('price2');

  const Price(this.priceName);
  final String priceName;
}
