#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint custom_camera.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'custom_camera'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter project.'
  s.description      = <<-DESC
A new Flutter project.
                       DESC
  s.homepage         = 'https://github.com/chenyuanyuan23/custom_camera'
  s.license          = { :file => '../LICENSE' }
  s.author           = { '' => '' }
  s.source           = { :path => '.' }
  s.source_files = 'custom_camera/Sources/custom_camera_internal/**/*.{h,m}', 'custom_camera/Sources/custom_camera/**/*.swift'
  s.public_header_files = 'custom_camera/Sources/custom_camera_internal/include/*.h'
  s.resources = ['custom_camera/Sources/custom_camera_internal/Resources/Assets.xcassets']
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
