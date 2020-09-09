

Pod::Spec.new do |s|

s.name         = "TakePhotoSDK"
s.version      = "0.0.1"
s.summary      = "拍照SDK～"

s.description  = <<-DESC
拍照SDK～
DESC

s.homepage     = "https://git.coding.net/smallLufei/cameraDemo.git"

s.license      = "MIT"

s.author       = { "lufei" => "small@small.com" }

s.platform     = :ios, "8.0"

s.resource  = "cameraDemo/TakePhotoSDK/Image.bundle"

s.source       = { :git => "https://git.coding.net/smallLufei/cameraDemo.git", :tag => "#{s.version}" }

s.source_files  = "TakePhotoSDK","cameraDemo/TakePhotoSDK/*.*"


s.preserve_paths = "cameraDemo/lib/*.h"
s.vendored_libraries = "cameraDemo/lib/libspecInfo.a"

s.xcconfig = { 'HEADER_SEARCH_PATHS' => "${PODS_ROOT}/#{s.name}/cameraDemo/lib/**" }

s.frameworks = 'Foundation', 'UIKit', 'Security'

s.dependency 'AFNetworking'

s.dependency 'Masonry'

s.dependency 'SDWebImage'

s.dependency 'LLSimpleCamera'

s.dependency 'MBProgressHUD'

end
