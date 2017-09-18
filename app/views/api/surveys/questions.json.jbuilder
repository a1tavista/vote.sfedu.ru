@questions.each do |question|
  json.set! question.id do
    json.id question.id
    json.text question.text
    json.required question.required
    json.multichoice question.multichoice
    json.freeAnswer question.free_answer
    json.options question.options.where(custom: false), :id, :text
  end
end
