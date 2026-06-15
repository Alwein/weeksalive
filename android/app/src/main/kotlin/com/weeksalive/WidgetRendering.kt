package com.weeksalive

import android.content.Context
import android.content.res.Configuration
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import org.json.JSONObject
import kotlin.math.ceil
import kotlin.math.sqrt

/// Subset of theme color tokens the widgets draw with, decoded from the hex
/// strings the Flutter side resolves for the active theme.
internal data class WidgetPalette(
    val content: Int,
    val contentSoft: Int,
    val bg: Int,
    val bgSoft: Int,
    val strokeColor: Int,
    val accentOrange: Int,
) {
    companion object {
        fun fromJson(json: JSONObject): WidgetPalette = WidgetPalette(
            content = parseColor(json.optString("content")),
            contentSoft = parseColor(json.optString("contentSoft")),
            bg = parseColor(json.optString("bg")),
            bgSoft = parseColor(json.optString("bgSoft")),
            strokeColor = parseColor(json.optString("strokeColor")),
            accentOrange = parseColor(json.optString("accentOrange")),
        )

        /// Parses an `#AARRGGBB` (or `#RRGGBB`) hex string into an ARGB int.
        private fun parseColor(hex: String): Int {
            if (hex.isEmpty()) return Color.TRANSPARENT
            return try {
                Color.parseColor(hex)
            } catch (_: IllegalArgumentException) {
                Color.TRANSPARENT
            }
        }
    }
}

/// True when the system is currently in dark (night) mode.
internal fun Context.isNightMode(): Boolean {
    val mode = resources.configuration.uiMode and Configuration.UI_MODE_NIGHT_MASK
    return mode == Configuration.UI_MODE_NIGHT_YES
}

/// Picks the palette matching the current night mode from a payload object that
/// carries both a `light` and a `dark` palette.
internal fun JSONObject.paletteFor(context: Context): WidgetPalette {
    val key = if (context.isNightMode()) "dark" else "light"
    return WidgetPalette.fromJson(optJSONObject(key) ?: JSONObject())
}

/// Largest bitmap (in pixels) we hand to Glance. AppWidget bitmaps are limited
/// by the host's memory budget (roughly `screenWidth * screenHeight * 6` bytes
/// shared across all widgets); a few megapixels is safe for a single widget and
/// keeps the dots crisp at the device's native resolution. Below this cap we
/// draw at full device-pixel resolution (no downscaling, no pixelation).
private const val MAX_BITMAP_PIXELS = 4_000_000

/// Fewest columns (largest dots) whose grid, sized to fill the full [maxWidth],
/// still fits within [maxHeight]. Adding columns only shrinks the dots, so the
/// smallest count that fits both dimensions fills the area best. Mirrors the
/// iOS `bestColumns` logic.
internal fun bestColumns(
    maxWidth: Int,
    maxHeight: Int,
    totalCells: Int,
    spacing: Float,
): Int {
    if (maxWidth <= 0 || maxHeight <= 0 || totalCells <= 0) return 1
    for (columns in 1..totalCells) {
        val rows = ceil(totalCells.toDouble() / columns).toInt()
        val dot = (maxWidth - spacing * (columns - 1)) / columns
        if (dot <= 0f) continue
        val gridHeight = rows * dot + (rows - 1) * spacing
        if (gridHeight <= maxHeight) return columns
    }
    return totalCells
}

/// Computes the bitmap size to draw the grid into: the full available
/// [maxWidth] x [maxHeight] area (so the Image can fill the whole space without
/// letterboxing), scaled down only if it exceeds the pixel budget. The grid
/// itself is drawn width-filling and top-aligned within this canvas.
internal fun gridBitmapSize(
    maxWidth: Int,
    maxHeight: Int,
    totalCells: Int,
    columns: Int,
    spacing: Float,
): Pair<Int, Int>? {
    if (maxWidth <= 0 || maxHeight <= 0 || totalCells <= 0 || columns <= 0) return null
    var width = maxWidth
    var h = maxHeight
    val pixels = width.toLong() * h.toLong()
    if (pixels > MAX_BITMAP_PIXELS) {
        val scale = sqrt(MAX_BITMAP_PIXELS.toDouble() / pixels.toDouble())
        width = (width * scale).toInt().coerceAtLeast(1)
        h = (h * scale).toInt().coerceAtLeast(1)
    }
    return width to h
}

/// Draws a uniform-dot life grid: the first [filled] of [total] cells use
/// [activeColor], the rest [inactiveColor]. Mirrors the Flutter WeekGridPainter /
/// LifeYearScalePainter layout.
internal fun drawLifeGrid(
    width: Int,
    height: Int,
    total: Int,
    filled: Int,
    columns: Int,
    spacing: Float,
    activeColor: Int,
    inactiveColor: Int,
): Bitmap {
    val bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
    val canvas = Canvas(bitmap)
    if (total <= 0 || columns <= 0) return bitmap

    val dotSize = (width - spacing * (columns - 1)) / columns
    if (dotSize <= 0f) return bitmap
    val maxRadius = dotSize / 2
    val active = Paint(Paint.ANTI_ALIAS_FLAG).apply { color = activeColor }
    val inactive = Paint(Paint.ANTI_ALIAS_FLAG).apply { color = inactiveColor }
    val clampedFilled = filled.coerceIn(0, total)

    for (i in 0 until total) {
        val col = i % columns
        val row = i / columns
        val cx = col * (dotSize + spacing) + maxRadius
        val cy = row * (dotSize + spacing) + maxRadius
        canvas.drawCircle(cx, cy, maxRadius, if (i < clampedFilled) active else inactive)
    }
    return bitmap
}

private const val MIN_DOT_DIAMETER = 4f
private const val STROKE_WIDTH = 1f

/// Maps a recorded size level [0, 4] to a radius given the max cell radius.
private fun sizeRadius(level: Int, maxRadius: Float): Float {
    val minRadius = MIN_DOT_DIAMETER / 2
    if (level <= 0) return minRadius
    if (level >= 4) return maxRadius
    return minRadius + (maxRadius - minRadius) * (level / 4f)
}

/// Draws the current-year grid following the in-app YearGridPainter encoding:
/// `-1` future (empty stroke), `-2` past w/o record ([pastEmptyColor]),
/// `-3` today w/o record ([todayEmptyColor]), `[0, 4]` recorded size level.
internal fun drawYearGrid(
    width: Int,
    height: Int,
    totalDays: Int,
    sizes: IntArray,
    columns: Int,
    spacing: Float,
    fillColor: Int,
    strokeColor: Int,
    pastEmptyColor: Int,
    todayEmptyColor: Int,
): Bitmap {
    val bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
    val canvas = Canvas(bitmap)
    if (totalDays <= 0 || columns <= 0) return bitmap

    val dotSize = (width - spacing * (columns - 1)) / columns
    if (dotSize <= 0f) return bitmap
    val maxRadius = dotSize / 2
    val strokeRadius = maxRadius - STROKE_WIDTH / 2

    val fill = Paint(Paint.ANTI_ALIAS_FLAG).apply { color = fillColor }
    val past = Paint(Paint.ANTI_ALIAS_FLAG).apply { color = pastEmptyColor }
    val today = Paint(Paint.ANTI_ALIAS_FLAG).apply { color = todayEmptyColor }
    val stroke = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        style = Paint.Style.STROKE
        strokeWidth = STROKE_WIDTH
        color = strokeColor
    }

    for (i in 0 until totalDays) {
        val col = i % columns
        val row = i / columns
        val cx = col * (dotSize + spacing) + maxRadius
        val cy = row * (dotSize + spacing) + maxRadius
        val level = if (i < sizes.size) sizes[i] else 4
        when (level) {
            -1 -> canvas.drawCircle(cx, cy, strokeRadius, stroke)
            -2 -> canvas.drawCircle(cx, cy, maxRadius, past)
            -3 -> canvas.drawCircle(cx, cy, maxRadius, today)
            else -> canvas.drawCircle(cx, cy, sizeRadius(level.coerceIn(0, 4), maxRadius), fill)
        }
    }
    return bitmap
}
