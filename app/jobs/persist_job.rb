class PersistJob
  include Sidekiq::Workflow::Worker
  sidekiq_options retry: false

  def perform(*_, **_)
    result = self.get_payload CheckJob, :json
    type   = result.fetch 'type'
    host   = result.fetch 'host'
    args   = result.fetch 'args'
    result = result.fetch 'result'
    Analysis.post! type, host, args, result
  end
end
