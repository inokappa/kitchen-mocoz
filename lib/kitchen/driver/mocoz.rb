# -*- encoding: utf-8 -*-

require 'kitchen'
require 'open-uri'
require 'nokogiri'

module Kitchen

  module Driver

    # Mocoz driver for Kitchen.
    #
    #
    class Mocoz < Kitchen::Driver::SSHBase

      default_config :mocoz_url, nil

      def create(state)
        puts get_recipe
        puts "いただきます"
      end

      def destroy(state)
        puts "ごちそうさまでした"
      end

      def get_recipe
        charset = nil
        html = open(config[:mocoz_url]) do |f|
          charset = f.charset
          f.read
        end
        
        doc = Nokogiri::HTML.parse(html, nil)

        recipes = []
        doc.xpath('//h3').each do |node|
          moco = []
          moco << node.inner_text
          moco << node.css('a').attribute('href').value
          recipes << moco
        end
        
        # recipes = recipes.sample.compact.reject(&:empty?)
        recipe = recipes.sample
        res = recipe[0].to_s.gsub("\n", "") + " | " + config[:mocoz_url].to_s.gsub("index.html","") + recipe[1]
        
        return res
      end

    end
  end
end
