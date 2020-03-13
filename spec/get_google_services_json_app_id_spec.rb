describe Fastlane::Actions::GetGoogleServicesJsonAppIdAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The android_getgoogle_services_parser plugin is working!")

      Fastlane::Actions::GetGoogleServicesJsonAppIdAction.run(nil)
    end
  end
end