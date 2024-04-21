import "@typespec/http";
import "@typespec/rest";
import "@typespec/openapi3";
import "@typespec/versioning";

import "./models.tsp";

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;

/**
 * Aroundy 앱 및 어드민 페이지 공용 API
 */
@service({
	title: "Aroundy",
})
@server("https://api.aroundy.teambigbox.com", "엔드포인트")
@versioned(Aroundy.Versions)
namespace Aroundy;

enum Versions {
	v0_1_0: "v0.1.0",
	v1_0_0: "v1.0.0",
}

@route("/posts")
namespace Posts {
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

	/**
	 * Post 목록을 추천 기준에 따라 조회 및 검색한다.
	 * */
	@summary("Post 조회 및 검색")
	@tag("App")
	op fetchPosts(
		/** 한정할 카테고리 */
		@query category?: string,

		/** 추천 기준 */
		@query sort?: SortOption,

		/** 브랜드 한정 필터 */
		@query({
			format: "csv",
		})
		companies?: string[],

		/** 최소 가격 필터
		 *
		 * 단위는 10k KRW
		 * */
		@query priceMin?: uint64,

		/** 최대 가격 필터
		 *
		 * 단위는 10k KRW
		 * */
		@query priceMax?: uint64,

		/** 지역 필터
		 *
		 * - 전체
		 * - 서울
		 * - 경기
		 * - 인천
		 * - 강원
		 * - 세종
		 * - 대전
		 * - 충북
		 * - 충남
		 * - 부산
		 * - 대구
		 * - 울산
		 * - 경북
		 * - 경남
		 * - 광주
		 * - 전북
		 * - 전남
		 * - 제주
		 * */
		@query({
			format: "csv",
		})
		location?: string[],

		/**
		 * 이벤트 상태 필터
		 *
		 * - `undefined`: 상태 무관
		 * - `true`: 종료된 이벤트만
		 * - `false`: 진행 중인 이벤트만
		 * */
		@query ended?: boolean,
	): {
		@header("X-Total-Records") totalRecords: uint64;
		...Paginate<Post>;
	};

	@summary("새 Post 등록")
	op createPost(...CreatePost): {
		@statusCode _: 201;
		...Post;
	};

	@summary("Post 수정")
	@patch
	op updatePost(@path id: string, ...UpdatePost): Post;

	@summary("좋아요 추가")
	@tag("App")
	@route("/{id}/like")
	@patch
	op like(@path id: string): void;

	@summary("좋아요 해제")
	@tag("App")
	@route("/{id}/unlike")
	@patch
	op unlike(@path id: string): void;

	@summary("마이페이지에 저장")
	@tag("App")
	@route("/{id}/save")
	@patch
	op save(@path id: string): void;

	@summary("마이페이지에서 저장 취소")
	@tag("App")
	@route("/{id}/unsave")
	@patch
	op unsave(@path id: string): void;

	@summary("조회수 증가")
	@tag("App")
	@route("/{id}/view")
	@patch
	op view(@path id: string): void;

	@summary("Post 삭제")
	@delete
	op deletePost(@path id: string): Post;
}
