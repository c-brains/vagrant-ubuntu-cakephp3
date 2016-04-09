# CakePHP Development Environment (Vagrant + Ubuntu)

## Requirement

* Virtualbox > 5.0
* Vagrant > 1.8

## install

```
vagrant plugin install vagrant-multiplug
cp itamae/node.default.yml itamae/node.yml
vagrant up
```

## provision in VM

```
vagrant ssh
vagrant$ cd /var/itamae; sudo bundle exec itamae local /vagrant/itamae/bootstrap.rb --node-yaml=/vagrant/itamae/node.yml
```
