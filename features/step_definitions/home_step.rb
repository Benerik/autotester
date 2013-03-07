
Given /^I have more items/ do
  FactoryGirl.create(:item)
  FactoryGirl.create(:item_1)
  FactoryGirl.create(:item_2)
  FactoryGirl.create(:item_3)
  FactoryGirl.create(:item_4)
end
Given /I go to home page/  do
  visit "/home"
end

When /^I press the button "(.*?)"$/ do |button|
  click_button(button)
end

When /^I click the row "(.*?)"$/ do |link|
  find(link).click
  end
When /^I click the div "(.*?)"$/ do |div|
  find(div).click
end
When /^(?:|I )click "([^"]*)" span$/ do |selector|
  element ||= find('span', :text => selector)
  element.click
end
Then /^I select "(.*?)" from "(.*?)"$/ do |option, field|
  page.select option, :from => field
end
And /^I wait for (\d+) seconds?$/ do |n|
  sleep(n.to_i)
end

And /^I fill in "(.*?)" with "(.*?)"$/ do |field, value|
  fill_in(field, :with => value)
end

Then /^I should see "([^"]*)"$/ do |name|
  page.should have_content(name)
end

Then /^I should not see "([^"]*)"$/ do |name|
  page.should_not have_content(name)
end
Then /^I should see "([^"]*)" and should not see "([^"]*)"$/ do |name1,name2|
  page.should have_content(name1)
  page.should_not have_content(name2)
end