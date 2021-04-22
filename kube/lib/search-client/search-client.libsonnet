(import 'ksonnet-util/kausal.libsonnet') +
(import './external_ip_service.libsonnet') +
(import './config.libsonnet') +
(import './envVar.libsonnet') +
{
  local deploy = $.apps.v1.deployment,
  local container = $.core.v1.container,
  local port = $.core.v1.containerPort,

  local config = $._config.search_client,
  local images = $._images.search_client,
  local ip_service = $.phineas.external_ip_service.new,

  search_client: {
    web: {
      deployment: deploy.new(
        name=config.web.name,
        replicas=1,
        containers=[
          container.new(config.web.name, images.web)
                   .withPorts([port.new('ui', config.web.port)])
                   .withImagePullPolicy('Always')
          + container.withEnv( $._envVar,),
        ]
      ),

      service: $.util.serviceFor(self.deployment) + $.core.v1.service.mixin.spec.withPorts($.core.v1.service.mixin.spec.portsType.newNamed(
        name=config.web.name,
        port=80,
        targetPort=config.web.port,
      )),

    },

    database: ip_service("mysql",config.database.ip,config.database.port),

    solr: ip_service("solr-catalog",config.solr.ip,config.solr.port)
  },
}
