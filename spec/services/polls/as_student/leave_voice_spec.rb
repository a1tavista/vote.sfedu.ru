require "rails_helper"

describe Polls::AsStudent::LeaveVoice do
  subject { described_class.new.call(student: student, poll: poll, poll_option: chosen_option) }

  let(:faculty) { create(:faculty) }
  let(:poll) { create(:poll, :with_options, faculty_ids: [faculty.id]) }
  let(:student) { create(:student, :with_grade_book, faculty_id: faculty.id) }
  let(:chosen_option) { poll.options.first }

  shared_examples "a service that accepts vote" do
    it("returns success") { expect(subject).to be_success }
    it("creates answer") { expect { subject }.to change { Poll::Answer.count }.by(1) }
    it("creates participation") { expect { subject }.to change { Poll::Participation.count }.by(1) }
  end

  shared_examples "a service that rejects vote" do
    it("returns failure") { expect(subject).to be_failure }
    it("creates answer") { expect { subject }.not_to change { Poll::Answer.count } }
    it("creates participation") { expect { subject }.not_to change { Poll::Participation.count } }
  end

  context "when poll started and not finished" do
    it_behaves_like "a service that accepts vote"
  end

  context "when student belongs to participating faculty" do
    it_behaves_like "a service that accepts vote"
  end

  context "when student not participated before" do
    it_behaves_like "a service that accepts vote"
  end

  context "when poll option not belongs to poll" do
    let(:another_poll) { create(:poll, :with_options, faculty_ids: [faculty.id]) }
    let(:chosen_option) { another_poll.options.first }

    it_behaves_like "a service that rejects vote"
  end

  context "when student not belongs to participating faculty" do
    let(:another_faculty) { create(:faculty) }
    let(:student) { create(:student, :with_grade_book, faculty_id: another_faculty.id) }

    it_behaves_like "a service that rejects vote"
  end

  context "when student participated before" do
    let!(:poll_participation) { create(:poll_participation, student: student, poll: poll) }

    it_behaves_like "a service that rejects vote"
  end

  context "when poll isn't started yet" do
    let(:poll) { create(:poll, :with_options, starts_at: Time.current + 1.day, faculty_ids: [faculty.id]) }

    it_behaves_like "a service that rejects vote"
  end

  context "when poll finished" do
    let(:poll) { create(:poll, :with_options, ends_at: Time.current - 1.day, faculty_ids: [faculty.id]) }

    it_behaves_like "a service that rejects vote"
  end
end
