Pod::Spec.new do |s|

  s.name         = "SDForms"
  s.version      = "0.9.1"
  s.summary      = "iOS"
  s.description  = <<-DESC
                   SDForms is an open source iOS forms library that allows to create dynamic UITableView-based forms. It offers different types of fields like text fields, picker fields, date picker fields, switch fields, slider fields etc. It also enables to automatically map fields' values to object properties.
                   DESC
  s.homepage     = "https://github.com/SnowdogApps/SDForms"
  s.social_media_url = 'https://twitter.com/SnowdogApps'
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Rafał Kwiatkowski" => "rafal@snowdog.pl" }
  s.platform     = :ios, "7.1"
  s.source       = { :git => "https://github.com/SnowdogApps/SDForms.git", :tag => "0.9.2" }
  s.source_files  = "SDForms/**/*.{h,m}"
  s.resource_bundles = {
    'SDFormsResources' => ['SDForms/**/*.xib'],
  }
  s.requires_arc = true

end
