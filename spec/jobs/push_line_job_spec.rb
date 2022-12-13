require 'rails_helper'

RSpec.describe PushLineJob, type: :job do
  describe "プッシュ通知テスト" do
    before do
      line_client_mock = double('Line client')
      allow(line_client_mock).to receive(:push_message).and_return('<Net::HTTPRequest 200 OK>')
      push_line_job = PushLineJob.new
      allow(push_line_job).to receive(:line_client).and_return(line_client_mock)
    end
    it "通知を送れる" do
      ActiveJob::Base.queue_adapter = :test #テスト用のキューアダプターを利用
      expect {
        PushLineJob.perform_now
      }.not_to raise_error
    end
  end
end