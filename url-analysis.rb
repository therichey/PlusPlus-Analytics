require "csv"

CSV.foreach("data.csv", headers: true) do |row|
  puts row.fetch("Page")
end
