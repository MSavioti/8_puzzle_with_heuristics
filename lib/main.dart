import 'board.dart';

main(List<String> args) {
  Board board1 = Board([5, 8, 4, 1, 3, 0, 6, 2, 7]);
  Board board2 = Board([1, 2, 3, 8, 0, 4, 7, 6, 5]);

  print(board1.manhattanCost(board2));
  print(board1);
  print(Board(board1.elements)..swapPositions(0, 1));
  print(board2);
}
