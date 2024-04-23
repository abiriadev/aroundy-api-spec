import "@typespec/http";
import "@typespec/rest";
import "@typespec/openapi3";
import "@typespec/versioning";

import "./models.tsp";
import "./utils.tsp";

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

	/** 검색 옵션 */
	model QueryOption {
		/** 한정할 카테고리 */
		@query category?: string;

		/** 추천 기준 */
		@query sort?: SortOption;

		/** 브랜드 한정 필터 */
		@query({
			format: "csv",
		})
		companies?: string[];

		/** 최소 가격 필터
		 *
		 * 단위는 10k KRW
		 * */
		@query priceMin?: uint64;

		/** 최대 가격 필터
		 *
		 * 단위는 10k KRW
		 * */
		@query priceMax?: uint64;

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
		location?: string[];

		/**
		 * 이벤트 상태 필터
		 *
		 * - `undefined`: 상태 무관
		 * - `true`: 종료된 이벤트만
		 * - `false`: 진행 중인 이벤트만
		 * */
		@query ended?: boolean;

		/**
		 * 검색어
		 *
		 * 초성 검색 지원
		 * */
		@query search?: string;
	}

	/**
	 * Post 목록을 추천 기준에 따라 조회 및 검색한다.
	 * */
	@summary("Post 조회 및 검색")
	@tag("App")
	op fetchPosts(...QueryOption): Paginate<Post>;

	@summary("새 Post 등록")
	@useAuth(BearerAuth)
	op createPost(...CreatePost): {
		@statusCode _: 201;
		...Post;
	};

	@summary("Post 수정")
	@useAuth(BearerAuth)
	@patch
	op updatePost(...ById, ...UpdatePost): Post;

	@summary("좋아요 추가")
	@tag("App")
	@useAuth(BearerAuth)
	@route("/{id}/like")
	@patch
	op like(...ById): void;

	@summary("좋아요 해제")
	@route("/{id}/unlike")
	op unlike is like;

	@summary("마이페이지에 저장")
	@route("/{id}/save")
	op save is like;

	@summary("마이페이지에서 저장 취소")
	@route("/{id}/unsave")
	op unsave is like;

	@summary("조회수 증가")
	@tag("App")
	@route("/{id}/view")
	@patch
	op view(...ById): void;

	@summary("Post 삭제")
	@useAuth(BearerAuth)
	@delete
	op deletePost(...ById): Post;
}

@route("/companies")
namespace Companies {
	/**
	 * 기업 목록을 추천 기준에 따라 조회 및 검색한다.
	 * */
	@summary("기업 조회 및 검색")
	@tag("App")
	op fetchCompanies(
		/**
		 * 검색어
		 *
		 * 초성 검색 지원
		 * */
		@query search?: string,
	): Paginate<Company>;

	@summary("새 기업 등록")
	@useAuth(BearerAuth)
	op createCompany(...BaseCompany): {
		@statusCode _: 201;
		...Company;
	};

	@summary("기업정보 수정")
	@useAuth(BearerAuth)
	@patch
	op updateCompany(...ById, ...UpdateCompany): Company;

	@summary("기업정보 삭제")
	@useAuth(BearerAuth)
	@delete
	op deleteCompany(...ById): Company;
}

@summary("이미지 업로드")
@useAuth(BearerAuth)
@route("/images/upload")
op uploadImage(
	@header contentType: "multipart/form-data",

	/** 업로드할 이미지 정보 배열 */
	images: Image[],
): {
	@statusCode _: 201;

	/** 업로드된 이미지 URL 배열 */
	urls: url[];
};

@tag("App")
@route("/login")
namespace Login {
	@summary("카카오 로그인")
	@route("/kakao")
	op kakao(): {};
}

@route("/users")
namespace Users {
	@summary("회원 조회 및 검색")
	op fetchUsers(
		/**
		 * 검색어
		 *
		 * 초성 검색 지원
		 * */
		@query search?: string,
	): Paginate<User>;

	@summary("회원정보 수정")
	@tag("App")
	@tag("Admin")
	@useAuth(BearerAuth)
	@patch
	op updateUser(
		...ById,
		...OptionalProperties<BaseUser>,
	): User;

	@summary("회원 탈퇴")
	@useAuth(BearerAuth)
	@delete
	op deleteUser(...ById): void;
}
