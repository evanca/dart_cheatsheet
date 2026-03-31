import 'dart:collection';
import 'dart:math';

void main() {
  testLists();
  testMaps();
  testSets();
  testStacks();
  testQueues();
  testTrees();
  testAlgos();
  testMath();
  testMatrix();
  testRecursion();
  testGraphs();
  print("All tests passed! The cheatsheet code is fully valid.");
}

void testLists() {
  var list = <int>[1, 2, 3];

  var zeros = List.filled(5, 0);
  assert(zeros.length == 5 && zeros[0] == 0);

  var grid = List.generate(3, (_) => List.filled(3, 0));
  assert(grid.length == 3 && grid[0].length == 3);

  list.add(4);
  assert(list.last == 4);

  var popped = list.removeLast();
  assert(popped == 4);

  list.insert(0, 99);
  assert(list[0] == 99);

  var removed = list.removeAt(0);
  assert(removed == 99);

  var index = list.indexOf(2);
  assert(index == 1);

  var combined = [...list, 4, 5];
  assert(combined.length == 5);

  int iterationCount = 0;
  for (var item in list) {
    iterationCount += 1;
  }
  assert(iterationCount == list.length);

  list.forEach((item) {
    // print(item);
  });
}

void testMaps() {
  var map = <String, int>{'a': 1};

  map['b'] = 2;
  map.remove('a');
  assert(map.containsKey('b') == true);
  assert(map.containsKey('a') == false);

  map.putIfAbsent('c', () => 3);
  assert(map['c'] == 3);

  map.update('b', (v) => v + 1, ifAbsent: () => 1);
  assert(map['b'] == 3);

  for (var entry in map.entries) {
    // print('${entry.key}: ${entry.value}');
  }
}

void testSets() {
  var set = <int>{1, 2, 3};

  set.add(4);
  set.remove(2);
  assert(set.contains(3) == true);
  assert(set.contains(2) == false);

  var a = {1, 2}, b = {2, 3};
  assert(a.union(b).length == 3);
  assert(a.intersection(b).length == 1 && a.intersection(b).first == 2);
  assert(a.difference(b).length == 1 && a.difference(b).first == 1);
}

void testStacks() {
  var stack = <int>[];

  stack.add(1);
  stack.add(2);

  if (stack.isNotEmpty) {
    var top = stack.removeLast();
    assert(top == 2);
  }

  var peek = stack.last;
  assert(peek == 1);
}

void testQueues() {
  var queue = Queue<int>(); 

  queue.addLast(1); 
  
  if (queue.isNotEmpty) {
    var front = queue.removeFirst();
    assert(front == 1);
  }

  queue.addFirst(0);    
  queue.addLast(2);   
  
  var removedLast = queue.removeLast();
  assert(removedLast == 2);

  assert(queue.first == 0);
  assert(queue.last == 0);
}

void testTrees() {
  var treeMap = SplayTreeMap<int, String>();
  treeMap[3] = 'C';
  treeMap[1] = 'A';
  assert(treeMap.firstKey() == 1); 

  var treeSet = SplayTreeSet<int>();
  treeSet.addAll([5, 1, 8]);
  assert(treeSet.first == 1); 
}

void testAlgos() {
  var arr = [3, 1, 5];
  
  arr.sort((a,b) => a.compareTo(b)); 
  assert(arr[0] == 1 && arr[2] == 5);

  arr.sort((a,b) => b.compareTo(a)); 
  assert(arr[0] == 5 && arr[2] == 1);

  var evens = arr.where((x) => x.isEven);
  assert(evens.isEmpty == true); 
  
  var mapped = arr.map((x) => x * 2);
  // mapped creates an Iterable, list equivalent is [10, 6, 2]
  assert(mapped.first == 10);
  
  var sum = arr.reduce((a, b) => a + b);
  assert(sum == 9);

  var maxVal = arr.reduce(max);
  assert(maxVal == 5);

  var s = "hello";
  var reversed = s.split('').reversed.join();
  assert(reversed == "olleh");
}

void testMath() {
  var div = 5 ~/ 2;
  var mod = 5 % 2;
  assert(div == 2 && mod == 1);

  assert(5.isEven == false);
  assert(5.isOdd == true);
  assert((-5).abs() == 5);

  var and = 5 & 1; // 0101 & 0001 = 0001 = 1
  var or = 5 | 2;  // 0101 | 0010 = 0111 = 7
  var xor = 5 ^ 1; // 0101 ^ 0001 = 0100 = 4
  var shift = 1 << 2; // 0001 -> 0100 = 4

  assert(and == 1);
  assert(or == 7);
  assert(xor == 4);
  assert(shift == 4);
}

void testMatrix() {
  var grid = [
    [1, 2],
    [3, 4]
  ];

  var flat = grid.expand((i) => i).toList();
  assert(flat.length == 4 && flat[0] == 1 && flat[3] == 4);

  var sum = 0;
  for (var r = 0; r < grid.length; r++) {
    for (var c = 0; c < grid[r].length; c++) {
      sum += grid[r][c];
    }
  }
  assert(sum == 10);

  var r = 0, c = 0;
  var dirs = [[0,1], [1,0], [0,-1], [-1,0]];
  for (var d in dirs) {
    var nr = r + d[0], nc = c + d[1];
    // testing logical assignment mapping logic
    assert(nr == r + d[0] && nc == c + d[1]);
  }
}

var memo = <int, int>{};
int fib(int n) {
  if (n <= 1) return n;
  if (memo.containsKey(n)) return memo[n]!;
  return memo[n] = fib(n - 1) + fib(n - 2);
}

void testRecursion() {
  memo.clear();
  assert(fib(5) == 5);
  assert(fib(6) == 8);
  assert(fib(10) == 55);
}

void testGraphs() {
  var graph = <int, List<int>>{
    1: [2, 3],
    2: [4],
    3: [],
    4: []
  };

  // BFS
  var bfsOrder = <int>[];
  var q = Queue<int>()..add(1);
  var visBfs = <int>{1};
  
  while (q.isNotEmpty) {
    var node = q.removeFirst();
    bfsOrder.add(node);
    for (var next in graph[node] ?? []) {
      if (visBfs.add(next)) q.add(next);
    }
  }
  assert(bfsOrder.join(',') == '1,2,3,4');

  // DFS
  var dfsOrder = <int>[];
  var visDfs = <int>{};
  
  void dfs(int node) {
    if (!visDfs.add(node)) return;
    dfsOrder.add(node);
    for (var next in graph[node] ?? []) dfs(next);
  }
  
  dfs(1);
  assert(dfsOrder.join(',') == '1,2,4,3');
}



