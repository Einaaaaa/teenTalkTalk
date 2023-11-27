CREATE DATABASE webdb;

CREATE USER 'webservice'@'%' IDENTIFIED BY 'webservice';
GRANT ALL PRIVILEGES ON webdb.* TO 'webservice'@'%' WITH GRANT OPTION;
GRANT SUPER ON *.* TO 'webservice'@'%';
GRANT SELECT ON appdb.* TO 'webservice'@'%';

flush privileges;

DROP TABLE IF EXISTS webdb.`tb_user`;

-- 회원 정보
CREATE TABLE webdb.`tb_user` (
  `board_idx` int(11) NOT NULL AUTO_INCREMENT,
  `uid` varchar(100) NOT NULL,
  `userid` varchar(255) NOT NULL, -- **사용자 고유 식별 번호 컬럼 추가 쿼리 : alter table `tb_user` add `uid` varchar(100) NOT NULL after `board_idx` ;
  `reg_no` varchar(30) NULL,
  `userpw` varchar(255) NOT NULL, -- **password -> userpw 이름 변경 쿼리 : alter table `tb_user` change `password` `userpw` varchar(255) NOT NULL;
  `user_name` varchar(255) NOT NULL, -- **name -> user_name 이름 변경 쿼리 : alter table `tb_user` change `name` `user_name` varchar(255) NOT NULL;
  `user_role` varchar(1) NULL,  -- 0 : 사용자, 1 : 최고 관리자(root), 2 : 부관리자, 3 : 정책 관리자
  `user_type` varchar(1) NOT NULL,
  `youthAge_code` varchar(1) NULL,
  `parentsAge_code` varchar(1) NULL,
  `sex_class_code` varchar(1) NULL,
  `emd_class_code` varchar(2) NULL,
  `user_email` varchar(50) NULL,
  `salt` varchar(255) NOT NULL,
  `fig` varchar(4) NOT NULL DEFAULT 0, 
  `token_temp` VARCHAR(100) NULL, -- **사용자 토큰 추가 커리 : alter table `tb_user` add `token_temp` varchar(100) NULL after `fig` ;
  `del_chk` varchar(1) NOT NULL DEFAULT 'N',
  `ins_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `upd_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  -- PRIMARY KEY (`board_idx`) USING BTREE 
  PRIMARY KEY (`board_idx`, `uid`) USING BTREE


) ENGINE=InnoDB DEFAULT CHARSET=utf8;
-- 최고 관리자 id 설정 - 아이디 : admin, 비밀번호 : 1234
insert into tb_user (userid, uid, userpw, user_name, user_role, user_type, salt) values ('admin', '7f06c817-d8ee-43be-be7b-226c0a4d3432', 'NNNq1ZZBr3kfAIhMCxsxAn7LWe73aPjZEblZHtFPn0DNysXK8qGUXBewTNhkFzeaaBmS0qi2sWws89Ra/iTNjaQrZjIzkRswFLOy5qhOGWa6CKujexk8L/Yv07wMTGRF2ZTK8301Z5QLqawDWjTgt5hyUtabSK0kmS06+s1VAHg=', 'admin', '1', '0', 'yFfmKDozNt6TLMf+9tOni7zbrnqTOZqZWmF1i57q2rNMS5pMlxqAVdiJwPyVWBDKYT5G6wa4V389/tsSS/Ydeg==');

-- 기존 테이블에서 PK 추가 :  uid
-- alter table `webdb`.`tb_user` add primary key `uid`;
-- ALTER TABLE webdb.tb_user DROP PRIMARY KEY, ADD PRIMARY KEY (board_idx, uid); 실행

-- 정책 정보
CREATE TABLE webdb.`tb_policy` (
  `board_idx` int(11) NOT NULL AUTO_INCREMENT,
  `uid` VARCHAR(100) NOT NULL, -- 정책 고유 번호 컬럼 추가 쿼리 : alter table `tb_policy` add `uid` varchar(100) NOT NULL after `board_idx` ; // pid로 이름 변경
  `policy_name` varchar(50) NOT NULL,
  `policy_target_code` varchar(2) NOT NULL,
  `policy_institution_code` varchar(2) NOT NULL,
  `description` longtext NULL,
  `policy_field_code` varchar(2) NOT NULL,
  `policy_character_code` varchar(2) NOT NULL,
  `del_chk` varchar(1) NOT NULL DEFAULT 'N',
  `policy_link` varchar(100) NULL,
  `application_start_date` timestamp NULL,
  `application_end_date` timestamp NULL,
  `count_scraps` int(4) NOT NULL DEFAULT 0,
  -- **is_scrap 컬럼 삭제 : alter table tb_policy drop is_scrap;
  `count_views` int(4) NOT NULL DEFAULT 0, 
  `min_fund` int(10) NOT NULL,
  `max_fund` int(10) NOT NULL,
  `content` varchar(1000) NULL,
  `img` varchar(30) NULL,
  `register_uid` varchar(100) NULL,
  `ins_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `upd_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`board_idx`, `uid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
-- **기존 테이블에서 PK 추가 : uid
-- alter table `webdb`.`tb_policy` add primary key `uid`;



-- 공통 코드 설계
create table webdb.`tb_common_code`(
  `code` varchar(2) NOT NULL,
  `code_name` varchar(30) NOT NULL,
  `code_english_name` varchar(30) NULL,
  `code_desc` varchar(100) NULL,
  `code_use_yn` varchar(1) NOT NULL DEFAULT 'Y',
  PRIMARY KEY (`code`) USING BTREE 
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
-- 공통 코드 유형
insert into tb_common_code (code,code_name,code_english_name) values('01','사용자 유형','user_type');
insert into tb_common_code (code,code_name,code_english_name) values('02','청소년/청소년부모 나이','youthAge_code');
insert into tb_common_code (code,code_name,code_english_name) values('03','학부모  나이 코드','parentsAge_code');
insert into tb_common_code (code,code_name,code_english_name) values('04','성별','sex_class_code');
insert into tb_common_code (code,code_name,code_english_name) values('05','읍면동','emd_class_code');
insert into tb_common_code (code,code_name,code_english_name) values('06','정책 대상','policy_target_code');
insert into tb_common_code (code,code_name,code_english_name) values('07','기관','policy_institution_code');
insert into tb_common_code (code,code_name,code_english_name) values('08','분야','policy_field_code');
insert into tb_common_code (code,code_name,code_english_name) values('09','정책 성격','policy_character_code');
insert into tb_common_code (code,code_name,code_english_name) values('10','탈퇴 사유','withdrawal_reason_code');
insert into tb_common_code (code,code_name,code_english_name) values('11','질문 유형','inquiry_type_code'); -- 고객센터 질문 유형 코드 추가

-- 공통 코드 설계
create table webdb.`tb_common_code_detail`(
  `code` varchar(2) NOT NULL,
  `code_detail` varchar(2) NOT NULL,
  `code_detail_name` varchar(30) NOT NULL,
  `code_detail_desc` varchar(100) NULL,
  `code_detail_use_yn` varchar(1) NOT NULL DEFAULT 'Y',
  PRIMARY KEY (`code`,`code_detail`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
-- 공통 코드 유형
insert into tb_common_code_detail (code,code_detail,code_detail_name) values('01','0','청소년'),('01','1','청소년 부모'),('01','2','학부모');
insert into tb_common_code_detail (code,code_detail,code_detail_name) values('02','0','초등학교'),('02','1','중학교'),('02','2','고등학교'),('02','3','대학교'),('02','4','기타(학교밖)'),('02','5','선택 안함'); 
insert into tb_common_code_detail (code,code_detail,code_detail_name) values('03','0','10대'),('03','1','20대'),('03','2','30대'),('03','3','40대'),('03','4','50대'),('03','5','60대 이상'),('03','6','선택 안함');
insert into tb_common_code_detail (code,code_detail,code_detail_name) values('04','0','남자'),('04','1','여자'),('04','2','선택 안함');
insert into tb_common_code_detail (code,code_detail,code_detail_name) values('05','00','영암읍'),('05','01','삼호읍'),('05','02','덕진면'),('05','03','금정면'),('05','04','신북면'),('05','05','시종면'),('05','06','도표면'),('05','07','군서면'),('05','08','서호면'),('05','09','학산면'),('05','10','미암면');
insert into tb_common_code_detail (code,code_detail,code_detail_name) values('06','00','부부/임산부'),('06','01','영유아'),('06','02','청소년/학생'),('06','03','청년/대학생'),('06','04','직장인'),('06','05','중장년'),('06','06','노인'),('06','07','선택 안함');
insert into tb_common_code_detail (code,code_detail,code_detail_name) values('07','00','영암군'),('07','01','청소년 수련관'),('07','02','방과후 아카데미'),('07','03','청소년상담복지센터'),('07','04','학교밖지원센터'),('07','05','삼호읍청소년문화의집');
insert into tb_common_code_detail (code,code_detail,code_detail_name) values('08','00','학업'),('08','01','상담'),('08','02','취업/이직'),('08','03','생활비'),('08','04','건강'),('08','05','주거'),('08','06','결혼/양육'),('08','07','청소년활동'),('08','08','학교밖청소년'),('08','09','돌봄');
insert into tb_common_code_detail (code,code_detail,code_detail_name) values('09','00','지원.보조금/연금'),('09','01','도움/서비스'),('09','02','장학제도'),('09','03','분양/임대'),('09','04','공모전'),('09','05','대출/금융');
insert into tb_common_code_detail (code,code_detail,code_detail_name) values('10','00','앱 사용법을 모르겠어요'),('10','01','더이상 쓰지 않는 앱이에요'),('10','02','불편해요'),('10','03','앱 속도가 너무 느려요'),('10','04','보안이 걱정돼요'),('10','05','오류 때문에 쓸 수 없어요'),('10','06','알림이 너무 많아요'),('10','07','기타(텍스트 입력)');
insert into tb_common_code_detail (code,code_detail,code_detail_name) values('11','00','이용 문의'),('11','01','불편 사항'),('11','02','오류 신고'),('11','03','기타'); -- 고객센터 질문 유형 코드 추가


-- 이용 약관
CREATE TABLE webdb.`tb_terms` (
  `board_idx` int(11) NOT NULL AUTO_INCREMENT,
  `terms` text NOT NULL,
  `privacy` text NOT NULL,
  `ins_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `upd_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`board_idx`) USING BTREE 
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
insert into tb_terms (terms,privacy) value('회원 가입 약관','개인 정보 처리 방침');

-- 배너 정보
CREATE TABLE webdb.`tb_banner` (
  `board_idx` int(11) NOT NULL AUTO_INCREMENT,
  `banner_name` varchar(30) NULL,
  `banner_img` varchar(30) NOT NULL,
  `banner_link` varchar(100) NULL,
  `ins_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `upd_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`board_idx`) USING BTREE 
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 무화과 사용 내역
CREATE TABLE webdb.`tb_fig_usage`(
  `fig_usage_no` int(11) NOT NULL AUTO_INCREMENT,
  `pid` varchar(100) NOT NULL,
  `uid` varchar(100) NOT NULL,
  `fig_used_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`fig_usage_no`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 무화과 잡화점 상품 정보
CREATE TABLE webdb.`tb_product`(
  `board_idx` int(11) NOT NULL AUTO_INCREMENT,
  `pid` varchar(100) NOT NULL,
  `product_name` varchar(100) NOT NULL,
  `product_cost` varchar(4) NOT NULL,
  `product_img` varchar(100) NOT NULL,
  -- `product_desc` varchar(255) NOT NULL,
  -- `product_category` varchar(100) NOT NULL,
  `product_stock` varchar(4) NOT NULL,
  -- `product_sales` int(11) NOT NULL, -- 판매량 
  -- `product_like` int(11) NOT NULL, 
  `product_reg_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `product_update_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`board_idx`) USING BTREE 
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 이벤트 정보
CREATE TABLE webdb.`tb_event`(
  `board_idx` int(11) NOT NULL AUTO_INCREMENT,
  `eid` varchar(100) NOT NULL,
  `event_name` varchar(100) NOT NULL,
  `fig_payment` varchar(4) NOT NULL,
  `event_start_date` timestamp NOT NULL,
  `event_end_date` timestamp NOT NULL,
  `event_reg_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `event_update_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`board_idx`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
insert into webdb.tb_event (eid,event_name,fig_payment,event_start_date,event_end_date) values('1','출석체크','1','2023-07-05 00:00:00','2023-08-01 00:00:00'),('2','웰컴 청소년 톡talk','10','2023-07-05 00:00:00','2023-07-11 00:00:00'),('3','정책 스크랩','2','2023-07-12 00:00:00','2023-07-18 00:00:00'),('4','정책 공유','3','2023-07-19 00:00:00','2023-07-25 00:00:00'),('5','친구 초대','3','2023-07-05 00:00:00','2023-08-01 00:00:00'),('6','추천인 입력','10','2023-07-05 00:00:00','2023-08-01 00:00:00');
-- insert into webdb.tb_event (eid,event_name,fig_payment,event_start_date,event_end_date) values('1','출석체크','1','2023-07-05 00:00:00','2023-08-01 00:00:00'),('2','웰컴 청소년 톡talk','10','2023-07-05 00:00:00','2023-07-11 00:00:00'),('3','톡talk 알림 허용','2','2023-07-12 00:00:00','2023-07-18 00:00:00'),('4','정책 스크랩','3','2023-07-19 00:00:00','2023-07-25 00:00:00'),('5','정책 공유','3','2023-07-26 00:00:00','2023-08-01 00:00:00'),('6','친구 초대','3','2023-07-05 00:00:00','2023-08-01 00:00:00'),('7','추천인 입력','10','2023-07-05 00:00:00','2023-08-01 00:00:00');

CREATE TABLE webdb.`tb_event_part`(
  `event_part_no` int(11) NOT NULL AUTO_INCREMENT,
  `eid` varchar(100) NOT NULL,
  `uid` varchar(100) NOT NULL,
  `acquired_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 오타 aquired -> acquired
  PRIMARY KEY (`event_part_no`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 출석 체크 기록
CREATE TABLE tb_attendance_logs (
  -- `uid_attendance` VARCHAR(100) PRIMARY KEY,
  `user_uid` VARCHAR(100) NOT NULL,
  `attendance_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  -- PRIMARY KEY (user_uid, attendance_date),
  FOREIGN KEY(user_uid) REFERENCES webdb.`tb_user`(`uid`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 기존 tb_policy_scrap drop
-- 쿼리 : drop table tb_policy_scrap;
/* 
CREATE TABLE webdb.`tb_policy_scrap` (
  `board_idx` int(11) NOT NULL AUTO_INCREMENT,
  `policy_idx` int(11) NOT NULL,
  `user_idx` int(11) NOT NULL,
  `ins_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `upd_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`board_idx`) USING BTREE 
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
*/


-- 정책 스크랩 (new)
-- add index (tb_policy와 tb_user의 uid 컬럼을 Foregin key로 가져오기 위해)
ALTER TABLE `tb_user` ADD INDEX (`uid`);
ALTER TABLE `tb_policy` ADD INDEX (`uid`);

CREATE TABLE webdb.`tb_policy_scrap`
(
	`uid_scraps` VARCHAR(100) PRIMARY KEY,
	`user_uid` VARCHAR(100) NOT NULL,
	`policy_uid` VARCHAR(100) NOT NULL,
  `is_scrapped` BOOL NOT NULL DEFAULT 0,
	`ins_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `upd_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	
	FOREIGN KEY(user_uid) REFERENCES webdb.`tb_user`(`uid`),
	FOREIGN KEY(policy_uid) REFERENCES webdb.`tb_policy`(`uid`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 탈퇴 내역
create table webdb.`tb_withdrawal_logs`(
  `board_idx` int(11) NOT NULL AUTO_INCREMENT,
  `withdrawal_reason_code` varchar(2) not null,
  `withdrawal_date` timestamp not null default current_timestamp,
  `etc` varchar(200) null,
  PRIMARY KEY (`board_idx`) USING BTREE
)engine=InnoDB default charset=utf8;

-- 공지사항
create table webdb.`tb_notice`(
  `board_idx` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `content` varchar(500) NOT NULL,
  `register_uid` varchar(100) NOT NULL,
  `ins_date` timestamp not null default current_timestamp,
  PRIMARY KEY (`board_idx`) USING BTREE
)engine=InnoDB default charset=utf8;

-- 고객센터 문의
create table webdb.`tb_inquiry`(
  `board_idx` int(11) NOT NULL AUTO_INCREMENT,
  `inquiry_type_code` varchar(2) NOT NULL,
  `content` varchar(200) NOT NULL,
  `register_email` varchar(50) NOT NULL,
  `ins_date` timestamp not null default current_timestamp,
  PRIMARY KEY (`board_idx`) USING BTREE
)engine=InnoDB default charset=utf8;

-- 외래 키 제약 조건 삭제
-- ALTER TABLE tb_policy_scrap DROP FOREIGN KEY 외래_키_제약_조건_이름;
ALTER TABLE tb_policy_scrap DROP FOREIGN KEY tb_policy_scrap_ibfk_1;
ALTER TABLE tb_attendance_logs DROP FOREIGN KEY tb_attendance_logs_ibfk_1;


