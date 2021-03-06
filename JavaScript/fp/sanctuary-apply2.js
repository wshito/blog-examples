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

const grade2 = R.compose(
  S.fromMaybe("欠席"),
  S.map(grade),
  S.ifElse(_.isNumber)(S.toMaybe)(x => S.Nothing));

const gradeAll = students => S.ap([R.map(grade2)])
  (S.map(R.prop('exams'))(students));

const zip = student => grade => {
  return { ...student, grade };
};

const mark = students => S.zipWith(zip)(students)(gradeAll(students));

console.log(mark(students));
