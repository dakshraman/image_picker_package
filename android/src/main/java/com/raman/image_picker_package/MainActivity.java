package com.example.image_picker_package;

import android.content.Intent;
import android.graphics.Bitmap;
import android.provider.MediaStore;
import android.net.Uri;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "image_picker_package";
    private static final int PICK_IMAGE = 1;
    private Result pendingResult;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("pickImage")) {
                                int source = call.argument("source");
                                pickImage(source, result);
                            } else {
                                result.notImplemented();
                            }
                        }
                );
    }

    private void pickImage(int source, Result result) {
        pendingResult = result;
        Intent intent;
        if (source == 0) { // Camera
            intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        } else { // Gallery
            intent = new Intent(Intent.ACTION_PICK, MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
        }
        startActivityForResult(intent, PICK_IMAGE);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == PICK_IMAGE && resultCode == RESULT_OK) {
            Uri imageUri = data.getData();
            if (imageUri != null) {
                String path = imageUri.getPath();
                pendingResult.success(path);
            } else {
                pendingResult.error("UNAVAILABLE", "Image not available.", null);
            }
        } else {
            pendingResult.error("UNAVAILABLE", "Image picker failed.", null);
        }
    }
}
