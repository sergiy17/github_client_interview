require_relative './client.rb'
require 'json'
require 'debug'

module Github
    class Processor
        def initialize(client)
            @client = client
        end

        def issues(open: true)
            state = open ? 'open' : 'closed'
            issues = @client.get(path: "/issues?state=#{state}")

            sorted_issues = issues.sort_by do |issue|
                if state == 'closed'
                    issue['closed_at']
                else
                    issue['created_at']
                end
            end.reverse

            sorted_issues.each do |issue|
                if issue['state'] == 'closed'
                    puts "#{issue['title']} - #{issue['state']} - Closed at: #{issue['closed_at']}"
                else
                    puts "#{issue['title']} - #{issue['state']} - Created at: #{issue['created_at']}"
                end
            end
        end
    end
end
# The URL to make API requests for the IBM organization and the jobs repository
# would be 'https://api.github.com/repos/ibm/jobs'.
Github::Processor.new(Github::Client.new(ENV['TOKEN'], ARGV[0])).issues(open: false)
