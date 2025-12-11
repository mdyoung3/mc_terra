# The "name" of the availability domain to be used for the compute instance.
output "name-of-first-availability-domain" {
  value = data.oci_identity_availability_domains.ads.availability_domains[0].name
}

output "connection-info" {
  value = "ubuntu@${oci_core_instance.ubuntu_instance.public_ip}"
}
