class SurveyCloner < Clowne::Cloner
  adapter :active_record

  include_association :questions, clone_with: SurveyQuestionCloner
  include_association :options

  nullify :passcode
end
