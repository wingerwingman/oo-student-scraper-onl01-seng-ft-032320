require 'open-uri'
require 'pry'

class Scraper
  attr_accessor

  def self.scrape_index_page(index_url)
    @students = []
    index = Nokogiri::HTML(open(index_url))
    index.css("div.student-card").each do |student|
      student_details = {}
      student_details[:name] = student.css("h4.student-name").text
      student_details[:location] = student.css("p.student-location").text
      profile_path = student.css("a").attribute("href").value
      # student_details[:profile_url].include? "./fixtures/student-site/"
      student_details[:profile_url] = profile_path

      @students << student_details
    end
      # binding.pry
    @students
  end

  def self.scrape_profile_page(profile_url)
    @student_items = {}
    
    page = Nokogiri::HTML(open(profile_url))
    container = page.css(".social-icon-container a").collect{|icon| icon.attribute('href').value}
    container.each do |items|
      if items.include?("twitter")
        @student_items[:twitter] = items
      elsif items.include?("linkedin")
        @student_items[:linkedin] = items
      elsif items.include?("github")
        @student_items[:github] = items
      elsif items.include?(".com")
        @student_items[:blog] = items
      end
    end
    @student_items[:profile_quote] = page.css("div.profile-quote").text
    @student_items[:bio] = page.css("div.description-holder p").text
    @student_items
    # binding.pry
  end

end

