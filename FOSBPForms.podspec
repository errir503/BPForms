Pod::Spec.new do |s|
  s.name        = 'FOSBPForms'
  s.version  = '2.0.8'
  s.license  = { :type => 'MIT', :file => 'LICENSE' }
  s.summary  = 'Dynamic forms for iPhone/iPad - iOS 8 and later.'
  s.homepage = 'https://github.com/bpoplauschi/BPForms'
  s.author   = { 'Bogdan Poplauschi' => 'bpoplauschi@gmail.com' }
  s.source   = { :git => 'https://github.com/foscomputerservices/BPForms.git',
                 :tag => "#{s.version}" }

  s.description = 'Inspired from BZGFormViewController, BPForms allows easily creating beautiful dynamic forms.'

  s.requires_arc = true
  s.platform     = :ios, '8.4'

  s.preserve_paths = 'README*'

  s.source_files = 'BPForms/**/*.{h,m}', 'BPFormsFloatLabel/*.{h,m}'
  s.public_header_files = 'BPForms/**/*.h', 'BPFormsFloatLabel/*.h'
  s.dependency 'Masonry'
  s.dependency 'JVFloatLabeledTextField'

end
