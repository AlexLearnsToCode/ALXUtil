#
# Be sure to run `pod lib lint ALXUtil.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ALXUtil'
  s.version          = '0.1.5'
  s.summary          = 'A common utility set easy to use.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/alexlearnstocode/ALXUtil'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'alexlearnstocode' => '229570121@qq.com' }
  s.source           = { :git => 'https://github.com/alexlearnstocode/ALXUtil.git', :tag => s.version.to_s }
  s.social_media_url = 'https://www.jianshu.com/u/fb6f45f5a7f6'

  s.ios.deployment_target = '8.0'
  s.platform = :ios, '8.0'

  s.source_files = 'ALXUtil/Classes/**/*'
  s.subspec 'ALXUtil-UIView' do |ss|
      ss.source_files = 'UIView+ALXUtil.{h,m}'
      ss.public_header_files = 'UIView+ALXUtil.h'
  end
  s.subspec 'ALXUtil-UIImage' do |ss|
      ss.source_files = 'ALXUtil/Classes/UIImage+ALXUtil.{h,m}'
      ss.public_header_files = 'ALXUtil/Classes/UIImage+ALXUtil.h'
  end
  
  # s.resource_bundles = {
  #   'ALXUtil' => ['ALXUtil/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'Foundation', 'CoreGraphics'
  # s.dependency 'AFNetworking', '~> 2.3'
end
