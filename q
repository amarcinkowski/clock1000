# Nadpisanie pliku build.gradle.kts z dodanymi importami i wersją NDK
cat > android/app/build.gradle.kts << 'EOF'
plugins {
    id("com.android.application")
    kotlin("android")
    id("dev.flutter.flutter-gradle-plugin")
}

import java.util.Properties
import java.io.FileInputStream

fun localProperties(): Properties {
    val localPropertiesFile = rootProject.file("local.properties")
    val properties = Properties()
    if (localPropertiesFile.exists()) {
        properties.load(FileInputStream(localPropertiesFile))
    }
    return properties
}

val flutterVersionCode by extra(localProperties().getProperty("flutter.versionCode", "1").toInt())
val flutterVersionName by extra(localProperties().getProperty("flutter.versionName", "1.0"))

android {
    ndkVersion = "27.0.12077973"
    namespace = "com.amarcinkowski.clock1000"
    compileSdk = flutter.compileSdkVersion.get()
    sourceSets {
        main.java.srcDirs("src/main/kotlin")
    }

    defaultConfig {
        applicationId = "com.amarcinkowski.clock1000"
        minSdk = flutter.minSdkVersion.get()
        targetSdk = flutter.targetSdkVersion.get()
        versionCode = flutterVersionCode
        versionName = flutterVersionName
    }

    buildTypes {
        release {
            isSigningReady = true
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
}
EOF

echo "✅ Plik android/app/build.gradle.kts został naprawiony."
