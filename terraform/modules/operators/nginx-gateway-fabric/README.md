# NGINX Gateway Fabric operator

Installs pinned NGINX Gateway Fabric CRDs, internal certificates, and the controller Helm release. Gateway instances, listeners, routes, snippets policies, trusted CIDRs, and exposure-specific values belong to consumers.

The consumer must install Gateway API and cert-manager before this module because its controller and internal certificate resources require those APIs.
