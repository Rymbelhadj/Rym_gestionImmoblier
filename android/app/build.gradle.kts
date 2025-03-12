plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin") // Doit être chargé après Android et Kotlin
}

android {
    namespace = "com.example.flutter_application_1"
    compileSdk = 34 // Remplace par la dernière version supportée par Flutter

    // Spécifie une version stable du NDK pour éviter les erreurs
    ndkVersion = "25.2.9519653"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.flutter_application_1"
        minSdk = 21 // Modifie si nécessaire
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
            signingConfig = signingConfigs.getByName("debug") // ⚠️ Change en "release" en prod
        }
    }
}

flutter {
    source = "../.."
}
