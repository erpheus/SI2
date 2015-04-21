
cd ~
git clone https://erpheus@github.com/erpheus/SI2

wget http://c758482.r82.cf2.rackcdn.com/sublime_text_3_build_3065_x32.tar.bz2
tar -xvf sublime_text_3_build_3065_x32.tar.bz2 
sublime_text_3/sublime_text ./SI2/

rm -r si2srv
rm -r maquina1
rm -r maquina2

tar -xvf /opt/si2/si2srv.tgz
mv si2srv maquina1

tar -xvf /opt/si2/si2srv.tgz
mv si2srv maquina2

cd maquina1 && \
  ./si2fixMAC.sh 2401 3 1 && \
  sed -i 's/displayName = \"si2srv\"/displayName = \"maquina1\"/g' si2srv.vmx &&\
  sed -i 's/numvcpus = \"2\"/numvcpus = \"1\"/g' si2srv.vmx &&\
  cd -

cd maquina2 && \
  ./si2fixMAC.sh 2401 3 2 && \
  sed -i 's/displayName = \"si2srv\"/displayName = \"maquina2\"/g' si2srv.vmx &&\
  sed -i 's/numvcpus = \"2\"/numvcpus = \"1\"/g' si2srv.vmx &&\
  sed -i 's/memsize = \"768\"/memsize = \"512\"/g' si2srv.vmx &&\
  cd -


sudo /opt/si2/virtualip.sh eth0
echo "export J2EE_HOME=\"/usr/local/glassfish-4.0/glassfish\"" >> ~/.bashrc
export J2EE_HOME="/usr/local/glassfish-4.0/glassfish"
source ~/.bashrc

vmplayer maquina1/si2srv.vmx &

vmplayer maquina2/si2srv.vmx &

read -p "Pulsa enter cuando todas las máquinas estén preparadas... "

ssh-copy-id -i mv_rsa.pub si2@10.1.3.1
ssh-copy-id -i mv_rsa.pub si2@10.1.3.2
ssh-copy-id -i mv_rsa.pub si2@10.1.3.3
mkdir -p ~/.shh
cp mv_rsa ~/.ssh/id_rsa
cp mv_rsa.pub ~/.ssh/id_rsa.pub

j2ee_home=/opt/glassfish4/glassfish
asadmin_path=$j2ee_home/bin
export_stmt="export J2EE_HOME=$j2ee_home; export PATH=\$PATH:$asadmin_path"
ssh si2@10.1.3.1 "$export_stmt; bash -s" < m1-config.sh


#tar -xvf UnidadH/jakarta-jmeter.tgz

#jakarta-jmeter/bin/jmeter

