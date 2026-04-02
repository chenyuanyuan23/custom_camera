package com.custom.custom_camera

import androidx.camera.video.VideoRecordEvent

/// 录制
interface OnRecordListener {

    fun start(event: VideoRecordEvent)
    fun stop(event: VideoRecordEvent)
    fun takeVideo(result: Map<String, Any>)

}