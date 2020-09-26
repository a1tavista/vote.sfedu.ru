require "rails_helper"

describe OneCApi::FetchStudentTeachersRelations do
  subject { described_class.new.call(external_id: external_id) }

  let(:external_id) { '0000' }
  let(:teacher_raw_data) do
    {
      prep_kod: Faker::Config.random,
      prep_fio: Faker::Name.name,
      prep_snils: Faker::Russian.snils,
      edu_year: {
        edu_year_name: '2019 - 2020',
        semester_name: 'I полугодие',
        disc_name: 'Математический анализ',
      }
    }
  end

  let(:teachers_raw_data) { [teacher_raw_data] * 3 }

  before do
    allow_any_instance_of(described_class).to receive(:fetch_relations_data).and_return(teachers_raw_data)
  end

  context "in normal case" do
    it { expect(subject.count).to eq(3) }
    # TODO: Validate schema
    # TODO: Test data mutations
    # TODO: Test failed cases (no connection with 1C, etc.)
  end
end
