require 'uri'
require 'cgi'

class Categorizer
  
  def self.categorize(path)
    if path.start_with?('/search/?q=')
      params = parse_params(path)
      q = params['q'].first
      q = q.gsub('+',' ').strip
      if q =~ /\A[0-9]+\z/      
        'single-upc'
      elsif q =~ /\A[tT][0-9]+/
        'single-tcode'
      else
        'generic-search'
      end
    elsif path.start_with?('/customer-search?search_type=') 
      'customer-search' 
    else
      'unknown'
    end
  end
  
  def self.contains_category?(path)
    params = parse_params(path)
    params.has_key?("category")
  end
  
  def self.contains_page?(path)
    params = parse_params(path)
    params.has_key?("page")
  end

  def self.parse_params(path)
    path = path.gsub(' ','+')
    query = URI.parse(path).query
    CGI.parse(query)
    # search/?q=1&q=2
    # {'q' => ['1','2']}
    # {'q' => ['searchterm']}
  end
end

# h = { "a" => 100, "b" => 200 }
# h.has_key?("a")   #=> true
# h.has_key?("z")   #=> false