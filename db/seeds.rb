require 'net/http'
require 'openssl'
require 'json'
require 'nokogiri'
require 'open-uri'

puts 'Cleaning database...'
Video.destroy_all

def scrap(url)
  import_list = []
  puts "\nSearching #{url}..."
  doc = Nokogiri::HTML(open(url), nil, 'utf-8')
  # scrapping movie title
  titles = doc.xpath("//div[@class='original-title']")
  # import title into import list in the format of an array of array
  titles.each_with_index { |title, index| import_list[index] = [title.text] }
  return import_list
end

puts 'Scrapping netflix...'

import = scrap("https://www.netflix.com/jp-en/originals")

final = [] #array of result hashes

import.first(5).each do |target|
# import.each do |target|

  # target = "#realityhigh"
  # target = "hitman’s bodyguard"
  # target = "dunkirk"

  encoding_options = {
    :invalid           => :replace,  # Replace invalid byte sequences
    :undef             => :replace,  # Replace anything not defined in ASCII
    :replace           => '',        # Use a blank for those replacements
    :universal_newline => true       # Always break lines with \n
  }

  # encoded_target = target.encode(Encoding.find('ASCII'), encoding_options)
  encoded_target = target[0].encode(Encoding.find('ASCII'), encoding_options)

  input = encoded_target.downcase

  # search the movie database API for both movies and tv shows
  url = URI("https://api.themoviedb.org/3/search/multi?include_adult=false&page=1&query=#{input}&language=en-US&api_key=#{ENV["MOVIEDB_API"]}")

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Get.new(url)
  request.body = "{}"

  response = http.request(request)

  filepath = response.read_body

  output = JSON.parse(filepath)

  # *************************************************************

  puts 'Enquiring from moviedb...'

  matches = [] #array_of_hashes
  i = 0

  # check if output is nil, skip to end if so
  if output["success"] == false

    puts ""

  else

    # iterate through the output json string
    output["results"].each do |result|
    # assign any matching title to the matches array of hashes

      if result["media_type"] == "movie"
        # make sure result is not nil
        unless result["title"] == nil
          # make sure it's exact matching name
          if result["title"].downcase == input

            matches[i] = {title: result["original_title"],
                          media_type: result["media_type"],
                          date: result["release_date"],
                          vote_average: result["vote_average"],
                          popularity: result["popularity"]}
            i += 1

          end
        end

      elsif result["media_type"] == "tv"

        unless result["name"] == nil

          if result["name"].downcase == input

            matches[i] = {title: result["original_name"],
                          media_type: result["media_type"],
                          date: result["first_air_date"],
                          vote_average: result["vote_average"],
                          popularity: result["popularity"]}
            i += 1
          end
        end
      end
    end
    # p matches

    # sort the title matches by popularity in descending order
    sorted = matches.sort_by { |e| e[:popularity] }.reverse
    # get the most popular result which is likely the most relevant one
    p sorted.first

    # push non-empty result hashes into final array
    unless sorted.first == nil
      final << sorted.first
    end
  end
end

puts 'Creating database...'

final.each do |element|

  video = Video.create!(
    title: element[:title],
    media_type: element[:media_type],
    release_date: element[:date],
    popularity: element[:popularity],
    avg_vote: element[:vote_average]
    )
end

puts 'Finished!'
