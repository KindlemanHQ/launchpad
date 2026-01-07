Date::DATE_FORMATS[:short] = ->(date) { date.strftime("#{date.day.ordinalize} %b %Y") }
Date::DATE_FORMATS[:long] = ->(date) { date.strftime("#{date.day.ordinalize} %B %Y") }
Date::DATE_FORMATS[:longer] = ->(date) { date.strftime("%a #{date.day.ordinalize} %B %Y") }
Date::DATE_FORMATS[:full] = ->(date) { date.strftime("%A #{date.day.ordinalize} %B %Y") }

Time::DATE_FORMATS[:short] = ->(date) { date.strftime("%H:%M #{date.day.ordinalize} %b %Y") }
Time::DATE_FORMATS[:long] = ->(date) { date.strftime("%H:%M #{date.day.ordinalize} %B %Y") }
Time::DATE_FORMATS[:longer] = ->(date) { date.strftime("%H:%M %a #{date.day.ordinalize} %B %Y") }
Time::DATE_FORMATS[:full] = ->(date) { date.strftime("%H:%M %A #{date.day.ordinalize} %B %Y") }

Time::DATE_FORMATS[:short_civillian] = ->(date) { date.strftime("%l:%M%P #{date.day.ordinalize} %b %Y") }
Time::DATE_FORMATS[:long_civillian] = ->(date) { date.strftime("%l:%M%P #{date.day.ordinalize} %B %Y") }
Time::DATE_FORMATS[:longer_civillian] = ->(date) { date.strftime("%l:%M%P %a #{date.day.ordinalize} %B %Y") }
Time::DATE_FORMATS[:full_civillian] = ->(date) { date.strftime("%l:%M%P %A #{date.day.ordinalize} %B %Y") }

