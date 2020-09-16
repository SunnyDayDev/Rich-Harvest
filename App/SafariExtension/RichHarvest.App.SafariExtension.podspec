#
# Be sure to run `pod lib lint RichHarvest.App.SafariExtension.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|

  s.name             = 'RichHarvest.App.SafariExtension'
  s.version          = '0.1.0'
  s.summary          = 'Rich harvest Module'

  s.homepage         = 'https://ima.org.il'

  s.author           = { 'Aleksandr Tcikin' => 'mail@sunnydaydev.me' }

  s.source           = { :path => '../' }

  s.osx.deployment_target = '10.15'

  s.source_files = 'Sources/Classes/**/*'

  s.resource_bundles = {
    'RichHarvest.App.SafariExtension' => ['Sources/Assets/**/*']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = #'UIKit', 'MapKit'

  s.dependency 'RichHarvest.Core.Core'

  s.dependency 'RichHarvest.Feature.Auth'
  s.dependency 'RichHarvest.Feature.Timer'
  s.dependency 'RichHarvest.Feature.Rules'

end
