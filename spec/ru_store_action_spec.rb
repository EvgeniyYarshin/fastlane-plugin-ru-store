describe Fastlane::Actions::RuStoreAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The ru_store plugin is working!")

      Fastlane::Actions::RuStoreAction.run(nil)
    end
  end
end
