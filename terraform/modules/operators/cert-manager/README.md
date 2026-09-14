# cert-manager operator

Installs cert-manager with optional CRD and Gateway API support. ClusterIssuers, contact identities, and DNS credentials are deliberately outside this module.

When Gateway API support is enabled, the consumer must install the selected Gateway API CRDs before this module.
