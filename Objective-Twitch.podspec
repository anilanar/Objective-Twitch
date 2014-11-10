#
# Be sure to run `pod lib lint Objective-Twitch.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Objective-Twitch"
  s.version          = "0.1.0"
  s.summary          = "Objective C library to make TwitchAPI calls."
  s.description      = <<-DESC
                       Objective C library to make TwitchAPI calls.

                       * Followers.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/anilanar/Objective-Twitch"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Anil Anar" => "anilanar@hotmail.com" }
  s.source           = { :git => "https://github.com/anilanar/Objective-Twitch.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :osx, '10.10'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resource_bundles = {
    'Objective-Twitch' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
