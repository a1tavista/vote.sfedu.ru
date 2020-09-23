FactoryBot.define do
  factory :poll_participation, class: 'Poll::Participation' do
    poll
    student
  end
end
