platform :ios, '12.0'

use_frameworks! :linkage => :static

target 'color-generation' do
  pod 'FirebaseAnalytics'
  pod 'Firebase/Firestore'

  pod 'gRPC-C++', :modular_headers => true
  pod 'gRPC-Core', :modular_headers => true
  pod 'BoringSSL-GRPC', :modular_headers => true

  target 'color-generationTests' do
    inherit! :search_paths
  end

  target 'color-generationUITests' do
  end
end
