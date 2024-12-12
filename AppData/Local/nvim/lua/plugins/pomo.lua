return {
	"epwalsh/pomo.nvim",
	version = "*", -- Recommended, use latest release instead of latest commit
	lazy = true,
	cmd = { "TimerStart", "TimerRepeat", "TimerSession" },
	dependencies = {
		-- Optional, but highly recommended if you want to use the "Default" timer
		"rcarriga/nvim-notify",
	},
	opts = {
		notifiers = {
			{
				name = "Default",
				opts = {
					sticky = false,
				},
			},
			{
				init = function(timer, opts)
					local WSLNotifier = {}

					WSLNotifier.new = function(timer, opts)
						local self = setmetatable({}, { __index = WSLNotifier })
						self.timer = timer
						self.hidden = true
						self.opts = opts -- not used
						return self
					end

					WSLNotifier.start = function(self)
						print(
							string.format(
								"Starting timer #%d, %s, for %ds",
								self.timer.id,
								self.timer.name,
								self.timer.time_limit
							)
						)
					end

					WSLNotifier.tick = function(self, time_left)
						if not self.hidden then
							print(
								string.format(
									"Timer #%d, %s, %ds remaining...",
									self.timer.id,
									self.timer.name,
									time_left
								)
							)
						end
					end

					WSLNotifier.done = function(self)
						os.execute("wsl-notify-send.exe -c $WSL_DISTRO_NAME 'Timer done! Get up and enjoy life :D'")
					end

					WSLNotifier.stop = function(self) end

					WSLNotifier.show = function(self)
						self.hidden = false
					end

					WSLNotifier.hide = function(self)
						self.hidden = true
					end
					return WSLNotifier.new(timer, opts)
				end,
				opts = {},
			},
		},
		-- You can optionally define custom timer sessions.
		sessions = {
			-- Example session configuration for a session called "pomodoro".
			pomodoro = {
				{ name = "Work", duration = "25m" },
				{ name = "Short Break", duration = "5m" },
				{ name = "Work", duration = "25m" },
				{ name = "Short Break", duration = "5m" },
				{ name = "Work", duration = "25m" },
				{ name = "Long Break", duration = "15m" },
			},
		},
		update_interval = 3000,
	},
}
