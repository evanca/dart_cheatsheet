import 'dart:collection';
import 'dart:math';
import 'package:collection/collection.dart';

class ListNode {
  int val;
  ListNode? next;
  ListNode(this.val, [this.next]);
}

class Point {
  final int x, y;
  const Point(this.x, this.y);
}

void main() {
  testLists();
  testMaps();
  testSets();
  testStacks();
  testQueues();
  testHeaps();
  testTrees();
  testAlgos();
  testMath();
  testMatrix();
  testRecursion();
  testGraphs();
  testQuickSort();
  testBinarySearch();
  testClasses();
  testRecords();
  testControlFlow();
  testReverseList();
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

  assert(list.contains(2) == true);
  assert(list.contains(99) == false);

  var combined = [...list, 4, 5];
  assert(combined.length == 5);

  int iterationCount = 0;
  for (var item in list) {
    iterationCount += 1;
  }
  assert(iterationCount == list.length);

  int reverseCount = 0;
  for (var i = list.length - 1; i >= 0; i--) {
    reverseCount += list[i];
  }
  assert(reverseCount == 6); // 1+2+3

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

void testHeaps() {
  var minHeap = PriorityQueue<int>();
  minHeap.add(5);
  minHeap.add(1);
  assert(minHeap.first == 1);
  assert(minHeap.removeFirst() == 1);

  var maxQ = PriorityQueue<int>();
  maxQ.addAll([-3, -8, -2]);
  assert(-maxQ.removeFirst() == 8);
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

  var intervals = [[8, 10], [1, 3], [15, 18], [2, 6]];
  intervals.sort((a, b) => a[0].compareTo(b[0]));
  assert(intervals.map((e) => e.join(',')).join(';') == '1,3;2,6;8,10;15,18');

  var evens = arr.where((x) => x.isEven);
  assert(evens.isEmpty == true); 
  
  var mapped = arr.map((x) => x * 2);
  // mapped creates an Iterable, list equivalent is [10, 6, 2]
  assert(mapped.first == 10);
  
  var sum = arr.reduce((a, b) => a + b);
  assert(sum == 9);

  var maxVal = arr.reduce(max);
  var minVal = arr.reduce(min);
  assert(maxVal == 5 && minVal == 1);

  var s = "hello";
  var chars = <String>[];
  for (var char in s.split('')) {
    chars.add(char);
  }
  assert(chars.join() == "hello");
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
  var zeros = List.generate(3, (_) => List.filled(4, 0));
  assert(zeros.length == 3 && zeros[0].length == 4 && zeros[0][0] == 0);

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

  var revSum = 0;
  var order = <int>[];
  for (var r = grid.length - 1; r >= 0; r--) {
    for (var c = grid[r].length - 1; c >= 0; c--) {
      revSum += grid[r][c];
      order.add(grid[r][c]);
    }
  }
  assert(revSum == 10);
  assert(order.join(',') == '4,3,2,1');

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

List<int> quickSort(List<int> arr) {
  if (arr.length <= 1) return arr;
  var pivot = arr[arr.length ~/ 2];
  var left = arr.where((x) => x < pivot).toList();
  var middle = arr.where((x) => x == pivot).toList();
  var right = arr.where((x) => x > pivot).toList();
  return [...quickSort(left), ...middle, ...quickSort(right)];
}

void testQuickSort() {
  assert(quickSort([3, 1, 4, 1, 5, 9, 2, 6, 5]).join(',') == '1,1,2,3,4,5,5,6,9');
  assert(quickSort([]).isEmpty);
  assert(quickSort([10]).join(',') == '10');
  assert(quickSort([5, 4, 3, 2, 1]).join(',') == '1,2,3,4,5');
}

int binarySearch(List<int> sortedList, int target) {
  int low = 0, high = sortedList.length - 1;
  while (low <= high) {
    int mid = low + (high - low) ~/ 2;
    if (sortedList[mid] == target) return mid;
    if (sortedList[mid] < target) low = mid + 1;
    else high = mid - 1;
  }
  return -1;
}

void testBinarySearch() {
  var list = [1, 3, 5, 7, 9];
  assert(binarySearch(list, 5) == 2);
  assert(binarySearch(list, 1) == 0);
  assert(binarySearch(list, 9) == 4);
  assert(binarySearch(list, 4) == -1);
  assert(binarySearch([], 5) == -1);
}

void testClasses() {
  var p = const Point(10, 20);
  assert(p.x == 10 && p.y == 20);
}

void testRecords() {
  var record = (1, 2, name: 'Dart');
  assert(record.$1 == 1);
  assert(record.name == 'Dart');
  
  var (a, b, name: n) = record;
  assert(a == 1 && b == 2 && n == 'Dart');
}

ListNode? reverseList(ListNode? head) {
  ListNode? prev;
  ListNode? curr = head;
  while (curr != null) {
    ListNode? nextTemp = curr.next;
    curr.next = prev;
    prev = curr;
    curr = nextTemp;
  }
  return prev;
}

void testReverseList() {
  var n3 = ListNode(3);
  var n2 = ListNode(2, n3);
  var n1 = ListNode(1, n2);
  
  var reversed = reverseList(n1);
  assert(reversed?.val == 3);
  assert(reversed?.next?.val == 2);
  assert(reversed?.next?.next?.val == 1);
  assert(reversed?.next?.next?.next == null);
}

void testControlFlow() {
  var message = StringBuffer();
  for (var i = 0; i < 5; i++) {
    message.write('!');
  }
  assert(message.toString() == '!!!!!');

  int count = 0;
  for (var x in [1, 2, 3]) {
    count += x;
  }
  assert(count == 6);

  var val = 1;
  var res = switch(val) {
    1 => 'one',
    _ => 'many'
  };
  assert(res == 'one');
}
