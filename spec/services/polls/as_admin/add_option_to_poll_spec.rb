require "rails_helper"

describe Polls::AsAdmin::AddOptionToPoll do
  subject { described_class.new.call(title: title, poll: poll) }

  context "with valid params" do
    let!(:poll) { create(:poll, starts_at: Time.current + 2.days) }
    let(:title) { Faker::Name.name }

    it("returns success") { expect(subject).to be_success }
    it("creates poll") { expect { subject }.to change { Poll::Option.count }.by(1) }
  end
end
