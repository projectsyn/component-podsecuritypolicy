local argocd = import 'lib/argocd.libjsonnet';

local app = argocd.App('podsecuritypolicy', '') {
  spec+: {
    destination+: {
      namespace:: '',
    },
  },
};

{
  podsecuritypolicy: app,
}
