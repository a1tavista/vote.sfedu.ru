require "rails_helper"

describe Teachers::AsStudent::LeaveFeedback do
  subject do
    described_class.new.call(
      student: student,
      stage: stage,
      teacher: teacher,
      answers: answers
    )
  end

  let(:stage) { create(:stage, :with_questions, :with_semester) }
  let(:student) { create(:student, :with_grade_book) }
  let(:teacher) { create(:teacher) }

  let!(:students_teachers_relation) { create(:students_teachers_relation, teacher: teacher, student: student, semester: stage.semesters.first) }

  let(:answers) {
    index = 0
    stage.questions.map do |question|
      answer = { question_id: question.id, rate: rates[index] }
      index += 1
      answer
    end
  }
  let(:rates) { [1, 1, 1, 1, 1] }

  shared_examples "a service that accepts feedback" do
    it("returns success") { expect(subject).to be_success }
    it("creates participation") { expect { subject }.to change { Participation.where(teacher: teacher, student: student).count }.by(1) }
    it("updates answers") { expect { subject }.to change { Answer.where(teacher: teacher, stage: stage).pluck(:ratings) } }
  end

  context "with valid params" do
    it_behaves_like "a service that accepts feedback"
  end
end
