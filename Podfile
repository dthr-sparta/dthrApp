# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'dthrApp' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for dthrApp
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'SDWebImage/WebP'
  pod 'FirebaseDatabase'
  pod 'SVProgressHUD'
  pod 'TwitterKit'
  pod 'Firebase/Storage'
  pod 'Firebase/Firestore'
  pod 'MessageKit'
    post_install do |installer|
        installer.pods_project.targets.each do |target|
            if target.name == 'MessageKit'
                target.build_configurations.each do |config|
                    config.build_settings['SWIFT_VERSION'] = '4.2'
                end
            end
        end
    end



end
