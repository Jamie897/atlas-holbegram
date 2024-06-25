// Module (app-level) Gradle file (<project>/<app-module>/build.gradle.kts)
plugins {
    id("com.android.application")
    id("com.google.gms.google-services")

    // Other plugins you may have...
}

android {
    // Android configurations like compileSdkVersion, buildTypes, etc.
    // Ensure your minimum SDK version is compatible with Firebase SDKs.
}

dependencies {
    // Import the Firebase BoM (Bill of Materials) for managing Firebase dependencies
    implementation(platform("com.google.firebase:firebase-bom:33.1.1"))

    // Add the Firebase SDKs you want to use in your app
    // Example: Adding Firebase Authentication
    implementation("com.google.firebase:firebase-auth-ktx")

    // Add more Firebase SDKs as needed, e.g., Firestore, Storage, etc.
    // When using the BoM, do not specify versions for individual Firebase libraries
    // Firebase BoM ensures compatibility between SDK versions.

    // Other dependencies your app requires...
}

// Other configurations like buildTypes, flavorDimensions, etc.
