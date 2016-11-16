Pod::Spec.new do |spec|
  spec.name         = 'MVVM'
  spec.version      = '0.1.1'
  spec.homepage 	= 'https://github.com/markohlebar/BIND'
  spec.license      = { :type => 'MIT' }
  spec.authors      = { 'Marko Hlebar' => 'marko.hlebar@gmail.com' }
  spec.summary      = 'A mini MVVM framework'
  spec.source       = { :git => 'https://github.com/markohlebar/MVVM.git', :tag => spec.version }
  spec.source_files = 'MVVM/**/*.swift'
  spec.platform 	= :ios, '8.0'
end
