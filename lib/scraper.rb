require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    students = []
    file = File.read(index_url)
    data = Nokogiri::HTML(file)

    all_students = data.css(".student-card")

    all_students.each do |student|
      students << {
        name: student.css(".card-text-container h4").text,
        location: student.css(".card-text-container p").text,
        profile_url: student.css("a").attribute("href").value
      }
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    file = File.read(profile_url)
    data = Nokogiri::HTML(file)
    #twitter url(optional), linkedin url, github url, blog url, profile quote, and bio
    profile_page = {
      profile_quote: data.css(".vitals-text-container").css(".profile-quote").text,
      bio: data.css(".details-container .bio-content .description-holder p").text
    }
    social_links = data.css(".social-icon-container").css("a")
    social_links.each do |link|
      link_img_icon = link.css("img").attribute("src").value
      link_text = link.attributes["href"].value
      profile_page[:github] = link_text if link_img_icon.include?("github")
      profile_page[:twitter] = link_text if link_img_icon.include?("twitter")
      profile_page[:linkedin] = link_text if link_img_icon.include?("linkedin")
      profile_page[:blog] = link_text if link_img_icon.include?("rss-icon")
    end
    profile_page
  end

end
Scraper.scrape_profile_page('./fixtures/student-site/students/joe-burgess.html')
