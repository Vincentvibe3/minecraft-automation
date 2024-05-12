FROM docker.io/ubuntu:latest as mcrcon_build
RUN apt-get update && apt-get install -y --no-install-recommends git build-essential gcc ca-certificates
WORKDIR /home/build
RUN git clone https://github.com/Tiiffi/mcrcon.git
RUN cd mcrcon && make
FROM docker.io/ubuntu:latest
RUN apt-get update && apt-get install -y --no-install-recommends make python3-full python3-pip
COPY --from=mcrcon_build /home/build/mcrcon/mcrcon /tmp/mcrcon/mcrcon
COPY --from=mcrcon_build /home/build/mcrcon/mcrcon.1 /tmp/mcrcon/mcrcon.1
COPY --from=mcrcon_build /home/build/mcrcon/Makefile /tmp/mcrcon/Makefile
WORKDIR /tmp/mcrcon
RUN make install
WORKDIR /home
#Create env
RUN python3 -m venv ./env
RUN /home/env/bin/python3 -m pip install boto3
COPY /start.sh ../start.sh
COPY s3upload.py ../s3upload.py
RUN chmod +x ../start.sh
ENV WORLD_NAME=""
ENV BUCKET=""
ENV S3_ENDPOINT=""
ENV KEY_ID=""
ENV KEY_SECRET=""
ENV MCRCON_PASS=""
ENV MCRCON_HOST=""
ENTRYPOINT [ "../start.sh" ]