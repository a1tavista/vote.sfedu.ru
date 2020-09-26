require "rails_helper"

describe OneCApi::FetchStudentPersonalData do
  subject { described_class.new.call(external_id: external_id) }
  let(:external_id) { '0000' }

  context "in normal context" do
    before do
      allow_any_instance_of(described_class).to receive(:fetch_personal_info).and_return(response_for_student)
      allow_any_instance_of(described_class).to receive(:fetch_grade_book_info).and_return(response_for_grade_book)
    end

    let(:response_for_student) do
      {
        fio: Faker::Name.name,
        study_inf: {
          zachetka: Faker::Config.random
        }
      }
    end

    let(:response_for_grade_book) do
      {
        f_obuch: 'Очная',
        ur_podg: '65',
        napr_podg_name: 'test',
        place: {
          faculty_name: grade_book_faculty_name,
          kurs: 'Первый',
          group: 1
        }
      }
    end

    context "when faculty name from student's grade book existed in faculty lists" do
      let(:grade_book_faculty_name) { Faker::Educator.university }
      let!(:existed_faculty) { create(:faculty, name: grade_book_faculty_name) }

      it("returns correct data") { expect(subject).to include(:name => response_for_student[:fio]) }
      it("uses correct faculty") { expect(subject[:study_info].first).to include(:faculty => existed_faculty)}
      it("holds faculty count") { expect{ subject }.not_to change(Faculty, :count) }
    end

    context "when faculty name from student's grade book contained as alias in some existed faculty" do
      let(:grade_book_faculty_name) { Faker::Educator.university }
      let!(:existed_faculty) { create(:faculty, aliases: [grade_book_faculty_name]) }

      it("returns correct data") { expect(subject).to include(:name => response_for_student[:fio]) }
      it("uses correct faculty") { expect(subject[:study_info].first).to include(:faculty => existed_faculty)}
      it("holds faculty count") { expect{ subject }.not_to change(Faculty, :count) }
    end

    context "when faculty name from student's grade book is new for faculty list" do
      let(:grade_book_faculty_name) { Faker::Educator.university }
      let!(:existed_faculty) { create(:faculty) }

      it("returns correct data") { expect(subject).to include(:name => response_for_student[:fio]) }
      it("creates new faculty") { expect{ subject }.to change(Faculty, :count).by(1) }
    end
  end
end
