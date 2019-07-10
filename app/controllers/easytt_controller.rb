#require 'date'

class EasyttController < ApplicationController
  include EasyttHelper

  # Constants
  DEFAULT_REFDATE = Date.today
  DEFAULT_REFINDEX = 0
  DEFAULT_VIEWTYPE = "week"
  # Response to route '/easytt/index/...'
  def index
    @userid = User.current.id
    if (params.has_key?(:userid))
      @userid = params[:userid]
    end

    @view = get_view

    # Give data to the view
    if (@view.is_a? BaseView)
      @view.set_datas(@entries = TimeEntry.where("user_id = ? AND spent_on >= ? AND spent_on <= ?", @userid, @view.startdate, @view.enddate).all,@userid,User.current.id)
    end
    @time_entry ||= TimeEntry.new(:project => @project, :issue => @issue, :user => User.current, :spent_on => User.current.today)
    @time_entry.safe_attributes = params[:time_entry]
    @users ||= User.new
  end

  ### Responce to route '/easytt/delete/id/'
  def delete 
    @time_entry= TimeEntry.find(params[:id])
    if @time_entry.destroy
      flash[:notice] = l(:notice_successful_delete)
    else
      flash[:error] = l(:notice_unable_delete_time_entry)
    end
    redirect_to params[:return]
  end 

  def other_user
   @user  = User.find(params[:user][:id])

  end

  ### Responce to route '/easytt/create'
  def create
    @time_entry = TimeEntry.new(:project => @project, :issue => @issue, :user => User.current, :spent_on => User.current.today)
    @time_entry.safe_attributes = params[:time_entry]
    @time_entry.spent_on = @time_entry.spent_on
    @time_entry.save
    if (@time_entry.save)
      flash[:notice] = l(:notice_successful_create)
    else
      flash[:error] = l(:notice_unable_create_time_entry)
    end
    redirect_to "/easytt/index/"+params[:userid]+"/"+params[:viewtype]+"/"+params[:refdate]
  end

  ### Responce to route '/easytt/multiple_create'
  def multiple_create
    i = 0.day;
    selec = params[:select_repetition].to_s
    d2 = Date.parse(params[:time_entry][:spent_on])
    d1 = Date.parse(params[:date_end])
    if (params[:date_end] != nil)
      if ((d2.month == d1.month && selec == "daily") || ( (d2.month <= d1.month + 3) && selec == "weekly") || ( (d2.month <= d1.month + 3) && selec == "biweekly"))
        while d2 <= d1  do
          puts d2
          if(!d2.on_weekend?)
            @time_entry = TimeEntry.new(:project => @project, :issue => @issue, :user => User.current, :spent_on => User.current.today)
            @time_entry.safe_attributes = params[:time_entry]
            @time_entry.spent_on = d2
            @time_entry.save
            if (@time_entry.save)
              flash[:notice] = l(:notice_successful_create)
            else
              flash[:error] = l(:notice_unable_create_time_entry)
            end
          end
          if (selec == "daily")
            d2 = d2.next_day()
          else
            if(selec == "weekly")
              d2 = d2.next_week()
            else
              if(selec == "biweekly")
                d2 = d2 + 2.week
              end
            end
          end  
        end
      end
    end
  redirect_to "/easytt/index/"+params[:userid]+"/"+params[:viewtype]+"/"+params[:refdate]
  end

  ### Responce to route '/easytt/edit/id/'
  def edit
    @time_entry =TimeEntry.find(params[:id])
    @time_entry.safe_attributes = params[:time_entry]
    if @time_entry.save
      respond_to do |format|
        format.html {
          flash[:notice] = l(:notice_successful_update)
        }
        format.api  { render_api_ok }
      end
    end
    redirect_to "/easytt/index/"+params[:userid]+"/"+params[:viewtype]+"/"+params[:refdate]
  end

  def update
    @time_entry.safe_attributes = params[:time_entry]

    call_hook(:controller_timelog_edit_before_save, { :params => params, :time_entry => @time_entry })

    if @time_entry.save
      respond_to do |format|
        format.html {
          flash[:notice] = l(:notice_successful_update)
          redirect_back_or_default project_time_entries_path(@time_entry.project)
        }
        format.api  { render_api_ok }
      end
    else
      respond_to do |format|
        format.html { render :action => 'edit' }
        format.api  { render_validation_errors(@time_entry) }
      end
    end
  end

private
  # Get the reference date from the URL if any
  # If no valid date is given, use today.
  def get_refdate
    return Date.strptime(params[:refdate])
  rescue
    params[:refdate] = DEFAULT_REFDATE
    return DEFAULT_REFDATE
  end

  # Get a view object corresponding to the viewtype and refdate.
  def get_view
    # If not viewtype is given, use the default view.
    viewtype = DEFAULT_VIEWTYPE
    if (params.has_key?(:viewtype))
      viewtype = params[:viewtype]
    end

    # Get the reference date
    refdate = get_refdate

    # Build the correct view object
    case params[:viewtype]
    when "day"
      return DayView.new(refdate)
    when "week"
      return WeekView.new(refdate)
    when "workweek"
      return WorkWeekView.new(refdate)
    when "month"
      return MonthView.new(refdate)
    when "workmonth"
      return WorkMonthView.new(refdate)
    else
      redirect_to action: "index", userid: @userid,viewtype: viewtype, refdate: refdate
    end
  end
end
