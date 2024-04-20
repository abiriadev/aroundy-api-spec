import "@typespec/http";
import "@typespec/rest";
import "@typespec/openapi3";

import "./models.tsp";

using TypeSpec.Http;
using TypeSpec.Rest;

/**
 * Aroundy 앱 및 어드민 페이지 공용 API
 */
@service({
	title: "Aroundy",
})
@server("https://api.aroundy.teambigbox.com", "엔드포인트")
namespace Aroundy;

op fetchPosts(): Post[];
