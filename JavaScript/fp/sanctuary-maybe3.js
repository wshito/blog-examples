const S = require('sanctuary');
const R = require('ramda');
const _ = require('lodash');

const students = [
  { name: "太朗", exams: { midterm: 'NA', endterm: 65 } },
  { name: "花子", exams: { midterm: 93, endterm: 38 } },
  { name: "謙太", exams: { midterm: null, endterm: 65 } },
  { name: "春子", exams: { midterm: 92, endterm: 78 } },
  { name: "五朗", exams: { midterm: 48, endterm: 25 } },
  { name: "郁子", exams: { midterm: 73, endterm: null } },
];

const geqAlt = (border, grade) => alt => x => x >= border ? grade : alt(x);
const grade = geqAlt(90, "A")(geqAlt(80, "B")(geqAlt(60, "C")(x => "D")));

// sanctuaryのcomposeは2引数までなのでramdaを使う
const grade2 = S.compose(
  S.fromMaybe("欠席")) // getOrElse()と同じ．
(S.compose((S.map(grade)))        // Nothingはこのmapをスルーする
 (S.ifElse(_.isNumber)(S.toMaybe)(x => S.Nothing)));

const gradeLens = R.lensProp("grade");
// student.examsの値が同じ型ではないのでS.map()の型制約を満たさない．unchecked.map()を使う．
const mark = student => R.set(gradeLens, S.unchecked.map(grade2)(student.exams), student);

console.log(students.map(mark));
console.log("----------------");
console.log(students);
