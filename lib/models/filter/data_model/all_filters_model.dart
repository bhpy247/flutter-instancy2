class AllFilterModel {
  String categoryName = "";

  AllFilterModel({
    this.categoryName = "",
  });

  AllFilterModel.copy({required AllFilterModel allFilterModel}) {
    categoryName = allFilterModel.categoryName;
  }
}