json.available @available do |teacher|
  json.partial! 'api/students_api/stages/teachers/teacher', teacher: teacher
  json.participated false
end

json.evaluated @evaluated do |teacher|
  json.partial! 'api/students_api/stages/teachers/teacher', teacher: teacher
  json.participated true
end
