extends Node


const DeviceType = {
	DESKTOP = "desktop",
	MOBILE = "mobile",
	TABLET = "tablet",
	TV = "tv"
}

const VisibilityState = {
	VISIBLE = "visible",
	HIDDEN = "hidden"
}

const PlatformId = {
	VK = "vk",
	YANDEX = "yandex",
	CRAZY_GAMES = "crazy_games",
	ABSOLUTE_GAMES = "absolute_games",
	GAME_DISTRIBUTION = "game_distribution",
	MOCK = "mock"
}

const PlatformMessage = {
	GAME_READY = "game_ready",
	IN_GAME_LOADING_STARTED = "in_game_loading_started",
	IN_GAME_LOADING_STOPPED = "in_game_loading_stopped",
	GAMEPLAY_STARTED = "gameplay_started",
	GAMEPLAY_STOPPED = "gameplay_stopped",
	PLAYER_GOT_ACHIEVEMENT = "player_got_achievement"
}

const StorageType = {
	LOCAL_STORAGE = "local_storage",
	PLATFORM_INTERNAL = "platform_internal"
}

const BannerState = {
	LOADING = "loading",
	SHOWN = "shown",
	HIDDEN = "hidden",
	FAILED = "failed"
}

const InterstitialState = {
	LOADING = "loading",
	OPENED = "opened",
	CLOSED = "closed",
	FAILED = "failed"
}

const RewardedState = {
	LOADING = "loading",
	OPENED = "opened",
	REWARDED = "rewarded",
	CLOSED = "closed",
	FAILED = "failed"
}


class ShareVkOptions:
	var link
	func _init(link):
		self.link = link

class JoinCommunityVkOptions:
	var group_id
	func _init(group_id):
		self.group_id = group_id

class CreatePostVkOptions:
	var message
	var attachments
	func _init(message, attachments):
		self.message = message
		self.attachments = attachments

class SetScoreYandexOptions:
	var score
	var leaderboard_name
	func _init(score, leaderboard_name):
		self.score = score
		self.leaderboard_name = leaderboard_name

class GetScoreYandexOptions:
	var leaderboard_name
	func _init(leaderboard_name):
		self.leaderboard_name = leaderboard_name

class GetEntriesYandexOptions:
	var leaderboard_name
	var include_user
	var quantity_around
	var quantity_top
	func _init(leaderboard_name, include_user, quantity_around, quantity_top):
		self.leaderboard_name = leaderboard_name
		self.include_user = include_user
		self.quantity_around = quantity_around
		self.quantity_top = quantity_top

class ShowNativePopupVkOptions:
	var user_result
	var global
	func _init(user_result, global):
		self.user_result = user_result
		self.global = global


var platform setget , _platform_getter
var device setget , _device_getter
var player setget , _player_getter
var game setget , _game_getter
var storage setget , _storage_getter
var advertisement setget , _advertisement_getter
var social setget , _social_getter
var leaderboard setget , _leaderboard_getter


func _platform_getter():
	return _platform

func _device_getter():
	return _device

func _player_getter():
	return _player

func _game_getter():
	return _game

func _storage_getter():
	return _storage

func _advertisement_getter():
	return _advertisement

func _social_getter():
	return _social

func _leaderboard_getter():
	return _leaderboard

var _platform = null
var _device = null
var _player = null
var _game = null
var _storage = null
var _advertisement = null
var _social = null
var _leaderboard = null


func _ready():
	if OS.has_feature("JavaScript"):
		var js_bridge = JavaScript.get_interface("bridge")
		_platform = load("res://addons/instant_games_bridge/scripts/platform/platform.gd").new(js_bridge.platform)
		_device = load("res://addons/instant_games_bridge/scripts/device/device.gd").new(js_bridge.device)
		_player = load("res://addons/instant_games_bridge/scripts/player/player.gd").new(js_bridge.player)
		_game = load("res://addons/instant_games_bridge/scripts/game/game.gd").new(js_bridge.game)
		_storage = load("res://addons/instant_games_bridge/scripts/storage/storage.gd").new(js_bridge.storage)
		_advertisement = load("res://addons/instant_games_bridge/scripts/advertisement/advertisement.gd").new(js_bridge.advertisement)
		_social = load("res://addons/instant_games_bridge/scripts/social/social.gd").new(js_bridge.social)
		_leaderboard = load("res://addons/instant_games_bridge/scripts/leaderboard/leaderboard.gd").new(js_bridge.leaderboard)
	else:
		_platform = load("res://addons/instant_games_bridge/scripts/platform/platform_editor_mock.gd").new()
		_device = load("res://addons/instant_games_bridge/scripts/device/device_editor_mock.gd").new()
		_player = load("res://addons/instant_games_bridge/scripts/player/player_editor_mock.gd").new()
		_game = load("res://addons/instant_games_bridge/scripts/game/game_editor_mock.gd").new()
		_storage = load("res://addons/instant_games_bridge/scripts/storage/storage_editor_mock.gd").new()
		_advertisement = load("res://addons/instant_games_bridge/scripts/advertisement/advertisement_editor_mock.gd").new()
		_social = load("res://addons/instant_games_bridge/scripts/social/social_editor_mock.gd").new()
		_leaderboard = load("res://addons/instant_games_bridge/scripts/leaderboard/leaderboard_editor_mock.gd").new()
