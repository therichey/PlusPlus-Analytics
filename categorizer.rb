require 'uri'
require 'cgi'

class Categorizer
  
  def self.categorize(path)
    # Define the product categories
    if path.start_with?('/search/?q=')
      terms = get_terms_from_path(path)
      
      if terms.length == 1 && is_a_upc?(terms.first)      
        'single-upc'
      elsif terms.length == 1 && is_a_tcode?(terms.first) 
        'single-tcode'
      elsif terms.length == 0
        'blank-search'
      elsif terms.all? { |term| is_a_upc?(term) || is_a_tcode?(term) }
        'multi-code'
      elsif terms.none? { |term| is_a_upc?(term) || is_a_tcode?(term) }
        'generic-search'
      else 
        'generic-and-code'
      end
    # Define the customer search categories  
    elsif path.start_with?('/customer-search?search_type=') 
      if path.include? "search_type=phoneNumber"
        'phone-number'
      elsif path.include? "search_type=email"
        'email'
      elsif path.include? "search_type=firstName_lastName"
        'firstname-lastname'
      elsif path.include? "search_type=lastName_postcode"
        'lastname-postcode'
      elsif path.include? "search_type=orderNumber"
        'ordernumber'
      else
        'customer-search'
      end
    else
      'unclassified'
    end
  end
  
  def self.is_a_upc?(string)
    string =~ /\A[0-9]{3,}\z/
  end
  
  def self.is_a_tcode?(string)
    string =~ /\A[tT][0-9]{3,}/
  end
  
  def self.contains_category?(path)
    params = parse_product_search_params(path)
    params.has_key?("category")
  end
  
  def self.contains_page?(path)
    params = parse_product_search_params(path)
    params.has_key?("page")
  end

  def self.parse_product_search_params(path)
    path = path.gsub(' ','+')
    query = path.gsub('/search/?','')
    CGI.parse(query)
    # search/?q=1&q=2
    # {'q' => ['1','2']}
    # {'q' => ['searchterm']}
  end
  
  def self.get_terms_from_path(path)
    params = parse_product_search_params(path)
    q = params['q'].first
    q.gsub('+',' ').strip.split
  end
  
end

# h = { "a" => 100, "b" => 200 }
# h.has_key?("a")   #=> true
# h.has_key?("z")   #=> false