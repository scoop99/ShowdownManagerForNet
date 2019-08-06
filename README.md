# Showdown Web Manager  
iodides님이 제작하신 Showdown을 Web에서 관리할 수 있도록 제작  

제작 및 구동 환경  
Visual Studio 2019  
UI : jui.io http://jui.io/  
Microsoft .NET Framework 4.5  
Windows10 IIS  
Showdown v1.55 : https://iodides.tistory.com/15  

기본적인 로직
1. 정보(방송 프로그램, 에피소드)는 DB에 바로 접속  
2. 프로그램 추가, 수정, 삭제 및 에피소드 추가, 수정 는 Showdown 서버와 소켓 통신  
3. 로그 파일은 직접 해당 하는 파일 직접 핸들링  


#### 설치 방법 by Windows10 IIS(기본적으로 IIS가 세팅이 되어 있다 라는 전제 하에 설명 하겠습니다.)

메뉴얼 폴더에 있는 이미지를 참고
1. 그림001 과 같이 웹 사이트 추가 하여 실제 경로와 사용할 포트를 입력
2. 웹 사이트 추가가 되었으면 기본 문서를 설정을 확인 : Login.aspx 필수 (그림 002~004 참고)
3. 응용 프로그램 풀 설정 : 고급 설정 -> 32비트 응용 프로그램 사용 : True (그림 005~006 참고)
4. Web.config 설정 (그림 009~010 참고)
   1) 실제 DB 경로 : <add key="connStr" value="Data Source=H:\Project\ShowDownTest\Data\SQLDB.db" />
   2) Showdown 서버 주소 : <add key="connSocketIP" value="localhost" />
   3) Showdown 서버 포트번호 : <add key="connSocketPort" value="1111" />
   4) 웹페이지 로그인 아이디 : <add key="id" value="admin" />
   5) 웹페이지 로그인 비밀번호 : <add key="pass" value="admin" />
   6) 로그파일 경로 : <add key="logPath" value="H:\Project\ShowDownTest\Data" />
5. 접속 테스트 : localhost:포트번호 (그림 011 참고)
6. 로그인 후 메인 화면 (그림 012)
   1) 기본적으로 방영중인 드라마가 세팅.
   2) 기능
      - 기존 Showdown 클라이언트 기능과 동일한 방영예정, 방영중, 종영된 드라마, 예능, TV 리스트 출력
      - 각 항목별로 상세(에피소드 리스트 출력)
      - 프로그램 추가(그림 013), 수정, 삭제
      - 로그파일 호출(그림 014)
      - 제목으로 검색
7. 에피소드 리스트 화면(그림 012-01)
    1) 해당 항목의 에피소드 리스트 출력
    2) 에피소드 검색 기능
    3) 에피소드 추가 기능
    4) 모니터링 상태 변경 기능
    5) 상태 구분값 변경 기능
    6) 720P, 1080P 변경 기능

# Version History
v0.1 / 20190801
 - 공개
 
# 알려진 버그
 - 19.08.01 - 로그파일중 ShowDown.log 파일을 읽어 오지 못함(iodides님께 )



# 남기는 말
먼저 Showdown을 제작 및 공개해주신 iodides님께 감사드립니다.
실제로 사용하기 위해서 제작되어 있어서 기본적인 부분들만 구현되어 있습니다.

이용에 참고해 주세요.
Showdown을 사용함에 있어 조금이나마 도움이 되었으면 합니다.

감사합니다.

# Showdown Client가 실행된 상태에서는 Showdown Manager가 동작하지 않습니다.
