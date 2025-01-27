local MULTI_MOD = {
	NAME = "ONLINE MULTIPLAYER",
	TIP = "<c:FF8411>ONLINE MULTIPLAYER</c>\nEnables multiplayer over a TCP connection.\nAdvanced options become available when you launch the game.",
	
	GAME_MODES = {
		NAME = "GAME MODE",
		TIP = "<c:FF8411>GAME MODE</c>Determines the rules for players controlling agents.\n<c:FF8411>FREE FOR ALL</c>\nAny player can control any agent at any time.\n<c:FF8411>BACKSTAB PROTOCOLS</c>\nPlayers control one agent each and take alternating moves. End Turn is replaced with Yield Turn, which hands control to the other player.",
		OPTS = {
			"FREE FOR ALL",
			"BACKSTAB PROTOCOLS"
		}
	},
	
	MISSION_VOTING = {
		NAME = "MISSION VOTING",
		TIP = "<c:FF8411>MISSION VOTING</c>Determines the rules for selecting missions.\n<c:FF8411>FIRST COME FIRST SERVED</c>\nAny player can start a mission.\n<c:FF8411>MAJORITY VOTE</c>\nAll players must select a mission and the mission with the most votes is chosen (random in case of a tie).\n<c:FF8411>WEIGHTED RANDOM</c>\nMissions are chosen at random depending on the number of players that vote on them.\n<c:FF8411>HOST DECIDES</c>\nOnly the host can start a mission.",
		OPTS = {
			"FIRST COME FIRST SERVED",
			"MAJORITY VOTE",
			"WEIGHTED RANDOM",
			"HOST DECIDES",
		}
	},

	REQUIRE_COSTLY_TO_YIELD = {
		NAME = "REQUIRE COSTLY ACTIONS TO YIELD TURN",
		TIP = "If enabled (default), yielding the turn in Backstab Protocols mode will only be available after taking costly actions, otherwise turn ends instead.\nIf disabled, taking any action will allow yielding the turn.",
	},

	PLAYER_AGENT_BINDING = {
		NAME = "1 PLAYER = 1 AGENT",
		TIP = "If enabled, host will be able to assign specific agents to specific players, and other players won't be able to control the assigned agent.\nIf disabled (default), every player will be able to control every agent.",
	},

	FORCE_YIELD_AGENTLESS = {
		NAME = "AGENTLESS PLAYERS FORCE YIELD",
		TIP = "If enabled, players with incapacitated or missing agents will automatically yield every turn, becoming unable to play until they are assigned an active agent.\nDisabled by default.\nApplies only in Backstab Protocols mode with <c:FF8411>1 PLAYER = 1 AGENT</c> enabled.",
	},
	
	BUTTON_HOST = "HOST",
	BUTTON_JOIN = "JOIN",
	BUTTON_LOCAL = "OFFLINE PLAY",
	BUTTON_REFRESH = "REFRESH",
	
	TITLE_SETUP = "SETUP ONLINE MULTIPLAYER",
	TITLE_HOST = "HOST GAME",
	TITLE_JOIN = "JOIN GAME",
	
	BODY_SETUP = "Click Host to setup a game for others to join.",
	BODY_HOST = "Send the ip, port, and optional password to those you wish to join the game.",
	BODY_JOIN = "Enter the ip, port, and password the host sent to you.",
	
	CONNECTION_FAILED = "CONNECTION FAILED",
	CONNECTION_ERROR = "CONNECTION ERROR",
	JOIN_FAILED = "Game already closed.",
	RETRY = "RETRY",
	PASSWORD_REJECTED = "Password Incorrect.",
	WAITING_JOINING = "Waiting to join game...",
	WAITING_PASSWORD = "Waiting for password verification...",
	WAITING_CREATE = "Waiting for game listing to be created...",
	WAIT_GAMES_LIST = "Waiting for response...",
	CONNECTING = "CONNECTING",
	CONNECTING_BODY = "Connecting...",
	CONNECTION_TIMING_OUT = "Waiting for response...",
	CONTINUE_HOST = "HOST GAME",
	JOIN_FAILED_CLOSED = "Failed to join, game is already closed.",
	GAME_OVER = "Game ended by host.",
	
	SOCKET_VERSION_REQUIRED = "Socket version required:",
	CURRENT_SOCKET_VERSION = "Current socket version:",
	
	BACKSTAB_YIELD_SWIPE = "%s ACTIVITY",
	YIELD = "YIELD TURN",
	YIELDED_TO = "%s TURN",

	YIELD_TOOLTIP_HEADER = "YIELD TURN",
	YIELD_TOOLTIP = "Pass the turn to another player.",
	YIELDED_TO_TOOLTIP_HEADER = "TURN YIELDED",
	YIELDED_TO_TOOLTIP = "%s is currently taking their turn. Press to automatically yield until next turn.",
	AUTOYIELDING_TOOLTIP_HEADER = "AUTOYIELDING",
	YIELDED_TO_TOOLTIP_AUTOYIELDING = "%s is currently taking their turn. Turn will be automatically yielded until next turn, press to cancel.",
	AUTOYIELDING_SUFFIX = " <c:F0FF78>(A/Y)</c>",
	FORCEYIELDING_SUFFIX = " <c:F0FF78>(F/Y)</c>",
	FORCEYIELD_TOOLTIP_HEADER = "FORCE YIELDING",
	FORCEYIELD_TOOLTIP = "%s is currently taking their turn. You have no active agents assigned and will automatically yield at the start of your every turn.",

	NOT_YOUR_TURN_TITLE = "Not your turn",
	NOT_YOUR_TURN_SUBTEXT = "%s is currently taking actions.",

	NOT_YOUR_UNIT_TITLE = "Not your unit",
	NOT_YOUR_UNIT_SUBTEXT = "%s is played by %s",

	PLAYED_BY_TOOLTIP_SUFFIX = "\nPlayed by ",
	
	PANEL = {
		TITLE = "Game Title",
		PASSWORD = "Password",
		USERNAME = "Your Name",
		TOGGLE_PASSWORD = "Toggle password visibility",
	}
}

return MULTI_MOD
