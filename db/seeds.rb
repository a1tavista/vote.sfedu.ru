START_YEAR = 2000
40.times do |i|
  Semester.create(year_begin: (START_YEAR + i) - 1, year_end: START_YEAR + i, kind: :fall)
  Semester.create(year_begin: (START_YEAR + i) - 1, year_end: START_YEAR + i, kind: :spring)
end
