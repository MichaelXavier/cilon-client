require 'bundler'
Bundler.require(:default)
require 'uri'

module Cilon
  class Client
    def initialize(url)
      @uri = URI.parse(url)
    end

    def run
      refresh
    end

  private
    def color_status(status)
      case status
        when "new"       then status.blue
        when "building"  then status.yellow
        when "succeeded" then status.green
        when "failed"    then status.red
      end
    end

    def main_menu
      loop do
        begin
          c = ask('[R]efresh, [B]uild, [S]etup, [C]onfig Reload, [Q]uit: ') do |q| 
            q.character = true
            q.echo = true
            q.in = %w[R B S C Q r b s c q]
          end
          case c.upcase
            when 'R' then refresh
            when 'B' then build
            when 'S' then setup
            when 'C' then reload
            when 'Q' then quit
          end
        rescue => e
          warn "Error occurred (#{e.class}): #{e.message}"
        end
      end
    end

    def clear
      print "\e[2J\e[f"
    end

    def prompt_project_num
      num = ask("Which number?", Integer) do |q| 
        q.in = (0...@current.length)
        q.character = true
      end
    end

    def build
      num = prompt_project_num
      RestClient.get((@uri + "/#{@current[num]['name']}/build").to_s)
    end

    def setup
      num = prompt_project_num
      RestClient.get((@uri + "/#{@current[num]['name']}/setup").to_s)
      refresh
    end

    def refresh
      clear
      puts "Refreshing..."
      pull
      clear
      output = table do |t|
        t.headings = ['#', 'Project', 'Last Built', 'Status']
        @current.each_with_index do |data, i| 
          t << [i, data['long_name'], data['last_built'], color_status(data['status'])]
        end
      end
      puts output
      main_menu
    end

    def reload
      RestClient.post(@uri.to_s, {})
      refresh
    end

    def pull
      @current = Yajl::Parser.parse(RestClient.get(@uri.to_s)).collect do |(name, h)|
        h.merge('name' => name)
      end
    end

    def quit
      puts "Goodbye"
      exit(0)
    end
  end
end
