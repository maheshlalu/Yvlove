# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'NowFloats' do
    # Comment this line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!
    
    # Pods for NowFloats
    pod 'MagicalRecord/Shorthand'
    pod 'Alamofire', '~> 4.0'
    pod 'SDWebImage', '~> 3.8'
    pod 'SKPhotoBrowser', :git => 'https://github.com/suzuki-0000/SKPhotoBrowser.git', :branch => 'swift3'
    pod 'AFNetworking', '~> 3.1'
    pod 'XLForm', '~> 3.2'

    pod 'Fabric'
    pod 'Crashlytics'
    
    target 'NowFloatsTests' do
        inherit! :search_paths
        # Pods for testing
    end
    
    target 'NowFloatsUITests' do
        inherit! :search_paths
        # Pods for testing
    end
    
    
    target 'MyLabs' do
        inherit! :search_paths
        # Pods for testing
        pod 'MagicalRecord/Shorthand'
        pod 'Alamofire', '~> 4.0'
        pod 'SDWebImage', '~> 3.8'
        pod 'SKPhotoBrowser', :git => 'https://github.com/suzuki-0000/SKPhotoBrowser.git', :branch => 'swift3'
        pod 'AFNetworking', '~> 3.1'
        pod 'XLForm', '~> 3.2'
        
        pod 'Fabric'
        pod 'Crashlytics'
        
        pod 'FacebookCore'
        pod 'FacebookLogin'

    end
    
    
    post_install do |installer|
        installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.0'
            end
        end
    end
end
