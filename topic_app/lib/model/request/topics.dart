class TopicRequestModel {
  String id;
  String title;
  String detail;
  String parentId;


  TopicRequestModel({
    required this.id,
    required this.title,
    required this.detail,
    required this.parentId,
  });

  toJson(){
    return {
      'Id': id, 'ParentId': parentId
    };
  }
}
