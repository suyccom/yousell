# encoding: utf-8

def login
  visit '/dev/set_current_user?login=tecnicos%40unoycero.com'
  visit '/'
end

def manual_login
  create_admin
  visit '/login'
  fill_in 'login', :with => 'tecnicos@unoycero.com'
  fill_in 'password', :with => 'RobotRobot'
  click_button 'Login'
  page.should have_content 'You have logged in'
end
