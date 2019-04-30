Pod::Spec.new do |s|
  s.name             = 'EasyMVVM'
  s.version          = '0.6.2'
  s.summary          = 'EasyMVVM is a framework for MVVM best practices in iOS Projects. '
  s.description      = <<-DESC
  EasyMVVM is a framework for MVVM best practices in iOS Projects. You can use action, event, some UIKit extension bind view and viewModel easiky.
                       DESC

  s.homepage         = 'https://github.com/Meituan-Dianping/EasyMVVM'
  s.license          = { :type => 'Apache License 2.0', :file => 'LICENSE' }
  s.author           = { 'William Zang' => 'chengwei.zang.1985@gmail.com', '姜沂' => 'nero_jy@qq.com', 'Qin Hong' => 'qinhong@face2d.com'}
  s.source           = { :git => 'https://github.com/Meituan-Dianping/EasyMVVM.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'

  s.module_map = 'EasyMVVM/EasyMVVM.modulemap'

  s.source_files = 'EasyMVVM/Classes/**/*'
  s.public_header_files = 'EasyMVVM/Classes/**/*.h'
  s.private_header_files = ['EasyMVVM/Classes/Private/**/*.h']

  s.dependency 'EasyAction', '~> 0.2.0'
end
