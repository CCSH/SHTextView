Pod::Spec.new do |s|

    s.name         = "SHTextView"
    s.version      = "1.0.0"
    s.summary      = "文本局部点击,定制文本输入框"
    s.homepage     = "https://github.com/CCSH/SHTextView"
    s.source       = { :git => "https://github.com/CCSH/SHTextView.git", :tag => s.version }
    s.source_files = "SHTextView/*.{h,m}"

    s.requires_arc = true
    s.license      = "MIT"
    s.authors      = { "CSH" => "624089195@qq.com" }
    s.platform     = :ios, "7.0"

end
