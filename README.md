## Summary
COMP322002-Introduction to Database-Term Project : Eonju Lee, Jeon sungyoon

* This is github repository for team 1 website
* Please check Team1-Phase4-User_Manual.pdf for more information

## Page Descriptions
#### Welcome Page
- Sign In 
: 로그인, 아이디와 비밀번호를 입력하여 로그인을 시도할 수 있음
- Sign Up 
: 회원가입, 회원 가입 시에는 사용자에게 필수 정보만을 입력받아 계정을 생성함. 계정 생성과 함께 기본적인 멤버십을 부여하기 위해 멤버십 계정도 함께 생성한다

#### Main Page - 로그인 이후 메인 기능 화면
- Account Page
: 계정 관련 기능 화면(Account Page)으로 이동함
- Movie Page
: 영상물 관련 기능 화면(Movie Page)으로 이동함
- Rating Page
: 영상물 평가 관련 기능 화면(Rating Page)으로 이동함
- Sign Out
: 로그인한 계정에서 로그아웃하고 로그인 화면(Welcome Page)으로 돌아감
- Administrator Page
: 관리자 관련 기능 화면(Administator Page)으로 이동함. 현재 로그인한 사용자가 관리자인 경우만 이 메뉴를 가시화함

#### Account Page - 계정 관련 기능 화면
- Edit Account Profile
: 사용자 정보를 출력하고 수정함, 필수 정보는 스킵할 수 없으며(빈 정보 제공 시 오류메세지 생성), 정보 제공을 스킵할 경우 기존 정보는 수정되지 않음
- Edit Password
: 사용자 비밀번호를 수정함
- Withdrawl
: 회원 탈퇴 후 로그인 화면(Welcome Page)으로 돌아감. 계정 정보가 데이터베이스에서 삭제됨
- Back to Previous Page
: 계정 관련 기능 페이지를 종료하고, 메인 페이지(Main Page)로 이동함

#### Movie Page - 영상물 관련 기능 화면
- Movie List
: 영상물 릴레이션의 모든 정보를 출력함. 출력된 영상물의 View Detail을 클릭하여 영상물의 상세 정보를 확인할 수 있음 
- Movie Search
: Search by title (영상물 제목으로 검색 진행), Search by attribute (영상물을 특정 조건으로 검색함. 영상물 타입, 장르, 버전으로 검색할 수 있음)
- Recommend Page
: 회원 정보를 바탕으로 영상물 추천 서비스를 제공함. 사용자와 같은 연령대의 사람들의 평가 결과, 전체 평가 결과, 사용자가 평가한 영상물 종류를 추천 시스템의 근거로 이용함
- Back to Previous Page
: 영화 관련 기능 페이지를 종료하고, 메인 페이지(Main Page)로 이동함

#### Rating Page - 영상물 평가 관련 기능 화면
- View my Ratings
: 사용자가 평가한 영상물의 정보(영상물 제목과 자신이 평가한 평점)를 확인할 수 있음
- Back to Previous Page
: 영상물 관련 기능 페이지를 종료하고, 메인 페이지(Main Page)로 이동함
- (Admin) View all ratings
: 현재 로그인한 사용자가 관리자인 경우 이 메뉴를 가시화함. 데이터베이스에 저장된 영상물 평가 정보(영상물 제목, 평가자, 평점)를 모두 가져와서 출력함

#### Admin Page - 관리자 관련 기능 화면
- Movie & Version Management
: 전체 영상물 목록을 출력함. 새 영상물을 추가하거나, 기존 영상물의 정보를 변경하거나, 삭제할 수 있음.  정보 변경 시 필수 정보를 스킵할 수 없음
: 영상물의 Version Info를 클릭하면 해당하는 영상물의 버전 정보를 출력함. 마찬가지로 버전 정보를 변경하거나 삭제할 수 있으며 영상물의 새 국가버전을 등록할 수 있음
- Episode Management
: 전체 TV Series 목록을 출력함.
: 영상물의 Episode Info를 클릭하면 해당하는 영상물의 에피소드 정보를 출력함. 에피소드 정보를 변경, 삭제, 추가 가능함.
- Back to Previous Page
: 관리자 관련 기능 페이지를 종료하고, 메인 페이지(Main Page)로 이동함

## Development Environment
#### DBMS
- PostgreSQL 12.5 (Ubuntu 12.5-0ubuntu0.20.04.1))

#### VM
- Oracle VM VirtualBox 
- 버전 : 5.2.26 r128414(Qt5.6.2)

#### OS - Linux
- 운영체제: Ubuntu 12.5-0ubuntu0.20.04.1
- 시스템 설정 : 기본 메모리(4096MB), 부팅 순서(플로피 디스크, 광 디스크, 하드 디스크), 가속(VT-X/AMD-V, 네스티드 페이징, KVM 반가상화)

#### Eclipse 
- Eclipse IDE for Enterprise Java Developers (includes Incubating components)
- Version: 2020-09 (4.17.0)
- Build id: 20200910-1200

#### Java
- javac 11.0.9.1
- openjdk 11.0.9.1 2020-11-04
- openJDK Runtime Environment (build 11.0.9.1+1-Ubuntu-0ubuntu1.20.04)
- OpenJDK 64-Bit Server VM (build 11.0.9.1+1-Ubuntu-0ubuntu1.20.04)

## Demo URL
- https://youtu.be/oe7odDA7ciY
