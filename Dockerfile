######################################
#
#   maven + tomcat 镜像
#
######################################

# 基础镜像
FROM maven:3.3.3

# 设置 Tomcat 相关的环境变量，并添加到系统 PATH 变量中

# CATALINA_HOME tomcat 的安装目录
ENV CATALINA_HOME /usr/local/tomcat

# tomcat 添加到系统 PATH 变量中
ENV PATH $CATALINA_HOME/bin:$PATH

# 创建 tomcat 目录
RUN mkdir -p "$CATALINA_HOME"

# cd 到 tomcat 目录中
WORKDIR $CATALINA_HOME

# 添加 Tomcat GPG-KEY，用于 Tomcat 下载完后校验文件是否正确
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys \
	05AB33110949707C93A279E3D3EFE6B686867BA6 \
	07E48665A34DCAFAE522E5E6266191C37C037D42 \
	47309207D818FFD8DCD3F83F1931D684307A10A5 \
	541FBE7D8F78B25E055DDEE13C370389288584E7 \
	61B832AC2F1C5A90F0F9B00A1C506407564C17A3 \
	79F7026C690BAA50B92CD8B66A3AD3F4F22C4FED \
	9BA44C2621385CB966EBA586F72C284D731FABEE \
	A27677289986DB50844682F8ACB77FC2E86E29AC \
	A9C5DF4D22E99998D9875A5110C01C5A2F6059E7 \
	DCFD35E0BF8CA7344752DE8B6FB21E8933C60243 \
	F3A04C595DB5B6A5F1ECA43E3B7BBB100D811BBE \
	F7DA48BB64BCB84ECBA7EE6935CD23C10D498E23

# 设置 Tomcat 版本变量，构建时可以传入相应参数更改 Tomcat 版本
ENV TOMCAT_VERSION 8.0.52

# tomcat 下载地址 例如：https://www.apache.org/dist/tomcat/tomcat-8/v8.5.32/bin/apache-tomcat-8.5.32-fulldocs.tar.gz
ENV TOMCAT_TGZ_URL https://www.apache.org/dist/tomcat/tomcat-8/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz

# -o : 将文件下载到本地并命名为 tomcat.tar.gz
RUN set -x \
	&& curl -fSL "$TOMCAT_TGZ_URL" -o tomcat.tar.gz \
	&& curl -fSL "$TOMCAT_TGZ_URL.asc" -o tomcat.tar.gz.asc \
	&& gpg --verify tomcat.tar.gz.asc \
	&& tar -xvf tomcat.tar.gz --strip-components=1 \
	&& rm bin/*.bat \
	&& rm tomcat.tar.gz*

# 暴露 Tomcat 默认的 8080 端口
EXPOSE 8080

# 基于该镜像的容器启动时执行的脚本，该脚本为 Tomcat 启动脚本
CMD ["catalina.sh", "run"]
