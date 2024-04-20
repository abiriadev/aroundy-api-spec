/** Post 정보 */
model Post {
	/** Post의 고유 ID */
	@format("uuid")
	id: string;

	/** 제목 */
	title: string;

	/** 카테고리 */
	category: string;

	/** Post를 등록한 기업 */
	company: Company;

	/** 피드 배너 이미지 목록 */
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

	/** 좋아요 수 */
	likes: uint64;

	/** 조회수 */
	views: uint64;

	/** 현재 로그인된 사용자가 이미 좋아요한 Post인지 여부 */
	isLiked: boolean;
}

/** 기업 정보 */
model Company {
	/** 기업 고유 ID */
	@format("uuid")
	id: string;

	/** 기업명 */
	name: string;

	/** 기업 로고 */
	logo: url;

	/** 상태 */
	status: string;
}

/** 이벤트 유형 */
enum EventType {
	/** 온라인 */
	Online,

	/** 오프라인 */
	Offline,

	/** 온/오프라인 */
	Both,
}
