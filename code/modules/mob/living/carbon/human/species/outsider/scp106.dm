/datum/species/scp106
	name = "SCP-106"
	name_plural = "SCP-106s"

	darksight = 8
	has_organ = list()
	siemens_coefficient = 0

	blood_color = "#622a37"
	flesh_color = "#442A37"

	species_flags = SPECIES_FLAG_NO_SLIP | SPECIES_FLAG_NO_POISON
	spawn_flags = SPECIES_IS_RESTRICTED

	genders = list(MALE)

	// immune to viruses
	virus_immune = TRUE

	// icon overrides
	icobase = null
	deform = null

	// damage icon overrides
	damage_overlays = null
	damage_mask = null
	blood_mask = null

	// damage overrides
	brute_mod =      0.5                    // 50% physical damage
	burn_mod =       0.5                    // 50% burn damage
	oxy_mod =        0.0                    // No oxygen damage
	toxins_mod =     0.0                    // No toxin damage
	radiation_mod =  0.0                    // No radiation damage
	flash_mod =      0.0                    // Unflashable

/datum/species/scp106/handle_npc(var/mob/living/carbon/human/scp106/H)
	if (!H.client)
		H.lying = FALSE
		H.pursueTarget()