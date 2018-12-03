const S = require('sanctuary');
const R = require('ramda');

// setting for swank-js
console.log = (typeof inspect === "undefined") ? console.log : inspect;

const students = [
  { name: "太朗", exams: { midterm: 80, endterm: 65 } },
  { name: "花子", exams: { midterm: 93, endterm: 38 } },
  { name: "謙太", exams: { midterm: 55, endterm: 65 } },
  { name: "春子", exams: { midterm: 92, endterm: 78 } },
  { name: "五朗", exams: { midterm: 48, endterm: 25 } },
  { name: "郁子", exams: { midterm: 73, endterm: 84 } },
];

const geqAlt = (border, grade) => alt => x => x >= border ? grade : alt(x);
const grade = geqAlt(90, "A")(geqAlt(80, "B")(geqAlt(60, "C")(geqAlt(0, "D")(x => "欠席"))));

markEach = student => {
  return {...student, grade: S.map(grade)(student.exams)};
};

console.log(students.map(markEach));
console.log("----------------");
console.log(students);
