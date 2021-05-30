import 'package:demo_itunes_music/core_component/api_repositories/graphql_client.dart';
import 'package:demo_itunes_music/core_component/api_repositories/graphql_queries.dart';
import 'package:demo_itunes_music/modules/itunesListPage/model/music_item_list_model.dart';
import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphqlService {
  GraphqlService();

  static debugPrint(dynamic printText) {
    if (kDebugMode) print(printText);
  }

  /// get category details
  Future<MusicItemListModel> getSearchResult({
    String term,
  }) async {
    debugPrint(
        '//////////////////fetching getSearchResult data from query..... ${GraphqlQueries.getSearchResult(
      term: term,
    )}////////////////////////');
    QueryResult result = await getGraphqlClient(
      searchBy: term,
    ).then(
      (value) => value.value.query(
        QueryOptions(
          fetchPolicy: FetchPolicy.networkOnly,
          documentNode: gql(GraphqlQueries.getSearchResult(
            term: term,
          )),
        ),
      ),
    );
    debugPrint('fetching getSearchResult from API..... ${result.data}');
    // if (result.hasException) {
    //   return ApiResponse.graphqlError(result.exception.clientException);
    // } else {
    //   return ApiResponse<ProductCategoryListModel>.completed(
    //       ProductCategoryListModel.fromJson(result.data['getCategoryDetails']));
    return MusicItemListModel.fromJson(result.data);
    // }
  }
}
