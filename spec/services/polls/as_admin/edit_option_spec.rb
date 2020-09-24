require "rails_helper"

describe Polls::AsAdmin::EditOption do
  subject { described_class.new.call(poll_option: poll_option, description: description) }

  context "with valid params" do
    let!(:poll) { create(:poll, :with_options, starts_at: Time.current + 2.days) }
    let(:poll_option) { poll.options.first }
    let(:description) { Faker::Name.name }

    it("returns success") { expect(subject).to be_success }
    it("creates poll") { expect { subject }.to change { poll_option.reload.description }.to(description) }
  end
end
