concommand.Add("sv_register", function(p,c,a)
	if !p or !a then return end
	Registration(p, a[1], a[2], a[3]);
end);

concommand.Add("sv_link", function(p,c,a)
	if !p or !a then return end
	LinkAccount(p,a[1],a[2]);
end);

concommand.Add("sv_reset", function(p,c,a)
	if !p or !a then return end
	if !Reset then return end
	ResetUser(p);
end);

print("[gForum] Commands Loaded");
