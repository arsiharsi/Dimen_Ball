var is_supported setget , _is_supported_getter
var is_native_popup_supported setget , _is_native_popup_supported_getter
var is_multiple_boards_supported setget , _is_multiple_boards_supported_getter
var is_set_score_supported setget , _is_set_score_supported_getter
var is_get_score_supported setget , _is_get_score_supported_getter
var is_get_entries_supported setget , _is_get_entries_supported_getter


func _is_supported_getter():
	return _js_leaderboard.isSupported

func _is_native_popup_supported_getter():
	return _js_leaderboard.isNativePopupSupported

func _is_multiple_boards_supported_getter():
	return _js_leaderboard.isMultipleBoardsSupported

func _is_set_score_supported_getter():
	return _js_leaderboard.isSetScoreSupported

func _is_get_score_supported_getter():
	return _js_leaderboard.isGetScoreSupported

func _is_get_entries_supported_getter():
	return _js_leaderboard.isGetEntriesSupported

var _js_leaderboard = null
var _set_score_callback = null
var _js_set_score_then = JavaScript.create_callback(self, "_on_js_set_score_then")
var _js_set_score_catch = JavaScript.create_callback(self, "_on_js_set_score_catch")
var _get_score_callback = null
var _js_get_score_then = JavaScript.create_callback(self, "_on_js_get_score_then")
var _js_get_score_catch = JavaScript.create_callback(self, "_on_js_get_score_catch")
var _get_entries_callback = null
var _js_get_entries_then = JavaScript.create_callback(self, "_on_js_get_entries_then")
var _js_get_entries_catch = JavaScript.create_callback(self, "_on_js_get_entries_catch")
var _show_native_popup_callback = null
var _js_show_native_popup_then = JavaScript.create_callback(self, "_on_js_show_native_popup_then")
var _js_show_native_popup_catch = JavaScript.create_callback(self, "_on_js_show_native_popup_catch")


func set_score(options, callback = null):
	if _set_score_callback != null:
		return
	
	if not options is Bridge.SetScoreYandexOptions:
		if callback != null:
			callback.call_func(false)
		return
	
	_set_score_callback = callback
	
	var js_options = JavaScript.create_object("Object")
	js_options.yandex = JavaScript.create_object("Object")
	js_options.yandex.score = options.score
	js_options.yandex.leaderboardName = options.leaderboard_name
	
	_js_leaderboard.setScore(js_options) \
		.then(_js_set_score_then) \
		.catch(_js_set_score_catch)

func get_score(options, callback = null):
	if _get_score_callback != null:
		return
	
	if not options is Bridge.GetScoreYandexOptions:
		if callback != null:
			callback.call_func(false)
		return
	
	_get_score_callback = callback
	
	var js_options = JavaScript.create_object("Object")
	js_options.yandex = JavaScript.create_object("Object")
	js_options.yandex.leaderboardName = options.leaderboard_name
	
	_js_leaderboard.getScore(js_options) \
		.then(_js_get_score_then) \
		.catch(_js_get_score_catch)

func get_entries(options, callback = null):
	if _get_entries_callback != null:
		return
	
	if not options is Bridge.GetEntriesYandexOptions:
		if callback != null:
			callback.call_func(false)
		return
	
	_get_entries_callback = callback
	
	var js_options = JavaScript.create_object("Object")
	js_options.yandex = JavaScript.create_object("Object")
	js_options.yandex.leaderboardName = options.leaderboard_name
	js_options.yandex.includeUser = options.include_user
	js_options.yandex.quantityAround = options.quantity_around
	js_options.yandex.quantityTop = options.quantity_top
	
	_js_leaderboard.getEntries(js_options) \
		.then(_js_get_entries_then) \
		.catch(_js_get_entries_catch)

func show_native_popup(options, callback = null):
	if _show_native_popup_callback != null:
		return
	
	if not options is Bridge.ShowNativePopupVkOptions:
		if callback != null:
			callback.call_func(false)
		return
	
	_show_native_popup_callback = callback
	
	var js_options = JavaScript.create_object("Object")
	js_options.vk = JavaScript.create_object("Object")
	js_options.vk.userResult = options.user_result
	js_options.vk.global = options.global
	
	_js_leaderboard.showNativePopup(js_options) \
		.then(_js_show_native_popup_then) \
		.catch(_js_show_native_popup_catch)


func _init(js_leaderboard):
	_js_leaderboard = js_leaderboard

func _on_js_set_score_then(args):
	if _set_score_callback != null:
		_set_score_callback.call_func(true)
		_set_score_callback = null

func _on_js_set_score_catch(args):
	if _set_score_callback != null:
		_set_score_callback.call_func(false)
		_set_score_callback = null

func _on_js_get_score_then(args):
	if _get_score_callback != null:
		_get_score_callback.call_func(true, args[0])
		_get_score_callback = null

func _on_js_get_score_catch(args):
	if _get_score_callback != null:
		_get_score_callback.call_func(false, 0)
		_get_score_callback = null

func _on_js_get_entries_then(args):
	if _get_entries_callback != null:
		var data = args[0]
		var data_type = typeof(data)
		match data_type:
			TYPE_OBJECT:
				var array = []
				for i in range(data.length):
					array.append(data[i])
				_get_entries_callback.call_func(true, array)
			_:
				_get_entries_callback.call_func(false, [])
		_get_entries_callback = null

func _on_js_get_entries_catch(args):
	if _get_entries_callback != null:
		_get_entries_callback.call_func(false, [])
		_get_entries_callback = null

func _on_js_show_native_popup_then(args):
	if _show_native_popup_callback != null:
		_show_native_popup_callback.call_func(true)
		_show_native_popup_callback = null

func _on_js_show_native_popup_catch(args):
	if _show_native_popup_callback != null:
		_show_native_popup_callback.call_func(false)
		_show_native_popup_callback = null
