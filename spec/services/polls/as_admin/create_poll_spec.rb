require "rails_helper"

describe Polls::AsAdmin::CreatePoll do
  subject { described_class.new.call(name: name, starts_at: starts_at, ends_at: ends_at, faculty_ids: faculty_ids) }

  let(:name) {}
  let(:starts_at) {}
  let(:ends_at) {}
  let(:faculty_ids) {}

  context "with valid params" do
    let!(:faculties) { create_list(:faculty, 3) }

    let(:name) { Faker::Game.title }
    let(:starts_at) { Time.current + 2.days }
    let(:ends_at) { Time.current + 7.days }
    let(:faculty_ids) { faculties.pluck(:id) }

    it("returns success") { expect(subject).to be_success }
    it("creates poll") { expect { subject }.to change { Poll.count }.by(1) }
  end
end
