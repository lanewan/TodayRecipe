# 使用 Tomcat 作為基礎鏡像
FROM tomcat:9.0-jdk11

# 刪除 Tomcat 默認的 ROOT 應用
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# 複製編譯好的類文件
COPY build/classes /usr/local/tomcat/webapps/ROOT/WEB-INF/classes

# 複製 webapp 文件
COPY src/main/webapp /usr/local/tomcat/webapps/ROOT

# 暴露端口
EXPOSE 8080

# 啟動 Tomcat
CMD ["catalina.sh", "run"]
