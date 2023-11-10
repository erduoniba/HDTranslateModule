#
# Be sure to run `pod lib lint HDTranslateModule.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HDTranslateModule'
  s.version          = '0.1.0'
  s.summary          = 'iOS多语言解决方案大全：半自动化+特殊场景手动解决项目中的多语言问题'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/erduoniba/HDTranslateModule'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'denglibing' => '328418417@qq.com' }
  s.source           = { :git => 'git@github.com:erduoniba/HDTranslateModule.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.source_files = 'HDTranslateModule/Classes/**/*.{h,m,py}'
  s.public_header_files="HDTranslateModule/Classes**/*.h"
  s.resource = "HDTranslateModule/Assets/*"

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
