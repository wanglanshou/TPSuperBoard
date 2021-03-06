


#TPiOSFramework.podspec
Pod::Spec.new do |s|

	s.name		= "TPSuperBoard"
	s.version	= "0.0.5"
	s.summary	= "TPSuperboard provide you edit a photo on a view"
	s.homepage 	= "https://github.com/wanglanshou"
	s.license	= "mit"
	s.author	= {"Wang Lanshou" => "782699669@qq.com"}
	s.platform	= :ios,"8.0"
	s.ios.deployment_target = "8.0"
	s.source	= {:git => "https://github.com/wanglanshou/TPSuperBoard.git" ,:tag => s.version}
	s.source_files = "SuperBoard/Controller/*.{h,m}"
	s.subspec "Func" do |f|
		f.source_files = "TPSuperBoard/Func/*"
		end
	s.subspec "Model" do |m|
		m.source_files = "TPSuperBoard/Model/*"
		end
	s.subspec "View" do |v|
		v.source_files = "TPSuperBoard/View/*"
		end
	s.ios.vendored_framework = "TPSuperBoard/TPWhiteBoard.bundle"
	s.requires_arc = true
	s.dependency "Masonry","~>0.6.4"
	s.dependency "TPiOSFramework"
end


