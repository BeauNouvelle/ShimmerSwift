#
#  Be sure to run `pod spec lint ShimmerSwift.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "ShimmerSwift"
  s.version      = "2.1.1"
  s.summary      = "A swift implementation of Facebooks shimmer effect."
  s.platform     = :ios, "9.0"

  s.homepage     = "https://github.com/BeauNouvelle/ShimmerSwift"

  s.license      = { :type => "Unlicense", :file => "LICENSE" }

  s.author    = "Beau Nouvelle"
  s.social_media_url   = "http://twitter.com/BeauNouvelle"


  s.source       = { :git => "https://github.com/BeauNouvelle/ShimmerSwift.git", :tag => "#{s.version}" }

  s.source_files  = "Classes", "Shimmer/*.{swift}"
  s.exclude_files = "Classes/Exclude"

  s.swift_version = "5.1"

end
