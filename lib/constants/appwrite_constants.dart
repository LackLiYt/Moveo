class AppwriteConstants {
  static const String databaseId = '6717aac9002fc50506d7'; 
  static const String projectId =  '6717a8f8000e772c5899';
  static const String endPoint = 'https://cloud.appwrite.io/v1';
  
  static const String usersCollectionId = '6793ffd70014bf79247d';
  static const String postCollectionId = '679f890c0025ddf0c58b';

  static const String imagesBucketId = '6796730c003d58e79e62';
  static String imageUrl(String imageId) => '$endPoint/storage/buckets/$imagesBucketId/files/$imageId/view?project=$projectId&mode=admin';
}