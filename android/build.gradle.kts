//buildscript {
//    repositories {
//        google()
//        mavenCentral()
//        gradlePluginPortal()
//    }
//    dependencies {
//        // AGP 9.x bundles KGP 2.2.10, while Flutter 3.47 requires >= 2.2.20.
//        // Keep Built-in Kotlin enabled for migrated plugins (for example flutter_facebook_auth)
//        // and override AGP's runtime KGP with a version compatible with Gradle 9.3.1 / AGP 9.1.x.
//        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:2.4.20")
//    }
//}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
