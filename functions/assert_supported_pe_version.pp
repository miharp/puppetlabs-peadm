# @return [Boolean] true if the version is supported, raise error otherwise
# @param [String] the version number to check
function peadm::assert_supported_pe_version (
  String $version,
  Boolean $permit_unsafe_versions = false,
) >> Struct[{'supported' => Boolean}] {
  $oldest = '2019.7'
  $newest = '2021.3'
  $supported = (($version =~ SemVerRange(">= ${oldest} <= ${newest}")) or $permit_unsafe_versions)

  if $permit_unsafe_versions {
    warning(@("WARN"/L))
      WARNING: Permitting unsafe PE versions. This is not supported or tested.
        Proceeding with this action could result in a broken PE Infrastructure.
      | WARN
  }

  unless $supported {
    fail(@("REASON"/L))
      This version of the puppetlabs-peadm module does not support PE ${version}.

      For PE versions older than ${oldest}, please check to see if version 1.x \
      or 2.x of the puppetlabs-peadm module supports your PE version.

      For PE versions newer than ${newest}, check to see if a new version of peadm \
      exists which supports that version of PE.

      | REASON
  }

  return({ 'supported' => $supported })
}
