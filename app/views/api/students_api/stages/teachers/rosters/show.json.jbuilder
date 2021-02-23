json.available_teachers @available_teachers do |teacher|
  json.partial! 'api/students_api/stages/teachers/teacher', teacher: teacher
  json.selected false
end

json.selected_teachers @selected_teachers do |teacher|
  json.partial! 'api/students_api/stages/teachers/teacher', teacher: teacher
  json.selected true
end
