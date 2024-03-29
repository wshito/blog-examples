const S = require('sanctuary');
const R = require('ramda');

// setting for swank-js
console.log = (typeof inspect === "undefined") ? console.log : inspect;

const students = [
  { name: "太朗", exams: { midterm: 'NA', endterm: 65 } },
  { name: "花子", exams: { midterm: 93, endterm: 38 } },
  { name: "謙太", exams: { midterm: null, endterm: 65 } },
  { name: "春子", exams: { midterm: 92, endterm: 78 } },
  { name: "五朗", exams: { midterm: 48, endterm: 25 } },
  { name: "郁子", exams: { midterm: 73, endterm: null } }
];

// 'NA' は欠席になるが null は D になる．
const geqAlt = (border, grade) => alt => x => x >= border ? grade : alt(x);
const grade = geqAlt(90, "A")(geqAlt(80, "B")(geqAlt(60, "C")(geqAlt(0, "D")(x => "欠席"))));

const gradeLens = R.lensProp("grade");
const markEach = student => R.set(gradeLens, S.unchecked.map(grade)(student.exams), student);
// 上の 2 行は下と同じ
// const markEach = student => {
//   return {...student, grade:R.map(grade, student.exams)};
// };

console.log(students.map(markEach));
console.log("----------------");
console.log(students);
