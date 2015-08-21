util.AddNetworkString("gforum_register");
util.AddNetworkString("gforum_error");
util.AddNetworkString("gforum_link");
util.AddNetworkString("gforum_setinfo");
util.AddNetworkString("gforum_users");

function Registration( self, user, pass, email, group, regdate )
	local salt, hash, key;

	if self.Registered then
		net.Start("gforum_register");
		net.Send(self);

		net.Start("gforum_error");
			net.WriteString("Notice!!;User already registered under this name.");
		net.Send(self);
		return
	end

	if !user or !pass or !email then
		net.Start("gforum_register");
		net.Send(self);
		net.Start("gforum_error");
			net.WriteString("Notice!!;You\'ve left an entry blank.");
		net.Send(self);
		return
	end

	if !group then group = Group or 0 end
	if !regdate then regdate = os.time() end

		if Forum == "smf" then
			local q1 = db:query("SELECT `member_name` FROM " .. Prefix .. "_members WHERE `member_name`='" .. user .. "'");

				q1.onError = function(e,sql)
					print("[gForum] Query q1 errored! \n [gForum] Query: " .. sql .. " \n [gForum] Error: " .. e );
				end

				q1.onSuccess = function(q,d)
					local q1Data = q:getData()[1] or nil;
					if q1Data then
						net.Start("gforum_register");
						net.Send(self);
						net.Start("gforum_error");
							net.WriteString("Notice!;This username is already taken!");
						net.Send(self);
						self.Halt = true;
						timer.Simple(3, function()
							// query is too fast, because the return is so slow. -- Aide
							self.Halt = false;
						end);
						return
					end
				end

			q1:start();

			hash = string.lower(user) .. pass
			local q2 = db:query("SELECT SHA1('" .. hash .. "')");

				q2.onError = function(e, sql)
					print("[gForum] Query q2 Errored! \n [gForum] Query: " .. sql .. " \n [gForum] Error: " .. e);
				end

				q2.onSuccess = function(q,d)
					for k,v in pairs(q:getData()[1]) do
						hash = string.lower(v);
						break
					end

					if self.Halt then return end

					local q3 = db:query("INSERT INTO " .. Prefix .. "_members (`member_name`, `passwd`, `date_registered`, `id_group`, `real_name`, `email_address`, `member_ip`, `member_ip2`) VALUES('" .. escape(user) .. "', '" .. escape(hash) .. "', '" .. regdate .. "', '" .. group .. "', '" .. escape(user) .. "', '" .. email .. "', '" .. self:IPAddress() .. "', '" .. self:IPAddress() .. "' )");

						q3.onError = function(_e,_sql)
							print("[gForum] Query q3 Errored! \n [gForum] Query: " .. _sql .. " \n [gForum] Error: " .. _e);
						end

						q3.onSuccess = function(_q,_d)
							self:ChatPrint("[gForum] SMF -- Registration Successful! Welcome, "..self:Nick()..", your username is: ".. user);
							LinkAccount(self, user, pass);
							self.Registered = true;
						end

					q3:start();

				end

			q2:start();

		elseif Forum == "mybb" then

				--[[ TODO MyBB ]]--

		elseif Forum == "ipb" then

				--[[ TODO IPB ]]--

		elseif Forum == "xen" then

				--[[ TODO XEN ]]--

		elseif Forum == "phpbb" then

				--[[ TODO PhpBB ]]--

		else

				print("[gForum] This addon currently only supports SMF, Xenforo, IPB, MyBB, and PhpBB.  Create a request in the github");

		end

end


function GetUser( self )
	local group;

		if Forum == "smf" then

			local q1 = db:query("SELECT `id` FROM " .. Prefix .. "_link WHERE `steamid`='" .. self:SteamID() .. "'");

				q1.onError = function(e,sql)
					print("[gForum] Query q1 Errored! \n [gForum] Query: " .. _sql .. " \n [gForum] Error: " .. _e);
				end

				q1.onSuccess = function(q,d)
					local q1Data = q:getData()[1] or nil;

					if q1Data then
						self.Registered = true;
						self:ChatPrint("[gForum] SMF -- Welcome back, " .. self:Nick() .. ", remember to check out our forums at ".. URL .. "!");

						local q2 = db:query("SELECT `id_member`, `member_name`, `id_group`, `personal_text` FROM " .. Prefix .. "_members WHERE `id_member`='" .. q1Data['id'] .. "'");

							q2.onError = function(_e,_sql)
								print("[gForum] Query q2 Errored! \n [gForum] Query: " .. _sql .. " \n [gForum] Error: " .. _e);
							end

							q2.onSuccess = function(_q,_d)
								local q2Data = _q:getData()[1] or nil;

								if q2Data['id_member'] then
									if Alias then
										if q2Data['personal_text'] != self:Nick() then
											db:query("UPDATE " .. Prefix .. "_members SET `personal_text`='" .. escape(self:Nick()) .."' WHERE `id_member`='" .. q1Data['id'] .. "'");
										end
									end

									local q3 = db:query("SELECT `group_name`,`id_group` FROM " .. Prefix .. "_membergroups WHERE `id_group`='" .. q2Data['id_group'] .. "'");

										q3.onError = function(__e,__sql)
											print("[gForum] Query q3 Errored! \n [gForum] Query: " .. _sql .. " \n [gForum] Error: " .. _e);
										end

										q3.onSuccess = function(__q,__d)

											local q3Data = __q:getData()[1] or nil;
											if !q3Data['group_name'] then
												group = "Registered";
											else
												group = q3Data['group_name'];
											end
											if tonumber(q3Data['id_group']) == BanUserGroup and Kick then
												self:Kick("[gForum] You are currently banned from our forums.");
											end

											net.Start("gforum_setinfo");
												net.WriteString(q2Data['member_name']);
												net.WriteString(group);
												net.WriteString(URL);
											net.Send(self);

											local table = { self:Nick(), q2Data['member_name'], self:UniqueID(), q1Data['id'] };
											ForumUsers[q1Data['id']] = table;

											net.Start("gforum_users");
												net.WriteTable(ForumUsers);
											net.Send(self);

											if Admin then
												SetUserGroup(self, q2Data['id_member'], q3Data['id_group'], q3Data['group_name']);
											end

										end

									q3:start();

								end

							end

						q2:start();

					else

						self.Registered = false;
						net.Start("gforum_register");
						net.Send(self);
						net.Start("gforum_error");
							net.WriteString("NOtice!!;Please register for, or link, your forum account.");
						net.Send(self);

					end

				end

			q1:start()

		elseif Forum == "mybb" then		


		elseif Forum == "ipb" then

		elseif Forum == "xen" then

		elseif Forum == "phpbb" then

		else 

			print("[gForum] This addon currently only supports SMF, Xenforo, IPB, MyBB, and PhpBB.  Make a request in the github");

		end
end

function LinkAccount(self, name, pass)

	local salt, hash;
	if self.Halt then return end
	if self.Registered then
		net.Start("gforum_error");
			net.WriteString("Notice!!; Did you already link this account?");
		net.Send(self);
		return
	end
	local Password, Salt;

	if Forum == "smf" then

			hash = string.lower(name) .. pass;
			local q1 = db:query("SELECT SHA1('" .. hash .. "')");
				q1.onError = function(e,sql)
					print("[gForum] Query q1 errored! \n [gForum] Query: " .. sql .. " \n [gForum] Error: " .. e );
				end

				q1.onSuccess = function(q,d)
					for k,v in pairs(q:getData()[1]) do
						hash = string.lower(v);
						break
					end

					local q2 = db:query("SELECT `id` FROM " .. Prefix .. "_link WHERE `steamid`='" .. self:SteamID() .. "'");

						q2.onError = function(_e,_sql)
							print("[gForum] Query q2 errored! \n [gForum] Query: " .. _sql .. " \n [gForum] Error: " .. _e );
						end

						q2.onSuccess = function(_q,_d)
							local q2Data = _q:getData()[1] or nil;

							if q2Data && q2Data['id'] then
								self.Registered = true;
								self:ChatPrint("[gForum] Your account was already linked.");
							else
								local q3 = db:query("SELECT `id_member`, `member_name`, `passwd`, `password_salt` FROM " .. Prefix .. "_members WHERE `member_name`='" .. name .. "'");

									q3.onError = function(__e,__sql)
										print("[gForum] Query q3 errored! \n [gForum] Query: " .. __sql .. " \n [gForum] Error: " .. __e );
									end

									q3.onSuccess = function(__q,__d)
										local q3Data = __q:getData()[1] or nil;

										if !q3Data or !q3Data['id_member'] then
											net.Start("gforum_link");
											net.Send(self);
											net.Start("gforum_error");
												net.WriteString("Notice!;The username wasn't found.");
											net.Send(self);
											return
										end
										local q4 = db:query("SELECT `id` FROM " .. Prefix .. "_link WHERE `id`='" .. q3Data['id_member'] .. "'");

											q4.onError = function(___e,___sql)
												print("[gForum] Query q4 errored! \n [gForum] Query: " .. ___sql .. " \n [gForum] Error: " .. ___e );
											end

											q4.onSuccess = function(___q,___d)
												local q4Data = ___q:getData()[1] or nil;

												if q4Data && q4Data['id'] then
													net.Start("gforum_link");
													net.Send(self);
													net.Start("gforum_error");
														net.WriteString("Notice!!;That account was already linked.");
													net.Send(self);
													return

												else
													if q3Data['passwd'] == hash then
														local q5 = db:query("INSERT INTO " .. Prefix .. "_link (`id`, `steamid`) VALUES('" .. escape(q3Data['id_member']) .. "', '" .. escape(self:SteamID()) .. "')");

															q5.onError = function(____e,____sql)
																print("[gForum] Query q5 errored! \n [gForum] Query: " .. ____sql .. " \n [gForum] Error: " .. ____e );
															end	

															q5.onSuccess = function(____q,____d)
																local q5Data = ____q:getData()[1] or nil;
																self:ChatPrint("[gForum] Your account has been successfully linked!");
																timer.Simple(3, function()
																	GetUser(self)
																end)
															end
														q5:start()
													elseif q3Data['passwd'] != hash then
														net.Start("gforum_link");
														net.Send(self);
														net.Start("gforum_error");
															net.WriteString("Notice!; The password you entered was incorrect.");
														net.Send(self);
													end			

												end
											end
										q4:start();
									end
								q3:start();
							end
						end
					q2:start();
				end
			q1:start();


	elseif Forum == "mybb" then

	elseif Forum == "ipb" then

	elseif Forum == "xen" then

	elseif Forum == "phpbb" then

	else

	end
end

function SetUserGroup(self,id,gid,name)

	if !self or !id or !gid or !name then return end
	id, gid = tonumber(id), tonumber(gid);

		local q1 = db:query("SELECT * FROM " .. Prefix .. "_rank WHERE `steamid`='" .. self:SteamID() .. "'");

			q1.onError = function(e,sql)
				print("[gForum] Query q1 Errored! \n [gForum] Query: "..sql.." \n [gForum] Error: "..e);
			end

			q1.onSuccess = function(q,d)
				local q1Data = q:getData()[1] or nil;

				if !q1Data and Group != gid then

					local q2 = db:query("INSERT INTO " .. Prefix .. "_rank (`id`, `rank`, `steamid`) VALUES('" .. id .. "', '" .. escape(name) .. "', '" .. escape(self:SteamID()) .. "')" );

						q2.onError = function(_e,_sql)
							print("[gForum] Query q2 Errored! \n [gForum] Query: ".._sql.." \n [gForum] Error: ".._e);
						end

						q2.onSuccess = function(_q)
							local q2Data = _q:getData()[1] or nil;
							if ULib and ULib.ucl then
								self:ChatPrint("[gForum] Your ULX access was set to " .. name ..".");
								local selfInfo = ULib.ucl.authed[self:UniqueID()];
								ULib.ucl.addUser(self:SteamID(), selfInfo.allow or {}, selfInfo.deny or {}, name:lower());

								if self:IsUserGroup(BanUserGroup) then
									self:Ban(BanLength);
									self:Kick();
								end
							else
								self:ChatPrint("[gForum] Your evolve admin access was set to " .. name ..".");
								self:EV_SetRank(name:lower());
							end
						end

					q2:start()

				else

					if Group != gid or (Group == 21 and gid == 21) then
						local q2 = db:query("UPDATE " .. Prefix .. "_rank SET `rank`='" .. name .. "' WHERE `steamid`='" .. self:SteamID() .. "'" );

							q2.onError = function(_e,_sql)
								print("[gForum] Query q2 Errored! \n [gForum] Query: ".._sql.." \n [gForum] Error: ".._e);
							end

							q2.onSuccess = function(_q,_d)
							local q2Data = _q:getData()[1] or nil;

								if ULib and ULib.ucl then
									self:ChatPrint("[gForum] Your ULX access was set to "..name.."")
									local selfInfo = ULib.ucl.authed[self:UniqueID()];
									ULib.ucl.addUser(self:SteamID(), selfInfo.allow or {}, selfInfo.deny or {}, name:lower());
								else
									self:ChatPrint("[gForum] Your evolve admin access was set to " .. name .. ".");
									self:EV_SetRank(name:lower());
								end

							end

						q2:start()

					else

						if ULib and ULib.ucl then
							self:ChatPrint("[gForum] Your ULX access was revoked.");
							ULib.ucl.removeUser(self:SteamID());
						else
							self:ChatPrint("[gForum] Your evolve admin access wasr evoked.");
							self:EV_SetRank("guest");
						end

						local q2 = db:query("DELETE FROM " .. Prefix .. "_rank WHERE `steamid`='" .. self:SteamID() .. "'");

							q2.onError = function(_q,_sql)
								print("[gForum] Query q2 Errored! \n [gForum] Query: ".._sql.." \n [gForum] Error: ".._e);
							end

						q2:start()

					end

				end

			end

		q1:start()
end

function ResetUser(self)
	if !self then return end
	if !Reset then return self:ChatPrint("[gForum] This server does not allow unlinking accounts."); end
	local q1 = db:query("SELECT `id` FROM " .. Prefix .. "_link WHERE `steamid`='" .. self:SteamID() .. "'");
		q1.onError = function(e,sql)
			print("[gForum] Query q1 Errored! \n [gForum] Query: "..sql.." \n [gForum] Error: "..e);
		end

		q1.onSuccess = function(q,d)
			local q1Data = q:getData()[1] or nil;
			if q1Data && q1Data['id'] then
				local q2 = db:query("DELETE FROM " .. Prefix .. "_link WHERE `steamid`='" .. self:SteamID() .. "'");	
					q2.onError = function(_e,_sql)
						print("[gForum] Query q2 Errored! \n [gForum] Query: ".._sql.." \n [gForum] Error: ".._e);
					end

					q2.onSuccess = function(_q,_d)
						self.Registered = false;
						net.Start("gforum_register");
						net.Send(self);
						net.Start("gforum_error");
							net.WriteString("Notice!!; You've unlinked your account.");
						net.Send(self);
					end
				q2:start();
			end
		end
	q1:start();
end
	

function Salt(self,key)
	if !key then return end
	key = tonumber(key);
	local salt = "";
	local characters = { "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "1", "2", "3", "4", "5", "6", "7", "8", "9" };
	for i=1,key do
		salt = salt .. table.Random(characters);
	end
	return tostring(salt);
end
