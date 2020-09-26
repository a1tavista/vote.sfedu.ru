require "rails_helper"

describe Faculties::AsAdmin::MergeDuplicatedFacultyToAnotherFaculty do
  subject { described_class.new.call(faculty: master_faculty, duplicated_faculty: duplicated_faculty) }

  let!(:master_faculty) { create(:faculty) }
  let!(:duplicated_faculty) { create(:faculty) }
  let!(:students) { create_list(:student, 3, :with_grade_book, faculty_id: duplicated_faculty.id) }
  let!(:polls) { create_list(:poll, 3, faculty_ids: [duplicated_faculty.id]) }

  context "with valid params" do
    it("returns success") { expect(subject).to be_success }
    it("changes faculty for students") do
      expect { subject }.to change { students.map(&:reload).map(&:faculty_ids).flatten }
                              .from([duplicated_faculty.id] * 3).to([master_faculty.id] * 3)
    end

    it("changes faculties-participants in poll") do
      expect { subject }.to change { polls.map(&:reload).map(&:faculty_ids).flatten }
                              .from([duplicated_faculty.id] * 3).to([master_faculty.id] * 3)
    end

    it("adds alias to master faculty") do
      expect { subject }.to change { master_faculty.aliases }.from([]).to([duplicated_faculty.name])
    end

    it("destroys duplicated faculty") do
      expect { subject }.to change(Faculty, :count).by(-1)
    end
  end
end
