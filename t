# Nadpisanie pliku ClockWidgetProvider.kt kodem zgodnym z nową wersją pakietu home_widget
cat > android/app/src/main/kotlin/com/amarcinkowski/clock1000/ClockWidgetProvider.kt << 'EOF'
package com.amarcinkowski.clock1000

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.os.Build
import android.widget.RemoteViews

class ClockWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        appWidgetIds.forEach { widgetId ->
            // Tworzenie widoku na podstawie layoutu XML
            val views = RemoteViews(context.packageName, R.layout.clock_widget_layout).apply {

                // Pobranie danych zapisanych przez Flutera z SharedPreferences
                val widgetData = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
                val title = widgetData.getString("widget_title", "Clock 1000")
                val data = widgetData.getString("widget_data", "--")

                // Ustawienie tekstu w widżecie
                setTextViewText(R.id.widget_title, title)
                setTextViewText(R.id.widget_data, data)

                // Utworzenie intencji (Intent) do uruchomienia głównej aktywności aplikacji
                val intent = Intent(context, MainActivity::class.java)
                val pendingIntentFlag = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                } else {
                    PendingIntent.FLAG_UPDATE_CURRENT
                }
                val pendingIntent = PendingIntent.getActivity(context, 0, intent, pendingIntentFlag)

                // Ustawienie akcji kliknięcia na widżet
                setOnClickPendingIntent(R.id.widget_data, pendingIntent)
                setOnClickPendingIntent(R.id.widget_title, pendingIntent)
            }

            // Zaktualizowanie widżetu na ekranie głównym
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
EOF

echo "✅ Plik ClockWidgetProvider.kt został naprawiony. Spróbuj uruchomić budowanie ponownie."
