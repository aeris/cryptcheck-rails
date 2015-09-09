class TlsController < CheckController
  protected
  def type
    :tls
  end

  def worker
    TLSWorker
  end

  def tls_type
    'TLS'
  end
end
