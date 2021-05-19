Pod::Spec.new do |s|
  s.name             = "SZAutogrowTextView"
  s.version          = "0.1.2"
  s.summary          = "Yet another autogrow UITextView subclass."

  s.homepage         = "https://github.com/Sega-Zero/SZAutogrowTextView"
  s.license          = 'MIT'
  s.author           = { "Сергей Галездинов" => "segazero@gmail.com" }
  s.source           = { :git => "https://github.com/Sega-Zero/SZAutogrowTextView.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/SegaZero'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
end
