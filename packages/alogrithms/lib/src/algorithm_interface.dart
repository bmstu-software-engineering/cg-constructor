import 'package:forms/forms.dart';
import 'package:models_ns/models_ns.dart';

abstract interface class Algorithm<
  DataModelType extends DataModel,
  ResultModelType extends ResultModel
> {
  DataModelType getDataModel();
  ResultModelType calculate();
}

abstract interface class DataModel {}

abstract interface class AlgorithmData {}

abstract interface class FormsDataModel implements DataModel {
  FormConfig get config;

  AlgorithmData get data;
}

abstract interface class ResultModel {}

class ViewerResultModel implements ResultModel {
  final List<Point> points;
  final List<Line> lines;

  const ViewerResultModel({this.points = const [], this.lines = const []});
}
