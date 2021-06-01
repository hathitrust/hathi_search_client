(import 'search-client/search-client.libsonnet') +
{
  _config+:: {
    search_client+: {
      web+: {
        host: 'testing.search-client.kubernetes.hathitrust.org'
      },
      database+: {
        ip: "10.255.8.249",
        port: 3306
      },
      solr+: {
        ip: "10.255.8.197",
        port: 9033
      }
    }
  }
}
