class CoursesController < ApplicationController
  def show
    @course = Course.find(params[:code])
  end

  def new; end

  def create
    @course = Course.create(course_params)
    render :show
  end

  private

  def course_params
    params.permit(:name, :description, :enrollment_deadline, :code, :price, :instructor_id).to_h
  end
end
