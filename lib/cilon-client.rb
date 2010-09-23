module CIlon
  class Client
    def initialize(uri)
      @uri = uri
    end

    def print_summary
      obj = pull
      obj.each do |shortname, data| 
        puts "#{(data['long_name'] || shortname).yellow} (#{data['last_built']}): [#{color_status(data['status'])}]"
      end
    end

  private

    def clear
      print "\e[2J\e[f"
    end

    def color_status(status)
      case status
        when "new"       then status.blue
        when "building"  then status.orange
        when "succeeded" then status.green
        when "failed"    then status.red
      end
    end

    def pull
      Yajl::Parser.parse(RestClient.get(@uri.to_s))
    end
  end
end
