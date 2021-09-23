resource "google_compute_instance" "vm_lb" {
  name         = "load-balancer-instance"
  machine_type = "e2-medium"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  tags = ["ansible", "lb"]
  network_interface {
    subnetwork = google_compute_subnetwork.vpc_subnet.id
    access_config {
    }
  }
  metadata = {
    ssh-keys = "${var.ansible_user}:${file(var.ssh_key_public)}"
  }
  metadata_startup_script = "sudo apt -y install python"
}

resource "google_compute_instance" "vm1" {
  name         = "vm1-instance"
  machine_type = "e2-medium"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  tags = ["ansible", "node"]
  network_interface {
    subnetwork = google_compute_subnetwork.vpc_subnet.id
    access_config {
    }
  }
  metadata = {
    ssh-keys = "${var.ansible_user}:${file(var.ssh_key_public)}"
  }
  metadata_startup_script = "sudo apt -y install python"

}

resource "google_compute_instance" "vm2" {
  name         = "vm2-instance"
  machine_type = "e2-medium"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  tags = ["ansible", "node"]
  network_interface {
    subnetwork = google_compute_subnetwork.vpc_subnet.id
    access_config {
    }
  }
  metadata = {
    ssh-keys = "${var.ansible_user}:${file(var.ssh_key_public)}"
  }
  metadata_startup_script = "sudo apt -y install python"
}

resource "google_compute_instance" "vm3" {
  name         = "vm3-instance"
  machine_type = "e2-medium"
  boot_disk {
    initialize_params {
      image = "windows-cloud/windows-server-2019-dc-v20210914"
    }
  }
  tags = ["ansible", "node", "win"]
  network_interface {
    subnetwork = google_compute_subnetwork.vpc_subnet.id
    access_config {
    }
  }
  metadata = {
    ssh-keys = "${var.ansible_user}:${file(var.ssh_key_public)}"
    windows-startup-script-ps1 = <<EOF
    #OpenSSH feature on windows
    Add-WindowsCapability –Online –Name OpenSSH.Server~~~~0.0.1.0
    Set-Service sshd –StartupType Automatic
    Start-Service sshd
    New-ItemProperty –Path "HKLM:\SOFTWARE\OpenSSH" –Name DefaultShell –Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" –PropertyType String –Force
    Restart-Service sshd

    #ansible user and key
    $length = 10
    $nonAlphaChars = 5
    Add-Type –AssemblyName 'System.Web'
    $user = \"${var.ansible_user}\"
    $pass = ([System.Web.Security.Membership]::GeneratePassword($length, $nonAlphaChars))
    $secureString = ConvertTo-SecureString $pass –AsPlainText –Force
    New-LocalUser –Name $user –Password $secureString
    $credential = New-Object System.Management.Automation.PsCredential($user,$secureString)
    $process = Start-Process cmd /C –Credential $credential –ErrorAction SilentlyContinue –LoadUserProfile
    $newPass = ([System.Web.Security.Membership]::GeneratePassword($length, $nonAlphaChars))
    $newSecureString = ConvertTo-SecureString $newPass –AsPlainText –Force
    Set-LocalUser –Name $user –Password $newSecureString
    New-Item –Path \"C:\\Users\\$user" –Name \".ssh\" –ItemType Directory
    $content = \"${var.ssh_key_public}\"
    $content | Set-Content –Path \"c:\\users\\$user\\.ssh\\authorized_keys\"

    #Firewall rule
    New-NetFirewallRule -DisplayName 'OpenSSH' -Direction Inbound -Action Allow -Protocol TCP -LocalPort 22
    EOF
    
  }
  
}

#windows-startup-script-ps1 = "Add-WindowsCapability –Online –Name OpenSSH.Server~~~~0.0.1.0; Set-Service sshd –StartupType Automatic; Start-Service sshd; $length = 10; $nonAlphaChars = 5; Add-Type –AssemblyName 'System.Web'; $user = 'ansible'; $pass = ([System.Web.Security.Membership]::GeneratePassword($length, $nonAlphaChars)); $secureString = ConvertTo-SecureString $pass –AsPlainText –Force; New-LocalUser –Name $user –Password $secureString; $credential = New-Object System.Management.Automation.PsCredential($user,$secureString); $process = Start-Process cmd /c –Credential $credential –ErrorAction SilentlyContinue –LoadUserProfile; $newPass = ([System.Web.Security.Membership]::GeneratePassword($length, $nonAlphaChars)); $newSecureString = ConvertTo-SecureString $newPass –AsPlainText –Force; Set-LocalUser –Name $user –Password $newSecureString; New-Item –Path 'C:\\Users\\$user' –Name '.ssh' –ItemType Directory; $content = 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQChg1U0G5wYkBrMAG0h7tkxe+w/zmgtezvUVjUBrg554qdEw8SecVJO0G3ErEZb7Uf/2fsnOzM20pW8WMRKKaylyCYXKzwB1Z7kkn8LOi3pQIDsfqEDRtltk2wc+iYLhs4UBUCJ6nlwrZ1RDDapWR2Wr1xwhtqiUKAYjI9XtgiNVbi1nyDKsiut5DYNxBuDfckBHqY8wyK5sVV6hAHXca5mahUa9d102rg2F9CAMOHQqNRAnkxp3HO2p0mOXI/8eVC5pt9WoQPw/ctebXafnRj6Jz0VHbRIg5BG/4TWls+Yxn7J08fZEPybtSyuqu+QfksO+ICykAuhx75ta5ZqQhvP ichijoint@cs-652761960658-default-boost-qhkxg'; $content | Set-Content –Path 'c:\\users\\$user\\.ssh\\authorized_keys'; New-NetFirewallRule -DisplayName 'OpenSSH' -Direction Inbound -Action Allow -Protocol TCP -LocalPort 22"