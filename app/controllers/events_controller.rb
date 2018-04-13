class EventsController < ApplicationController

  before_action :set_current_user
  before_action :set_event, only: [:show, :join, :leave, :comment, :destroy, :edit, :update]
  before_action :verify_user_for_editing, only: [:edit, :update]

  def index
  end

  def show
    @attendees = @event.attendees.includes(:location)
    @comments = @event.comments.includes(:user)
  end

  def edit
  end

  def create
    @loc = Location.find_or_create_by(loc_params)
    @event = Event.new(event_params)
    @event.location = @loc
    @event.user = @user
    @event.attendees = [@user]
    unless @event.save
      flash[:error] = @event.errors.full_messages
    end
    redirect_to "/events"
  end

  def update
    @loc = Location.find_or_create_by(loc_params)
    @event.update(event_params)
    @event.update(location: @loc)
    redirect_to "/events/#{@event.id}"
  end

  def destroy
    redirect_to "/events/#{@event.id}" unless @event.user == @user
    @event.destroy
    redirect_to "/events"
  end

  def comment
    @comment = Comment.new(comment: params[:comment][:comment])
    @comment.user = @user
    @comment.event = @event
    unless @comment.save
      flash[:error] = @comment.errors.full_messages
    end
    redirect_to "/events/#{@event.id}"
  end

  def join
    @event.attendees += [@user]
    redirect_to "/events"
  end

  def leave
    if @event.attendees.exists?(@user.id)
      @event.attendees.delete(@user)
    end
    redirect_to "/events"
  end

  private
  def set_current_user
    @user = User.find(session[:user_id]) if session.include?(:user_id)
    # @in_state_events = Location.where(@user.location.state).events
    @in_state_events = Event.joins(:location, :user).where(locations: {state: @user.location.state}).order(:date)
    @out_of_state_events = Event.joins(:location, :user).where.not(locations: {state: @user.location.state}).order(:date)
    redirect_to "/" unless @user
  end
  def set_event
    @event = Event.includes(:location).find(params[:id])
    redirect_to "/events" unless @event
  end
  def event_params
    params.require(:event).permit(:name, :date)
  end
  def loc_params
    params.require(:event).require(:location).permit(:city, :state)
  end
  def verify_user_for_editing
    redirect_to "/events" unless @event.user == @user
  end
end
