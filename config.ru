require './app'

use Rack::Cache,
  verbose: true,
  default_ttl: 30 * 60,
  metastore:   ENV['MEMCACHE_SERVERS'] ? "memcached://#{ENV['MEMCACHE_SERVERS']}/meta" : 'file:tmp/cache/rack/meta',
  entitystore: ENV['MEMCACHE_SERVERS'] ? "memcached://#{ENV['MEMCACHE_SERVERS']}/body" : 'file:tmp/cache/rack/entity'

run App
