const String tableName = 'scores';
const String columnId = 'id';
const String columnScore = 'score';
const String columnDate = 'date';

const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
const String integerType = 'INTEGER NOT NULL';

class Score {
  final int? id;
  final int score;
  final DateTime date;
  Score({required this.score, required this.date, this.id});
  // from json
  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(score: json['score'], date: DateTime.parse(json['date']));
  }
  // to json
  Map<String, dynamic> toJson() {
    return {'score': score, 'date': date.toIso8601String()};
  }

  //copy with
  Score copyWith({int? score, DateTime? date, int? id}) {
    return Score(
        score: score ?? this.score, date: date ?? this.date, id: id ?? this.id);
  }
}
