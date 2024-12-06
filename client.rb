require 'httparty'

module Github
    class Client
        def initialize(token, repo_url)
            @token = token
            @repo_url = repo_url
        end

        def get(path: nil, page: 1, per_page: 50)
            headers = {
              'Authorization' => "Bearer #{@token}",
              'User-Agent' => 'Github Client'
            }

            response = HTTParty.get("#{@repo_url}#{path}", headers: headers, query: { page: page, per_page: per_page, state: 'closed' })

            if response.success?
                records = JSON.parse(response.body)

                more_records_available = response.headers['Link']&.match(/<(.*)>; rel="next"/)&.captures&.any?
                if more_records_available
                    records += get(path: path, page: page += 1, per_page: per_page)
                end

                records
            else
                raise "Error fetching issues: #{response.code} #{response.message}"
            end
        end
    end

end
