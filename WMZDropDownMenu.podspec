Pod::Spec.new do |s|

  s.name         = "WMZDropDownMenu"
  s.version      = "1.1.3"
  s.platform     = :ios, "8.0"
  s.requires_arc = true
  s.frameworks   = 'UIKit'
  s.license      = { :type => 'MIT' }
  s.summary      = "🌹一个能几乎实现所有筛选菜单的控件,闲鱼/美团/Boss直聘/京东/饿了么/淘宝/拼多多/赶集网等等。。。可以自由调用代理实现自己想组装的筛选功能和UI🌹"
  s.description  = <<-DESC 
                   🌹一个能几乎实现所有筛选菜单的控件,闲鱼/美团/Boss直聘/京东/饿了么/淘宝/拼多多/赶集网等等。。。可以自由调用代理实现自己想组装的筛选功能和UI🌹
                   注：Building Settings设置CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF为NO可以消除链  式编程的警告
                   DESC
  s.homepage     = "https://github.com/wwmz/WMZDropDownMenu"
  s.author       = { "wmz" => "925457662@qq.com" }
  s.source       = { :git => "https://github.com/wwmz/WMZDropDownMenu.git", :tag => s.version.to_s }
  s.source_files = "WMZDropDownMenu/WMZDropDownMenu/**/*.{h,m}"
  s.resources     = "WMZDropDownMenu/WMZDropDownMenu/WMZDropMenu.bundle"
end

