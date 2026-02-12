# 第一階段：編譯 Java 代碼
FROM openjdk:11-jdk-slim AS builder

# 安裝必要的工具
RUN apt-get update && apt-get install -y findutils

# 設置工作目錄
WORKDIR /app

# 複製源代碼和依賴
COPY src/main/java ./src/main/java
COPY src/main/webapp/WEB-INF/lib ./lib

# 創建編譯輸出目錄
RUN mkdir -p build/classes

# 編譯 Java 源文件
# 首先找到所有 .java 文件並編譯
RUN find src/main/java -name "*.java" > sources.txt && \
    javac -d build/classes \
    -cp "lib/*:/usr/local/tomcat/lib/servlet-api.jar" \
    @sources.txt || \
    javac -d build/classes \
    -cp "lib/*" \
    @sources.txt

# 第二階段：構建最終鏡像
FROM tomcat:9.0-jdk11

# 刪除 Tomcat 默認的 ROOT 應用
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# 從構建階段複製編譯好的類文件
COPY --from=builder /app/build/classes /usr/local/tomcat/webapps/ROOT/WEB-INF/classes

# 複製 webapp 文件
COPY src/main/webapp /usr/local/tomcat/webapps/ROOT

# 暴露端口
EXPOSE 8080

# 啟動 Tomcat
CMD ["catalina.sh", "run"]
