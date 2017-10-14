class Survey::Results
  def initialize(survey)
    @survey = survey
    @respondents = survey.users.includes(:kind)
    @respondents_count = survey.users.count
    @options_hash = survey.options.group_by(&:id)
    @helper = Class.new.extend(ActionView::Helpers::NumberHelper)
  end

  attr_reader :survey
  attr_reader :respondents
  attr_reader :options_hash

  def breakdown
    breakdown_by(survey.questions)
  end

  private

  def breakdown_by(questions)
    questions_fields = %i(id text required multichoice free_answer)
    options_fields = %i(id text custom)
    results = questions.select(*questions_fields).map do |question|
      survey_options = question.options
                         .select(*options_fields)
                         .where(custom: false)
                         .map(&method(:handle_regular_options))
      custom_options = question.options
                         .select(*options_fields)
                         .where(custom: true)
                         .map(&method(:handle_regular_options))

      { question: question, survey_options: survey_options, custom_options: custom_options, }
    end
    {
      results: results,
      respondents: @respondents.map { |r| { user: r, kind: r.kind } },
    }
  end

  def handle_regular_options(option)
    option_answers_count = option.answers.where('survey_answers.user_id IN (?)', ids).count
    percentage = @respondents_count.positive? ? (100 * option_answers_count / @respondents_count.to_f) : 0
    {
      option: option,
      count: option_answers_count,
      rate: percentage,
    }
  end

  def ids
    if @respondents.present?
      @respondents.pluck(:id)
    else
      [-1]
    end
  end
end
