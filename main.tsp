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
	/** 검색 옵션 */
	model QueryOption extends SearchByName {
		/** 한정할 카테고리 */
		@query category?: string;

		/** 추천 기준 */
		@query sort?: SortOption;

		/** 브랜드 한정 필터 */
		@query({
			format: "csv",
		})
		companies?: string[];

		/**
		 * 지역 필터
		 *
		 * 아무 값도 없을 때는 지역 무관
		 *
		 * 지역은 여러 개 선택 가능
		 */
		@query({
			format: "csv",
		})
		location?: Location[];

		/** 태그 한정 필터 */
		@query({
			format: "csv",
		})
		tags?: id[];

		/**
		 * 이벤트 상태 필터
		 *
		 * - `undefined`: 상태 무관
		 * - `true`: 종료된 이벤트만
		 * - `false`: 진행 중인 이벤트만
		 */
		@query ended?: boolean;
	}

	/** Post 목록을 추천 기준에 따라 조회 및 검색한다. */
	@summary("Post 조회 및 검색")
	@tag("App")
	@tag("Admin")
	op fetchPosts(...QueryOption): Paginate<Post>;

	@summary("새 Post 등록")
	@tag("Admin")
	@useAuth(BearerAuth)
	op createPost(...CreatePost): {
		@statusCode _: 201;
		...Post;
	};

	@summary("Post 수정")
	@tag("Admin")
	@useAuth(BearerAuth)
	@patch
	op updatePost(...ById, ...UpdatePost): Post;

	@tag("App")
	@useAuth(BearerAuth)
	@post
	op set<T = ById>(...T): void;

	@tag("App")
	@useAuth(BearerAuth)
	@delete
	op unset<T = ById>(...T): void;

	@route("/{id}/like")
	namespace Like {
		@summary("좋아요 추가")
		op like is set;

		@summary("좋아요 해제")
		op unlike is unset;
	}

	@route("/{id}/save")
	namespace Save {
		@summary("마이페이지에 저장")
		op save is set;

		@summary("마이페이지에서 저장 취소")
		op unsave is unset;
	}

	@summary("조회수 증가")
	@tag("App")
	@route("/{id}/view")
	@patch
	op view(...ById): void;

	@summary("Post 삭제")
	@tag("Admin")
	@useAuth(BearerAuth)
	@delete
	op deletePost(...ById): Post;
}

@tag("Admin")
@route("/companies")
namespace Companies {
	/** 기업 목록을 추천 기준에 따라 조회 및 검색한다. */
	@summary("기업 조회 및 검색")
	@tag("App")
	op fetchCompanies(...SearchByName): Paginate<Company>;

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
@tag("Admin")
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
	@useAuth(BearerAuth)
	@tag("Admin")
	op fetchUsers(...SearchByName): Paginate<User>;

	@summary("단일 회원정보 조회")
	@tag("App")
	@useAuth(BearerAuth)
	op fetchUser(...ById): User;

	@summary("회원 프로필 정보 조회")
	@tag("App")
	@useAuth(BearerAuth)
	@route("/{id}/profile")
	op profile(...ById): UserProfile;

	@summary("회원 개인정보 수정")
	@tag("App")
	@useAuth(BearerAuth)
	@patch
	op updateUser(...ById, ...UpdateUser): User;

	@summary("회원 탈퇴")
	@tag("App")
	@useAuth(BearerAuth)
	@delete
	op deleteUser(...ById): void;
}

@route("/categories")
namespace Categories {
	@summary("카테고리 생성")
	@tag("Admin")
	@useAuth(BearerAuth)
	op createCategory(...Category.Create): void;

	@summary("카테고리 조회 및 검색")
	@tag("App")
	@tag("Admin")
	op fetchCategories(
		...SearchByName,
	): Paginate<Category.Base>;
}

@route("/tags")
namespace Tags {
	@summary("태그 생성")
	@tag("Admin")
	@useAuth(BearerAuth)
	op createTag(...Tag.Create): void;

	@summary("태그 조회 및 검색")
	@tag("App")
	@tag("Admin")
	op fetchTags(...SearchByName): Paginate<Tag.Base>;
}
