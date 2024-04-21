using TypeSpec.Http;

/** 고유 ID */
@format("uuid")
scalar id extends string;

/** 항목 수 헤더 래퍼 */
model TotalRecordsHeader<T> {
	/** 검색된 총 항목 수 */
	@header("X-Total-Records") totalRecords: uint64;

	...T;
}

/** 페이징 메타데이터 */
model Paginate<T> {
	/** 실제 데이터 */
	items: T[];

	/** 페이지 메타데이터 */
	page: {
		/** 검색된 총 항목 수 */
		totalRecords: uint64;

		/** 총 페이지 갯수 */
		totalPages: uint64;

		/** 현재 페이지에 포함된 항목 수 */
		pageSize: uint64;

		/** 다음 페이지 번호
		 *
		 * 현재 페이지가 마지막 페이지인 경우 `nextPage`는 `null`이 된다.
		 * */
		nextPage: uint64 | null;

		/** 다음 페이지에 나타날 항목 수
		 *
		 * 다음 페이지가 마지막 페이지일 경우 페이지 크기로 나누어 떨어지지 않는 값이 들어간다.
		 * 다음 페이지 로딩 전 표시할 스켈레톤 갯수를 맞추기 위해 사용한다.
		 * */
		nextRecords: uint64;
	};
}

/** 상속용 Post 클래스 */
model BasePost {
	/** 제목 */
	title: string;

	/** 카테고리 */
	category: string;

	/** 피드 배너 이미지 목록 */
	@maxItems(10)
	feeds: url[];

	/** Post 상세 내용 */
	@maxLength(2200)
	caption: string;

	/** 이벤트 유형 */
	type: EventType;

	/** 상세주소 */
	location: string | null;

	/** 연락처 */
	contact: string | null;

	/** 오픈일 */
	startsAt: utcDateTime | null;

	/** 종료일 */
	endsAt: utcDateTime | null;

	/** 출처 링크 */
	link: url | null;

	/** 태그 목록 */
	tags: string[];
}

/** Post 생성 시 입력할 정보 */
model CreatePost extends BasePost {
	/** Post를 생성할 기업의 ID */
	companyId: id;
}

/** Post 수정 시 입력할 정보 */
alias UpdatePost = OptionalProperties<BasePost>;

/** Post 정보 */
model Post extends BasePost {
	/** Post의 고유 ID */
	id: id;

	/** Post를 등록한 기업 */
	company: Company;

	/** 좋아요 수 */
	likes: uint64;

	/** 조회수 */
	views: uint64;

	/** 현재 로그인된 사용자가 이미 좋아요한 Post인지 여부 */
	isLiked: boolean;

	/** 현재 로그인된 사용자가 이미 마이페이지에 저장한 Post인지 여부 */
	isSaved: boolean;
}

/** 기업 정보 */
model Company {
	/** 기업 고유 ID */
	id: id;

	/** 기업명 */
	name: string;

	/** 기업 로고 */
	logo: url;

	/** 상태 */
	status: string;
}

/** 이벤트 유형
 *
 * - `online`: 온라인
 * - `offline`: 오프라인
 * - `both`: 온/오프라인
 * */
enum EventType {
	online,
	offline,
	both,
}
