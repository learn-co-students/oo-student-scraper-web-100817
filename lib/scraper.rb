require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    data = Nokogiri::HTML(open(index_url))
    x = data.css(".roster-cards-container")
    students = []
    x.css(".student-card a").each do |student|
      name = student.css(".card-text-container > .student-name").text
      location = student.css(".card-text-container > .student-location").text
      profile_url = student.attr('href')
      students << {name: name, location: location, profile_url: profile_url }
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    profile_page = Nokogiri::HTML(open(profile_url))
    student = {}
    links = profile_page.css(".social-icon-container").css("a").map { |e| e.attr("href")}
      links.each do |link|
        if link.include?("twitter")
          student[:twitter] = link
        elsif link.include?("linkedin")
          student[:linkedin] = link
        elsif link.include?("github")
          student[:github] = link
        else
          student[:blog] = link
        end
      end
    student[:profile_quote] = profile_page.css(".profile-quote").text
    student[:bio] = profile_page.css(".bio-block .description-holder p").text

    student
  end

end
