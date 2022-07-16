part of 'cell_service.dart';

abstract class IGridCellDataConfig {
  // The cell data will reload if it receives the field's change notification.
  bool get reloadOnFieldChanged;
}

abstract class ICellDataParser<T> {
  T? parserData(List<int> data);
}

class GridCellDataLoader<T> {
  final CellService service = CellService();
  final GridCellIdentifier cellId;
  final ICellDataParser<T> parser;
  final bool reloadOnFieldChanged;

  GridCellDataLoader({
    required this.cellId,
    required this.parser,
    this.reloadOnFieldChanged = false,
  });

  Future<T?> loadData() {
    final fut = service.getCell(cellId: cellId);
    return fut.then(
      (result) => result.fold((Cell cell) {
        try {
          return parser.parserData(cell.data);
        } catch (e, s) {
          Log.error('$parser parser cellData failed, $e');
          Log.error('Stack trace \n $s');
          return null;
        }
      }, (err) {
        Log.error(err);
        return null;
      }),
    );
  }
}

class StringCellDataParser implements ICellDataParser<String> {
  @override
  String? parserData(List<int> data) {
    final s = utf8.decode(data);
    return s;
  }
}

class DateCellDataParser implements ICellDataParser<DateCellData> {
  @override
  DateCellData? parserData(List<int> data) {
    if (data.isEmpty) {
      return null;
    }
    return DateCellData.fromBuffer(data);
  }
}

class SelectOptionCellDataParser implements ICellDataParser<SelectOptionCellData> {
  @override
  SelectOptionCellData? parserData(List<int> data) {
    if (data.isEmpty) {
      return null;
    }
    return SelectOptionCellData.fromBuffer(data);
  }
}

class URLCellDataParser implements ICellDataParser<URLCellData> {
  @override
  URLCellData? parserData(List<int> data) {
    if (data.isEmpty) {
      return null;
    }
    return URLCellData.fromBuffer(data);
  }
}