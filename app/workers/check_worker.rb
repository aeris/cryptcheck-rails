class CheckWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(host, *args)
    host   = SimpleIDN.to_ascii host.downcase
    result = self.analyze host, *args
    args = nil if args.empty?
    Analysis.post! self.type, host, args, result
  end
end
