class XmppController < CheckController
  protected

  def type
    :xmpp
  end

  def worker
    XMPPWorker
  end

  def tls_type
    'STARTTLS'
  end

  def default_args
    :c2s
  end
end
