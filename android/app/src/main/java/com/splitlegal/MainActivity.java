package com.splitlegal;

import android.content.Intent;
import android.os.Bundle;
import android.view.KeyEvent;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

  private static final String CHANNEL = "com.Rahim.myFlutterApp/surveyMonkey";
  private MethodChannel.Result result;
  private static final int REQUESTCODE = 120;


  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
  }

  @Override
  protected void onActivityResult(int requestCode, int resultCode, Intent data) {
    super.onActivityResult(requestCode, resultCode, data);
    if (requestCode == REQUESTCODE && resultCode == RESULT_OK && data != null) {
      String resultString = data.getStringExtra("isSuccess");
      result.success(resultString);
    }
  }

  @Override
  public void onBackPressed() {
      return;
  }
}
