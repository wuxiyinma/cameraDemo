

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

s.preserve_paths = "cameraDemo/lib/specInfo.h"

s.vendored_libraries = "cameraDemo/lib/libspecInfo.a"

s.frameworks = 'Foundation', 'UIKit'

s.dependency 'AFNetworking', '~> 3.0'

s.dependency 'Masonry'

s.dependency 'SDWebImage', '~> 4.0'

s.dependency 'YYModel'

s.dependency 'LLSimpleCamera', '~> 4.1'

s.dependency 'MBProgressHUD', '~> 1.1.0'

end
