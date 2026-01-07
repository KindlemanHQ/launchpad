Rails.application.config.to_prepare do
  # Ensure "Pages" is only added once
  # unless HoustonCms::Engine.config.sidebar_content_items.any? { |item| item[:name] == "Pages" }
  #   HoustonCms::Engine.config.sidebar_content_items << {
  #     name: "Pages",
  #     icon: "bi-link-45deg",
  #     path: "/admin/pages"
  #   }
  # end

  # Ensure "Media" is only added once
end