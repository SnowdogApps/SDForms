Pod::Spec.new do |s|

  s.name         = "SDForms"
  s.version      = "0.9.3"
  s.summary      = "iOS"
  s.description  = <<-DESC
                   SDForms is an Objective-C library for creating UITableView-based forms.
                   DESC
  s.homepage     = "https://github.com/SnowdogApps/SDForms"
  s.social_media_url = 'https://twitter.com/SnowdogApps'
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Rafał Kwiatkowski" => "rafal@snowdog.pl" }
  s.platform     = :ios, "7.1"
  s.source       = { :git => "https://github.com/SnowdogApps/SDForms.git", :tag => "0.9.3" }
  s.source_files  = "SDForms/**/*.{h,m}"
  s.resource_bundles = {
    'SDFormsResources' => ['SDForms/**/*.xib'],
  }
  s.requires_arc = true

end
