package com.weeksalive

import HomeWidgetGlanceState
import HomeWidgetGlanceStateDefinition
import HomeWidgetGlanceWidgetReceiver
import android.content.Context
import android.content.SharedPreferences
import androidx.compose.runtime.Composable
import androidx.glance.GlanceModifier
import androidx.glance.Image
import androidx.glance.ImageProvider
import androidx.glance.LocalSize
import androidx.glance.action.clickable
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.SizeMode
import androidx.glance.appwidget.provideContent
import androidx.glance.background
import androidx.glance.currentState
import androidx.glance.layout.Alignment
import androidx.glance.layout.Box
import androidx.glance.layout.Column
import androidx.glance.layout.ContentScale
import androidx.glance.layout.Row
import androidx.glance.layout.Spacer
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.fillMaxWidth
import androidx.glance.layout.height
import androidx.glance.layout.padding
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import androidx.glance.unit.ColorProvider
import androidx.glance.GlanceId
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import es.antonborri.home_widget.actionStartActivity
import org.json.JSONObject

/// Density-independent widget padding mirrored from the in-app rendering (12dp).
private const val WIDGET_PADDING_DP = 12

/// Vertical room reserved for the footer row (text + gap above the grid), so the
/// grid bitmap is sized within the remaining height. Mirrors the iOS VStack
/// spacing (8) plus the ~13sp footer line.
private const val FOOTER_HEIGHT_DP = 26

/// Parses the JSON blob stored under [key] in the home_widget preferences.
private fun SharedPreferences.widgetJson(key: String): JSONObject? {
    val raw = getString(key, null) ?: return null
    return try {
        JSONObject(raw)
    } catch (_: Exception) {
        null
    }
}

/// Footer row mirroring iOS: [label] on the left, [value] on the right, spaced
/// apart, both in the `content` color.
@Composable
private fun WidgetFooter(label: String, value: String, color: Int) {
    val style = TextStyle(
        color = ColorProvider(Color(color)),
        fontSize = 13.sp,
        fontWeight = FontWeight.Medium,
    )
    Row(
        modifier = GlanceModifier.fillMaxWidth(),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        Text(text = label, style = style)
        Spacer(modifier = GlanceModifier.defaultWeight())
        Text(text = value, style = style)
    }
}

/// Formats a fraction as a percentage with one decimal (e.g. `37.4%`).
private fun percent(filled: Int, total: Int): String {
    if (total <= 0) return "0%"
    val value = filled.toDouble() / total.toDouble() * 100
    return String.format("%.1f%%", value)
}

// MARK: - Life Grid

/// "Grille de vie": small = 1 cell/year, large = 1 cell/week.
class LifeGridGlanceWidget : GlanceAppWidget() {
    override val sizeMode: SizeMode = SizeMode.Exact

    /// Needed so home_widget can push updates by reloading the Glance state.
    override val stateDefinition = HomeWidgetGlanceStateDefinition()

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        provideContent { LifeGridContent(context, currentState()) }
    }

    @Composable
    private fun LifeGridContent(context: Context, state: HomeWidgetGlanceState) {
        val payload = state.preferences.widgetJson("life_grid_json")
        val size = LocalSize.current
        if (payload == null) {
            Box(modifier = GlanceModifier.fillMaxSize()) {}
            return
        }
        val palette = payload.paletteFor(context)
        // Small family is roughly square; treat the year-scale view as the
        // compact one and the week view for anything wider/taller.
        val isSmall = size.width <= 200.dp && size.height <= 200.dp
        val spacing = if (isSmall) 3f else 1.5f
        val total = payload.optInt(if (isSmall) "totalYears" else "totalWeeks")
        val filled = payload.optInt(if (isSmall) "livedYears" else "livedWeeks")

        val density = context.resources.displayMetrics.density
        val pad = (WIDGET_PADDING_DP * density).toInt()
        val footer = (FOOTER_HEIGHT_DP * density).toInt()
        val maxWidth = (size.width.value * density).toInt() - pad * 2
        val maxHeight = (size.height.value * density).toInt() - pad * 2 - footer
        val columns = bestColumns(maxWidth, maxHeight, total, spacing)
        val dims = gridBitmapSize(maxWidth, maxHeight, total, columns, spacing)

        Column(
            modifier = GlanceModifier
                .fillMaxSize()
                .background(ColorProvider(Color(palette.bg)))
                .padding(WIDGET_PADDING_DP.dp)
                .clickable(onClick = actionStartActivity<MainActivity>(context)),
        ) {
            Box(
                modifier = GlanceModifier.defaultWeight().fillMaxWidth(),
                contentAlignment = Alignment.TopStart,
            ) {
                if (dims != null) {
                    val bitmap = drawLifeGrid(
                        width = dims.first,
                        height = dims.second,
                        total = total,
                        filled = filled,
                        columns = columns,
                        spacing = spacing * (dims.first.toFloat() / maxWidth.coerceAtLeast(1)),
                        activeColor = palette.content,
                        inactiveColor = palette.bgSoft,
                    )
                    Image(
                        provider = ImageProvider(bitmap),
                        contentDescription = null,
                        contentScale = ContentScale.FillBounds,
                        modifier = GlanceModifier.fillMaxSize(),
                    )
                }
            }
            Spacer(modifier = GlanceModifier.height(8.dp))
            WidgetFooter(
                label = "Life",
                value = percent(filled, total),
                color = palette.content,
            )
        }
    }
}

class LifeGridWidgetReceiver : HomeWidgetGlanceWidgetReceiver<LifeGridGlanceWidget>() {
    override val glanceAppWidget: LifeGridGlanceWidget = LifeGridGlanceWidget()
}

// MARK: - Year Grid

/// "Grille année": current civil year, day by day.
class YearGridGlanceWidget : GlanceAppWidget() {
    override val sizeMode: SizeMode = SizeMode.Exact

    /// Needed so home_widget can push updates by reloading the Glance state.
    override val stateDefinition = HomeWidgetGlanceStateDefinition()

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        provideContent { YearGridContent(context, currentState()) }
    }

    @Composable
    private fun YearGridContent(context: Context, state: HomeWidgetGlanceState) {
        val payload = state.preferences.widgetJson("year_grid_json")
        val size = LocalSize.current
        if (payload == null) {
            Box(modifier = GlanceModifier.fillMaxSize()) {}
            return
        }
        val palette = payload.paletteFor(context)
        val spacing = 3f
        val year = payload.optInt("year")
        val totalDays = payload.optInt("totalDays")
        val livedDays = payload.optInt("livedDays")
        val sizes = payload.optString("fillSizes")
            .split(",")
            .mapNotNull { it.trim().toIntOrNull() }
            .toIntArray()

        val density = context.resources.displayMetrics.density
        val pad = (WIDGET_PADDING_DP * density).toInt()
        val footer = (FOOTER_HEIGHT_DP * density).toInt()
        val maxWidth = (size.width.value * density).toInt() - pad * 2
        val maxHeight = (size.height.value * density).toInt() - pad * 2 - footer
        val columns = bestColumns(maxWidth, maxHeight, totalDays, spacing)
        val dims = gridBitmapSize(maxWidth, maxHeight, totalDays, columns, spacing)

        Column(
            modifier = GlanceModifier
                .fillMaxSize()
                .background(ColorProvider(Color(palette.bg)))
                .padding(WIDGET_PADDING_DP.dp)
                .clickable(onClick = actionStartActivity<MainActivity>(context)),
        ) {
            Box(
                modifier = GlanceModifier.defaultWeight().fillMaxWidth(),
                contentAlignment = Alignment.TopStart,
            ) {
                if (dims != null) {
                    val bitmap = drawYearGrid(
                        width = dims.first,
                        height = dims.second,
                        totalDays = totalDays,
                        sizes = sizes,
                        columns = columns,
                        spacing = spacing * (dims.first.toFloat() / maxWidth.coerceAtLeast(1)),
                        fillColor = palette.content,
                        strokeColor = palette.strokeColor,
                        pastEmptyColor = palette.bgSoft,
                        todayEmptyColor = palette.accentOrange,
                    )
                    Image(
                        provider = ImageProvider(bitmap),
                        contentDescription = null,
                        contentScale = ContentScale.FillBounds,
                        modifier = GlanceModifier.fillMaxSize(),
                    )
                }
            }
            Spacer(modifier = GlanceModifier.height(8.dp))
            WidgetFooter(
                label = "$year",
                value = "$livedDays/$totalDays",
                color = palette.content,
            )
        }
    }
}

class YearGridWidgetReceiver : HomeWidgetGlanceWidgetReceiver<YearGridGlanceWidget>() {
    override val glanceAppWidget: YearGridGlanceWidget = YearGridGlanceWidget()
}
