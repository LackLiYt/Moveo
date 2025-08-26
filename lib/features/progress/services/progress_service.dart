import 'package:moveo/models/user_model.dart';

class ProgressService {
  // Points for different activities
  static const int POINTS_PER_POST = 10;
  static const int POINTS_PER_LIKE = 1;
  static const int POINTS_PER_COMMENT = 2;
  static const int POINTS_PER_FOLLOWER = 5;
  static const int POINTS_PER_DAILY_LOGIN = 5;
  
  // Experience for different activities
  static const int EXP_PER_POST = 20;
  static const int EXP_PER_LIKE = 2;
  static const int EXP_PER_COMMENT = 5;
  static const int EXP_PER_FOLLOWER = 10;
  static const int EXP_PER_DAILY_LOGIN = 15;
  
  // Update user progress for creating a post
  UserModel updateProgressForPost(UserModel user) {
    return user
      .addPoints(POINTS_PER_POST)
      .addExperience(EXP_PER_POST);
  }
  
  // Update user progress for receiving a like
  UserModel updateProgressForLike(UserModel user) {
    return user
      .addPoints(POINTS_PER_LIKE)
      .addExperience(EXP_PER_LIKE);
  }
  
  // Update user progress for adding a comment
  UserModel updateProgressForComment(UserModel user) {
    return user
      .addPoints(POINTS_PER_COMMENT)
      .addExperience(EXP_PER_COMMENT);
  }
  
  // Update user progress for daily login
  UserModel updateProgressForDailyLogin(UserModel user) {
    return user
      .addPoints(POINTS_PER_DAILY_LOGIN)
      .addExperience(EXP_PER_DAILY_LOGIN);
  }
  
  // Update user progress for steps
  UserModel updateProgressForSteps(UserModel user, int steps, {int? previousSteps}) {
    // Only add new steps if they've increased
    int newSteps = 0;
    if (previousSteps != null && steps > previousSteps) {
      newSteps = steps - previousSteps;
    } else if (previousSteps == null) {
      newSteps = steps;
    }
    
    // Convert new steps to points and experience
    int pointsFromSteps = (newSteps / 100).floor(); // 1 point per 100 steps
    int expFromSteps = (newSteps / 50).floor(); // 1 exp per 50 steps
    
    return user
      .addPoints(pointsFromSteps)
      .addExperience(expFromSteps);
  }

  // Update user progress for follower
  UserModel updateProgressForFollower(UserModel user) {
    return user
      .addPoints(POINTS_PER_FOLLOWER)
      .addExperience(EXP_PER_FOLLOWER);
  }
} 