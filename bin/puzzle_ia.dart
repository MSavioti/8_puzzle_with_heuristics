import 'dart:io';

import 'package:puzzle_ia/board.dart';
import 'package:puzzle_ia/puzzle.dart';

void main(List<String> arguments) {
  stdout.writeln(
      '\nDigite os números do jogo dos 8 (0-8) da esquerda para a direita, de cima para baixo.');
  stdout.writeln('Pressione \"enter\" após cada inserção de número.');
  stdout.writeln('Para o espaço vazio, use o número 0(zero).');
  stdout.writeln('Para começar com uma sequência aleatória, digite 9.');

  // ignore: prefer_collection_literals
  final inputSet = Set<int>();

  while (inputSet.length < 9) {
    final input = int.tryParse(stdin.readLineSync()!);

    if ((input == null) || (input < 0) || (input > 9)) {
      stdout.writeln('Entrada inválida. Digite um número.');
      continue;
    }

    if (input == 9) {
      inputSet.clear();
      inputSet.addAll(List.generate(9, (index) => index)..shuffle());
      final board = Board(inputSet.toList());
      stdout.writeln('Estado inicial gerado automaticamente:.');
      stdout.write(board);
      break;
    }

    if (inputSet.contains(input)) {
      stdout.writeln(
          'O número $input já foi incluído. Digite um número entre 0 e 8 que ainda não foi usado.');
      continue;
    }

    inputSet.add(input);
  }

  final board = Board(inputSet.toList());
  stdout.writeln('\nEstado inicial escolhido:');
  stdout.write(board);

  stdout.writeln('\nEscolha entre os objetivos disponíveis:');
  stdout.writeln('Digite 1 para:\n1 2 3\n8 _ 4\n 7 6 5\n');
  stdout.writeln('Digite 2 para:\n1 2 3\n4 5 6\n 7 8 _\n');

  // ignore: omit_local_variable_types
  List<int> targetNumbers = [];

  while (true) {
    final input = int.tryParse(stdin.readLineSync()!);

    if (input == 1) {
      targetNumbers = [1, 2, 3, 8, 0, 4, 7, 6, 5];
      break;
    }

    if (input == 2) {
      targetNumbers = [1, 2, 3, 4, 5, 6, 7, 8, 0];
      break;
    }
  }

  int? input = -1;

  while ((input != 0) && (input != 1)) {
    stdout.writeln(
        'O programa pode usar informações heurísticas para encontrar o caminho mais rápido.');
    stdout.writeln('Digite 1 para usar informações heurísticas');
    stdout.writeln('Digite 0 para não usar informações heurísticas');
    input = int.tryParse(stdin.readLineSync()!);

    if ((input != 0) && (input != 1)) {
      stdout.writeln('O valor $input é inválido.');
      stdout.writeln('Digite 1 para usar informações heurísticas');
      stdout.writeln('Digite 0 para não usar informações heurísticas');
    }
  }

  final useHeuristics = input == 1;

  // stdout.writeln(
  //     'O processamento pode demorar consideravelmente. Digite um tempo limite para execução em segundos.');
  // stdout
  //     .writeln('Digite 0 ou um número negativo para executar indefinidamente.');

  // input = null;

  // while (input == null) {
  //   input = int.tryParse(stdin.readLineSync()!);

  //   if (input == null) {
  //     stdout.writeln('Entrada inválida. Digite um valor em segundos.');
  //     stdout.writeln(
  //         'Digite 0 ou um número negativo para executar indefinidamente.');
  //   }
  // }

  var origin = Board(inputSet.toList());
  var target = Board(targetNumbers);

  final puzzle = Puzzle(origin, target, useHeuristics);
  stdout.writeln('Iniciando processamento...\n');
  final result = puzzle.process();

  if (result.solutionSteps.isEmpty) {
    stdout.writeln('Não foi possível encontrar a solução.');
    return;
  }

  stdout.writeln('Solução encontrada!');
  stdout.writeln('Mostrando passos...\n');

  for (var i = 0; i < result.solutionSteps.length; i++) {
    if (i < result.solutionSteps.length - 1) {
      print(result.solutionSteps[i]);
      print('\n |\n |');
      print('\\\'/');
    } else {
      print('- - - - -');
      print('SOLUÇÃO!');
      print(result.solutionSteps[i]);
      print('- - - - -');
    }
  }

  stdout.writeln('Time elapsed: ${result.timeElapsed} milissegundos');
  stdout.writeln('Jogadas exploradas: ${result.exploredNodesCount}');
  stdout.writeln('Jogadas expandidas: ${result.expandededNodesCount}');
  stdout.writeln('Fim da execução.\n');
  exit(0);
}
