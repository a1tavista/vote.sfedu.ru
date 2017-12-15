class TeachersController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!

  def index
    unless current_kind.teachers_loaded?
      redirect_to prepare_teachers_path
    end

    @evaluated = current_kind.evaluated_teachers(Stage.current)
    @available = current_kind.available_teachers(Stage.current)
  end

  def prepare
    teachers = Teacher.all.order(name: :asc)
    @physical_teachers = teachers.where(kind: 1)
    @lang_teachers = teachers.where(kind: 2)
  end

  def choose
    current_kind.drop_teachers_relations!
    if current_kind.teachers_load_required?
      current_kind.load_teachers!
    end

    ActiveRecord::Base.transaction do
      semester = Stage.current.semesters.first
      teachers_params[:lang_teacher_ids].each do |id|
        relation = StudentsTeachersRelation.new(teacher_id: id, semester: semester)
        current_kind.students_teachers_relations << relation
      end

      teachers_params[:physical_teacher_ids].each do |id|
        relation = StudentsTeachersRelation.new(teacher_id: id, semester: semester)
        current_kind.students_teachers_relations << relation
      end
    end

    redirect_to action: :index
  end

  def show
    @questions = Stage.current.questions
  end

  def respond
    answers = answers_param.map do |q, answer|
      question_id = q.split('_')[1]
      {
        question_id: question_id.to_i,
        rate: answer.to_i,
      }
    end
    Teacher.find_by_id(params[:teacher_id]).evaluate_by(current_kind, Stage.current, answers)
    redirect_to action: :index
  end

  private

  def teachers_params
    params.require(:student).permit(lang_teacher_ids: [], physical_teacher_ids: [])
  end

  def answers_param
    params.require(:answers).permit!.to_hash
  end
end
