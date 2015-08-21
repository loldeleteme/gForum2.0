AddCSLuaFile("autorun/client/cl_ui.lua");
include("autorun/server/sv_cmd.lua");
include("autorun/server/sv_config.lua");

if Module == "mysqloo" then
	include("autorun/server/sv_mysqloo.lua");
elseif Module == "tmysql" then
	include("autorun/server/sv_tmysql.lua");
else
	include("autorun/server/sv_mysqloo.lua");
	Module = "mysqloo";
end

util.AddNetworkString("gforum");

local Hostname = "";
local Username = "";
local Password = "";
local Database = "";
local Port = 3306;
db = {};
ForumUsers = {};

function ConnectDb()
	if Module == "mysqloo" then
	require("mysqloo");
		
		db = mysqloo.connect(Hostname, Username, Password, Database, Port);

		db.onConnected = function()
			db.connected = true;
			print("[gForum] Successfully connected to the database.");
		end

		db.onConnectionFailed = function()
			db.connected = false;
			print("[gForum] Failed to connect to database.");
		end

		db:connect()

		timer.Simple(3, function()
			if !db.connected then return print("[gForum] Warning!  gForum is not connected to the database, this addon will not work.") end
			local q1 = db:query("CREATE TABLE IF NOT EXISTS " .. Prefix .. "_link(`id` INTEGER NOT NULL, `steamid` TEXT NOT NULL)");
			q1:start()

			local q2 = db:query("CREATE TABLE IF NOT EXISTS " .. Prefix .. "_rank (`id` INTEGER NOT NULL, `rank` TEXT NOT NULL, `steamid` TEXT NOT NULL)");
			q2:start()
		end)

	elseif Module == "tmysql" then

		--[[ REMOVED FOR TESTING ]]--

	else return end
end

if DarkRP then
	
	hook.Add("DarkRPFinishedLoading", "DBConnection", ConnectDb);

	hook.Add("PostPlayerSay", "PostPlayerSay.ChatCommands", function(p, t)
		if t == "!login" or t == "!register" then
			GetUser(p);
		elseif t == "!unlink" or t == "!logout" then
			ResetUser(p);
		elseif t == "!help" then
			p:ChatPrint("[gForum] You can register or link your forum account with the !login or !register command.");
			p:ChatPrint("[gForum] You can unlink or logout of your account with !unlink or !logout.");
		end
	end);

else

	hook.Add("InitPostEntity", "DBConnection", ConnectDb);

	hook.Add("PlayerSay", "PlayerSay.ChatCommands", function(p, text)
		if text == "!login" or text == "!register" then
			GetUser(p);
		elseif text == "!unlink" or text == "!logout" then
			ResetUser(p);
		elseif text == "!help" then
			p:ChatPrint("[gForum] You can register or link your forum account with the !login or !register command.");
			p:ChatPrint("[gForum] You can unlink or logout of your account with !unlink or !logout.");
		end
	end);

end

hook.Add("PlayerInitialSpawn", "PlayerInitialSpawn.GetUser", function(p)
	p:ChatPrint("[gForum] Welcome to "..Community..", Please register on our forum by typing !login or !register")
	net.Start("gforum")
		net.WriteString(Forum)
	net.Send(p)
	p.Register = false
	p.Halt = false
	if p:IsUserGroup("user") then
			net.Start("gforum_setinfo")
				net.WriteString("N A")
				net.WriteString("N A")
				net.WriteString(URL)
            net.Send(p)
            p:ChatPrint("[gForum] Commands: !login !unlink !help")
	else
	GetUser(p)
	end
end)

print("[gForum] SQL Initialized. \n [gForum] gForum2.0 Loaded.");
