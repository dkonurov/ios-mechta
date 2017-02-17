# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Mechta' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Mechta
  pod 'CoreDataBoilerplate', :git => 'https://github.com/npu3pak/ios-lib-coredata-boilerplate.git'
  pod 'Alamofire', '~> 4.3'
  pod 'SwiftyJSON', '~> 3.1'
  pod 'PagingMenuController', '~>1.4'
  pod 'RESideMenu', '~> 4.0.7'
  pod 'OpenSans'
  pod 'SDWebImage', '~>3.7'
  pod 'SwiftDate', '~> 4.0'
  pod 'YandexMapView', :git => 'https://github.com/npu3pak/ios-yandex-map-view.git'
  
  target 'MechtaTests' do
      inherit! :search_paths
      # Pods for testing
  end
  
  post_install do |installer|
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['SWIFT_VERSION'] = '3.0'
          end
      end
  end

end
