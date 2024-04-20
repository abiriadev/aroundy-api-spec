model Post {
	/** Post의 고유 ID */
	id: string;

	/** 제목 */
	title: string;

	/** 카테고리 */
	category: string;

	/** Post를 등록한 회사 */
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
}
