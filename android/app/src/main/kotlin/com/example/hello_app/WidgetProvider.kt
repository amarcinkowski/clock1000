package com.example.hello_app

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import java.util.Calendar
import java.util.concurrent.TimeUnit

class WidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.widget_layout).apply {
                val displayMinutes = getDisplayMinutes()
                val counterText = String.format("%03d", displayMinutes)
                setTextViewText(R.id.widget_text, counterText)
            }

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }

    private fun getDisplayMinutes(): Int {
        val maxMinutes = 1000
        val now = Calendar.getInstance()

        val startToday = Calendar.getInstance().apply {
            set(Calendar.HOUR_OF_DAY, 6)
            set(Calendar.MINUTE, 15)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
        }

        val minutesElapsed: Int
        if (now.before(startToday)) {
            val startYesterday = startToday.clone() as Calendar
            startYesterday.add(Calendar.DATE, -1)
            minutesElapsed = TimeUnit.MILLISECONDS.toMinutes(now.timeInMillis - startYesterday.timeInMillis).toInt()
        } else {
            minutesElapsed = TimeUnit.MILLISECONDS.toMinutes(now.timeInMillis - startToday.timeInMillis).toInt()
        }

        return if (minutesElapsed <= maxMinutes) {
            if (minutesElapsed < 0) 0 else minutesElapsed
        } else {
            val nextStart = startToday.clone() as Calendar
            nextStart.add(Calendar.DATE, 1)
            val minutesRemaining = TimeUnit.MILLISECONDS.toMinutes(nextStart.timeInMillis - now.timeInMillis).toInt()
            if (minutesRemaining < 0) 0 else minutesRemaining
        }
    }
}
