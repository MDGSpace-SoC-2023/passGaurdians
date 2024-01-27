import android.view.accessibility.AccessibilityEvent
import android.view.accessibility.AccessibilityNodeInfo
import androidx.core.view.accessibility.AccessibilityNodeInfoCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MyAccessibilityService : AccessibilityService() {
    override fun onAccessibilityEvent(event: AccessibilityEvent) {
        // Check for password input events
        if (event.eventType == AccessibilityEvent.TYPE_VIEW_TEXT_CHANGED) {
            val text = event.text
            if (!text.isNullOrEmpty() && isPasswordInput(event.source)) {
                // Send a message to Flutter through platform channel
                MethodChannel(
                    (applicationContext as FlutterActivity).flutterEngine!!.dartExecutor.binaryMessenger,
                    "password_manager_channel"
                ).invokeMethod("onPasswordDetected", text.toString())
            }
        }
    }

    private fun isPasswordInput(nodeInfo: AccessibilityNodeInfo?): Boolean {
        // Implement logic to determine if the node is a password input field
        // You may need to traverse the accessibility tree to find the input type
        // For simplicity, you can assume all EditText fields are password inputs
        return nodeInfo != null && nodeInfo.className == "android.widget.EditText"
    }

    override fun onInterrupt() {
        // Handle service interruption
    }
}
