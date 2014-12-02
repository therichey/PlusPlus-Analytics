require "csv"
require './categorizer'

CSV.open("output.csv", "wb") do |csv|
  csv << ["page", "pageviews", "category", "filtered_by_category", "filtered_by_page", "filtered_by_price", "min_price_filter", "max_price_filter"]

  CSV.foreach("data.csv", headers: true) do |row|
    
    if Categorizer.contains_category?(row.fetch("Page"))
      contains_category = '1'
    end
    
    if Categorizer.contains_page?(row.fetch("Page"))
      contains_page = '1'
    end
    
    if Categorizer.contains_price_filter?(row.fetch("Page"))
      contains_price_filter = '1'
    end
    
    csv << [row.fetch("Page"), 
      row.fetch("Pageviews"), 
      Categorizer.categorize(row.fetch("Page")), 
      contains_category,
      contains_page,
      contains_price_filter,
      Categorizer.min_price_filtering(row.fetch("Page")),
      Categorizer.max_price_filtering(row.fetch("Page")) 
    ]
  end
end





# CSV.open("path/to/file.csv", "wb") do |csv|
#   csv << ["row", "of", "CSV", "data"]
#   csv << ["another", "row"]
#   # ...
# end