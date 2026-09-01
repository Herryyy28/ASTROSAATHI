package com.astrosaathi.app

import android.app.Application
import androidx.work.Configuration
import android.util.Log

class MainApplication : Application(), Configuration.Provider {
    override val workManagerConfiguration: Configuration
        get() = Configuration.Builder()
            .setMinimumLoggingLevel(Log.DEBUG)
            .build()
}
