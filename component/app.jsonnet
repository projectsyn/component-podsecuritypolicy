local argocd = import 'lib/argocd.libjsonnet';

local app = argocd.App('podsecuritypolicy', '') {
  spec+: {
    destination+: {
      namespace:: '',
    },
  },
};

local appPath =
  local project = std.get(std.get(app, 'spec', {}), 'project', 'syn');
  if project == 'syn' then 'apps' else 'apps-%s' % project;

{
  ['%s/podsecuritypolicy' % appPath]: app,
}
