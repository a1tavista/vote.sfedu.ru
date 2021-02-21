json.stage do
  json.partial! 'api/students_api/stages/stage', stage: @stage
end

json.teacher do
  json.partial! 'api/students_api/stages/teachers/teacher', teacher: @teacher
  json.disciplines @student_relations.pluck(:disciplines).flatten
end

json.questions @questions do |question|
  json.id question.id
  json.text question.text
  json.max_rating question.max_rating
end
