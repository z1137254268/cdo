FROM nginx:latest
MAINTAINER ifeng <https://t.me/HiaiFeng>
EXPOSE 80
USER root

RUN apt-get update && apt-get install -y supervisor wget unzip

#定义 UUID 及 伪装路径,请自行修改.(注意:伪装路径前无需加/符号，程序已自行添加.)
ENV UUID 10974d1a-cbd6-4b6f-db1d-38d78b3fb109
ENV VMESS_WSPATH vmess
ENV VLESS_WSPATH vless

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY nginx.conf /etc/nginx/nginx.conf

RUN mkdir /etc/v2ray /usr/local/v2ray
COPY config.json /etc/v2ray/
COPY entrypoint.sh /usr/local/v2ray/
RUN chmod a+x /usr/local/v2ray/entrypoint.sh

RUN wget -q -O /tmp/v2ray-linux-64.zip https://github.com/v2fly/v2ray-core/releases/download/v4.45.0/v2ray-linux-64.zip && \
    unzip -d /usr/local/v2ray /tmp/v2ray-linux-64.zip
    
RUN addgroup -g 10015 choreo && \
    adduser  --disabled-password  --no-create-home --uid 10015 --ingroup choreo choreouser
# Set a non-root user
USER 10015

ENTRYPOINT [ "/usr/local/v2ray/entrypoint.sh" ]
CMD ["/usr/bin/supervisord"]
