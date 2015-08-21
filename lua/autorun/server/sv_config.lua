--[[
        Module is the MySQL Module your Garry's Mod server is using.
--]]
Module = "mysqloo";
--[[
        Forum is the board software you are using for your website.

        Supports:
                "smf",
                "mybb",
                "ipb",
                "xen",
                "phpbb"

        If you wish to add support for this software contact me at
        Septharoth@rebornservers.com and I'll get to work on it.

--]]

Forum = "";

--[[
        Prefix is the "prefix" used to define the the beginning of
        forum tables.  Examples are: smf_link, smf_rank

        Note: Ensure this is correct.  I don't want to hear you 
        complaining this isn't working when this is your issue.
--]]

Prefix = "";

--[[
        Community is the name of your community you are linking
        your users to.
--]]

Community = "";

--[[
        URL is the address to your forum site index page.

        Note: DO NOT include ANY FILE EXTENSION IN THIS URL!
        YOU MUST ONLY USE ONE / IN THE http://

        HERE IS AN EXAMPLE: "http:/www.yoursite.com"
--]]

URL = "";

--[[
        Group is the default Group you wish clients to be placed
        into.  This MUST be a number.

        Defaults: SMF 4, MyBB 2, IPB 3, XEN 2
--]]

Group = 21;

--[[
        Admin is a boolean, when set to true it will enable
        the SetUserGroup function and will rank users according
        to their Forum usergroup.  Forum and ulx ranks MUST be the same.
--]]

Admin = true;

--[[
        Alias is a boolean, when set to true it will enable the
        function that sets your forum Display name to your Steam
        nickname.
--]]
Alias = false;

--[[
        Kick is a boolean, when set to true it will kick users who are
        banned from the forum.
--]]

Kick = false;

--[[
        BanUserGroup is the group id that contains your banned forum users.

        Default this is disabled.  MUST be a number.
--]]

BanGroup = nil;

--[[
        Reset is a boolean, when set to true users can use the "!logout"
        or "!unlink" chat commands.
--]]

Reset = true;

--[[
        Register is a boolean, when set to true, users are forced to
        register for your forums in-game.
--]]

Register = false;

--[[
        CheckDB is a boolean, when set to true this will check your database
        every 10 minutes to see if a connection is established or not.
--]]

CheckDB = false;

--[[
        vers is the version of gForum2.0, modifying this does nothing.
--]]

vers = "1";


--[[
        END OF CONFIG
--]]

print("[gForum] Configuration Loaded! You are using Forum Software: ".. Forum ..", using version "..vers.." of gForum2.0.");
