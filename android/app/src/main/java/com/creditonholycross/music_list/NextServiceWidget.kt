//package com.example.flutter_cpc_music_list
//
//import android.appwidget.AppWidgetManager
//import android.appwidget.AppWidgetProvider
//import android.content.Context
//import android.widget.RemoteViews
//
//import es.antonborri.home_widget.HomeWidgetPlugin
//
///**
// * Implementation of App Widget functionality.
// */
//class NextServiceWidget : AppWidgetProvider() {
//    override fun onUpdate(
//        context: Context,
//        appWidgetManager: AppWidgetManager,
//        appWidgetIds: IntArray
//    ) {
//        // There may be multiple widgets active, so update all of them
//        for (appWidgetId in appWidgetIds) {
//            updateAppWidget(context, appWidgetManager, appWidgetId)
//        }
//    }
//
//    override fun onEnabled(context: Context) {
//        // Enter relevant functionality for when the first widget is created
//    }
//
//    override fun onDisabled(context: Context) {
//        // Enter relevant functionality for when the last widget is disabled
//    }
//}
//
//internal fun updateAppWidget(
//    context: Context,
//    appWidgetManager: AppWidgetManager,
//    appWidgetId: Int
//) {
//    val widgetData = HomeWidgetPlugin.getData(context)
//    val views = RemoteViews(context.packageName, R.layout.next_service_widget).apply {
//        val date = widgetData.getString("service_date", null)
//        setTextViewText(R.id.service_date, date ?: "No date")
//
//        val serviceType = widgetData.getString("service_type", null)
//        setTextViewText(R.id.service_type, serviceType ?: "No service")
//
//       val hymnNumbers = widgetData.getString("hymn_numbers", null)
//       setTextViewText(R.id.hymns, hymnNumbers ?: "No service")
//
//       val psalm = widgetData.getString("psalm", null)
//       setTextViewText(R.id.psalm, psalm ?: "No service")
//    }
//
//    // Instruct the widget manager to update the widget
//    appWidgetManager.updateAppWidget(appWidgetId, views)
//}