# Ostateczna, poprawiona wersja pliku build.gradle.kts
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
    compileSdk = 34

    sourceSets {
        getByName("main") {
            java.srcDirs("src/main/kotlin")
        }
    }

    defaultConfig {
        applicationId = "com.amarcinkowski.clock1000"
        minSdk = 21
        targetSdk = 34
        versionCode = flutterVersionCode
        versionName = flutterVersionName
    }

    buildTypes {
        release {
            // Ta linia jest kluczowa do podpisania aplikacji kluczem debugowym.
            // Błędna właściwość 'isSigningReady' została usunięta.
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

echo "✅ Plik build.gradle.kts został przepisany z poprawną składnią Kotlin DSL."
