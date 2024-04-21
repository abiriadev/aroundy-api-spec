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
	/** Post 추천 기준 */
	enum SortOption {
		/** 추천순 */
		recommended,

		/** 게시순 */
		latest,

		/** 마감순 */
		deadline,

		/** 높은 할인순 */
		higherDiscount,

		/** 낮은 할인순 */
		lowserDiscount,

		/** 높은 가격순 */
		higherPrice,

		/** 낮은 가격순 */
		lowserPrice,

		/** 먼 거리순 */
		farthest,

		/** 가까운 거리순 */
		nearest,
	}

	@summary("Post 조회 및 검색")
	@tag("App")
	op fetchPosts(
		@query category?: string,
		@query sort?: SortOption,
	): Paginate<Post>;

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
	op like(@path id: string, ...UpdatePost): void;

	@summary("좋아요 해제")
	@tag("App")
	@route("/{id}/unlike")
	@patch
	op unlike(@path id: string, ...UpdatePost): void;

	@summary("조회수 증가")
	@tag("App")
	@route("/{id}/view")
	@patch
	op view(@path id: string, ...UpdatePost): void;

	@summary("Post 삭제")
	@delete
	op deletePost(@path id: string): Post;
}
