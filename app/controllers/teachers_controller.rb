class TeachersController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!

  def index
    current_user.kind.load_teachers! if current_user.kind.teachers_load_required?
    @evaluated = current_user.kind.evaluated_teachers(Stage.current)
    @available = current_user.kind.available_teachers(Stage.current)
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
    Teacher.find(params[:teacher_id]).evaluate_by(current_user.kind, Stage.current, answers)
    redirect_to(teachers_path)
  end

  private

  def answers_param
    params.require(:answers).permit!.to_hash
  end
end
