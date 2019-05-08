class Student::TeachersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    unless current_kind.teachers_loaded?
      redirect_to prepare_student_teachers_path
    end

    @evaluated = current_kind.evaluated_teachers(Stage.current)
    @available = current_kind.available_teachers(Stage.current)
  end

  def refresh
    interaction = Teachers::AsStudent::ResetTeachersList.run(student: current_kind)
    redirect_to action: :index
  end

  def prepare
    teachers = Teacher.all.order(name: :asc)
    @physical_teachers = teachers.where(kind: :physical_education)
    @lang_teachers = teachers.where(kind: :foreign_language)
  end

  def choose
    interaction = Teachers::AsStudent::ChooseCustomTeachers.run(
      student: current_kind,
      lang_teacher_ids: teachers_params[:lang_teacher_ids].to_a,
      physical_teacher_ids: teachers_params[:physical_teacher_ids].to_a
    )

    redirect_to action: :index
  end

  def show
    @questions = Stage.current.questions
  end

  def respond
    Teachers::AsStudent::Evaluate.run(
      teacher: Teacher.find_by_id(params[:teacher_id]),
      student: current_kind,
      stage: Stage.current,
      answers: answers_param.map do |question, answer|
        { question_id: question.split('_')[1].to_i, rate: answer.to_i }
      end.to_a
    )

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
