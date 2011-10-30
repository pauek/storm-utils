
# Download zeromq
wget http://download.zeromq.org/historic/zeromq-2.1.7.tar.gz && \
  unzip zeromq-2.1.7.tar.gz

pushd zeromq-2.1.7
./configure
make 
make install
popd



