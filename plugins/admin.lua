--[[
	IRC Bot Administration
]]

PLUGIN.Name = "Administration"

local BOT

function Load(bot)
	BOT = bot
end

--bot administration
Command "login"
{	
	function(password)
		if CONFIG.password and CONFIG.password == password then
			reply("Welcome, %s", user.nick)
			loggedIn[user.host] = true
		end
	end
}

Command "reload"
{
	admin = true;
	
	function(dir)
		--TODO: once commands stick after a single unload, don't reload default plugins
		BOT:unloadPlugins()

		local succ, err = BOT:loadDefaultPlugins()
		if not succ then
			raise(err)
		end
		succ, err = BOT:loadPluginsFolder(dir or CONFIG.plugin_dir)
		if not succ then
			raise(err)
		end
		reply("Reloaded plugins.")
	end
}

Command "quit" "exit"
{
	admin = true;
	
	function(message)
		BOT:close(message)
		os.exit()
	end
}

--irc helpers
Command "join"
{
	expectedArgs = -1;
	admin = true;
	
	function(channel, key)
		BOT:join(channel, key)
		reply("Joined %s", channel)
	end
}

Command "part"
{
	expectedArgs = 1;
	admin = true;

	function(channel)
		BOT:part(channel)
		reply("Left %s", channel)
	end
}

Command "pm" "send"
{
	expectedArgs = "^(%S+) (.+)$";
	admin = true;

	function(target, message)
		BOT:sendChat(target, message)
		reply("Sent \"%s\" to \"%s\"", message, target)
	end
}
