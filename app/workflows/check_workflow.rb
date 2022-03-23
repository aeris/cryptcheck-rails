class CheckWorkflow < Sidekiq::Workflow
  def configure(*args, **kwargs)
    check = job CheckJob, *args, **kwargs
    job PersistJob, after: check
  end
end
