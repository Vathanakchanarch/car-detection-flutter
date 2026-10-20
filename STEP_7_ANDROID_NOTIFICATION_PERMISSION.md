# AICA Step 7 — Android Notification Permission Test Plan

## Scope

Step 7 requests only the Android notification permission. Notifications, Firebase, backend services, device tokens, and push delivery are not implemented.

The permission control is located at:

```text
Profile
→ Notification preferences
→ Device notifications
```

Opening the screen checks the current Android permission status. It does not display the permission dialog automatically.

## Requirements

- Use a real Android phone running Android 13 or newer to see the runtime notification permission dialog.
- Install a fresh debug build of the application.
- Keep the phone connected for `flutter run`, or install the generated APK manually.

Older Android versions do not require the same notification runtime prompt. On those versions, the permission package should report notifications as allowed when the operating system does not require a prompt.

## Test 1 — First Request

1. Install and open the application on an Android 13 or newer phone.
2. Complete or skip onboarding.
3. Use demo sign-in and verification if needed.
4. Open **Profile**.
5. Open **Notification preferences**.
6. Confirm that the screen opens without showing an Android permission dialog.
7. Find **Device notifications** with the **Not allowed** status.
8. Tap **Enable**.
9. Confirm that the Android notification permission dialog appears.

Expected result: the system dialog appears only after tapping **Enable**.

## Test 2 — Allow

1. Follow Test 1 until the Android dialog appears.
2. Tap **Allow**.
3. Return to **Notification preferences** if necessary.

Expected result:

- **Device notifications** displays **Allowed**.
- A green check icon is shown.
- Tapping the row again does not request permission again.
- The rest of the app continues working.

## Test 3 — Deny

1. Open Android **Settings**.
2. Open **Apps** and select the AICA/car_detection application.
3. Open **Notifications** and disable notification permission, or uninstall and reinstall the application to reset the first request.
4. Return to the app and open **Profile → Notification preferences**.
5. Tap **Enable**.
6. When the Android dialog appears, tap **Don't allow**.

Expected result:

- The app remains open and usable.
- **Device notifications** shows **Not allowed**, unless Android reports the denial as permanent.
- A short message explains that the app will continue normally.
- Demo notifications remain available inside the application.

## Test 4 — Permanently Denied and Settings

The exact number of denials before Android stops showing the prompt can vary by Android version and device manufacturer.

1. Deny notification permission until Android no longer offers the runtime dialog, or disable the permission and select any available option that prevents future prompts.
2. Return to **Profile → Notification preferences**.
3. Confirm that **Device notifications** displays **Enable from Android app settings**.
4. Tap **Settings**.
5. Confirm that Android opens the application's settings page.
6. Enable notifications manually.
7. Return to the app.

Expected result:

- The app opens Android settings without crashing.
- Returning to the app refreshes the actual operating system permission status.
- **Device notifications** displays **Allowed** after permission is enabled.

## Existing Features to Recheck

After testing permission behavior, confirm:

- onboarding persistence still works;
- language preference still restores;
- notification read state still restores;
- demo notification cards still open normally;
- demo payments, vehicles, and violations remain unchanged.

## Test Status

The permission service and UI trigger behavior are covered by automated Flutter tests. The real Android system dialog and device settings flow still require the manual tests above on an Android phone.
