# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'PVTG' do

  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for PVTG

  pod 'Alamofire'
  pod 'SwiftyJSON'
  pod 'IQKeyboardManagerSwift'
  pod 'SDWebImage'
  pod 'ReachabilitySwift'
  pod 'SVProgressHUD'
  pod 'AMShimmer'
  pod 'Firebase/Messaging'
  pod 'Cosmos', '~> 22.1'
  pod "Firebase/Auth", "= 8.10.0"
#  pod 'Firebase/Auth'
  pod 'FSCalendar'
  pod 'SVPinView', '~> 1.0'
  pod 'GoogleMaps'
  pod 'GooglePlaces'
  pod 'GoogleSignIn', '~> 5.0'
#  pod 'GoogleSignIn'
  pod 'FBSDKLoginKit'
  pod 'paper-onboarding'
  pod 'MarqueeLabel'
  pod 'R.swift'
  pod 'RangeSeekSlider'
  pod 'Stripe', '~> 15.0.1'
#  pod 'R.swift'
  
  post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    end
    end


end



