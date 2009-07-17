# README for the wolf31o2 overlay
# $Id$

This overlay includes several packages which are also available in Gentoo's
main tree.  Where I divulge from Gentoo is generally a matter of policy, such
as configuring usable defaults for a working out-of-box experience, or reducing
typical "garbage" clutter from the output to the end user.  As such, I have a
few minor policies, which I enforce on ebuilds and packages I commit to this
repository.  However, I sometimes commit ebuilds from Gentoo's tree with only
minimal modification, as this *is* only an overlay, and not a complete tree.

- Only output information which applies to the user or the installation
- Allow for site-wide variable configuration of certain portions of packages,
  such as centralized authentication, logging, or databases
- Compatibility with Gentoo's tree to ensure the repository is accessible and
  usable without any hacks
- Configuration of interactive aspects in a non-interactive manner via the use
  of variables or other data sources which can be queried, such as a database or
  external configuration files
- Enterprise-ready capabilities should be enabled, versus the Gentoo tendency to
  focus on the desktop
- Most packages assume a managed and controlled environment, versus general use
- Reduce choice where it allows the user to create an unworkable system, or a
  broken package or set of packages
