package com.amarcinkowski.clock1000

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

class ClockWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.clock_widget_layout).apply {
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java
                )
                setOnClickPendingIntent(R.id.widget_data, pendingIntent)
                setOnClickPendingIntent(R.id.widget_title, pendingIntent)

                val title = widgetData.getString("widget_title", "Clock 1000")
                val data = widgetData.getString("widget_data", "--")

                setTextViewText(R.id.widget_title, title)
                setTextViewText(R.id.widget_data, data)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
