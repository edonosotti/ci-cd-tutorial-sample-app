Vagrant.configure("2") do |config|
  config.vm.define "worker-stage" do |db|
    db.vm.box = "ubuntu/focal64"
    db.vm.hostname = "stage-1"
    db.vm.network "private_network", ip: "192.168.56.56"
    config.ssh.insert_key = false
    config.vm.provision "shell",
      inline: "sudo apt-get update && sudo apt-get install ansible -y"     
  end

  # config.vm.define "worker-prod" do |app|
  #   app.vm.box = "ubuntu/focal64"
  #   app.vm.hostname = "prod-1"
  #   app.vm.network "private_network", ip: "192.168.56.57"
  #   config.ssh.insert_key = false
  #   config.vm.provision "shell",
  #     inline: "sudo apt-get update && sudo apt-get install ansible -y"   
  # end

end