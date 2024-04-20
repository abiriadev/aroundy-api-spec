model Post {
	/** Post의 고유 ID */
	id: string;

	/** 제목 */
	title: string;

	/** 카테고리 */
	category: string;

	/** Post를 등록한 기업 */
	company: string;

	/** 피드 배너 이미지 목록 */
	feeds: string[];

	/** Post 상세 내용 */
	caption: string;

	/** 이벤트 유형 */
	type: string;

	/** 상세주소 */
	location: string;

	/** 연락처 */
	contact: string;

	/** 오픈일 */
	startsAt: utcDateTime;

	/** 종료일 */
	endsAt: utcDateTime;

	/** 출처 링크 */
	link: string;

	/** 태그 목록 */
	tags: string[];

	/** 좋아요 수 */
	likes: uint64;

	/** 조회수 */
	views: uint64;

	/** 현재 로그인된 사용자가 이미 좋아요한 Post인지 여부 */
	isLiked: boolean;
}

model Company {
	/** 기업 고유 ID */
	id: string;

	/** 기업명 */
	name: string;

	/** 기업 로고 */
	logo: string;

	/** 상태 */
	status: string;
}
