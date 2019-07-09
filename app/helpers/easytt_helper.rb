module EasyttHelper
    include TimelogHelper

    #---------------------------------------------------------------------------
    class BaseView
        include Redmine::I18n
        include ActionView::Helpers::JavaScriptHelper

        CSS_CALENDAR_CONTAINER = "easytt_calendar"
        CSS_CALENDAR_ROW = "easytt_calendar_row"
        CSS_CALENDAR_COL = "easytt_calendar_col"
        CSS_CALENDAR_HEADER = "easytt_calendar_header"
        CSS_CALENDAR_DAY_HEADER = "easytt_calendar_day_header"
        CSS_CALENDAR_DAY_CONTENT = "easytt_calendar_day_content"
        CSS_CALENDAR_DAY_TODAY = "easytt_calendar_day_today"
        PIXEL_PER_HOUR = 20

        # Construct a new instance
        def initialize(refdate)
            @refdate = refdate
        end

        # Get the view's type
        def type
            return @type
        end


        # Set the data to display
        def set_datas(entries,userid,curent_userid)
            @datas = entries
            @userid = userid
            @curent_userid = curent_userid
        end
        
        # Get the reference date
        def refdate
            return @refdate
        end

        # Get the first date to display
        def startdate
            return @startdate
        end

        # Get the last date to display
        def enddate
            return @enddate
        end
        
        # Get the previous date for this view
        def previous_date
            return @refdate.advance(@navigator => -1)
        end
        
        # Get the next date for this view
        def next_date
            return @refdate.advance(@navigator => +1)
        end

        
        # Get the view's title (month year) to be displayed
        def view_title
            month = month_name(@refdate.month)
            year = @refdate.year
            return "#{month} #{year}"
        end
        
        # Get the calendar HTML's code
        def calendar
            html = \
            "<div class=\"#{CSS_CALENDAR_CONTAINER}\">\n" \
            "#{calendar_header}\n" \
            "#{calendar_content}\n" \
            "</div>\n"
            html.html_safe
        end

    private
        # Get the calendar's header HTML's code
        def calendar_header
            html = \
            "\t<div class=\"#{CSS_CALENDAR_ROW}\">\n" \
            "\t#{calendar_header_days}\n" \
            "\t</div>\n"
            html.html_safe
        end

        # Get the header day HTML's code
        def calendar_header_day(name)
            html = "\t\t<div class=\"#{CSS_CALENDAR_COL} #{CSS_CALENDAR_HEADER}\">#{name}</div>\n"
            html.html_safe
            return html
        end

        # Get the calendar's content
        def calendar_content
            html = ""
            currentdate = @startdate
            while (currentdate <= @enddate)
                html += "\t<div class=\"#{CSS_CALENDAR_ROW}\">\n"
                html += calendar_row(currentdate)
                html += "\t</div>\n"
                currentdate = next_row_date(currentdate)
            end

            html.html_safe
        end

        # Get the HTML's code corresponding to a specific day
        def calendar_day(date)
            is_Edited = 0
            html = \
            "\t\t<div class=\"#{CSS_CALENDAR_COL}"
            if (date == Date.today)
                html += " " + CSS_CALENDAR_DAY_TODAY
            end
            return_url = "?return="+URI.escape("/easytt/index/"+@userid+"/"+@type+"/"+@refdate.strftime("%Y-%m-%d"))
            html += \
            "\">\n" \
            "\t\t\t<div class=\"#{CSS_CALENDAR_DAY_HEADER}\">#{date.strftime("%Y-%m-%d")}</div>\n" \
            "\t\t\t<div class=\"#{CSS_CALENDAR_DAY_CONTENT}\">\n"
            
            total_hours = 0.0
            @datas.each { |entry|
                if (entry.spent_on == date)
                    height = (PIXEL_PER_HOUR * entry.hours).to_s
                    style = "easytt_timeslot_ok"
                    if ((total_hours + entry.hours) > 8.0)
                        style = "easytt_timeslot_error"
                    end
                    total_hours += entry.hours
                    html += "\t\t\t\t<div class=\"easytt_timeslot " + style
                    html += "\" style=\"height: " + height + "px; line-height: " + height + "px;\">"
                    if @userid.to_i == @curent_userid
                    html += "<span class=\"localimage\"><a style=\"top: 0px;float:right;\" href=\"/easytt/delete/"+entry.id.to_s+return_url+"\" data-confirm=\"do you want to destroy this entry ?\"><img style = \"top: 0px; float:right;\" src= \"/images/delete.png\"> </a></span>"
                    html += "<span class=\"localimage\"><a style=\"top: 0px;float:right;\" href=\"#\" onclick='edit("+entry.to_json+")'><img style=\"top: 0px; float:right;\" src=\"/images/edit.png\"> </a></span>"
                    end
                    html += entry.hours.to_s + "h "+ "of" + " " + entry.activity.name + " " + "on" + " " + entry.project.name
                    html += "</div>\n"
                    is_Edited =1
                end
            }
            strTmp =""
            if total_hours < 8 && @userid.to_i == @curent_userid
                strTmp += "<a style = \"bottom: 50px; float:right;\"  class = \"toggle-multiselect\" href=\"#\", onclick = \"created('"+date.strftime("%Y-%m-%d")+"',"+(8-total_hours).to_s+")\"></a>" 
                if (date.on_weekday?)
                    strTmp += "<a style = \"bottom: 50px; float:left;\" href=\"#\", onclick = \"multiple_create()\"><img style=\"top: 0px; float:right;\" src=\"/images/add.png\"> </a></a>"
                end    
            end
            html += "\t\t\t</div>\n" 
            html += strTmp 
            html += "\t\t</div>\n"
            html.html_safe
            return html
        end

        # Get the next row first date
        def next_row_date(date)
            return date.advance(:weeks => +1)
        end

        # Get translated day's name
        def day_name(num)
            l('date.day_names')[num % 7]
        end

        # Get translated month's name
        def month_name(num)
            l('date.month_names')[num]
        end
    end
    #---------------------------------------------------------------------------
    class DayView < BaseView
        # Construct a new instance
        def initialize(refdate)
            super(refdate)
            @type = "day"
            @startdate = refdate
            @enddate = refdate
            @navigator = :days
            @daysperrow = 1 
        end

        # Get the day header row HTML's code
        def calendar_header_days
            html = calendar_header_day(l('date.day_names')[@refdate.cwday % 7])
            html.html_safe
            return html
        end

        # Get the row HTML's code
        def calendar_row(date)
            calendar_day(date)
        end
    end
    #---------------------------------------------------------------------------
    class WeekView < BaseView
        # Construct a new instance
        def initialize(refdate)
            super(refdate)
            @type = "week"
            @startdate = refdate.beginning_of_week
            @enddate = refdate.end_of_week
            @navigator = :weeks
            @daysperrow = 7
        end

        # Get the day header row HTML's code
        def calendar_header_days
            html = ""
            for i in 1..@daysperrow
                html += html = calendar_header_day(l('date.day_names')[i % 7])
            end
            html.html_safe
            return html
        end

        # Get the row HTML's code
        def calendar_row(date)
            html = ""
            for i in 1..@daysperrow
                html += calendar_day(date)
                date = date.advance(:days => +1)
            end
            html.html_safe
        end
    end
    #---------------------------------------------------------------------------
    class MonthView < WeekView
        # Construct a new instance
        def initialize(refdate)
            super(refdate)
            @type = "month"
            @startdate = refdate.beginning_of_month.beginning_of_week
            @enddate = refdate.end_of_month.end_of_week
            @navigator = :months
        end
    end
    #---------------------------------------------------------------------------
    class WorkWeekView < WeekView
        # Construct a new instance
        def initialize(refdate)
            super(refdate)
            @type = "workweek"
            @daysperrow = 5
        end
    end
    #---------------------------------------------------------------------------
    class WorkMonthView < MonthView
        # Construct a new instance
        def initialize(refdate)
            super(refdate)
            @type = "workmonth"
            @daysperrow = 5

            # If the month start with a week-end, skip it instead of adding a
            # whole week from previous month@startdate
            dayn = refdate.beginning_of_month.cwday % 7
            if (dayn == 0 || dayn == 6)
                @startdate = @startdate.advance(:weeks => +1)
            end
        end
    end
end
