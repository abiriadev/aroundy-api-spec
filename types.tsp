/** 고유 ID */
@format("uuid")
scalar id extends string;

/**
 * 이벤트 유형
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

/**
 * 회원 성별
 *
 * - `Woman`: 여성
 * - `Man`: 남성
 * - `Other`: 기타
 */
enum Gender {
	Woman,
	Man,
	Other,
}

/** Post 추천 기준
 *
 * - `recommended`: 추천순
 * - `latest`: 게시순
 * - `deadline`: 마감순
 * - `higherDiscount`: 높은 할인순
 * - `lowserDiscount`: 낮은 할인순
 * - `higherPrice`: 높은 가격순
 * - `lowserPrice`: 낮은 가격순
 * - `farthest`: 먼 거리순
 * - `nearest`: 가까운 거리순
 * */
enum SortOption {
	recommended,
	latest,
	deadline,
	higherDiscount,
	lowserDiscount,
	higherPrice,
	lowserPrice,
	farthest,
	nearest,
}
