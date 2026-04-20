extends Node

var disabled_color: Color = Color("1a1d23")
var background_color: Color = Color("16181d")
var normal_color: Color = Color("1e2128")
var normal_elevated_color: Color = Color("2f3440")
var accent_color: Color = Color("4fa3ff")
var progress_bar_fill_color: Color = Color("00d900")
var primary_font_color: Color = Color("e6eaf0")
var disabled_font_color: Color = Color("5e6675")
var tab_unselected_font_color: Color = Color("9aa4b2")

func _ready() -> void:
	SaveManager.settings_changed.connect(set_theme)
	set_theme()

func set_theme():
	default_themes(SaveManager.current_settings.get_value("display", "theme_options", "default"))
	var theme = create_theme()
	get_tree().root.theme = theme

func create_theme():
	var theme = Theme.new()
	
	# --- Panel ---
	var panel = StyleBoxFlat.new()
	panel.bg_color = background_color
	theme.set_stylebox("panel", "Panel", panel)

	# --- PanelContainer ---
	var panel_container = StyleBoxFlat.new()
	panel_container.bg_color = background_color
	set_content_margins(panel_container)
	theme.set_stylebox("panel", "PanelContainer", panel_container)
	
	# --- Label ---
	theme.set_color("font_color", "Label", primary_font_color)
	
	# --- LineEdit & TextEdit---
	var focus = StyleBoxFlat.new()
	focus.bg_color = normal_color
	focus.set_border_width_all(1)
	focus.border_color = accent_color
	set_content_margins(focus)
	
	var normal = StyleBoxFlat.new()
	normal.bg_color = normal_color
	normal.set_border_width_all(1)
	normal.border_color = normal_elevated_color
	set_content_margins(normal)
	
	var disabled = StyleBoxFlat.new()
	disabled.bg_color = disabled_color
	set_content_margins(disabled)
	
	theme.set_color("font_color", "LineEdit", primary_font_color)
	theme.set_color("font_uneditable_color", "LineEdit", disabled_font_color)
	theme.set_stylebox("focus", "LineEdit", focus)
	theme.set_stylebox("normal", "LineEdit", normal)
	theme.set_stylebox("read_only", "LineEdit", disabled)
	# TextEdit
	theme.set_color("font_color", "TextEdit", primary_font_color)
	theme.set_color("font_readonly_color", "TextEdit", disabled_font_color)
	theme.set_stylebox("focus", "TextEdit", focus)
	theme.set_stylebox("normal", "TextEdit", normal)
	theme.set_stylebox("read_only", "TextEdit", disabled)
	
	# --- ItemList ---
	theme.set_color("font_color", "ItemList", primary_font_color)
	theme.set_stylebox("panel", "ItemList", normal)
	
	# --- TabContainer ---
	var tab_unselected = StyleBoxFlat.new()
	tab_unselected.bg_color = normal_color
	tab_unselected.border_color = normal_elevated_color
	tab_unselected.border_width_bottom = 2
	tab_unselected.border_width_right = 1
	set_content_margins(tab_unselected)
	
	var tab_selected = StyleBoxFlat.new()
	tab_selected.bg_color = background_color
	tab_selected.border_color = accent_color
	tab_selected.border_width_bottom = 3
	set_content_margins(tab_selected)
	theme.set_stylebox("panel", "TabContainer", panel)
	theme.set_stylebox("tab_focus", "TabContainer", StyleBoxEmpty.new())
	theme.set_stylebox("tab_hovered", "TabContainer", tab_unselected)
	theme.set_stylebox("tab_unselected", "TabContainer", tab_unselected)
	theme.set_stylebox("tab_selected", "TabContainer", tab_selected)
	theme.set_color("font_hovered_color", "TabContainer", primary_font_color)
	theme.set_color("font_unselected_color", "TabContainer", tab_unselected_font_color)
	
	# --- Tree ---
	theme.set_color("font_color", "Tree", primary_font_color)
	theme.set_stylebox("panel", "Tree", StyleBoxEmpty.new())
	
	# --- PopupContainer ---
	var popup_panel: StyleBoxFlat = normal.duplicate(true)  # Unsure if true is needed
	popup_panel.set_corner_radius_all(12)
	theme.set_stylebox("panel", "PopupMenu", popup_panel)

	# --- HSlider ---
	var grabber_area = StyleBoxFlat.new()
	grabber_area.bg_color = normal_elevated_color
	grabber_area.set_corner_radius_all(4)
	
	var grabber_area_highlight = StyleBoxFlat.new()
	grabber_area_highlight.bg_color = accent_color
	grabber_area_highlight.set_corner_radius_all(4)
	
	var slider = StyleBoxFlat.new()
	slider.bg_color = normal_color
	slider.set_corner_radius_all(4)
	slider.set_content_margin_all(4)
	
	theme.set_stylebox("grabber_area", "HSlider", grabber_area)
	theme.set_stylebox("grabber_area_highlight", "HSlider", grabber_area_highlight)
	theme.set_stylebox("slider", "HSlider", slider)
	
	# --- VScrollBar ---
	theme.set_stylebox("grabber", "VScrollBar", grabber_area)
	theme.set_stylebox("grabber_highlight", "VScrollBar", grabber_area_highlight)
	theme.set_stylebox("grabber_pressed", "VScrollBar", grabber_area_highlight)
	theme.set_stylebox("scroll", "VScrollBar", slider)
	
	# --- ProgressBar ---
	var progress_background: StyleBoxFlat = normal.duplicate(true)
	progress_background.set_corner_radius_all(16)

	var progress_fill = StyleBoxFlat.new()
	progress_fill.bg_color = progress_bar_fill_color
	progress_fill.set_corner_radius_all(16)

	theme.set_stylebox("background", "ProgressBar", progress_background)
	theme.set_stylebox("fill", "ProgressBar", progress_fill)

	# --- Button ---
	var disabled_button = disabled.duplicate(true)
	disabled_button.border_color = normal_elevated_color
	disabled_button.set_border_width_all(1)
	disabled_button.set_corner_radius_all(6)
	
	var hover_button = StyleBoxFlat.new()
	hover_button.bg_color = normal_elevated_color
	hover_button.border_color = normal_elevated_color
	hover_button.set_border_width_all(1)
	hover_button.set_corner_radius_all(6)
	set_content_margins(hover_button)
	
	var normal_button: StyleBoxFlat = normal.duplicate(true)
	normal_button.set_corner_radius_all(6)
	var pressed: StyleBoxFlat = focus.duplicate(true)
	pressed.set_corner_radius_all(6)
	
	theme.set_stylebox("disabled", "Button", disabled_button)
	theme.set_stylebox("focus", "Button", StyleBoxEmpty.new())
	theme.set_stylebox("hover", "Button", hover_button)
	theme.set_stylebox("normal", "Button", normal_button)
	theme.set_stylebox("pressed", "Button", pressed)
	theme.set_color("font_color", "Button", primary_font_color)
	theme.set_color("font_disabled_color", "Button", disabled_font_color)
	
	
	# --- TransparentPanel & Container ---
	var panel_transparent: StyleBoxFlat = panel.duplicate(true)
	panel_transparent.bg_color = Color(panel.bg_color, 0.627)
	theme.set_type_variation("TransparentPanel", "Panel")
	theme.set_stylebox("panel", "TransparentPanel", panel_transparent)
	theme.set_type_variation("TransparentPanelContainer", "PanelContainer")
	theme.set_stylebox("panel", "TransparentPanelContainer", panel_transparent)

	# --- SecondaryPanel & Container ---
	var secondary_panel = StyleBoxFlat.new()
	secondary_panel.bg_color = normal_color
	theme.set_type_variation("SecondaryPanel", "Panel")
	theme.set_stylebox("panel", "SecondaryPanel", secondary_panel)
	theme.set_type_variation("SecondaryPanelContainer", "PanelContainer")
	theme.set_stylebox("panel", "SecondaryPanelContainer", secondary_panel)
	
	# --- GenreButton ---
	var genre_disabled: StyleBoxFlat = disabled_button.duplicate(true)
	set_genre_button(genre_disabled)
	var genre_hover: StyleBoxFlat = hover_button.duplicate(true)
	set_genre_button(genre_hover)
	var genre_normal: StyleBoxFlat = normal_button.duplicate(true)
	set_genre_button(genre_normal)
	var genre_pressed: StyleBoxFlat = pressed.duplicate(true)
	set_genre_button(genre_pressed)
	theme.set_type_variation("GenreButton", "Button")
	theme.set_stylebox("focus", "GenreButton", StyleBoxEmpty.new())
	theme.set_stylebox("disabled", "GenreButton", genre_disabled)
	theme.set_stylebox("hover", "GenreButton", genre_hover)
	theme.set_stylebox("normal", "GenreButton", genre_normal)
	theme.set_stylebox("pressed", "GenreButton", genre_pressed)
	
	return theme

func set_genre_button(stylebox: StyleBoxFlat):
	stylebox.border_width_left = 1
	stylebox.border_width_top = 1
	stylebox.border_width_right = 2
	stylebox.border_width_bottom = 2
	stylebox.content_margin_left = 7
	stylebox.content_margin_right = 7
	stylebox.set_corner_radius_all(10)

func set_content_margins(stylebox: StyleBoxFlat):
	stylebox.set_content_margin_all(4)
	stylebox.content_margin_bottom = 2
	stylebox.content_margin_top = 2


func default_themes(theme:String):
	if theme == "Default":
		disabled_color = Color("1a1d23")
		background_color = Color("16181d")
		normal_color = Color("1e2128")
		normal_elevated_color = Color("2f3440")
		accent_color = Color("4fa3ff")
		progress_bar_fill_color = Color("00d900")
		primary_font_color = Color("e6eaf0")
		disabled_font_color = Color("5e6675")
		tab_unselected_font_color = Color("9aa4b2")
	elif theme == "Amethyst":
		disabled_color = Color("1a1720")
		background_color = Color("13111a")
		normal_color = Color("1e1a2b")
		normal_elevated_color = Color("2e2840")
		accent_color = Color("9d6fff")
		progress_bar_fill_color = Color("7c3dff")
		primary_font_color = Color("e8e3f5")
		disabled_font_color = Color("6b6380")
		tab_unselected_font_color = Color("9d93b8")
	elif theme == "Blood Moon":
		disabled_color = Color("201517")
		background_color = Color("190f11")
		normal_color = Color("291518")
		normal_elevated_color = Color("3d1f23")
		accent_color = Color("e84a5f")
		progress_bar_fill_color = Color("c0392b")
		primary_font_color = Color("f0e6e8")
		disabled_font_color = Color("7a5e62")
		tab_unselected_font_color = Color("b08890")
	elif theme == "Moonlit Sakura":
		disabled_color = Color("2a1e22")
		background_color = Color("1f1519")
		normal_color = Color("2e1e24")
		normal_elevated_color = Color("3d2830")
		accent_color = Color("e8608a")
		progress_bar_fill_color = Color("d94f7a")
		primary_font_color = Color("f0dde3")
		disabled_font_color = Color("7a5560")
		tab_unselected_font_color = Color("a87d8a")
