# Uncomment the next line to define a global platform for your project
platform :osx, '10.14'

target 'Rich Harvest' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Rich Harvest

  pod 'RichHarvest.Core.Core', :path => 'Core/Core'
  pod 'RichHarvest.Core.UI', :path => 'Core/UI'

  pod 'RichHarvest.Domain.Networking.Api', :path => 'Domain/Networking.Api'
  pod 'RichHarvest.Domain.Networking.Implementation', :path => 'Domain/Networking.Implementation'

  pod 'RichHarvest.Domain.Auth.Api', :path => 'Domain/Auth.Api'
  pod 'RichHarvest.Domain.Auth.Implementation', :path => 'Domain/Auth.Implementation'

  pod 'RichHarvest.Domain.Rules.Api', :path => 'Domain/Rules/Rules.Api'
  pod 'RichHarvest.Domain.Rules.Implementation', :path => 'Domain/Rules/Rules.Implementation'

  pod 'RichHarvest.Domain.Harvest.Api', :path => 'Domain/Harvest.Api'
  pod 'RichHarvest.Domain.Harvest.Implementation', :path => 'Domain/Harvest.Implementation'
  pod 'RichHarvest.Feature.Rules', :path => 'Feature/Rules'

  pod 'RichHarvest.Feature.Auth', :path => 'Feature/Auth'

end

target 'Rich Harvest Extension' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Rich Harvest Extension
  #pod 'FirebaseCore', :git => 'https://github.com/firebase/firebase-ios-sdk.git', :branch => 'master'
  #pod 'FirebaseDatabase', :git => 'https://github.com/firebase/firebase-ios-sdk.git', :branch => 'master'

  pod 'RichHarvest.Core.Core', :path => 'Core/Core'
  pod 'RichHarvest.Core.UI', :path => 'Core/UI'

  pod 'RichHarvest.Domain.Networking.Api', :path => 'Domain/Networking.Api'
  pod 'RichHarvest.Domain.Networking.Implementation', :path => 'Domain/Networking.Implementation'

  pod 'RichHarvest.Domain.Auth.Api', :path => 'Domain/Auth.Api'
  pod 'RichHarvest.Domain.Auth.Implementation', :path => 'Domain/Auth.Implementation'

  pod 'RichHarvest.Domain.Harvest.Api', :path => 'Domain/Harvest.Api'
  pod 'RichHarvest.Domain.Harvest.Implementation', :path => 'Domain/Harvest.Implementation'

  pod 'RichHarvest.Domain.Rules.Api', :path => 'Domain/Rules/Rules.Api'
  pod 'RichHarvest.Domain.Rules.Implementation', :path => 'Domain/Rules/Rules.Implementation'

  pod 'RichHarvest.Feature.Auth', :path => 'Feature/Auth'
  pod 'RichHarvest.Feature.Timer', :path => 'Feature/Timer'
  pod 'RichHarvest.Feature.Rules', :path => 'Feature/Rules'

  pod 'RichHarvest.App.SafariExtension', :path => 'App/SafariExtension'

end

#region Swift version

DEFAULT_SWIFT_VERSION = '5.1'
POD_SWIFT_VERSION_MAP = {
    '' => '4.2'
}

post_install do |installer|
  installer.pods_project.targets.each do |target|

    swift_version = POD_SWIFT_VERSION_MAP[target.name] || DEFAULT_SWIFT_VERSION

    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = swift_version
    end

  end
end

#endregion
