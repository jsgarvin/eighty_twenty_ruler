require 'nokogiri'
require "active_support/core_ext/numeric/time"
require 'http'

Dir.glob(File.expand_path('../../lib/**/*.rb', __FILE__))
   .each { |file| require file }

require_relative '../config/eighty_twenty_ruler.rb'
