resource "oci_core_instance" "ubuntu_instance" {
  # Required
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.compartment_id
  shape               = "VM.Standard.E5.Flex"

  shape_config {
    ocpus         = "4"
    memory_in_gbs = "16"
  }

  source_details {
    source_id   = var.comp_source_id
    source_type = "image"
  }

  display_name = var.comp_display_name
  create_vnic_details {
    assign_public_ip = true
    subnet_id        = oci_core_subnet.public.id
  }

  metadata = {
    ssh_authorized_keys = file(var.ssh_key_path)
    user_data           = base64encode(file("${path.module}/scripts/startup_script.sh"))
  }

  preserve_boot_volume = false
}

resource "oci_core_vcn" "mc_vcn" {
  compartment_id = var.compartment_id
  cidr_blocks    = ["10.1.0.0/16"]
  display_name   = "mc-vcn"
  dns_label      = "mcvcn"
}

resource "oci_core_subnet" "public" {
  cidr_block     = "10.1.1.0/24"
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.mc_vcn.id
  display_name   = "public-subnet"
  security_list_ids = [oci_core_security_list.mc_security_list.id]
  route_table_id = oci_core_route_table.public.id
}

resource "oci_core_internet_gateway" "main" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.mc_vcn.id
  display_name   = "internet-gw"
}

resource "oci_core_security_list" "mc_security_list" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.mc_vcn.id

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 22
      max = 22
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 25565
      max = 25565
    }
  }
}

resource "oci_core_route_table" "public" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.mc_vcn.id

  route_rules {
    network_entity_id = oci_core_internet_gateway.main.id
    destination       = "0.0.0.0/0"
  }
}
