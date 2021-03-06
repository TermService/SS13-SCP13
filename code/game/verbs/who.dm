
/client/verb/who()
	set name = "Who"
	set category = "OOC"

	var/msg = "<b>Current Players:</b>\n"

	var/list/Lines = list()

	if(check_rights(R_INVESTIGATE, 0))
		for(var/client in GLOB.clients)
			var/client/C = client
			var/entry = "\t[C.key]"
			if(!C.mob) //If mob is null, print error and skip rest of info for client.
				entry += " - <font color='red'><i>HAS NO MOB</i></font>"
				Lines += entry
				continue

			entry += " - Playing as [C.mob.real_name]"
			switch(C.mob.stat)
				if(UNCONSCIOUS)
					entry += " - <font color='darkgray'><b>Unconscious</b></font>"
				if(DEAD)
					if(isghost(C.mob))
						var/mob/observer/ghost/O = C.mob
						if(O.started_as_observer)
							entry += " - <font color='gray'>Observing</font>"
						else
							entry += " - <font color='black'><b>DEAD</b></font>"
					else
						entry += " - <font color='black'><b>DEAD</b></font>"

			var/age
			if(isnum(C.player_age))
				age = C.player_age
			else
				age = 0

			if(age <= 1)
				age = "<font color='#ff0000'><b>[age]</b></font>"
			else if(age < 10)
				age = "<font color='#ff8c00'><b>[age]</b></font>"

			entry += " - [age]"

			if(is_special_character(C.mob))
				entry += " - <b><font color='red'>Antagonist</font></b>"
			if(C.is_afk())
				entry += " (AFK - [C.inactivity2text()])"
			entry += " (<A HREF='?_src_=holder;adminmoreinfo=\ref[C.mob]'>?</A>)"
			Lines += entry
	else
		for(var/client/C in GLOB.clients)
			if(!C.is_stealthed())
				Lines += C.key

	for(var/line in sortList(Lines))
		msg += "[line]\n"

	msg += "<b>Total Players: [length(Lines)]</b>"
	to_chat(src, msg)

//New SEXY Staffwho verb
/client/verb/staffwho()
	set category = "Admin"
	set name = "StaffWho"
	var/adminwho = ""
	var/modwho = ""
	var/mentwho = ""
	var/devwho = ""
	var/admin_count = 0
	var/mod_count = 0
	var/ment_count = 0
	var/dev_count = 0

	for(var/client in GLOB.admins)
		var/client/C = client
		if(C.is_stealthed() && !check_rights(R_MOD|R_ADMIN, 0, src)) // Normal players and mentors can't see stealthmins
			continue

		var/extra = ""
		if(holder)
			if(C.is_stealthed())
				extra += " (Stealthed)"
			if(isobserver(C.mob))
				extra += " - Observing"
			else if(istype(C.mob,/mob/new_player))
				extra += " - Lobby"
			else
				extra += " - Playing"
			if(C.is_afk())
				extra += " (AFK)"

		if(R_ADMIN & C.holder.rights)
			adminwho += "\t[C] is a <b>[C.holder.rank]</b>[extra]\n"
			admin_count++
		else if (R_MOD & C.holder.rights)
			modwho += "\t[C] is a <i>[C.holder.rank]</i>[extra]\n"
			mod_count++
		else if (R_MENTOR & C.holder.rights)
			mentwho += "\t[C] is a [C.holder.rank][extra]\n"
			ment_count++
		else if (R_DEBUG & C.holder.rights)
			devwho += "\t[C] is a [C.holder.rank][extra]\n"
			dev_count++

	to_chat(src, "<b><big>Online staff:</big></b>")
	to_chat(src, "<b>Current Admins ([admin_count]):</b><br>[adminwho]<br>")
	to_chat(src, "<b>Current Moderators ([mod_count]):</b><br>[modwho]<br>")
	to_chat(src, "<b>Current Mentors ([ment_count]):</b><br>[mentwho]<br>")
	to_chat(src, "<b>Current Developers ([dev_count]):</b><br>[devwho]<br>")

/*
/client/verb/donatorwho()
	set category = "Admin"
	set name = "DonatorWho"
	var/donators = ""
	var/donator_count = 0
	for(var/client in GLOB.donators)
		var/client/C = client
		if(C.is_stealthed() && !check_rights(R_MOD|R_ADMIN, 0, src)) // Normal players and mentors can't see stealthmins
			continue
		var/extra = ""
		if(holder)
			if(C.is_stealthed())
				extra += " (Stealthed)"
			if(isobserver(C.mob))
				extra += " - Observing"
			else if(istype(C.mob,/mob/new_player))
				extra += " - Lobby"
			else
				extra += " - Playing"
			if(C.is_afk())
				extra += " (AFK)"
		if(C.donator_holder && C.donator_holder.flags)
			donators += "\t[C]</b>[extra]\n"
			donator_count++
	to_chat(src, "<b><big>Online Donators ([donator_count]):</big></b>")
	to_chat(src, donators)
*/

/* OLD STUFF.
/client/verb/staffwho()
	set category = "Admin"
	set name = "Staffwho"

	var/list/msg = list()
	var/active_staff = 0
	var/total_staff = 0
	var/can_investigate = check_rights(R_INVESTIGATE, 0)

	for(var/client/C in GLOB.admins)
		var/line = list()
		if(!can_investigate && C.is_stealthed())
			continue
		total_staff++
		if(check_rights(R_ADMIN,0,C))
			line += "\t[C] is \an <b>["\improper[C.holder.rank]"]</b>"
		else
			line += "\t[C] is \an ["\improper[C.holder.rank]"]"
		if(!C.is_afk())
			active_staff++
		if(can_investigate)
			if(C.is_afk())
				line += " (AFK - [C.inactivity2text()])"
			if(isghost(C.mob))
				line += " - Observing"
			else if(istype(C.mob,/mob/new_player))
				line += " - Lobby"
			else
				line += " - Playing"
			if(C.is_stealthed())
				line += " (Stealthed)"
		line = jointext(line,null)
		if(check_rights(R_ADMIN,0,C))
			msg.Insert(1, line)
		else
			msg += line

	if(config.admin_irc)
		to_chat(src, "<span class='info'>Adminhelps are also sent to IRC. If no admins are available in game try anyway and an admin on IRC may see it and respond.</span>")
	to_chat(src, "<b>Current Staff ([active_staff]/[total_staff]):</b>")
	to_chat(src, jointext(msg,"\n"))

*/