local Forum, FName, FGroup, FPosts = "", "", "", ""

net.Receive("gforum", function( len, p )
        local str = net.ReadString()
        if str == "smf" then
                Forum = "SMF"
        elseif str == "mybb" then
                Forum = "MyBB"
        elseif str == "ipb" then
                Forum = "IPB"
        else
                Forum = "XF"
        end
        OpenedAlready = false
end)

surface.CreateFont( "CvetLarge", {
        font = "Coolvetica",
        size = 40,
        weight = 500,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = false,
        additive = false,
        outline = false,
} )

surface.CreateFont( "CvetMed", {
        font = "Coolvetica",
        size = 23,
        weight = 500,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = false,
        additive = false,
        outline = false,
} )

surface.CreateFont( "CvetSm", {
        font = "Coolvetica",
        size = 16,
        weight = 500,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = false,
        additive = false,
        outline = false,
} )

function RegisterAccount()
        local p = LocalPlayer()
        local RegisterPanel = vgui.Create("DFrame")
        RegisterPanel:SetSize(297, 414)
        RegisterPanel:SetPos(ScrW() / 2.2 - 93, ScrH() / 2.2 - 82)
        RegisterPanel:SetSizable(false)
        RegisterPanel:SetDraggable(false)
        RegisterPanel:SetDeleteOnClose(false)
        RegisterPanel:ShowCloseButton(false)
        RegisterPanel:MakePopup()
        RegisterPanel:SetTitle("Account Creation")
        RegisterPanel.Paint = function()
                surface.SetDrawColor(54, 57, 61, 255)
                surface.DrawRect(0, 0, RegisterPanel:GetWide(), RegisterPanel:GetTall())
                
                surface.SetDrawColor(46, 48, 57, 255)
                surface.DrawRect(1, 0, RegisterPanel:GetWide() - 2, RegisterPanel:GetTall() - 145)
                
                surface.SetDrawColor(150, 150, 150, 200)
                surface.DrawOutlinedRect(0, 0, RegisterPanel:GetWide(), RegisterPanel:GetTall())
        end

        local Logo = vgui.Create("DLabel", RegisterPanel)
        Logo:SetFont("CvetLarge")
        Logo:SetPos(RegisterPanel:GetWide() / 4.8, 34)
        Logo:SetText("registration")
        Logo:SizeToContents()
        
        local Link = vgui.Create("DButton", RegisterPanel)
        Link:SetPos(73,378)
        Link:SetSize(155, 25)
        Link:SetText("Already have an account?")
        Link:SetFont("CvetSm")
        Link.DoClick = function()
                LinkAccount()
                RegisterPanel:Close()
        end
        Link.Paint = function()
                draw.RoundedBox(4, 0, 0, Link:GetWide(), Link:GetTall(), Color(0, 255, 0, 200))
        end
        
        timer.Create("blink", 1, 3, function()
                if OpenedAlready then return end
                OpenedAlready = true
        end)

        local Close = vgui.Create("DLabel", RegisterPanel)
        Close:SetText("X")
        Close:SetFont("CvetLarge")
        Close:SetPos(RegisterPanel:GetWide() - Close:GetTextSize(), 3)
        Close.DoClick = function()
                RegisterPanel:Close()
        end

        // Username
        local Username = vgui.Create("DLabel", RegisterPanel)
        Username:SetPos(16, 98)
        Username:SetFont("CvetMed")
        Username:SetText("username")
        Username:SizeToContents()
        
        local UsernameEntry = vgui.Create("DTextEntry", RegisterPanel)
        UsernameEntry:SetSize(250, 21)
        UsernameEntry:SetPos(16, 118)
        UsernameEntry:SetText("")
        UsernameEntry.Paint = function( )
                draw.RoundedBox(4, 0, 0, UsernameEntry:GetWide(), UsernameEntry:GetTall(), Color( 255, 255, 255, 200 ) )
                local username = UsernameEntry:GetValue()
                local color = Color(100, 100, 100, 255)
                if string.len(username) <= 0 then
                        username = "Username"
                        color = Color(100, 100, 100, 255)
                elseif string.len(username) >= 1 then
                        username = UsernameEntry:GetValue()
                        color = Color(50, 50, 50, 255)
                end
                surface.SetFont("Default")
                surface.SetTextColor(color)
                surface.SetTextPos(2, 5) 
                surface.DrawText(username)
        end
        UsernameEntry.Think = function( )
                local username = UsernameEntry:GetValue()
                if string.len(username) > 5 then
                        UsernameStatus:SetImage("icon16/tick.png")
                end
        end
        
        local UsernameIcon = vgui.Create("DImage", RegisterPanel)
        UsernameIcon:SetSize(14, 14)
        UsernameIcon:SetPos(98, 102)
        UsernameIcon:SetImage("icon16/user.png")
        UsernameIcon:SetToolTip("User name must be 5 characters long.")
        
        UsernameStatus = vgui.Create("DImage", RegisterPanel)
        UsernameStatus:SetSize(14, 14)
        UsernameStatus:SetPos(268, 118)
        UsernameStatus:SetImage("icon16/exclamation.png")
        
        // Password
        local Password = vgui.Create("DLabel", RegisterPanel)
        Password:SetPos(16, 165)
        Password:SetFont("CvetMed")
        Password:SetText("password")
        Password:SizeToContents()
        
        local PasswordEntry = vgui.Create("DTextEntry", RegisterPanel)
        PasswordEntry:SetSize(250, 21)
        PasswordEntry:SetPos(16, 184)
        PasswordEntry:SetText("")
        PasswordEntry.Paint = function( )
                draw.RoundedBox(4, 0, 0, PasswordEntry:GetWide(), PasswordEntry:GetTall(), Color( 255, 255, 255, 200 ))
                local password = PasswordEntry:GetValue()
                local color = Color(100, 100, 100, 255)
                if string.len(password) <= 0 then
                        password = "Password"
                        color = Color(100, 100, 100, 255)
                elseif string.len(password) >= 1 then
                        password = PasswordEntry:GetValue()
                        color = Color(50, 50, 50, 255)
                end
                surface.SetFont("Default")
                surface.SetTextColor(color)
                surface.SetTextPos(2, 5) 
                surface.DrawText(password)
        end
        PasswordEntry.Think = function( )
                local password = PasswordEntry:GetValue()
                if string.len(password) > 5 then
                        PasswordStatus:SetImage("icon16/tick.png")
                end
        end
        
        local PasswordIcon = vgui.Create("DImage", RegisterPanel)
        PasswordIcon:SetSize(14, 14)
        PasswordIcon:SetPos(95, 168)
        PasswordIcon:SetImage("icon16/key.png")
        PasswordIcon:SetToolTip("Password must be 5 characters long.")
        
        PasswordStatus = vgui.Create("DImage", RegisterPanel)
        PasswordStatus:SetSize(14, 14)
        PasswordStatus:SetPos(268, 185)
        PasswordStatus:SetImage("icon16/exclamation.png")
        
        // Email
        local Email = vgui.Create("DLabel", RegisterPanel)
        Email:SetPos(16, 234)
        Email:SetFont("CvetMed")
        Email:SetText("e-mail address")
        Email:SizeToContents()
        
        local EmailEntry = vgui.Create("DTextEntry", RegisterPanel)
        EmailEntry:SetSize(250, 21)
        EmailEntry:SetPos(16, 253)
        EmailEntry:SetText("")
        EmailEntry.Paint = function( )
                draw.RoundedBox(4, 0, 0, EmailEntry:GetWide(), EmailEntry:GetTall(), Color( 255, 255, 255, 200 ))
                local email = EmailEntry:GetValue()
                local color = Color(100, 100, 100, 255)
                if string.len(email) <= 0 then
                        email = "Email"
                        color = Color(100, 100, 100, 255)
                elseif string.len(email) >= 1 then
                        email = EmailEntry:GetValue()
                        color = Color(50, 50, 50, 255)
                end
                surface.SetFont("Default")
                surface.SetTextColor(color)
                surface.SetTextPos(2, 5) 
                surface.DrawText(email)
        end
        EmailEntry.Think = function( )
                local email = EmailEntry:GetValue()
                if string.len(email) > 8 then
                        EmailStatus:SetImage("icon16/tick.png")
                end
        end
        
        local EmailIcon = vgui.Create("DImage", RegisterPanel)
        EmailIcon:SetSize(14, 14)
        EmailIcon:SetPos(134, 239)
        EmailIcon:SetImage("icon16/email.png")
        EmailIcon:SetToolTip("Email must be 8 characters long.")
        
        EmailStatus = vgui.Create("DImage", RegisterPanel)
        EmailStatus:SetSize(14, 14)
        EmailStatus:SetPos(266, 253)
        EmailStatus:SetImage("icon16/exclamation.png")
        
        // Submit
        local Submit = vgui.Create("DButton", RegisterPanel)
        Submit:SetSize(155, 43)
        Submit:SetPos(73, 316)
        Submit:SetText("sign up")
        Submit:SetFont("CvetLarge")
        Submit.Paint = function()
                draw.RoundedBox(4, 0, 0, Submit:GetWide(), Submit:GetTall(), Color(0, 255, 0, 200))
        end
        
        Submit.DoClick = function()
                local username = UsernameEntry:GetValue()
                local password = PasswordEntry:GetValue()
                local email = EmailEntry:GetValue()
                if string.len(username) < 4 then p:ChatPrint("[" .. Forum .. "] Your username has be 4 characters or more.") return end
                if string.len(password) < 6 then p:ChatPrint("[" .. Forum .. "] Your password has be 6 characters or more.") return end
                if string.len(email) < 8 then p:ChatPrint("[" .. Forum .. "] Your email has be 8 characters or more.") return end
                RegisterPanel:Close()
                RunConsoleCommand("sv_register", username, password, email)
        end

end

net.Receive("gforum_register", RegisterAccount)

function LinkAccount()
        local p = LocalPlayer()
        local LinkPanel = vgui.Create("DFrame")
        LinkPanel:SetSize(297, 414)
        LinkPanel:SetPos(ScrW() / 2.2 - 93, ScrH() / 2.2 - 82)
        LinkPanel:SetTitle("Login")
        LinkPanel:SetSizable(false)
        LinkPanel:SetDraggable(false)
        LinkPanel:SetDeleteOnClose(false)
        LinkPanel:ShowCloseButton(false)
        LinkPanel:MakePopup()
        LinkPanel.Paint = function()
                surface.SetDrawColor(54, 57, 61, 255)
                surface.DrawRect(0, 0, LinkPanel:GetWide(), LinkPanel:GetTall())
                
                surface.SetDrawColor(46, 48, 57, 255)
                surface.DrawRect(1, 0, LinkPanel:GetWide() - 2, LinkPanel:GetTall() - 145)
                
                surface.SetDrawColor(150, 150, 150, 200)
                surface.DrawOutlinedRect(0, 0, LinkPanel:GetWide(), LinkPanel:GetTall())
        end

        local Logo = vgui.Create("DLabel", LinkPanel)
        Logo:SetFont("CvetLarge")
        Logo:SetPos(LinkPanel:GetWide() / 3.8, 34)
        Logo:SetText("login")
        Logo:SizeToContents()
        
        local Register = vgui.Create("DButton", LinkPanel)
        Register:SetPos(73, 378)
        Register:SetSize(155, 25)
        Register:SetText("Dont have an account?")
        Register:SetFont("CvetSm")
        Register.DoClick = function()
                RegisterAccount()
                LinkPanel:Close()
        end
        Register.Paint = function()
                draw.RoundedBox(4, 0, 0, Register:GetWide(), Register:GetTall(), Color(0, 255, 0, 200))
        end
        
        timer.Create("blink", 1, 3, function()
                if OpenedAlready then return end
                OpenedAlready = true
        end)

        local Close = vgui.Create("DLabel", LinkPanel)
        Close:SetText("X")
        Close:SetFont("CvetLarge")
        Close:SetPos(LinkPanel:GetWide() - Close:GetTextSize(), 3)
        Close.DoClick = function()
                LinkPanel:Close()
        end
        
        // Username
        local Username = vgui.Create("DLabel", LinkPanel)
        Username:SetPos(16, 98)
        Username:SetFont("CvetMed")
        Username:SetText("username")
        Username:SizeToContents()
        
        local UsernameEntry = vgui.Create("DTextEntry", LinkPanel)
        UsernameEntry:SetSize(250, 21)
        UsernameEntry:SetPos(16, 118)
        UsernameEntry:SetText("")
        UsernameEntry.Paint = function( )
                draw.RoundedBox(4, 0, 0, UsernameEntry:GetWide(), UsernameEntry:GetTall(), Color( 255, 255, 255, 200 ) )
                local username = UsernameEntry:GetValue()
                local color = Color(100, 100, 100, 255)
                if string.len(username) <= 0 then
                        username = "Username"
                        color = Color(100, 100, 100, 255)
                elseif string.len(username) >= 1 then
                        username = UsernameEntry:GetValue()
                        color = Color(50, 50, 50, 255)
                end
                surface.SetFont("Default")
                surface.SetTextColor(color)
                surface.SetTextPos(2, 5) 
                surface.DrawText(username)
        end
        UsernameEntry.Think = function( )
                local username = UsernameEntry:GetValue()
                if string.len(username) > 5 then
                        UsernameStatus:SetImage("icon16/tick.png")
                end
        end
        
        local UsernameIcon = vgui.Create("DImage", LinkPanel)
        UsernameIcon:SetSize(14, 14)
        UsernameIcon:SetPos(98, 102)
        UsernameIcon:SetImage("icon16/user.png")
        UsernameIcon:SetToolTip("User name must be 5 characters long.")
        
        UsernameStatus = vgui.Create("DImage", LinkPanel)
        UsernameStatus:SetSize(14, 14)
        UsernameStatus:SetPos(268, 118)
        UsernameStatus:SetImage("icon16/exclamation.png")
        
        // Password
        local Password = vgui.Create("DLabel", LinkPanel)
        Password:SetPos(16, 165)
        Password:SetFont("CvetMed")
        Password:SetText("password")
        Password:SizeToContents()
        
        local PasswordEntry = vgui.Create("DTextEntry", LinkPanel)
        PasswordEntry:SetSize(250, 21)
        PasswordEntry:SetPos(16, 184)
        PasswordEntry:SetText("")
        PasswordEntry.Paint = function( )
                draw.RoundedBox(4, 0, 0, PasswordEntry:GetWide(), PasswordEntry:GetTall(), Color( 255, 255, 255, 200 ))
                local password = PasswordEntry:GetValue()
                local color = Color(100, 100, 100, 255)
                if string.len(password) <= 0 then
                        password = "Password"
                        color = Color(100, 100, 100, 255)
                elseif string.len(password) >= 1 then
                        password = PasswordEntry:GetValue()
                        color = Color(50, 50, 50, 255)
                end
                surface.SetFont("Default")
                surface.SetTextColor(color)
                surface.SetTextPos(2, 5) 
                surface.DrawText(password)
        end
        PasswordEntry.Think = function( )
                local password = PasswordEntry:GetValue()
                if string.len(password) > 5 then
                        PasswordStatus:SetImage("icon16/tick.png")
                end
        end
        
        local PasswordIcon = vgui.Create("DImage", LinkPanel)
        PasswordIcon:SetSize(14, 14)
        PasswordIcon:SetPos(95, 168)
        PasswordIcon:SetImage("icon16/key.png")
        PasswordIcon:SetToolTip("Password must be 5 characters long.")
        
        PasswordStatus = vgui.Create("DImage", LinkPanel)
        PasswordStatus:SetSize(14, 14)
        PasswordStatus:SetPos(268, 185)
        PasswordStatus:SetImage("icon16/exclamation.png")
        
        // Submit
        local Submit = vgui.Create("DButton", LinkPanel)
        Submit:SetSize(155, 43)
        Submit:SetPos(73, 316)
        Submit:SetText("login")
        Submit:SetFont("CvetLarge")
        Submit.Paint = function()
                draw.RoundedBox(4, 0, 0, Submit:GetWide(), Submit:GetTall(), Color(0, 255, 0, 200))
        end

        Submit.DoClick = function()
                local username = UsernameEntry:GetValue()
                local password = PasswordEntry:GetValue()
                if string.len(username) < 4 then p:ChatPrint("[" .. Forum .. "] Your username has be 4 characters or more.") return end
                if string.len(password) < 4 then p:ChatPrint("[" .. Forum .. "] Your password has be 4 characters or more.") return end
                LinkPanel:Close()
                RunConsoleCommand("sv_link", username, password)
        end
end

net.Receive("gforum_link", LinkAccount)

function ShowError( txt )
        local st = string.Explode(";", txt)
        local line1, line2 = st[1], st[2]
        local p = LocalPlayer()
        
        local ErrorPanel = vgui.Create("DFrame")
        ErrorPanel:SetSize(220, 64)
        ErrorPanel:SetPos(ScrW() / 2 - 110, ScrH() / 2 - 32)
        ErrorPanel:SetTitle(line1)
        ErrorPanel:SetSizable(false)
        ErrorPanel:SetDraggable(false)
        ErrorPanel:SetDeleteOnClose(false)
        ErrorPanel:ShowCloseButton(false)
        ErrorPanel:MakePopup()
        ErrorPanel.Paint = function()
                surface.SetDrawColor(54, 57, 61, 255)
                surface.DrawRect(0, 0, ErrorPanel:GetWide(), ErrorPanel:GetTall())
                
                surface.SetDrawColor(46, 48, 57, 255)
                surface.DrawRect(1, 1, ErrorPanel:GetWide() - 2, ErrorPanel:GetTall() - 145)
                
                surface.SetDrawColor(150, 150, 150, 200)
                surface.DrawOutlinedRect(0, 0, ErrorPanel:GetWide(), ErrorPanel:GetTall())
        end
        
        local Close = vgui.Create("DImageButton", ErrorPanel)
        Close:SetPos(200, 4)
        Close:SetImage("icon16/exclamation.png")
        Close:SetSize(14, 14)
        Close:SetToolTip("Close this panel?")
        Close.DoClick = function()
                ErrorPanel:Close()
        end
        
        local Message = vgui.Create("DLabel", ErrorPanel)
        Message:SetPos(2, 24)
        Message:SetTextColor(Color(255, 255, 255, 255))
        Message:SetText(" " .. st[2])
        Message:SizeToContents()
end

net.Receive("gforum_error", function( len, p)
        local txt = net.ReadString()
        ShowError(txt)
end)

ForumUsers = {}
net.Receive("gforum_users", function( len, p )
        local tbl = net.ReadTable()
        ForumUsers = tbl
end)

function Users()
        local UsersPanel = vgui.Create( "DFrame" )
        UsersPanel:SetTitle("Server Forum Users")
        UsersPanel:SetSize(300, 600)
        UsersPanel:SetDraggable(false)
        UsersPanel:ShowCloseButton(false)
        UsersPanel:MakePopup()
        UsersPanel:Center()
        UsersPanel:SetMouseInputEnabled(true)
        UsersPanel:SetKeyBoardInputEnabled(false)
        
        local Close = vgui.Create("DImageButton", UsersPanel)
        Close:SetPos(UsersPanel:GetWide() - 17, 4)
        Close:SetImage("icon16/cross.png")
        Close:SetSize(14, 14)
        Close:SetToolTip("Close this panel?")
        Close.DoClick = function()
                UsersPanel:Close()
        end
        
        local x, y = 4, 28
        for k, v in pairs(ForumUsers) do
                
                local User = vgui.Create("DPanel", UsersPanel)
                User:SetSize(UsersPanel:GetWide() - 8, 32)
                User:SetPos(x, y)
                
                local Avatar = vgui.Create("AvatarImage", User)
                Avatar:SetPos(2, 4)
                Avatar:SetSize(24, 24)
                Avatar:SetPlayer(player.GetByUniqueID(v[3]), 24)
                
                local Name = vgui.Create("DLabel", User)
                Name:SetPos(32, 4)
                Name:SetText(v[1])
                Name:SetFont("Trebuchet18")
                Name:SetTextColor(Color(1, 1, 1, 255))
                
                local FName = vgui.Create("DLabel", User)
                FName:SetPos(Avatar:GetWide() + Name:GetWide() + 4, 4)
                FName:SetText(v[2])
                FName:SetFont("Trebuchet18")
                FName:SetTextColor(Color(1, 1, 1, 255))
                
                local UserButton = vgui.Create("DButton", User)
                UserButton:SetSize(UsersPanel:GetWide() - 8, 32)
                UserButton:SetPos(0, 0)
                UserButton:SetText("")
                UserButton.DoClick = function()
                        if Forum == "smf" then
                                gui.OpenURL(FURL .. "index.php?action=profile;u=" .. v[4])
                        elseif Forum == "mybb" then
                                gui.OpenURL(FURL .. "member.php?action=profile&uid=" .. v[4])
                        elseif Forum == "ipb" then
                                gui.OpenURL(FURL .. "user/" .. v[4] .. "-" .. string.lower(v[2]) .. "/")
                        else
                                gui.OpenURL(FURL .. "members/" .. v[4])
                        end
                end
                UserButton.Paint = function()
                        surface.SetDrawColor(1, 1, 1, 0)
                        surface.DrawRect(0, 0, User:GetWide(), User:GetTall())
                end
                
                y = y + 34
        end
        
        UsersPanel:SizeToChildren(false, true)
        UsersPanel:Center()
        UsersPanel.Paint = function()
                surface.SetDrawColor(54, 57, 61, 255)
                surface.DrawRect(0, 0, UsersPanel:GetWide(), UsersPanel:GetTall())
                
                surface.SetDrawColor(150, 150, 150, 200)
                surface.DrawOutlinedRect(0, 0, UsersPanel:GetWide(), UsersPanel:GetTall())
        end
end

function DisplayAccount( p, bool )
        if !p or !bool then return end
        if !Panel then
                Panel = vgui.Create("DFrame")
                Panel:SetPos(2, 2)
                Panel:SetSize(150, 74)
                Panel:SetTitle("")
                Panel:SetDraggable(false)
                Panel:ShowCloseButton(false)
                Panel:MakePopup()
                Panel:SetMouseInputEnabled(true)
                Panel:SetKeyBoardInputEnabled(false)
                Panel:SetDrawOnTop(false)
                Panel.Paint = function()
                        surface.SetDrawColor(54, 57, 61, 255)
                        surface.DrawRect(0, 0, Panel:GetWide(), Panel:GetTall())
                        
                        surface.SetDrawColor(46, 48, 57, 255)
                        surface.DrawRect(1, 0, Panel:GetWide() - 2, Panel:GetTall() - 55)
                        
                        surface.SetDrawColor(150, 150, 150, 200)
                        surface.DrawOutlinedRect(0, 0, Panel:GetWide(), Panel:GetTall())
                        
                        surface.SetTextPos(40, 26)
                        surface.SetFont("Default")
                        surface.DrawText(FName)
                        surface.SetTextColor(255, 255, 255, 255)
                        
                        surface.SetTextPos(40, 40)
                        surface.SetFont("Default")
                        surface.DrawText(FGroup)
                        surface.SetTextColor(255, 255, 255, 255)
                end
                
                local Avatar = vgui.Create("AvatarImage", Panel)
                Avatar:SetPos(1, 25)
                Avatar:SetSize(32, 32)
                Avatar:SetPlayer(p, 32)
                
                local User = vgui.Create("DImageButton", Panel)
                User:SetPos(Panel:GetWide() - 84, 54)
                User:SetImage("icon16/user_go.png")
                User:SetSize(16, 16)
                User:SetToolTip("View all users forum account.")
                User.DoClick = function()
                        Users()
                end
                
                local Forum = vgui.Create("DImageButton", Panel)
                Forum:SetPos(Panel:GetWide() - 112, 54)
                Forum:SetImage("icon16/world_go.png")
                Forum:SetSize(16, 16)
                Forum:SetToolTip("Goto our forums.")
                Forum.DoClick = function()
                        gui.OpenURL(FURL)
                end
        end
        if bool == "true" then
                Panel:SetVisible(true)
        elseif bool == "false" then
                Panel:SetVisible(false)
        end
end

hook.Add("ScoreboardHide", "ScoreboardHide.DisplayAccount", function()
        DisplayAccount(LocalPlayer(), "false")
        gui.EnableScreenClicker(false)
end)

hook.Add("ScoreboardShow", "ScoreboardShow.DisplayAccount", function()
        DisplayAccount(LocalPlayer(), "true")
        gui.EnableScreenClicker(true)
end)

net.Receive("gforum_setinfo", function( len, p )
        FName = net.ReadString()
        FGroup = net.ReadString()
        FURL = net.ReadString()
        if string.GetChar(FURL, string.len(FURL)) != "/" then
                FURL = FURL .. "/"
        end
end)


print("[gForum] Interface & Networking loaded.")
