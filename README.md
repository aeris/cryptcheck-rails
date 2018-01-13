Install
=======


Requirements
------------

- Custom openssl to enable old protocols/ciphers (to test weak protocols/ciphers you need to known it)
- Ruby 2.2.3 with patch to support dhparam and link with your custom openssl install
- Redis is used by sidekiq
- Elasticsearch is used to store all results
- You need cryptcheck at the same level than rails app

Docker
------

You can run the entire stack in container, just follow this order:

**redis**

```
docker run -d --name redis redis:latest
```

**elasticsearch**

```
docker run -d --name elasticsearch elasticsearch
```

**sidekiq**

```
docker run -d --name cryptcheck-sidekiq --link redis:redis cryptcheck-rails sidekiq
```

**rails**
```
docker run -d --name cryptcheck-rails --link elasticsearch:elasticsearch --link redis:redis -p 9292:9292 cryptcheck-rails puma
```

Yeah! now you have the rails app available on port 9292

Nginx
-----

Rails app can run behing a nginx proxy.
For example this vhost:
```
server {
    listen   443 ssl spdy;
    listen   [::]:443 ssl spdy; ## listen for ipv6

    server_name  cryptcheck;

    include 'include/ssl.conf';

    location / {
      proxy_set_header Host $host;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_pass http://localhost:9292;
    }
}
```
