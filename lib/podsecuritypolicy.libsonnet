/**
 * \file Helper to create PodSecurityPolicy objects.
 */

local com = import 'lib/commodore.libjsonnet';
local kap = import 'lib/kapitan.libjsonnet';
local kube = import 'lib/kube.libjsonnet';
local inv = kap.inventory();
local params = inv.parameters.podsecuritypolicy;


/**
  * \brief Helper to create PodSecurityPolicy objects.
            The `app.kubernetes.io/managed-by` label is automatically set to `syn`.
  *
  * \arg The name of the PodSecurityPolicy.
  * \return A PodSecurityPolicy object.
  */

local podSecurityPolicy(name) = kube._Object('policy/v1beta1', 'PodSecurityPolicy', name) {
  metadata+: {
    labels+: {
      'app.kubernetes.io/managed-by': 'syn',
    },
  },
};

{
  podSecurityPolicy: podSecurityPolicy,
}
