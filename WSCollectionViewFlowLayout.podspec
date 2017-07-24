
Pod::Spec.new do |s|

s.name         = "WSCollectionViewFlowLayout"
s.version      = "0.0.4"
s.summary      = "可替代UICollectionViewFlowLayout的标签流布局.实现了UICollectionViewDelegateFlowLayout协议方法.使用形式和系统Flowlayout相同."
s.description  = <<-DESC
                    * 使用简单,和系统UICollectionViewFlowLayout无缝切换.
                    * 实现了UICollectionViewDelegateFlowLayout协议方法.使用形式和系统Flowlayout相同.
                    * 支持多个section, 不同section标签流布局和固定有规则布局混合
                DESC
s.homepage     = "https://github.com/ONECATYU/WSCollectionViewFlowLayout"
s.license      = { :type => "MIT", :file => "LICENSE" }
s.author             = { "ONECATYU" => "786910875@qq.com" }
s.platform     = :ios
s.source       = { :git => "https://github.com/ONECATYU/WSCollectionViewFlowLayout.git", :tag => s.version.to_s }
s.source_files  = "Lib/**/*.{h,m}"
s.frameworks = "UIKit", "Foundation"
s.requires_arc = true

end
