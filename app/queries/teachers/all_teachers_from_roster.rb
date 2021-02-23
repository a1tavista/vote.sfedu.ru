module Teachers
  class AllTeachersFromRoster
    extend Dry::Initializer

    option :stage

    def call
      return Teacher.none if stage.nil?

      Teacher.joins(:teachers_rosters).merge(TeachersRoster.where(stage: stage))
    end
  end
end
