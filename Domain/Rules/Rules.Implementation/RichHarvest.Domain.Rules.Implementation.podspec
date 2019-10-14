#
# Be sure to run `pod lib lint RichHarvest.Domain.Rules.Implementation.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|

  s.name             = 'RichHarvest.Domain.Rules.Implementation'
  s.version          = '0.1.0'
  s.summary          = 'Rich harvest Module'

  s.homepage         = 'https://ima.org.il'

  s.author           = { 'Aleksandr Tcikin' => 'maisl@sunnydaydev.me' }

  s.source           = { :path => '../' }

  s.osx.deployment_target = '10.14'

  s.source_files = 'Sources/Classes/**/*'

  s.resource_bundles = {
    'RichHarvest.Domain.Rules.Implementation' => ['Sources/Assets/**/*']
  }

  s.static_framework = true

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = #'UIKit', 'MapKit'

  # s.dependency 'RealmSwift', '3.12.0'

  s.dependency 'FirebaseCore', '6.3.1'
  s.dependency 'FirebaseDatabase', '6.1.1'

  s.dependency 'RichHarvest.Core.Core'
  s.dependency 'RichHarvest.Domain.Rules.Api'

end