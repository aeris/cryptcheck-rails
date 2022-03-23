class TlsController < CheckController
  protected
  def type
    :tls
  end

  def tls_type
    'TLS'
  end
end
