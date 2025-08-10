# Aktualizacja pliku build.gradle.kts do compileSdk 35
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
    compileSdk = 35

    sourceSets {
        getByName("main") {
            java.srcDirs("src/main/kotlin")
        }
    }

    defaultConfig {
        applicationId = "com.amarcinkowski.clock1000"
        minSdk = 21
        targetSdk = 35
        versionCode = flutterVersionCode
        versionName = flutterVersionName
    }

    buildTypes {
        release {
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

echo "✅ Plik build.gradle.kts został zaktualizowany. Ustawiono compileSdk i targetSdk na 35."
