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
        doc.xpath('//*').each do |node|
          unless node.css('h3').inner_text == ""
            recipes << node.css('h3').inner_text
          end
        end
        
        recipes = recipes.sample.split("\n").compact.reject(&:empty?)
        
        if recipes.length > 1
          recipe = recipes.sample
        else
          recipe = recipes[0]
        end

        return recipe
      end

    end
  end
end
