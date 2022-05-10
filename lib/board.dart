class Board {
  final List<int> elements = [];
  final int _tilesCount = 8;
  final int _slotsPerRow = 3;
  final int _rowsCount = 3;
  final int _columnsCount = 3;

  Board(List<int> values) {
    addElementsInOrder(values);
  }

  void addElementsInOrder(List<int> incomingElements) {
    for (var i = 0; i <= _tilesCount; i++) {
      if (_canAddElement(incomingElements[i])) {
        elements.add(incomingElements[i]);
      }
    }
  }

  int elementPosition(int element) {
    if (!elements.contains(element)) {
      return -1;
    }

    for (var i = 0; i < elements.length; i++) {
      if (elements[i] == element) {
        return i;
      }
    }

    throw ArgumentError();
  }

  int manhattanCost(Board target) {
    var cost = 0;

    for (var i = 0; i < elements.length; i++) {
      cost += _manhattanElementCost(i, target.elementPosition(elements[i]));
    }

    return cost;
  }

  void swapPositions(int pos1, int pos2) {
    final backup = elements[pos1];
    elements[pos1] = elements[pos2];
    elements[pos2] = backup;
  }

  int _manhattanElementCost(int currentPosition, int targetPosition) {
    var cost = 0;
    final _currentRow = _elementRow(currentPosition);
    final _targetRow = _elementRow(targetPosition);

    if (_currentRow > _targetRow) {
      cost += _currentRow - _targetRow;
    } else {
      cost += _targetRow - _currentRow;
    }

    final _currentColumn = _elementColumn(currentPosition);
    final _targetColumn = _elementColumn(targetPosition);

    if (_currentColumn > _targetColumn) {
      cost += _currentColumn - _targetColumn;
    } else {
      cost += _targetColumn - _currentColumn;
    }

    return cost;
  }

  bool _canAddElement(int element) {
    if (element > _tilesCount) {
      return false;
    }

    if (elements.length == _tilesCount + 1) {
      return false;
    }

    if (elements.contains(element)) {
      return false;
    }

    return true;
  }

  int _elementRow(int position) {
    for (var i = 0; i < _rowsCount + 1; i++) {
      if (position < (i + 1) * _slotsPerRow) {
        return i;
      }
    }

    throw ArgumentError();
  }

  int _elementColumn(int position) {
    return position % _columnsCount;
  }

  @override
  bool operator ==(other) {
    if (!(other is Board)) {
      return false;
    }

    // ignore: omit_local_variable_types
    final Board otherBoard = other;

    for (var i = 0; i <= _tilesCount; i++) {
      if (elements[i] != otherBoard.elements[i]) {
        return false;
      }
    }

    return true;
  }

  @override
  int get hashCode => elements.hashCode;

  @override
  String toString() {
    final buffer = StringBuffer();

    for (var i = 0; i < _tilesCount + 1; i++) {
      if (i % _rowsCount == 0) {
        buffer.write('\n');
      }

      buffer.write(elements[i]);
    }

    return buffer.toString();
  }
}
