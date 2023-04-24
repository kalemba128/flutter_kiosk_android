package com.kalemba128.flutter_kiosk_android

import android.app.Activity
import android.app.ActivityManager
import android.app.admin.DeviceAdminReceiver
import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.os.Build
import android.os.UserManager
import androidx.annotation.NonNull
import androidx.core.content.ContextCompat.getSystemService

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.logging.Logger

/** FlutterKioskAndroidPlugin */
class FlutterKioskAndroidPlugin : FlutterPlugin, MethodCallHandler, ActivityAware,
    DeviceAdminReceiver() {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var activity: Activity
    private lateinit var context: Context
    private val logger = Logger.getLogger(this.javaClass.name)

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_kiosk_android")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "isDeviceOwner" -> isDeviceOwner(result)
            "blockApplications" -> blockApplications(call.argument("packages"), result)
            "unblockApplications" -> unblockApplications(call.argument("packages"), result)
            "startKioskMode" -> startKioskMode(result)
            "stopKioskMode" -> stopKioskMode(result)
            "isInKioskMode" -> isInKioskMode(result)
            "allowInstallingApplications" -> allowInstallingApplications(result)
            "disallowInstallingApplications" -> disallowInstallingApplications(result)
            "isInstallingApplicationsAllowed" -> isInstallingApplicationsAllowed(result)
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onDetachedFromActivity() {}
    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity;
    }

    override fun onDetachedFromActivityForConfigChanges() {}

    private fun isDeviceOwner(result: Result) {
        val dpm = activity.getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR2) {
            val isOwner = dpm.isDeviceOwnerApp(context.packageName)
            result.success(isOwner)
        } else {
            result.success(false)
        }
    }


    private fun blockApplications(packages: List<String>?, result: Result) {
        val pkgs = suspendApplications(packages, true)
        result.success(pkgs)
    }

    private fun unblockApplications(packages: List<String>?, result: Result) {
        val pkgs = suspendApplications(packages, false)
        result.success(pkgs)
    }

    private fun suspendApplications(packages: List<String>?, suspended: Boolean): List<String> {
        val dpm = activity.getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
        val pkgs = packages ?: getInstalledApplicationPackagesNames()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            val notBlocked =
                dpm.setPackagesSuspended(getAdminComponent(), pkgs.toTypedArray(), suspended)
                    .filterNotNull()
            return pkgs.filter { !notBlocked.contains(it) }
        } else {
            return listOf()
        }
    }

    private fun startKioskMode(result: Result) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            val dpm = context.getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
            if (!dpm.isLockTaskPermitted(context.packageName)) {
                dpm.setLockTaskPackages(getAdminComponent(), arrayOf(context.packageName))
            }
            activity.startLockTask()
            result.success(true)
        } else {
            result.success(false)
        }
    }

    private fun stopKioskMode(result: Result) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            activity.stopLockTask()
            result.success(true)
        } else {
            result.success(false)
        }
    }

    private fun isInKioskMode(result: Result) {
        val service = activity.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            when (service.lockTaskModeState) {
                ActivityManager.LOCK_TASK_MODE_PINNED,
                ActivityManager.LOCK_TASK_MODE_LOCKED -> result.success(true)
                else -> result.success(false)
            }
        }
    }

    private fun getInstalledApplicationPackagesNames(): List<String> {
        val applications = context.packageManager.getInstalledPackages(0)
        return applications.map { it.packageName }.filter { it != context.packageName }
    }

    private fun getAdminComponent(): ComponentName {
        return ComponentName(context.packageName, this::class.java.name)
    }

    private fun disallowInstallingApplications(result: Result) {
        val dpm = activity.getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
        val admin = getAdminComponent()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            dpm.addUserRestriction(admin, UserManager.DISALLOW_INSTALL_APPS)
            logger.info("Disallowed install apps")
            result.success(true)
        } else {
            result.success(false)
        }

    }

    private fun allowInstallingApplications(result: Result) {
        val dpm = activity.getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
        val admin = getAdminComponent()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            dpm.clearUserRestriction(admin, UserManager.DISALLOW_INSTALL_APPS)
            logger.info("Allowed install apps")
            result.success(true)
        } else {
            result.success(false)
        }

    }

    private fun isInstallingApplicationsAllowed(result: Result) {
        val dpm = activity.getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
        val admin = getAdminComponent()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            val bundle = dpm.getUserRestrictions(admin)
            val value = bundle.getBoolean(UserManager.DISALLOW_INSTALL_APPS)
            result.success(!value)
        } else {
            result.success(null)
        }

    }
}
