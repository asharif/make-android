# tested with android build tools 19
default:
	@echo "make-android - usage: make [r-support | r | classes | classes-debug | dx | apk | apk-debug | clean]"

r-support:
	@mkdir -p bin/generated/
	@aapt p --auto-add-overlay -m \
		-M $(ANDROID_HOME)/extras/android/support/v7/appcompat/AndroidManifest.xml \
	 	-I $(ANDROID_HOME)/platforms/android-19/android.jar \
	 	-S $(ANDROID_HOME)/extras/android/support/v7/appcompat/res/ \
		-S $(ANDROID_HOME)/extras/google/google_play_services/libproject/google-play-services_lib/res/ \
		-J bin/generated/ 1>/dev/null

r:
	@mkdir -p bin/generated/
	@aapt p --auto-add-overlay -m \
		-M src/main/AndroidManifest.xml \
	 	-I $(ANDROID_HOME)/platforms/android-19/android.jar \
		-S src/main/res/ \
	 	-S $(ANDROID_HOME)/extras/android/support/v7/appcompat/res/ \
		-S $(ANDROID_HOME)/extras/google/google_play_services/libproject/google-play-services_lib/res/ \
		-J bin/generated/ 1>/dev/null
	
classes:
	@mkdir -p bin/classes/
	@javac -encoding ascii -Xlint:deprecation -target 1.7 -d bin/classes \
		-cp $(ANDROID_HOME)/platforms/android-19/android.jar:$(ANDROID_HOME)/extras/google/google_play_services/libproject/google-play-services_lib/libs/google-play-services.jar:$(ANDROID_HOME)/extras/android/support/v7/appcompat/libs/android-support-v7-appcompat.jar:$(ANDROID_HOME)/extras/android/support/v7/appcompat/libs/android-support-v4.jar `find src/ -iname *.java` `find bin/generated/ -iname *.java` 1>/dev/null

classes-debug:
	@mkdir -p bin/classes/
	@javac -encoding ascii -g -Xlint:deprecation -target 1.7 -d bin/classes \
		-cp $(ANDROID_HOME)/platforms/android-19/android.jar:$(ANDROID_HOME)/extras/google/google_play_services/libproject/google-play-services_lib/libs/google-play-services.jar:$(ANDROID_HOME)/extras/android/support/v7/appcompat/libs/android-support-v7-appcompat.jar:$(ANDROID_HOME)/extras/android/support/v7/appcompat/libs/android-support-v4.jar `find src/ -iname *.java` `find bin/generated/ -iname *.java` 1>/dev/null

dx: 
	@dx --dex --output=bin/classes.dex \
		bin/classes/ $(ANDROID_HOME)/extras/google/google_play_services/libproject/google-play-services_lib/libs/google-play-services.jar $(ANDROID_HOME)/extras/android/support/v7/appcompat/libs/android-support-v7-appcompat.jar $(ANDROID_HOME)/extras/android/support/v7/appcompat/libs/android-support-v4.jar 1>/dev/null

apk:
	@aapt p --auto-add-overlay -f \
	-M src/main/AndroidManifest.xml \
	-I $(ANDROID_HOME)/platforms/android-19/android.jar \
	-S src/main/res/ \
	-S $(ANDROID_HOME)/extras/android/support/v7/appcompat/res/ \
	-S $(ANDROID_HOME)/extras/google/google_play_services/libproject/google-play-services_lib/res/ \
	-F bin/AerServSampleApp.unaligned 1>/dev/null
	@cd bin/; aapt add -f MyApp.unaligned classes.dex
	@jarsigner -storepass password -sigalg SHA1withRSA -digestalg SHA1 -keystore ../../Keys/keystore bin/MyApp.unaligned sdk
	@zipalign -f 4 bin/MyApp.unaligned bin/MyApp.apk

apk-debug:
	@aapt p --debug-mode --auto-add-overlay -f \
	-M src/main/AndroidManifest.xml \
	-I $(ANDROID_HOME)/platforms/android-19/android.jar \
	-S src/main/res/ \
	-S $(ANDROID_HOME)/extras/android/support/v7/appcompat/res/ \
	-S $(ANDROID_HOME)/extras/google/google_play_services/libproject/google-play-services_lib/res/ \
	-F bin/MyApp.unaligned 1>/dev/null
	@cd bin/; aapt add -f MyApp.unaligned classes.dex
	@jarsigner -storepass password -sigalg SHA1withRSA -digestalg SHA1 -keystore ../../Keys/keystore bin/MyApp.unaligned sdk
	@zipalign -f 4 bin/MyApp.unaligned bin/MyApp.apk
	
clean:
	@rm -rf bin/
