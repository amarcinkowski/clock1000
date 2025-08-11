# Nadpisanie pliku ClockWidgetProvider.kt z poprawioną logiką tworzenia PendingIntent
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
            val views = RemoteViews(context.packageName, R.layout.clock_widget_layout).apply {

                val widgetData = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
                val title = widgetData.getString("widget_title", "Clock 1000")
                val data = widgetData.getString("widget_data", "--")

                setTextViewText(R.id.widget_title, title)
                setTextViewText(R.id.widget_data, data)

                // --- POPRAWIONY FRAGMENT ---
                // Zmieniamy sposób definiowania flag, aby uniknąć błędu kompilatora.
                val intent = Intent(context, MainActivity::class.java)
                var pendingIntentFlag = PendingIntent.FLAG_UPDATE_CURRENT
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    pendingIntentFlag = pendingIntentFlag or PendingIntent.FLAG_IMMUTABLE
                }
                
                val pendingIntent = PendingIntent.getActivity(context, 0, intent, pendingIntentFlag)
                // --- KONIEC POPRAWIONEGO FRAGMENTU ---

                setOnClickPendingIntent(R.id.widget_data, pendingIntent)
                setOnClickPendingIntent(R.id.widget_title, pendingIntent)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
EOF

echo "✅ Plik ClockWidgetProvider.kt został poprawiony. Logika tworzenia flagi jest teraz bardziej bezpośrednia."
