# 1.빌드 단계 -> 빌드 환경 설정 
FROM node:18 AS builder

# 작업 디렉토리 설정 -> 소스파일과 빌드 파일 관리하는 곳!
WORKDIR /usr/src/app

# package.json 복사 
# -> 로컬 시스템의 package.json 파일을 컨테이너의 /usr/src/app 디렉토리에 복사
COPY package.json ./

# 의존성 설치
# npm install을 실행하여 package.json에 정의된 모든 의존성을 설치
# 설치된 의존성은 컨테이너 내부에 저장되며, 빌드 프로세스에서 사용됨
RUN npm install

# 모든 소스 코드 복사
# 현재 디렉토리의 모든 파일과 폴더를 컨테이너의 작업 디렉토리(/usr/src/app)로 복사
COPY . .

# npm run build 명령을 실행하여 애플리케이션을 production 모드로 빌드
RUN npm run build

# 2. Nginx 서버 단계
# alpine은 매우 가벼운 리눅스 배포판으로, 컨테이너 크기를 줄이는 데 도움을 줌. 
FROM nginx:alpine

# 빌드된 정적 파일을 Nginx의 기본 제공 HTML 디렉토리에 복사
COPY --from=builder /usr/src/app/dist /usr/share/nginx/html

# 필요에 따라 Nginx 설정 파일 커스터마이징 적용
# 사용자 요구에 맞게 
COPY nginx.conf /etc/nginx/nginx.conf
 