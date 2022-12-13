require 'rails_helper'

RSpec.describe BuyAmazonJob, type: :job do
  describe "自動購入機能テスト" do
    it "キューにジョブが追加されること" do
      ActiveJob::Base.queue_adapter = :test #テスト用のキューアダプターを利用
      expect {
        BuyAmazonJob.perform_later
      }.to have_enqueued_job(BuyAmazonJob)
    end
  end
end