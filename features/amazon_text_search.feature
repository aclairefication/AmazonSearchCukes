Feature: Search Amazon.com for text string

	In order to see search results on Amazon.com
	As a user (prospective buyer)
	I want to search for a text string
	
	Scenario: text search
		Given the Amazon search page
		When I search for a text string "qa testing"
		Then I see search results for that text string
		
	Scenario: search results count
		Given I have searched for a text string "qa testing"
		When I see the search results
		Then the number of results is a positive integer