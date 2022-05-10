import 'dart:collection';

import 'package:collection/collection.dart';

import 'board.dart';

class Result {
  final List<Board> solutionSteps;
  final bool success;
  final int timeElapsed;
  final int exploredNodesCount;
  final int expandededNodesCount;

  Result(this.solutionSteps, this.success, this.timeElapsed,
      this.exploredNodesCount, this.expandededNodesCount);
}

class BreadthFirstNode {
  final Board board;
  final BreadthFirstNode? parent;
  late bool explored = false;

  BreadthFirstNode(this.board, this.parent);
}

class AstarNode extends Comparable<AstarNode> {
  final int gCost;
  final int hCost;
  final Board board;
  final AstarNode? parent;

  AstarNode(this.gCost, this.hCost, this.board, this.parent);

  int get fCost => gCost + hCost;

  @override
  bool operator ==(other) {
    if (!(other is AstarNode)) {
      return false;
    }

    return board == other.board;
  }

  @override
  int get hashCode => board.hashCode;

  @override
  int compareTo(AstarNode other) {
    return fCost - other.fCost;
  }
}

class Puzzle {
  final Board _startingBoard;
  final Board _targetBoard;
  final bool _useHeuristics;
  final List<Board> exploredBoards = [];
  final List<Board> expandedBoards = [];

  Puzzle(this._startingBoard, this._targetBoard, this._useHeuristics);

  Result process() {
    // ignore: omit_local_variable_types
    final List<Board> solutionBoards = [];
    var success = true;
    // final duration = Duration(seconds: _maxProcessingTime);
    // Timer(duration, _handleTimeout);
    final stopwatch = Stopwatch()..start();

    if (_useHeuristics) {
      var currentNode = _astarSearch();
      success = currentNode != null;

      while (currentNode != null) {
        solutionBoards.add(currentNode.board);
        currentNode = currentNode.parent;
      }
    } else {
      var currentNode = _breadthFirst();
      success = currentNode != null;

      while (currentNode != null) {
        solutionBoards.add(currentNode.board);
        currentNode = currentNode.parent;
      }
    }

    stopwatch.stop();

    final solutionSteps = solutionBoards.reversed.toList();

    return Result(solutionSteps, success, stopwatch.elapsed.inMilliseconds,
        exploredBoards.length, expandedBoards.length);
  }

  List<Board> _expand(Board board) {
    // ignore: omit_local_variable_types
    final List<Board> possiblePlays = [];
    final blankPosition = board.elementPosition(0);

    switch (blankPosition) {
      case 0:
        possiblePlays.add(Board(board.elements)..swapPositions(0, 1));
        possiblePlays.add(Board(board.elements)..swapPositions(0, 3));
        break;
      case 1:
        possiblePlays.add(Board(board.elements)..swapPositions(1, 0));
        possiblePlays.add(Board(board.elements)..swapPositions(1, 2));
        possiblePlays.add(Board(board.elements)..swapPositions(1, 4));
        break;
      case 2:
        possiblePlays.add(Board(board.elements)..swapPositions(2, 1));
        possiblePlays.add(Board(board.elements)..swapPositions(2, 5));
        break;
      case 3:
        possiblePlays.add(Board(board.elements)..swapPositions(3, 0));
        possiblePlays.add(Board(board.elements)..swapPositions(3, 4));
        possiblePlays.add(Board(board.elements)..swapPositions(3, 6));
        break;
      case 4:
        possiblePlays.add(Board(board.elements)..swapPositions(4, 1));
        possiblePlays.add(Board(board.elements)..swapPositions(4, 3));
        possiblePlays.add(Board(board.elements)..swapPositions(4, 5));
        possiblePlays.add(Board(board.elements)..swapPositions(4, 7));
        break;
      case 5:
        possiblePlays.add(Board(board.elements)..swapPositions(5, 2));
        possiblePlays.add(Board(board.elements)..swapPositions(5, 4));
        possiblePlays.add(Board(board.elements)..swapPositions(5, 8));
        break;
      case 6:
        possiblePlays.add(Board(board.elements)..swapPositions(6, 3));
        possiblePlays.add(Board(board.elements)..swapPositions(6, 7));
        break;
      case 7:
        possiblePlays.add(Board(board.elements)..swapPositions(7, 4));
        possiblePlays.add(Board(board.elements)..swapPositions(7, 6));
        possiblePlays.add(Board(board.elements)..swapPositions(7, 8));
        break;
      case 8:
        possiblePlays.add(Board(board.elements)..swapPositions(8, 5));
        possiblePlays.add(Board(board.elements)..swapPositions(8, 7));
        break;
      default:
        break;
    }

    return possiblePlays;
  }

  AstarNode? _astarSearch() {
    final closedSet = HeapPriorityQueue<AstarNode>();
    final openSet = HeapPriorityQueue<AstarNode>();
    final totalManhattanCost = _startingBoard.manhattanCost(_targetBoard);
    openSet.add(AstarNode(0, totalManhattanCost, _startingBoard, null));

    while (openSet.isNotEmpty) {
      final currentNode = openSet.removeFirst();
      closedSet.add(currentNode);

      if (currentNode.board == _targetBoard) {
        return currentNode;
      }

      final possiblePlays = _expand(currentNode.board);
      expandedBoards.add(currentNode.board);

      for (var play in possiblePlays) {
        exploredBoards.add(play);
        final mCost = play.manhattanCost(_targetBoard);
        final currentPlay =
            AstarNode(currentNode.gCost + 1, mCost, play, currentNode);

        if (closedSet.contains(currentPlay)) {
          continue;
        }

        if (!openSet.contains(currentPlay)) {
          openSet.add(currentPlay);
        }
      }
    }

    return null;
  }

  BreadthFirstNode? _breadthFirst() {
    final nodeQueue = Queue<BreadthFirstNode>();
    final root = BreadthFirstNode(_startingBoard, null);
    nodeQueue.add(root);

    while (nodeQueue.isNotEmpty) {
      final currentNode = nodeQueue.removeFirst();

      currentNode.explored = true;

      if (currentNode.board == _targetBoard) {
        return currentNode;
      }

      final possiblePlays = _expand(currentNode.board);
      expandedBoards.add(currentNode.board);

      for (var play in possiblePlays) {
        exploredBoards.add(play);
        final currentPlay = BreadthFirstNode(play, currentNode);

        if (!currentPlay.explored) {
          currentPlay.explored = true;
          nodeQueue.add(currentPlay);
        }
      }
    }

    return null;
  }

  // void _handleTimeout() {
  //   _timeoutReached = true;
  //   print('Time out!');
  // }
}
