require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = File.read(index_url)
    doc = Nokogiri::HTML(html)

    students = Array.new

    doc.css("div.student-card").each do |student|
      student_array = Hash.new
      student_array[:name] = student.css("h4.student-name").text
      student_array[:location] = student.css("p.student-location").text
      student_array[:profile_url] = student.css("a").attribute("href").value
      students << student_array
    end

    students
  end

  def self.scrape_profile_page(profile_url)
    html = File.read(profile_url)
    doc = Nokogiri::HTML(html)

    student = Hash.new

    student[:profile_quote] = doc.css("div .profile-quote").text
    student[:bio] = doc.css("div.description-holder p").text

    doc.css("div.social-icon-container a").each do |social_link|
      if social_link.attribute("href").value.include?("twitter")
        student[:twitter] = social_link.attribute("href").value
      elsif social_link.attribute("href").value.include?("facebook")
        student[:facebook] = social_link.attribute("href").value
      elsif social_link.attribute("href").value.include?("linkedin")
        student[:linkedin] = social_link.attribute("href").value
      elsif social_link.attribute("href").value.include?("github")
        student[:github] = social_link.attribute("href").value
      else
        student[:blog] = social_link.attribute("href").value
      end
    end

    student
  end

end
