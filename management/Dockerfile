FROM docker.io/ubuntu:latest as mcrcon_build
RUN apt-get update && apt-get install -y --no-install-recommends git build-essential gcc ca-certificates
WORKDIR /home/build
RUN git clone https://github.com/Tiiffi/mcrcon.git
RUN cd mcrcon && make

FROM docker.io/gitpod/openvscode-server:latest
USER root 
RUN apt-get update && apt-get install -y --no-install-recommends python3 python3-pip build-essential
ENV PATH "/home/tools:${PATH}"
COPY /modDownloader.py /home/tools/modDownloader
COPY --from=mcrcon_build /home/build/mcrcon/mcrcon /tmp/mcrcon/mcrcon
COPY --from=mcrcon_build /home/build/mcrcon/mcrcon.1 /tmp/mcrcon/mcrcon.1
COPY --from=mcrcon_build /home/build/mcrcon/Makefile /tmp/mcrcon/Makefile
WORKDIR /tmp/mcrcon
RUN make install
WORKDIR /home
RUN chmod +x /home/tools/modDownloader
USER openvscode-server
RUN pip install requests
