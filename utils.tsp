import "./types.tsp";

using TypeSpec.Http;

model Identifiable {
	/** 고유 ID */
	id: id;
}

model ById {
	@path id: id;
}

/** 이름으로 검색하는 쿼리 */
model SearchByName {
	/**
	 * 검색어
	 *
	 * 초성 검색 지원
	 */
	@query search?: string;
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
