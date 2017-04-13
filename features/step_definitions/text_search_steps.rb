require 'rubygems'
require 'watir'
require 'watir-webdriver'

class AmazonSearchPage
	def initialize
		@browser = Watir::Browser.new
		@browser.goto "http://www.amazon.com/"
	end
	
	def return_browser
		@browser
	end

	def search_for_text(search_string)
		@browser.text_field(:id => "twotabsearchtextbox").set(search_string)
		@browser.button(:value => "Go").click
	end
end

class AmazonResultPage
	def initialize(browser)
		@browser = browser
	end
	
	def search_result_text
		@browser.h2(:id => "s-result-count").wait_until_present
		@browser.h2(:id => "s-result-count").text
	end
	
	def number_of_results
		split_string = search_result_text.split(' ')
		total_count = split_string[2]
		total_count.to_i
	end
	
	def close_the_browser
		@browser.close
	end
end

Given(/^the Amazon search page$/) do
  @search_page = AmazonSearchPage.new
end

When(/^I search for a text string "(.*?)"$/) do | search_string |
  @search_string = search_string
  @search_page.search_for_text(@search_string)
end

Then(/^I see search results for that text string/) do
  @search_result_page = AmazonResultPage.new(@search_page.return_browser)
  expect(@search_result_page.search_result_text).to include(@search_string)
  @search_result_page.close_the_browser
end

Given(/^I have searched for a text string "(.*?)"$/) do | search_string_2 |
  @search_page_2 = AmazonSearchPage.new
  @search_string_2 = search_string_2
  @search_page_2.search_for_text(@search_string_2)
end

When(/^I see the search results$/) do
  @search_result_page_2 = AmazonResultPage.new(@search_page_2.return_browser)
  @search_result_text = @search_result_page_2.search_result_text
  expect(@search_result_text).to include(@search_string_2)
end

Then(/^the number of results is a positive integer$/) do
  expect(@search_result_page_2.number_of_results).to be > 0
  @search_result_page_2.close_the_browser
end