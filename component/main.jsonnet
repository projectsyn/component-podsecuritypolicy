// main template for podsecuritypolicy
local com = import 'lib/commodore.libjsonnet';
local kap = import 'lib/kapitan.libjsonnet';
local kube = import 'lib/kube.libjsonnet';
local inv = kap.inventory();
local psp = import 'lib/podsecuritypolicy.libsonnet';

local params = inv.parameters.podsecuritypolicy;

{
  [name]:
    local policy = params.policies[name];
    local labels = {
      'app.kubernetes.io/managed-by': 'syn',
    };
    local cluster_role = kube.ClusterRole('psp:' + name) {
      metadata+: {
        labels+: labels,
      },
      rules: [
        {
          apiGroups: [
            'policy',
          ],
          resources: [
            'podsecuritypolicies',
          ],
          verbs: [
            'use',
          ],
          resourceNames: [
            name,
          ],
        },
      ],
    };
    local annotations = if std.objectHas(policy, 'annotations') then
      policy.annotations
    else {};
    [
      psp.podSecurityPolicy(name) {
        metadata+: {
          annotations+: annotations,
        },
        spec+: com.makeMergeable(policy.spec),
      },
      cluster_role,
    ] + if std.objectHas(policy, 'bindToGroups') then [
      kube.ClusterRoleBinding(name) {
        metadata+: {
          labels+: labels,
        },
        subjects+: [
          {
            apiGroup: 'rbac.authorization.k8s.io',
            kind: 'Group',
            name: group,
          }
          for group in policy.bindToGroups
        ],
        roleRef_: cluster_role,
      },
    ] else []
  for name in std.objectFields(params.policies)
}
