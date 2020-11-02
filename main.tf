terraform {
  required_providers {
    google={}
  }
}

provider "google" {
  version = "3.5.0"

  credentials = file("ann.json")

  project = "integral-plexus-289616"
  region  = "us-central1"
  zone    = "us-central1-a"
}

resource "google_compute_network" "vpc_network" {
  name = "my-test-network"
}

resource "google_compute_firewall" "default" {
  name    = "my-test-fw"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "22"]
  }
}



resource "google_compute_network" "default" {
  name = "compute-network"
}



resource "google_compute_instance" "first_node" {
  name = "server1"
  machine_type="e2-micro"
  boot_disk {
  initialize_params {
      image = "ubuntu-2004-focal-v20200720"
    }
  }
  network_interface {
	  network=google_compute_network.vpc_network.name
  
  access_config {}
  }
}

resource "google_compute_instance" "second_node" {
  name = "server2"
  machine_type="e2-micro"
  tags=["second"]
  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20200720"
    }
  }
  network_interface {
	  network=google_compute_network.vpc_network.name
  
  access_config {}
  }
  
}

