local kap = import 'lib/kapitan.libjsonnet';
local inv = kap.inventory();
local params = inv.parameters.podsecuritypolicy;
local argocd = import 'lib/argocd.libjsonnet';

local app = argocd.App('podsecuritypolicy', params.namespace);

{
  podsecuritypolicy: app,
}
