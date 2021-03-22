{
  _config+:: {
    search_client: {
      web: {
        name: 'web',
        port: 4567,
        host: 'search-client.macc.kubernetes.hathitrust.org',
      },
    },
  },

  _images+:: {
    search_client: {
      web: 'hathitrust/search-client-unstable',
    },
  },
}
