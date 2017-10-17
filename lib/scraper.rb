require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    index = Nokogiri::HTML(open(index_url))
    student_array = []
    index.css('div.roster-cards-container').each do |card|
      card.css('.student-card a').each do |student|
        student_name = student.css('.student-name').text
        student_location = student.css('.student-location').text
        student_url = "#{student.attr('href')}"
        student_array << {name: student_name, location: student_location, profile_url: student_url }
        #binding.pry
      end
  end
  student_array
end

  def self.scrape_profile_page(profile_url)
    profile = Nokogiri::HTML(open(profile_url))
    profile_hash = {}
    social_links = profile.css('.social-icon-container').children.css('a').map {|link| link.attribute('href').value}
    social_links.each do |link|
      if link.include?("twitter")
        profile_hash[:twitter] = link
      elsif link.include?("github")
        profile_hash[:github] = link
      elsif link.include?("linkedin")
        profile_hash[:linkedin] = link
      else
        profile_hash[:blog] = link
      end
    end
      profile_hash[:profile_quote] = profile.css('.profile-quote').text if profile.css('.profile-quote')
      if profile.css('div.bio-content.content-holder div.description-holder p')
        profile_hash[:bio] = profile.css('div.bio-content.content-holder div.description-holder p').text
  end
    profile_hash
end


end
