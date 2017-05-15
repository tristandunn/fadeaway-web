["Designer News", "Dribbble", "Notification", "Product Hunt"].each do |name|
  Discount.find_or_create_by!(name: name) do |discount|
    discount.amount = 500
  end
end

Release.find_or_create_by!(version: "0.1.0") do |release|
  release.description = "Initial release."
  release.released_at = Time.zone.now
end
