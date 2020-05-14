require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    index_page = Nokogiri::HTML(open(index_url))
    students = []

    index_page.css("div.roster-cards-container").each do |card|
      card.css(".student-card a").each do |student|
        student_profile_link = "#{student.attr('href')}"
        student_location = student.css('.student-location').text
        student_name = student.css('.student-name').text
        students << {name: student_name, location: student_location, profile_url: student_profile_link}
      end
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    profile_page =  Nokogiri::HTML(open(profile_url))
    student = {}

    profile_page.css("div.social-icon-container a").each do |a|
      link = a.attribute("href").text
      if link.include?("github")
        student[:github] = link
      elsif link.include?("linkedin")
        student[:linkedin] = link
      elsif link.include?("twitter")
        student[:twitter] = link
      else
        student[:blog] = link
      end
    end
    student[:profile_quote] = profile_page.css("div.profile-quote").text
    student[:bio] = profile_page.css("div.description-holder p").text
    student
  end

end

