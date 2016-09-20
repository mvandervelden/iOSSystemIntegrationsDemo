# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'MVImageViewer' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MVImageViewer
  target 'MVImageViewerTests' do
    inherit! :search_paths
      pod 'Quick', :git => 'https://github.com/Quick/Quick.git', :branch => 'swift-3.0'
      pod 'Nimble', '~> 5.0'

    target 'CucumberishTests' do
      pod 'Cucumberish', :git => 'https://github.com/Ahmed-Ali/Cucumberish.git', :branch => 'develop'
      pod 'KIF', '~> 3.5'
      pod 'Nimble', '~> 5.0'
    end
  end
end
