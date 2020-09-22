class SurveyQuestionCloner < Clowne::Cloner
  adapter :active_record

  include_association :options, ->(_) { where(custom: false) }
end
