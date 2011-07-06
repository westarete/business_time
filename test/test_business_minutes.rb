require 'helper'

class TestBusinessMinutes < Test::Unit::TestCase
  context "with a standard Time object" do

    should "move to tomorrow if we add 480 minutes" do
      first = Time.parse("Aug 4 2010, 9:35 am")
      later = 480.business_minutes.after(first)
      expected = Time.parse("Aug 5 2010, 9:35 am")
      assert expected == later
    end
    
    should "move to yesterday if we subtract 480 minutes" do
      first = Time.parse("Aug 4 2010, 9:35 am")
      later = 480.business_minutes.before(first)
      expected = Time.parse("Aug 3 2010, 9:35 am")
      assert expected == later
    end
    
    should "take into account a weekend when adding 60 minutes" do
      friday_afternoon = Time.parse("April 9th, 4:50 pm")
      monday_morning = 60.business_minutes.after(friday_afternoon)
      expected = Time.parse("April 12th 2010, 9:50 am")
      assert expected == monday_morning
    end
    
    should "take into account a weekend when subtracting 60 minutes" do
      monday_morning = Time.parse("April 12th 2010, 9:50 am")
      friday_afternoon = 60.business_minutes.before(monday_morning)
      expected = Time.parse("April 9th 2010, 4:50 pm")
      assert expected == friday_afternoon
    end
    
    should "take into account a holiday" do
      BusinessTime::Config.holidays << Date.parse("July 5th, 2010")
      friday_afternoon = Time.parse("July 2nd 2010, 4:50pm")
      tuesday_morning = 60.business_minutes.after(friday_afternoon)
      expected = Time.parse("July 6th 2010, 9:50 am")
      assert expected == tuesday_morning
    end
    
    should "add minutes in the middle of the workday"  do
      monday_morning = Time.parse("April 12th 2010, 9:50 am")
      later = 30.business_minutes.after(monday_morning)
      expected = Time.parse("April 12th 2010, 10:20 am")
      assert expected == later
    end
    
    should "consider any time on a weekend as equivalent to monday morning" do
      sunday = Time.parse("Sun Apr 25 12:06:56, 2010")
      monday = Time.parse("Mon Apr 26, 09:00:00, 2010")
      assert_equal 1.business_minute.before(monday), 1.business_minute.before(sunday)
    end

  end
end
