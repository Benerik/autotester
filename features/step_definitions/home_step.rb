Given /I go to home page/  do
  visit "/home"
end

When /^I press the button "(.*?)"$/ do |button|
  click_button(button)
end

And /^I wait for (\d+) seconds?$/ do |n|
  sleep(n.to_i)
end