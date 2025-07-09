import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone_app/models/tweet.dart';
import 'package:twitter_clone_app/providers/user_provider.dart';

final feddProvider = StreamProvider.autoDispose<List<Tweet>>((ref) {
  final firestore = FirebaseFirestore.instance;
  return firestore.collection("tweets").orderBy("timestamp", descending: true).snapshots().map((event) {
    List<Tweet> tweets = [];

    for (int i = 0; i < event.docs.length; i++) {
      tweets.add(Tweet.fromMap(event.docs[i].data()));
    }

    return tweets;
  });
});

final tweetProvider = Provider<TwitterApi>((ref){
  return TwitterApi(ref);
});

class TwitterApi{
  TwitterApi(this.ref);
  final Ref ref;

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  Future<void> postTweet(String content) async {
    LocalUser currentUser = ref.read(userProvider);
    await _fireStore.collection("tweets").add(Tweet(
      userId: currentUser.id,
      profilePicture: currentUser.user.profilePictureUrl,
      name: currentUser.user.name,
      content: content,
      timestamp: Timestamp.now(),
    ).toMap());
  }
}
