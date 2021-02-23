json.stage_attendee do
  json.choosing_status @stage_attendee.choosing_status
  json.fetching_status @stage_attendee.fetching_status
end

json.available @available do |teacher|
  json.partial! 'api/students_api/stages/teachers/teacher', teacher: teacher
  json.participated false
end

json.evaluated @evaluated do |teacher|
  json.partial! 'api/students_api/stages/teachers/teacher', teacher: teacher
  json.participated true
end
