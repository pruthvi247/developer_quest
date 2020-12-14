[source: https://stackoverflow.com/questions/54321180/error-could-not-find-included-file-generated-xcconfig-in-search-paths-in-tar?rq=1]


I assume you have already ios/ folder in your Flutter project. If not, you can run flutter build ios.

The root cause of this error most of the times happens after you have cloned a project like from Github.

In order to fix, you need to get the packages and install the pods.

flutter clean && flutter pub get && cd ios/ && pod install 
(In some situation you might need to update your Pod Repo and Pods. You can do that via running pod repo update && pod update)
