/***************************************************************
**						Design Datums						  **
**	All the data for building stuff and tracking reliability. **
***************************************************************/
/*
For the materials datum, it assumes you need reagents unless specified otherwise. To designate a material that isn't a reagent,
you use one of the material IDs below. These are NOT ids in the usual sense (they aren't defined in the object or part of a datum),
they are simply references used as part of a "has materials?" type proc. They all start with a  to denote that they aren't reagents.
The currently supporting non-reagent materials:

Don't add new keyword/IDs if they are made from an existing one (such as rods which are made from metal). Only add raw materials.

Design Guidlines
- When adding new designs, check rdreadme.dm to see what kind of things have already been made and where new stuff is needed.
- A single sheet of anything is 2000 units of material. Materials besides metal/glass require help from other jobs (mining for
other types of metals and chemistry for reagents).

*/
//Note: More then one of these can be added to a design.

/datum/design						//Datum for object designs, used in construction
	var/name = null					//Name of the created object. If null it will be 'guessed' from build_path if possible.
	var/desc = null					//Description of the created object. If null it will use group_desc and name where applicable.
	var/item_name = null			//An item name before it is modified by various name-modifying procs
	var/id = "id"					//ID of the created object for easy refernece. Alphanumeric, lower-case, no symbols.
	var/list/req_tech = list()		//IDs of that techs the object originated from and the minimum level requirements.
	var/build_type = null			//Flag as to what kind machine the design is built in. See defines.
	var/list/materials = list()		//List of materials. Format: "id" = amount.
	var/list/chemicals = list()		//List of chemicals.
	var/build_path = null			//The path of the object that gets created.
	var/time = 10					//How many ticks it requires to build
	var/category = null 			//Primarily used for Mech Fabricators, but can be used for anything.
	var/sort_string = "ZZZZZ"		//Sorting order

/datum/design/New()
	..()
	item_name = name
	AssembleDesignInfo()

//These procs are used in subtypes for assigning names and descriptions dynamically
/datum/design/proc/AssembleDesignInfo()
	AssembleDesignName()
	AssembleDesignDesc()
	return

/datum/design/proc/AssembleDesignName()
	if(!name && build_path)					//Get name from build path if posible
		var/atom/movable/A = build_path
		name = initial(A.name)
		item_name = name
	return

/datum/design/proc/AssembleDesignDesc()
	if(!desc)								//Try to make up a nice description if we don't have one
		desc = "Allows for the construction of \a [item_name]."
	return

//Returns a new instance of the item for this design
//This is to allow additional initialization to be performed, including possibly additional contructor arguments.
/datum/design/proc/Fabricate(var/newloc, var/fabricator)
	return new build_path(newloc)

/datum/design/item
	build_type = PROTOLATHE

/datum/design/item/disk/AssembleDesignName()
	..()
	name = "Storage disk ([item_name])"

/datum/design/item/disk/design
	name = "research design"
	desc = "Produce additional disks for storing device designs."
	id = "design_disk"
	req_tech = list(TECH_DATA = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 30, "glass" = 10)
	build_path = /obj/item/weapon/disk/design_disk
	sort_string = "AAAAA"

/datum/design/item/disk/tech
	name = "technology data"
	desc = "Produce additional disks for storing technology data."
	id = "tech_disk"
	req_tech = list(TECH_DATA = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 30, "glass" = 10)
	build_path = /obj/item/weapon/disk/tech_disk
	sort_string = "AAAAB"

/datum/design/item/stock_part
	build_type = PROTOLATHE

/datum/design/item/stock_part/AssembleDesignName()
	..()
	name = "Component design ([item_name])"

/datum/design/item/stock_part/AssembleDesignDesc()
	if(!desc)
		desc = "A stock part used in the construction of various devices."

/datum/design/item/stock_part/basic_capacitor
	id = "basic_capacitor"
	req_tech = list(TECH_POWER = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)
	build_path = /obj/item/weapon/stock_parts/capacitor
	sort_string = "CAAAA"

/datum/design/item/stock_part/adv_capacitor
	id = "adv_capacitor"
	req_tech = list(TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)
	build_path = /obj/item/weapon/stock_parts/capacitor/adv
	sort_string = "CAAAB"

/datum/design/item/stock_part/super_capacitor
	id = "super_capacitor"
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50, "gold" = 20)
	build_path = /obj/item/weapon/stock_parts/capacitor/super
	sort_string = "CAAAC"

/datum/design/item/stock_part/micro_mani
	id = "micro_mani"
	req_tech = list(TECH_MATERIAL = 1, TECH_DATA = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 30)
	build_path = /obj/item/weapon/stock_parts/manipulator
	sort_string = "CAABA"

/datum/design/item/stock_part/nano_mani
	id = "nano_mani"
	req_tech = list(TECH_MATERIAL = 3, TECH_DATA = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 30)
	build_path = /obj/item/weapon/stock_parts/manipulator/nano
	sort_string = "CAABB"

/datum/design/item/stock_part/pico_mani
	id = "pico_mani"
	req_tech = list(TECH_MATERIAL = 5, TECH_DATA = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 30)
	build_path = /obj/item/weapon/stock_parts/manipulator/pico
	sort_string = "CAABC"

/datum/design/item/stock_part/basic_matter_bin
	id = "basic_matter_bin"
	req_tech = list(TECH_MATERIAL = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 80)
	build_path = /obj/item/weapon/stock_parts/matter_bin
	sort_string = "CAACA"

/datum/design/item/stock_part/adv_matter_bin
	id = "adv_matter_bin"
	req_tech = list(TECH_MATERIAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 80)
	build_path = /obj/item/weapon/stock_parts/matter_bin/adv
	sort_string = "CAACB"

/datum/design/item/stock_part/super_matter_bin
	id = "super_matter_bin"
	req_tech = list(TECH_MATERIAL = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 80)
	build_path = /obj/item/weapon/stock_parts/matter_bin/super
	sort_string = "CAACC"

/datum/design/item/stock_part/basic_micro_laser
	id = "basic_micro_laser"
	req_tech = list(TECH_MAGNET = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 10, "glass" = 20)
	build_path = /obj/item/weapon/stock_parts/micro_laser
	sort_string = "CAADA"

/datum/design/item/stock_part/high_micro_laser
	id = "high_micro_laser"
	req_tech = list(TECH_MAGNET = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 10, "glass" = 20)
	build_path = /obj/item/weapon/stock_parts/micro_laser/high
	sort_string = "CAADB"

/datum/design/item/stock_part/ultra_micro_laser
	id = "ultra_micro_laser"
	req_tech = list(TECH_MAGNET = 5, TECH_MATERIAL = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 10, "glass" = 20, "uranium" = 10)
	build_path = /obj/item/weapon/stock_parts/micro_laser/ultra
	sort_string = "CAADC"

/datum/design/item/stock_part/basic_sensor
	id = "basic_sensor"
	req_tech = list(TECH_MAGNET = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 20)
	build_path = /obj/item/weapon/stock_parts/scanning_module
	sort_string = "CAAEA"

/datum/design/item/stock_part/adv_sensor
	id = "adv_sensor"
	req_tech = list(TECH_MAGNET = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 20)
	build_path = /obj/item/weapon/stock_parts/scanning_module/adv
	sort_string = "CAAEB"

/datum/design/item/stock_part/phasic_sensor
	id = "phasic_sensor"
	req_tech = list(TECH_MAGNET = 5, TECH_MATERIAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 20, "silver" = 10)
	build_path = /obj/item/weapon/stock_parts/scanning_module/phasic
	sort_string = "CAAEC"

/datum/design/item/stock_part/RPED
	name = "Rapid Part Exchange Device"
	desc = "Special mechanical module made to store, sort, and apply standard machine parts."
	id = "rped"
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 15000, "glass" = 5000)
	build_path = /obj/item/weapon/storage/part_replacer
	sort_string = "CBAAA"

/datum/design/item/powercell
	build_type = PROTOLATHE | MECHFAB
	category = "Misc"

/datum/design/item/powercell/AssembleDesignName()
	name = "Power cell model ([item_name])"

/datum/design/item/powercell/device/AssembleDesignName()
	name = "Device cell model ([item_name])"

/datum/design/item/powercell/AssembleDesignDesc()
	if(build_path)
		var/obj/item/weapon/cell/C = build_path
		desc = "Allows the construction of power cells that can hold [initial(C.maxcharge)] units of energy."

/datum/design/item/powercell/Fabricate()
	var/obj/item/weapon/cell/C = ..()
	C.charge = 0 //shouldn't produce power out of thin air.
	return C

/datum/design/item/powercell/basic
	name = "basic"
	id = "basic_cell"
	req_tech = list(TECH_POWER = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 700, "glass" = 50)
	build_path = /obj/item/weapon/cell
	sort_string = "DAAAA"

/datum/design/item/powercell/high
	name = "high-capacity"
	id = "high_cell"
	req_tech = list(TECH_POWER = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 700, "glass" = 60)
	build_path = /obj/item/weapon/cell/high
	sort_string = "DAAAB"

/datum/design/item/powercell/super
	name = "super-capacity"
	id = "super_cell"
	req_tech = list(TECH_POWER = 3, TECH_MATERIAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 700, "glass" = 70)
	build_path = /obj/item/weapon/cell/super
	sort_string = "DAAAC"

/datum/design/item/powercell/hyper
	name = "hyper-capacity"
	id = "hyper_cell"
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 400, "gold" = 150, "silver" = 150, "glass" = 70)
	build_path = /obj/item/weapon/cell/hyper
	sort_string = "DAAAD"

/datum/design/item/powercell/device/standard
	name = "basic"
	id = "device_cell_standard"
	req_tech = list(TECH_POWER = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 70, "glass" = 5)
	build_path = /obj/item/weapon/cell/device/standard
	sort_string = "DAAAE"

/datum/design/item/powercell/device/high
	name = "high-capacity"
	build_type = PROTOLATHE | MECHFAB
	id = "device_cell_high"
	req_tech = list(TECH_POWER = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 70, "glass" = 6)
	build_path = /obj/item/weapon/cell/device/high
	sort_string = "DAAAF"

/datum/design/item/hud
	materials = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)

/datum/design/item/hud/AssembleDesignName()
	..()
	name = "HUD glasses design ([item_name])"

/datum/design/item/hud/AssembleDesignDesc()
	desc = "Allows for the construction of \a [item_name] HUD glasses."

/datum/design/item/hud/health
	name = "health scanner"
	id = "health_hud"
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 3)
	build_path = /obj/item/clothing/glasses/hud/health
	sort_string = "GAAAA"

/datum/design/item/hud/security
	name = "security records"
	id = "security_hud"
	req_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 2)
	build_path = /obj/item/clothing/glasses/hud/security
	sort_string = "GAAAB"

/datum/design/item/optical/AssembleDesignName()
	..()
	name = "Optical glasses design ([item_name])"

/datum/design/item/optical/mesons
	name = "mesons"
	desc = "Using the meson-scanning technology those glasses allow you to see through walls, floor or anything else."
	id = "mesons"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)
	build_path = /obj/item/clothing/glasses/meson
	sort_string = "GBAAA"

/datum/design/item/optical/material
	name = "material"
	id = "mesons_material"
	req_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)
	build_path = /obj/item/clothing/glasses/material
	sort_string = "GAAAB"

/datum/design/item/optical/tactical
	name = "tactical"
	id = "tactical_goggles"
	req_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50, "silver" = 50, "gold" = 50)
	build_path = /obj/item/clothing/glasses/tacgoggles
	sort_string = "GAAAC"

/datum/design/item/mining/AssembleDesignName()
	..()
	name = "Mining equipment design ([item_name])"

/datum/design/item/mining/jackhammer
	id = "jackhammer"
	req_tech = list(TECH_MATERIAL = 3, TECH_POWER = 2, TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 500, "silver" = 500)
	build_path = /obj/item/weapon/pickaxe/jackhammer
	sort_string = "KAAAA"

/datum/design/item/mining/drill
	id = "drill"
	req_tech = list(TECH_MATERIAL = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 6000, "glass" = 1000) //expensive, but no need for miners.
	build_path = /obj/item/weapon/pickaxe/drill
	sort_string = "KAAAB"

/datum/design/item/mining/plasmacutter
	id = "plasmacutter"
	req_tech = list(TECH_MATERIAL = 4, TECH_PHORON = 3, TECH_ENGINEERING = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 1500, "glass" = 500, "gold" = 500, "phoron" = 500)
	build_path = /obj/item/weapon/gun/energy/plasmacutter
	sort_string = "KAAAC"

/datum/design/item/mining/pick_diamond
	id = "pick_diamond"
	req_tech = list(TECH_MATERIAL = 6)
	materials = list("diamond" = 3000)
	build_path = /obj/item/weapon/pickaxe/diamond
	sort_string = "KAAAD"

/datum/design/item/mining/drill_diamond
	id = "drill_diamond"
	req_tech = list(TECH_MATERIAL = 6, TECH_POWER = 4, TECH_ENGINEERING = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 3000, "glass" = 1000, "diamond" = 2000)
	build_path = /obj/item/weapon/pickaxe/diamonddrill
	sort_string = "KAAAE"

/datum/design/item/mining/depth_scanner
	desc = "Used to check spatial depth and density of rock outcroppings."
	id = "depth_scanner"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2, TECH_BLUESPACE = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 1000,"glass" = 1000)
	build_path = /obj/item/device/depth_scanner
	sort_string = "KAAAF"

/datum/design/item/medical
	materials = list(DEFAULT_WALL_MATERIAL = 30, "glass" = 20)

/datum/design/item/medical/AssembleDesignName()
	..()
	name = "Biotech device prototype ([item_name])"

/datum/design/item/medical/slime_scanner
	desc = "Multipurpose organic life scanner."
	id = "slime_scanner"
	req_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 200, "glass" = 100)
	build_path = /obj/item/device/slime_scanner
	sort_string = "MACFA"

/datum/design/item/medical/robot_scanner
	desc = "A hand-held scanner able to diagnose robotic injuries."
	id = "robot_scanner"
	req_tech = list(TECH_MAGNET = 3, TECH_BIO = 2, TECH_ENGINEERING = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 500, "glass" = 200)
	build_path = /obj/item/device/robotanalyzer
	sort_string = "MACFB"

/datum/design/item/medical/mass_spectrometer
	desc = "A device for analyzing chemicals in blood."
	id = "mass_spectrometer"
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 2)
	build_path = /obj/item/device/mass_spectrometer
	sort_string = "MACAA"

/datum/design/item/medical/adv_mass_spectrometer
	desc = "A device for analyzing chemicals in blood and their quantities."
	id = "adv_mass_spectrometer"
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 4)
	build_path = /obj/item/device/mass_spectrometer/adv
	sort_string = "MACAB"

/datum/design/item/medical/reagent_scanner
	desc = "A device for identifying chemicals."
	id = "reagent_scanner"
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 2)
	build_path = /obj/item/device/reagent_scanner
	sort_string = "MACBA"

/datum/design/item/medical/adv_reagent_scanner
	desc = "A device for identifying chemicals and their proportions."
	id = "adv_reagent_scanner"
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 4)
	build_path = /obj/item/device/reagent_scanner/adv
	sort_string = "MACBB"

/datum/design/item/medical/hypospray
	desc = "A sterile, air-needle autoinjector for rapid administration of drugs"
	id = "hypospray"
	req_tech = list(TECH_MATERIAL = 4, TECH_BIO = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 8000, "glass" = 8000, "silver" = 2000)
	build_path = /obj/item/weapon/reagent_containers/hypospray/vial
	sort_string = "MAEAA"

/datum/design/item/surgery/AssembleDesignName()
	..()
	name = "Surgical tool design ([item_name])"

/datum/design/item/surgery/scalpel_laser1
	name = "Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field. "
	id = "scalpel_laser1"
	req_tech = list(TECH_BIO = 2, TECH_MATERIAL = 2, TECH_MAGNET = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 12500, "glass" = 7500)
	build_path = /obj/item/weapon/scalpel/laser1
	sort_string = "MBEAA"

/datum/design/item/surgery/scalpel_manager
	name = "Incision Management System"
	desc = "A true extension of the surgeon's body, this marvel instantly and completely prepares an incision allowing for the immediate commencement of therapeutic steps."
	id = "scalpel_manager"
	req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 7, TECH_MAGNET = 5, TECH_DATA = 4)
	materials = list (DEFAULT_WALL_MATERIAL = 12500, "glass" = 7500, "silver" = 1500, "gold" = 1500, "diamond" = 750)
	build_path = /obj/item/weapon/scalpel/manager
	sort_string = "MBEAD"

/datum/design/item/beaker/AssembleDesignName()
	name = "Beaker prototype ([item_name])"

/datum/design/item/beaker/noreact
	name = "cryostasis"
	desc = "A cryostasis beaker that allows for chemical storage without reactions. Can hold up to 50 units."
	id = "splitbeaker"
	req_tech = list(TECH_MATERIAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 3000)
	build_path = /obj/item/weapon/reagent_containers/glass/beaker/noreact
	sort_string = "MCAAA"


/datum/design/item/implant
	materials = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)

/datum/design/item/implant/AssembleDesignName()
	..()
	name = "Implantable biocircuit design ([item_name])"

/datum/design/item/implant/chemical
	name = "chemical"
	id = "implant_chem"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3)
	build_path = /obj/item/weapon/implantcase/chem
	sort_string = "MFAAA"

/datum/design/item/implant/death_alarm
	name = "death alarm"
	id = "implant_death"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3, TECH_DATA = 2)
	build_path = /obj/item/weapon/implantcase/death_alarm
	sort_string = "MFAAB"

/datum/design/item/implant/tracking
	name = "tracking"
	id = "implant_tracking"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3, TECH_BLUESPACE = 3)
	build_path = /obj/item/weapon/implantcase/tracking
	sort_string = "MFAAC"

/datum/design/item/implant/imprinting
	name = "imprinting"
	id = "implant_imprinting"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3, TECH_DATA = 4)
	build_path = /obj/item/weapon/implantcase/imprinting
	sort_string = "MFAAD"

/datum/design/item/implant/adrenaline
	name = "adrenaline"
	id = "implant_adrenaline"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3, TECH_ESOTERIC = 3)
	build_path = /obj/item/weapon/implantcase/adrenalin
	sort_string = "MFAAE"

/datum/design/item/implant/explosive
	name = "explosive"
	id = "implant_explosive"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3, TECH_ESOTERIC = 4)
	build_path = /obj/item/weapon/implantcase/explosive
	sort_string = "MFAAG"

/datum/design/item/weapon/AssembleDesignName()
	..()
	name = "Weapon prototype ([item_name])"

/datum/design/item/weapon/AssembleDesignDesc()
	if(!desc)
		if(build_path)
			var/obj/item/I = build_path
			desc = initial(I.desc)
		..()

/datum/design/item/weapon/chemsprayer
	desc = "An advanced chem spraying device."
	id = "chemsprayer"
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_BIO = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 1000)
	build_path = /obj/item/weapon/reagent_containers/spray/chemsprayer
	sort_string = "TAAAA"

/datum/design/item/weapon/rapidsyringe
	id = "rapidsyringe"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_BIO = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 1000)
	build_path = /obj/item/weapon/gun/launcher/syringe/rapid
	sort_string = "TAAAB"

/datum/design/item/weapon/temp_gun
	desc = "A gun that shoots high-powered thermal energy."
	id = "temp_gun"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 4, TECH_POWER = 3, TECH_MAGNET = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 500, "silver" = 3000)
	build_path = /obj/item/weapon/gun/energy/temperature
	sort_string = "TAAAC"

/datum/design/item/weapon/large_grenade
	id = "large_Grenade"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 3000)
	build_path = /obj/item/weapon/grenade/chem_grenade/large
	sort_string = "TABAA"

/datum/design/item/weapon/anti_photon
	id = "anti_photon"
	req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 3000, "glass" = 1000, "diamond" = 1000)
	build_path = /obj/item/weapon/grenade/anti_photon
	sort_string = "TABAB"

/datum/design/item/weapon/advancedflash
	id = "advancedflash"
	req_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 2000, "silver" = 500)
	build_path = /obj/item/device/flash/advanced
	sort_string = "TADAA"

/datum/design/item/weapon/stunrevolver
	id = "stunrevolver"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 4000)
	build_path = /obj/item/weapon/gun/energy/stunrevolver
	sort_string = "TADAB"

/datum/design/item/weapon/stunrifle
	id = "stun_rifle"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 4000, "glass" = 1000, "silver" = 500)
	build_path = /obj/item/weapon/gun/energy/stunrevolver/rifle
	sort_string = "TADAC"

/datum/design/item/weapon/grenadelauncher
	id = "grenadelauncher"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 1000)
	build_path = /obj/item/weapon/gun/launcher/grenade
	sort_string = "TAGAA"

/datum/design/item/weapon/pneumatic
	id = "pneumatic"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 2000, "silver" = 500)
	build_path = /obj/item/weapon/gun/launcher/pneumatic
	sort_string = "TAGAB"

/datum/design/item/weapon/railgun
	id = "railgun"
	req_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 6, TECH_MAGNET = 6, TECH_ESOTERIC = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 6000, "gold" = 8000, "silver" = 2000)
	build_path = /obj/item/weapon/gun/magnetic/railgun
	sort_string = "TAHAA"

/datum/design/item/weapon/phoronpistol
	id = "ppistol"
	req_tech = list(TECH_COMBAT = 5, TECH_PHORON = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 1000, "phoron" = 3000)
	build_path = /obj/item/weapon/gun/energy/toxgun
	sort_string = "TAJAA"


/datum/design/item/weapon/smg
	id = "smg"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 8000, "silver" = 2000, "diamond" = 1000)
	build_path = /obj/item/weapon/gun/projectile/automatic
	sort_string = "TAPAA"

/datum/design/item/weapon/wt550
	id = "wt550"
	req_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 8000, "silver" = 3000, "diamond" = 1500)
	build_path = /obj/item/weapon/gun/projectile/automatic/wt550
	sort_string = "TAPAB"

/datum/design/item/weapon/bullpup
	id = "bullpup"
	req_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 10000, "silver" = 5000, "diamond" = 3000)
	build_path = /obj/item/weapon/gun/projectile/automatic/z8
	sort_string = "TAPAC"

/datum/design/item/weapon/ammunition/AssembleDesignName()
	..()
	name = "Ammunition prototype ([item_name])"

/datum/design/item/weapon/ammunition/ammo_9mm
	id = "ammo_9mm"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 3750, "silver" = 100)
	build_path = /obj/item/ammo_magazine/box/c9mm
	sort_string = "TBAAA"

/datum/design/item/weapon/ammunition/stunshell
	desc = "A stunning shell for a shotgun."
	id = "shell-stun"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 4000)
	build_path = /obj/item/ammo_casing/shotgun/stunshell
	sort_string = "TBAAB"

/datum/design/item/weapon/ammunition/ammo_emp_38
	id = "ammo_emp_38"
	desc = "A .38 round with an integrated EMP charge."
	materials = list(DEFAULT_WALL_MATERIAL = 2500, "uranium" = 750)
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	build_path = /obj/item/ammo_magazine/box/emp
	sort_string = "TBAAC"

/datum/design/item/weapon/ammunition/ammo_emp_45
	id = "ammo_emp_45"
	desc = "A .45 round with an integrated EMP charge."
	materials = list(DEFAULT_WALL_MATERIAL = 2500, "uranium" = 750)
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	build_path = /obj/item/ammo_magazine/box/emp/c45
	sort_string = "TBAAD"

/datum/design/item/weapon/ammunition/ammo_emp_10
	id = "ammo_emp_10"
	desc = "A .10mm round with an integrated EMP charge."
	materials = list(DEFAULT_WALL_MATERIAL = 2500, "uranium" = 750)
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	build_path = /obj/item/ammo_magazine/box/emp/a10mm
	sort_string = "TBAAE"

/datum/design/item/weapon/ammunition/ammo_emp_slug
	id = "ammo_emp_slug"
	desc = "A shotgun slug with an integrated EMP charge."
	materials = list(DEFAULT_WALL_MATERIAL = 3000, "uranium" = 1000)
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3)
	build_path = /obj/item/ammo_casing/shotgun/emp
	sort_string = "TBAAF"

/datum/design/item/stock_part/subspace_ansible
	id = "s-ansible"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 80, "silver" = 20)
	build_path = /obj/item/weapon/stock_parts/subspace/ansible
	sort_string = "UAAAA"

/datum/design/item/stock_part/hyperwave_filter
	id = "s-filter"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 40, "silver" = 10)
	build_path = /obj/item/weapon/stock_parts/subspace/filter
	sort_string = "UAAAB"

/datum/design/item/stock_part/subspace_amplifier
	id = "s-amplifier"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 10, "gold" = 30, "uranium" = 15)
	build_path = /obj/item/weapon/stock_parts/subspace/amplifier
	sort_string = "UAAAC"

/datum/design/item/stock_part/subspace_treatment
	id = "s-treatment"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 2, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 10, "silver" = 20)
	build_path = /obj/item/weapon/stock_parts/subspace/treatment
	sort_string = "UAAAD"

/datum/design/item/stock_part/subspace_analyzer
	id = "s-analyzer"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 10, "gold" = 15)
	build_path = /obj/item/weapon/stock_parts/subspace/analyzer
	sort_string = "UAAAE"

/datum/design/item/stock_part/subspace_crystal
	id = "s-crystal"
	req_tech = list(TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	materials = list("glass" = 1000, "silver" = 20, "gold" = 20)
	build_path = /obj/item/weapon/stock_parts/subspace/crystal
	sort_string = "UAAAF"

/datum/design/item/stock_part/subspace_transmitter
	id = "s-transmitter"
	req_tech = list(TECH_MAGNET = 5, TECH_MATERIAL = 5, TECH_BLUESPACE = 3)
	materials = list("glass" = 100, "silver" = 10, "uranium" = 15)
	build_path = /obj/item/weapon/stock_parts/subspace/transmitter
	sort_string = "UAAAG"

/datum/design/item/synthstorage/AssembleDesignName()
	..()
	name = "Synthetic intelligence storage ([item_name])"


/datum/design/item/biostorage/AssembleDesignName()
	..()
	name = "Biological intelligence storage ([item_name])"


/datum/design/item/biostorage/mmi
	name = "man-machine interface"
	id = "mmi"
	req_tech = list(TECH_DATA = 8, TECH_BIO = 6)
	build_type = PROTOLATHE | MECHFAB
	materials = list(DEFAULT_WALL_MATERIAL = 1000, "glass" = 500)
	build_path = /obj/item/device/mmi
	category = "Misc"
	sort_string = "VACCA"

/datum/design/item/biostorage/mmi_radio
	name = "radio-enabled man-machine interface"
	id = "mmi_radio"
	req_tech = list(TECH_DATA = 9, TECH_BIO = 6)
	build_type = PROTOLATHE | MECHFAB
	materials = list(DEFAULT_WALL_MATERIAL = 1200, "glass" = 500)
	build_path = /obj/item/device/mmi/radio_enabled
	category = "Misc"
	sort_string = "VACCB"

/datum/design/item/bluespace/AssembleDesignName()
	..()
	name = "Bluespace device ([item_name])"

/datum/design/item/bluespace/beacon
	name = "tracking beacon"
	id = "beacon"
	req_tech = list(TECH_BLUESPACE = 1)
	materials = list (DEFAULT_WALL_MATERIAL = 20, "glass" = 10)
	build_path = /obj/item/device/radio/beacon
	sort_string = "VADAA"

/datum/design/item/bluespace/gps
	name = "triangulating device"
	desc = "Triangulates approximate co-ordinates using a nearby satellite network."
	id = "gps"
	req_tech = list(TECH_MATERIAL = 2, TECH_DATA = 2, TECH_BLUESPACE = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 500)
	build_path = /obj/item/device/gps
	sort_string = "VADAB"

/datum/design/item/bluespace/beacon_locator
	name = "beacon tracking pinpointer"
	desc = "Used to scan and locate signals on a particular frequency."
	id = "beacon_locator"
	req_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 2, TECH_BLUESPACE = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 1000,"glass" = 500)
	build_path = /obj/item/weapon/pinpointer/radio
	sort_string = "VADAC"

/datum/design/item/bluespace/ano_scanner
	name = "Alden-Saraspova counter"
	id = "ano_scanner"
	desc = "Aids in triangulation of exotic particles."
	req_tech = list(TECH_BLUESPACE = 3, TECH_MAGNET = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 10000,"glass" = 5000)
	build_path = /obj/item/device/ano_scanner
	sort_string = "VAEAA"

// tools

/datum/design/item/tool/AssembleDesignName()
	..()
	name = "Tool design ([item_name])"

/datum/design/item/tool/light_replacer
	name = "light replacer"
	desc = "A device to automatically replace lights. Refill with working lightbulbs."
	id = "light_replacer"
	req_tech = list(TECH_MAGNET = 3, TECH_MATERIAL = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 1500, "silver" = 150, "glass" = 3000)
	build_path = /obj/item/device/lightreplacer
	sort_string = "VAGAB"

/datum/design/item/tool/airlock_brace
	name = "airlock brace"
	desc = "Special door attachment that can be used to provide extra security."
	id = "brace"
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 50)
	build_path = /obj/item/weapon/airlock_brace
	sort_string = "VAGAC"

/datum/design/item/tool/brace_jack
	name = "maintenance jack"
	desc = "A special maintenance tool that can be used to remove airlock braces."
	id = "bracejack"
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 120)
	build_path = /obj/item/weapon/crowbar/brace_jack
	sort_string = "VAGAD"

/datum/design/item/tool/clamp
	name = "stasis clamp"
	desc = "A magnetic clamp which can halt the flow of gas in a pipe, via a localised cryo-stasis field."
	id = "stasis_clamp"
	req_tech = list(TECH_ENGINEERING = 4, TECH_MAGNET = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 500, "glass" = 500)
	build_path = /obj/item/clamp
	sort_string = "VAGAE"

/datum/design/item/tool/price_scanner
	name = "price scanner"
	desc = "Using an up-to-date database of various costs and prices, this device estimates the market price of an item up to 0.001% accuracy."
	id = "price_scanner"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 3000, "glass" = 3000, "silver" = 250)
	build_path = /obj/item/device/price_scanner
	sort_string = "VAGAF"

/datum/design/item/tool/experimental_welder
	name = "experimental welding tool"
	desc = "This welding tool feels heavier in your possession than is normal. There appears to be no external fuel port."
	id = "experimental_welder"
	req_tech = list(TECH_ENGINEERING = 5, TECH_PHORON = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 120, "glass" = 50)
	build_path = /obj/item/weapon/weldingtool/experimental
	sort_string = "VAGAG"

/datum/design/item/camouflage/AssembleDesignName()
	..()
	name = "Camouflage design ([item_name])"

/datum/design/item/camouflage/chameleon
	name = "holographic equipment kit"
	desc = "A kit of dangerous, high-tech equipment with changeable looks."
	id = "chameleon"
	req_tech = list(TECH_ESOTERIC = 10)
	materials = list(DEFAULT_WALL_MATERIAL = 500)
	build_path = /obj/item/weapon/storage/backpack/chameleon/sydie_kit
	sort_string = "VASBA"

// Superconductive magnetic coils
/datum/design/item/smes_coil/AssembleDesignName()
	..()
	name = "Superconductive magnetic coil ([item_name])"

/datum/design/item/smes_coil
	desc = "A superconductive magnetic coil used to store power in magnetic fields."
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 2000, "gold" = 1000, "silver" = 1000)

/datum/design/item/smes_coil/standard
	name = "standard"
	id = "smes_coil_standard"
	req_tech = list(TECH_MATERIAL = 7, TECH_POWER = 7, TECH_ENGINEERING = 5)
	build_path = /obj/item/weapon/smes_coil
	sort_string = "VAXAA"

/datum/design/item/smes_coil/super_capacity
	name = "capacitance"
	id = "smes_coil_super_capacity"
	req_tech = list(TECH_MATERIAL = 7, TECH_POWER = 8, TECH_ENGINEERING = 6)
	build_path = /obj/item/weapon/smes_coil/super_capacity
	sort_string = "VAXAB"

/datum/design/item/smes_coil/super_io
	name = "transmission"
	id = "smes_coil_super_io"
	req_tech = list(TECH_MATERIAL = 7, TECH_POWER = 8, TECH_ENGINEERING = 6)
	build_path = /obj/item/weapon/smes_coil/super_io
	sort_string = "VAXAC"


// Modular computer components
// Hard drives
/datum/design/item/modularcomponent/disk/AssembleDesignName()
	..()
	name = "Hard drive design ([item_name])"

/datum/design/item/modularcomponent/disk/normal
	name = "basic hard drive"
	id = "hdd_basic"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_type = PROTOLATHE
	materials = list(DEFAULT_WALL_MATERIAL = 400, "glass" = 100)
	build_path = /obj/item/stock_parts/computer/hard_drive/
	sort_string = "VBAAA"

/datum/design/item/modularcomponent/disk/advanced
	name = "advanced hard drive"
	id = "hdd_advanced"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	materials = list(DEFAULT_WALL_MATERIAL = 800, "glass" = 200)
	build_path = /obj/item/stock_parts/computer/hard_drive/advanced
	sort_string = "VBAAB"

/datum/design/item/modularcomponent/disk/super
	name = "super hard drive"
	id = "hdd_super"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	build_type = PROTOLATHE
	materials = list(DEFAULT_WALL_MATERIAL = 1600, "glass" = 400)
	build_path = /obj/item/stock_parts/computer/hard_drive/super
	sort_string = "VBAAC"

/datum/design/item/modularcomponent/disk/cluster
	name = "cluster hard drive"
	id = "hdd_cluster"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)
	build_type = PROTOLATHE
	materials = list(DEFAULT_WALL_MATERIAL = 3200, "glass" = 800)
	build_path = /obj/item/stock_parts/computer/hard_drive/cluster
	sort_string = "VBAAD"

/datum/design/item/modularcomponent/disk/micro
	name = "micro hard drive"
	id = "hdd_micro"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_type = PROTOLATHE
	materials = list(DEFAULT_WALL_MATERIAL = 400, "glass" = 100)
	build_path = /obj/item/stock_parts/computer/hard_drive/micro
	sort_string = "VBAAE"

/datum/design/item/modularcomponent/disk/small
	name = "small hard drive"
	id = "hdd_small"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	materials = list(DEFAULT_WALL_MATERIAL = 800, "glass" = 200)
	build_path = /obj/item/stock_parts/computer/hard_drive/small
	sort_string = "VBAAF"

// Network cards
/datum/design/item/modularcomponent/netcard/AssembleDesignName()
	..()
	name = "Network card design ([item_name])"

/datum/design/item/modularcomponent/netcard/basic
	name = "basic network card"
	id = "netcard_basic"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_type = IMPRINTER
	materials = list(DEFAULT_WALL_MATERIAL = 250, "glass" = 100)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/stock_parts/computer/network_card
	sort_string = "VBABA"

/datum/design/item/modularcomponent/netcard/advanced
	name = "advanced network card"
	id = "netcard_advanced"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 2)
	build_type = IMPRINTER
	materials = list(DEFAULT_WALL_MATERIAL = 500, "glass" = 200)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/stock_parts/computer/network_card/advanced
	sort_string = "VBABB"

/datum/design/item/modularcomponent/netcard/wired
	name = "wired network card"
	id = "netcard_wired"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 3)
	build_type = IMPRINTER
	materials = list(DEFAULT_WALL_MATERIAL = 2500, "glass" = 400)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/stock_parts/computer/network_card/wired
	sort_string = "VBABC"

// Data crystals (USB flash drives)
/datum/design/item/modularcomponent/portabledrive/AssembleDesignName()
	..()
	name = "Portable drive design ([item_name])"

/datum/design/item/modularcomponent/portabledrive/basic
	name = "basic data crystal"
	id = "portadrive_basic"
	req_tech = list(TECH_DATA = 1)
	build_type = IMPRINTER
	materials = list("glass" = 800)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/stock_parts/computer/hard_drive/portable
	sort_string = "VBACA"

/datum/design/item/modularcomponent/portabledrive/advanced
	name = "advanced data crystal"
	id = "portadrive_advanced"
	req_tech = list(TECH_DATA = 2)
	build_type = IMPRINTER
	materials = list("glass" = 1600)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/stock_parts/computer/hard_drive/portable/advanced
	sort_string = "VBACB"

/datum/design/item/modularcomponent/portabledrive/super
	name = "super data crystal"
	id = "portadrive_super"
	req_tech = list(TECH_DATA = 4)
	build_type = IMPRINTER
	materials = list("glass" = 3200)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/stock_parts/computer/hard_drive/portable/super
	sort_string = "VBACC"

// Card slot
/datum/design/item/modularcomponent/accessory/AssembleDesignName()
	..()
	name = "Computer accessory ([item_name])"

/datum/design/item/modularcomponent/accessory/cardslot
	name = "RFID card slot"
	id = "cardslot"
	req_tech = list(TECH_DATA = 2)
	build_type = PROTOLATHE
	materials = list(DEFAULT_WALL_MATERIAL = 600)
	build_path = /obj/item/stock_parts/computer/card_slot
	sort_string = "VBADA"

// inteliCard Slot
/datum/design/item/modularcomponent/accessory/aislot
	name = "inteliCard slot"
	id = "aislot"
	req_tech = list(TECH_POWER = 2, TECH_DATA = 3)
	build_type = IMPRINTER
	materials = list(DEFAULT_WALL_MATERIAL = 2000)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/stock_parts/computer/ai_slot
	sort_string = "VBADB"

// Nano printer
/datum/design/item/modularcomponent/accessory/nanoprinter
	name = "nano printer"
	id = "nanoprinter"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	materials = list(DEFAULT_WALL_MATERIAL = 600)
	build_path = /obj/item/stock_parts/computer/nano_printer
	sort_string = "VBADC"

// Tesla Link
/datum/design/item/modularcomponent/accessory/teslalink
	name = "tesla link"
	id = "teslalink"
	req_tech = list(TECH_DATA = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	materials = list(DEFAULT_WALL_MATERIAL = 2000)
	build_path = /obj/item/stock_parts/computer/tesla_link
	sort_string = "VBADD"

// Batteries
/datum/design/item/modularcomponent/battery/AssembleDesignName()
	..()
	name = "Battery design ([item_name])"

/datum/design/item/modularcomponent/battery/normal
	name = "standard battery module"
	id = "bat_normal"
	req_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 1)
	build_type = PROTOLATHE
	materials = list(DEFAULT_WALL_MATERIAL = 400)
	build_path = /obj/item/stock_parts/computer/battery_module
	sort_string = "VBAEA"

/datum/design/item/modularcomponent/battery/advanced
	name = "advanced battery module"
	id = "bat_advanced"
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	materials = list(DEFAULT_WALL_MATERIAL = 800)
	build_path = /obj/item/stock_parts/computer/battery_module/advanced
	sort_string = "VBAEB"

/datum/design/item/modularcomponent/battery/super
	name = "super battery module"
	id = "bat_super"
	req_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 3)
	build_type = PROTOLATHE
	materials = list(DEFAULT_WALL_MATERIAL = 1600)
	build_path = /obj/item/stock_parts/computer/battery_module/super
	sort_string = "VBAEC"

/datum/design/item/modularcomponent/battery/ultra
	name = "ultra battery module"
	id = "bat_ultra"
	req_tech = list(TECH_POWER = 5, TECH_ENGINEERING = 4)
	build_type = PROTOLATHE
	materials = list(DEFAULT_WALL_MATERIAL = 3200)
	build_path = /obj/item/stock_parts/computer/battery_module/ultra
	sort_string = "VBAED"

/datum/design/item/modularcomponent/battery/nano
	name = "nano battery module"
	id = "bat_nano"
	req_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 1)
	build_type = PROTOLATHE
	materials = list(DEFAULT_WALL_MATERIAL = 200)
	build_path = /obj/item/stock_parts/computer/battery_module/nano
	sort_string = "VBAEE"

/datum/design/item/modularcomponent/battery/micro
	name = "micro battery module"
	id = "bat_micro"
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	materials = list(DEFAULT_WALL_MATERIAL = 400)
	build_path = /obj/item/stock_parts/computer/battery_module/micro
	sort_string = "VBAEF"

// Processor unit
/datum/design/item/modularcomponent/cpu/AssembleDesignName()
	..()
	name = "CPU design ([item_name])"

/datum/design/item/modularcomponent/cpu/
	name = "computer processor unit"
	id = "cpu_normal"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 2)
	build_type = IMPRINTER
	materials = list(DEFAULT_WALL_MATERIAL = 1600)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/stock_parts/computer/processor_unit
	sort_string = "VBAFA"

/datum/design/item/modularcomponent/cpu/small
	name = "computer microprocessor unit"
	id = "cpu_small"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_type = IMPRINTER
	materials = list(DEFAULT_WALL_MATERIAL = 800)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/stock_parts/computer/processor_unit/small
	sort_string = "VBAFB"

/datum/design/item/modularcomponent/cpu/photonic
	name = "computer photonic processor unit"
	id = "pcpu_normal"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 4)
	build_type = IMPRINTER
	materials = list(DEFAULT_WALL_MATERIAL = 6400, glass = 2000)
	chemicals = list(/datum/reagent/acid = 40)
	build_path = /obj/item/stock_parts/computer/processor_unit/photonic
	sort_string = "VBAFC"

/datum/design/item/modularcomponent/cpu/photonic/small
	name = "computer photonic microprocessor unit"
	id = "pcpu_small"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3)
	build_type = IMPRINTER
	materials = list(DEFAULT_WALL_MATERIAL = 3200, glass = 1000)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/stock_parts/computer/processor_unit/photonic/small
	sort_string = "VBAFD"

// PDA and cartridges
/datum/design/item/pda
	name = "PDA design"
	desc = "Cheaper than whiny non-digital assistants."
	id = "pda"
	req_tech = list(TECH_ENGINEERING = 2, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)
	build_path = /obj/item/device/pda
	sort_string = "VCAAA"

/datum/design/item/pda_cartridge
	req_tech = list(TECH_ENGINEERING = 2, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)

/datum/design/item/pda_cartridge/AssembleDesignName()
	..()
	name = "PDA accessory ([item_name])"

/datum/design/item/pda_cartridge/cart_basic
	id = "cart_basic"
	build_path = /obj/item/weapon/cartridge
	sort_string = "VCBAA"

/datum/design/item/pda_cartridge/engineering
	id = "cart_engineering"
	build_path = /obj/item/weapon/cartridge/engineering
	sort_string = "VCBAB"

/datum/design/item/pda_cartridge/atmos
	id = "cart_atmos"
	build_path = /obj/item/weapon/cartridge/atmos
	sort_string = "VCBAC"

/datum/design/item/pda_cartridge/medical
	id = "cart_medical"
	build_path = /obj/item/weapon/cartridge/medical
	sort_string = "VCBAD"

/datum/design/item/pda_cartridge/chemistry
	id = "cart_chemistry"
	build_path = /obj/item/weapon/cartridge/chemistry
	sort_string = "VCBAE"

/datum/design/item/pda_cartridge/security
	id = "cart_security"
	build_path = /obj/item/weapon/cartridge/security
	sort_string = "VCBAF"

/datum/design/item/pda_cartridge/janitor
	id = "cart_janitor"
	build_path = /obj/item/weapon/cartridge/janitor
	sort_string = "VCBAG"

/datum/design/item/pda_cartridge/science
	id = "cart_science"
	build_path = /obj/item/weapon/cartridge/signal/science
	sort_string = "VCBAH"

/datum/design/item/pda_cartridge/quartermaster
	id = "cart_quartermaster"
	build_path = /obj/item/weapon/cartridge/quartermaster
	sort_string = "VCBAI"

/datum/design/item/pda_cartridge/hop
	id = "cart_hop"
	build_path = /obj/item/weapon/cartridge/hop
	sort_string = "VCBAJ"

/datum/design/item/pda_cartridge/hos
	id = "cart_hos"
	build_path = /obj/item/weapon/cartridge/hos
	sort_string = "VCBAK"

/datum/design/item/pda_cartridge/ce
	id = "cart_ce"
	build_path = /obj/item/weapon/cartridge/ce
	sort_string = "VCBAL"

/datum/design/item/pda_cartridge/cmo
	id = "cart_cmo"
	build_path = /obj/item/weapon/cartridge/cmo
	sort_string = "VCBAM"

/datum/design/item/pda_cartridge/rd
	id = "cart_rd"
	build_path = /obj/item/weapon/cartridge/rd
	sort_string = "VCBAN"

/datum/design/item/pda_cartridge/captain
	id = "cart_captain"
	build_path = /obj/item/weapon/cartridge/captain
	sort_string = "VCBAO"

//RIG Modules
//Sidenote; Try to keep a requirement of 5 engineering for each, but keep the rest as similiar to it's original as possible.
/datum/design/item/rig/AssembleDesignName()
	..()
	name = "RIG module ([item_name])"

/datum/design/item/rig/meson
	name = "Meson Scanner"
	desc = "A layered, translucent visor system for a RIG."
	id = "rig_meson"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 100, "glass" = 200, "plastic" = 300)
	build_path = /obj/item/rig_module/vision/meson
	sort_string = "WCAAA"

/datum/design/item/rig/medhud
	name = "Medical HUD"
	desc = "A simple medical status indicator for a RIG."
	id = "rig_medhud"
	req_tech = list(TECH_MAGNET = 3, TECH_BIO = 2, TECH_ENGINEERING = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 100, "glass" = 200,  "plastic" = 300)
	build_path = /obj/item/rig_module/vision/medhud
	sort_string = "WCAAB"

/datum/design/item/rig/sechud
	name = "Security HUD"
	desc = "A simple security status indicator for a RIG."
	id = "rig_sechud"
	req_tech = list(TECH_MAGNET = 3, TECH_BIO = 2, TECH_ENGINEERING = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 100, "glass" = 200,  "plastic" = 300)
	build_path = /obj/item/rig_module/vision/sechud
	sort_string = "WCAAC"

/datum/design/item/rig/nvg
	name = "Night Vision"
	desc = "A night vision module, mountable on a RIG."
	id = "rig_nvg"
	req_tech = list(TECH_MAGNET = 6, TECH_ENGINEERING = 6)
	materials = list("plastic" = 500, DEFAULT_WALL_MATERIAL = 300, "glass" = 200, "uranium" = 200)
	build_path = /obj/item/rig_module/vision/nvg
	sort_string = "WCAAD"

/datum/design/item/rig/healthscanner
	name = "Medical Scanner"
	desc = "A device able to distinguish vital signs of the subject, mountable on a RIG."
	id = "rig_healthscanner"
	req_tech = list(TECH_MAGNET = 3, TECH_BIO = 3, TECH_ENGINEERING = 5)
	materials = list("plastic" = 1000, DEFAULT_WALL_MATERIAL = 700, "glass" = 500)
	build_path = /obj/item/rig_module/device/healthscanner
	sort_string = "WCBAA"

/datum/design/item/rig/drill
	name = "Mining Drill"
	desc = "A diamond mining drill, mountable on a RIG."
	id = "rig_drill"
	req_tech = list(TECH_MATERIAL = 6, TECH_POWER = 4, TECH_ENGINEERING = 6)
	materials = list(DEFAULT_WALL_MATERIAL = 3500, "glass" = 1500, "diamond" = 2000, "plastic" = 1000)
	build_path = /obj/item/rig_module/device/drill
	sort_string = "WCCAA"

/datum/design/item/rig/plasmacutter
	name = "Plasma Cutter"
	desc = "A rock cutter that projects bursts of hot plasma, mountable on a RIG."
	id = "rig_plasmacutter"
	req_tech = list(TECH_MATERIAL = 4, TECH_PHORON = 3, TECH_ENGINEERING = 8, TECH_COMBAT = 6)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 1000, "plastic" = 1000, "gold" = 700, "phoron" = 500)
	build_path = /obj/item/rig_module/mounted/plasmacutter
	sort_string = "VCCAB"

/datum/design/item/rig/orescanner
	name = "Ore Scanner"
	desc = "A sonar system for detecting large masses of ore, mountable on a RIG."
	id = "rig_orescanner"
	req_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 4, TECH_ENGINEERING = 6)
	materials = list("plastic" = 1000, DEFAULT_WALL_MATERIAL = 800, "glass" = 500)
	build_path = /obj/item/rig_module/device/orescanner
	sort_string = "WCDAA"

/datum/design/item/rig/anomaly_scanner
	name = "Anomaly Scanner"
	desc = "An exotic particle detector commonly used by xenoarchaeologists, mountable on a RIG."
	id = "rig_anomaly_scanner"
	req_tech = list(TECH_BLUESPACE = 4, TECH_MAGNET = 4, TECH_ENGINEERING = 6)
	materials = list("plastic" = 1000, DEFAULT_WALL_MATERIAL = 800, "glass" = 500)
	build_path = /obj/item/rig_module/device/anomaly_scanner
	sort_string = "WCDAB"

/datum/design/item/rig/rcd
	name = "RCD"
	desc = "A Rapid Construction Device, mountable on a RIG."
	id = "rig_rcd"
	req_tech = list(TECH_MATERIAL = 8, TECH_MAGNET = 5, TECH_ENGINEERING = 7)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 1000, "plastic" = 1000,"gold" = 700, "silver" = 700)
	build_path = /obj/item/rig_module/device/rcd
	sort_string = "WCEAA"

/datum/design/item/rig/jets
	name = "Maneuvering Jets"
	desc = "A compact gas thruster system, mountable on a RIG."
	id = "rig_jets"
	req_tech = list(TECH_MATERIAL = 6,  TECH_ENGINEERING = 7)
	materials = list(DEFAULT_WALL_MATERIAL = 3000, "plastic" = 2000, "glass" = 1000)
	build_path = /obj/item/rig_module/maneuvering_jets
	sort_string = "WCFAA"

//I think this is like a janitor thing but seems like it could be useful for engis
/datum/design/item/rig/decompiler
	name = "Matter Decompiler"
	desc = "A drone matter decompiler reconfigured to be mounted onto a RIG."
	id = "rig_decompiler"
	req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 3000, "plastic" = 2000, "glass" = 1000)
	build_path = /obj/item/rig_module/device/decompiler
	sort_string = "WCGAA"

/datum/design/item/rig/powersink
	name = "Power Sink"
	desc = "A RIG module that allows the user to recharge their RIG's power cell without removing it."
	id = "rig_powersink"
	req_tech = list(TECH_POWER = 6, TECH_ENGINEERING = 6)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 2000, "gold" = 1000, "plastic" = 1000)
	build_path = /obj/item/rig_module/power_sink
	sort_string = "WCHAA"

/datum/design/item/rig/ai_container
	name = "IIS"
	desc = "An integrated intelligence system module suitable for most RIGs."
	id = "rig_ai_container"
	req_tech = list(TECH_DATA = 6, TECH_MATERIAL = 5, TECH_ENGINEERING = 6)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, "glass" = 1000, "plastic" = 1000, "gold" = 500)
	build_path = /obj/item/rig_module/ai_container
	sort_string = "WCIAA"

/datum/design/item/rig/flash
	name = "Flash"
	desc = "A normal flash, mountable on a RIG."
	id = "rig_flash"
	req_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 3, TECH_ENGINEERING = 5)
	materials = list("plastic" = 1500, DEFAULT_WALL_MATERIAL = 1000, "glass" = 500)
	build_path = /obj/item/rig_module/device/flash
	sort_string = "WCJAA"

/datum/design/item/rig/taser
	name = "Taser"
	desc = "A taser, mountable on a RIG."
	id = "rig_taser"
	req_tech = list(TECH_POWER = 5, TECH_COMBAT = 5, TECH_ENGINEERING = 6)
	materials = list(DEFAULT_WALL_MATERIAL = 4000, "plastic" = 2500, "glass" = 2000, "gold" = 1000)
	build_path = /obj/item/rig_module/mounted/taser
	sort_string = "WCKAA"



/datum/design/item/rig/cooling_unit
	name = "Cooling Unit"
	desc = "A suit cooling unit, mountable on a RIG."
	id = "rig_cooler"
	req_tech = list(TECH_MATERIAL = 2, TECH_MAGNET = 2, TECH_ENGINEERING = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 3000, "glass" = 3500, "plastic" = 2000)
	build_path = /obj/item/rig_module/cooling_unit
	sort_string = "WCLAB"


/datum/design/prefab
	name = "Device"
	desc = "A blueprint made from a design built here."
	materials = list(DEFAULT_WALL_MATERIAL = 200)
	id = "prefab"
	build_type = PROTOLATHE
	sort_string = "ZAAAA"
	var/decl/prefab/ic_assembly/fabrication
	var/global/count = 0

/datum/design/prefab/New(var/research, var/fab)
	if(fab)
		fabrication = fab
		materials = list(DEFAULT_WALL_MATERIAL = fabrication.metal_amount)
		build_path = /obj/item/device/electronic_assembly //put this here so that the default made one doesn't show up in protolathe list
		id = "prefab[++count]"
	sort_string = "Z"
	var/cur_count = count
	while(cur_count > 25)
		sort_string += ascii2text(cur_count%25+65)
		cur_count = (cur_count - cur_count%25)/25
	sort_string += ascii2text(cur_count + 65)
	while(length(sort_string) < 5)
		sort_string += "A"
	..()

/datum/design/prefab/AssembleDesignName()
	..()
	if(fabrication)
		name = "Device ([fabrication.assembly_name])"

/datum/design/prefab/Fabricate(var/newloc)
	if(!fabrication)
		return
	var/obj/O = fabrication.create(newloc)
	for(var/obj/item/integrated_circuit/circ in O.contents)
		circ.removable = 0
	return O

/*
CIRCUITS BELOW
*/

/datum/design/circuit
	build_type = IMPRINTER
	req_tech = list(TECH_DATA = 2)
	materials = list("glass" = 2000)
	chemicals = list(/datum/reagent/acid = 20)
	time = 5

/datum/design/circuit/AssembleDesignName()
	..()
	if(build_path)
		var/obj/item/weapon/circuitboard/C = build_path
		if(initial(C.board_type) == "machine")
			name = "Machine circuit design ([item_name])"
		else if(initial(C.board_type) == "computer")
			name = "Computer circuit design ([item_name])"
		else
			name = "Circuit design ([item_name])"

/datum/design/circuit/AssembleDesignDesc()
	if(!desc)
		desc = "Allows for the construction of \a [item_name] circuit board."

/datum/design/circuit/arcademachine
	name = "battle arcade machine"
	id = "arcademachine"
	req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/weapon/circuitboard/arcade/battle
	sort_string = "MAAAA"

/datum/design/circuit/oriontrail
	name = "orion trail arcade machine"
	id = "oriontrail"
	req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/weapon/circuitboard/arcade/orion_trail
	sort_string = "MABAA"

/datum/design/circuit/prisonmanage
	name = "prisoner management console"
	id = "prisonmanage"
	build_path = /obj/item/weapon/circuitboard/prisoner
	sort_string = "DACAA"

/datum/design/circuit/operating
	name = "patient monitoring console"
	id = "operating"
	build_path = /obj/item/weapon/circuitboard/operating
	sort_string = "FACAA"

/datum/design/circuit/crewconsole
	name = "crew monitoring console"
	id = "crewconsole"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 2, TECH_BIO = 2)
	build_path = /obj/item/weapon/circuitboard/crew
	sort_string = "FAGAI"

/datum/design/circuit/bioprinter
	name = "bioprinter"
	id = "bioprinter"
	req_tech = list(TECH_ENGINEERING = 1, TECH_BIO = 3, TECH_DATA = 3)
	build_path = /obj/item/weapon/circuitboard/bioprinter
	sort_string = "FAGAK"

/datum/design/circuit/roboprinter
	name = "prosthetic organ fabricator"
	id = "roboprinter"
	req_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 3)
	build_path = /obj/item/weapon/circuitboard/roboprinter
	sort_string = "FAGAM"


/datum/design/circuit/robocontrol
	name = "robotics control console"
	id = "robocontrol"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/weapon/circuitboard/robotics
	sort_string = "HAAAB"

/datum/design/circuit/mechacontrol
	name = "exosuit control console"
	id = "mechacontrol"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/weapon/circuitboard/mecha_control
	sort_string = "HAAAC"

/datum/design/circuit/rdconsole
	name = "R&D control console"
	id = "rdconsole"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/weapon/circuitboard/rdconsole
	sort_string = "HAAAE"

/datum/design/circuit/comm_monitor
	name = "telecommunications monitoring console"
	id = "comm_monitor"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/weapon/circuitboard/comm_monitor
	sort_string = "HAACA"

/datum/design/circuit/comm_server
	name = "telecommunications server monitoring console"
	id = "comm_server"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/weapon/circuitboard/comm_server
	sort_string = "HAACB"

/datum/design/circuit/comm_traffic
	name = "telecommunications traffic control console"
	id = "comm_traffic"
	req_tech = list(TECH_DATA = 6)
	build_path = /obj/item/weapon/circuitboard/comm_traffic
	sort_string = "HAACC"

/datum/design/circuit/message_monitor
	name = "messaging monitor console"
	id = "message_monitor"
	req_tech = list(TECH_DATA = 5)
	build_path = /obj/item/weapon/circuitboard/message_monitor
	sort_string = "HAACD"

/datum/design/circuit/aiupload
	name = "AI upload console"
	id = "aiupload"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/weapon/circuitboard/aiupload
	sort_string = "HAABA"

/datum/design/circuit/borgupload
	name = "cyborg upload console"
	id = "borgupload"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/weapon/circuitboard/borgupload
	sort_string = "HAABB"

/datum/design/circuit/destructive_analyzer
	name = "destructive analyzer"
	id = "destructive_analyzer"
	req_tech = list(TECH_DATA = 2, TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/weapon/circuitboard/destructive_analyzer
	sort_string = "HABAA"

/datum/design/circuit/protolathe
	name = "protolathe"
	id = "protolathe"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/weapon/circuitboard/protolathe
	sort_string = "HABAB"

/datum/design/circuit/circuit_imprinter
	name = "circuit imprinter"
	id = "circuit_imprinter"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/weapon/circuitboard/circuit_imprinter
	sort_string = "HABAC"

/datum/design/circuit/autolathe
	name = "autolathe board"
	id = "autolathe"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/weapon/circuitboard/autolathe
	sort_string = "HABAD"

/datum/design/circuit/rdservercontrol
	name = "R&D server control console"
	id = "rdservercontrol"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/weapon/circuitboard/rdservercontrol
	sort_string = "HABBA"

/datum/design/circuit/rdserver
	name = "R&D server"
	id = "rdserver"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/weapon/circuitboard/rdserver
	sort_string = "HABBB"

/datum/design/circuit/mechfab
	name = "exosuit fabricator"
	id = "mechfab"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/weapon/circuitboard/mechfab
	sort_string = "HABAE"

/datum/design/circuit/mech_recharger
	name = "mech recharger"
	id = "mech_recharger"
	req_tech = list(TECH_DATA = 2, TECH_POWER = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/weapon/circuitboard/mech_recharger
	sort_string = "HACAA"

/datum/design/circuit/recharge_station
	name = "cyborg recharge station"
	id = "recharge_station"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 2)
	build_path = /obj/item/weapon/circuitboard/recharge_station
	sort_string = "HACAC"

/datum/design/circuit/atmosalerts
	name = "atmosphere alert console"
	id = "atmosalerts"
	build_path = /obj/item/weapon/circuitboard/atmos_alert
	sort_string = "JAAAA"

/datum/design/circuit/air_management
	name = "atmosphere monitoring console"
	id = "air_management"
	build_path = /obj/item/weapon/circuitboard/air_management
	sort_string = "JAAAB"

/datum/design/circuit/rcon_console
	name = "RCON remote control console"
	id = "rcon_console"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3, TECH_POWER = 5)
	build_path = /obj/item/weapon/circuitboard/rcon_console
	sort_string = "JAAAC"

/datum/design/circuit/dronecontrol
	name = "drone control console"
	id = "dronecontrol"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/weapon/circuitboard/drone_control
	sort_string = "JAAAD"

/datum/design/circuit/powermonitor
	name = "power monitoring console"
	id = "powermonitor"
	build_path = /obj/item/weapon/circuitboard/powermonitor
	sort_string = "JAAAE"

/datum/design/circuit/solarcontrol
	name = "solar control console"
	id = "solarcontrol"
	build_path = /obj/item/weapon/circuitboard/solar_control
	sort_string = "JAAAF"

/datum/design/circuit/pacman
	name = "PACMAN-type generator"
	id = "pacman"
	req_tech = list(TECH_DATA = 3, TECH_PHORON = 3, TECH_POWER = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/weapon/circuitboard/pacman
	sort_string = "JBAAA"

/datum/design/circuit/superpacman
	name = "SUPERPACMAN-type generator"
	id = "superpacman"
	req_tech = list(TECH_DATA = 3, TECH_POWER = 4, TECH_ENGINEERING = 4)
	build_path = /obj/item/weapon/circuitboard/pacman/super
	sort_string = "JBAAB"

/datum/design/circuit/mrspacman
	name = "MRSPACMAN-type generator"
	id = "mrspacman"
	req_tech = list(TECH_DATA = 3, TECH_POWER = 5, TECH_ENGINEERING = 5)
	build_path = /obj/item/weapon/circuitboard/pacman/mrs
	sort_string = "JBAAC"

/datum/design/circuit/batteryrack
	name = "cell rack PSU"
	id = "batteryrack"
	req_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 2)
	build_path = /obj/item/weapon/circuitboard/batteryrack
	sort_string = "JBABA"

/datum/design/circuit/smes_cell
	name = "'SMES' superconductive magnetic energy storage"
	desc = "Allows for the construction of circuit boards used to build a SMES."
	id = "smes_cell"
	req_tech = list(TECH_POWER = 7, TECH_ENGINEERING = 5)
	build_path = /obj/item/weapon/circuitboard/smes
	sort_string = "JBABB"

/datum/design/circuit/gas_heater
	name = "gas heating system"
	id = "gasheater"
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 1)
	build_path = /obj/item/weapon/circuitboard/unary_atmos/heater
	sort_string = "JCAAA"

/datum/design/circuit/gas_cooler
	name = "gas cooling system"
	id = "gascooler"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/weapon/circuitboard/unary_atmos/cooler
	sort_string = "JCAAB"

/datum/design/circuit/secure_airlock
	name = "secure airlock electronics"
	desc =  "Allows for the construction of a tamper-resistant airlock electronics."
	id = "securedoor"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/weapon/airlock_electronics/secure
	sort_string = "JDAAA"

/datum/design/circuit/biogenerator
	name = "biogenerator"
	id = "biogenerator"
	req_tech = list(TECH_DATA = 2)
	build_path = /obj/item/weapon/circuitboard/biogenerator
	sort_string = "KBAAA"

/datum/design/circuit/miningdrill
	name = "mining drill head"
	id = "mining drill head"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/weapon/circuitboard/miningdrill
	sort_string = "KCAAA"

/datum/design/circuit/miningdrillbrace
	name = "mining drill brace"
	id = "mining drill brace"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/weapon/circuitboard/miningdrillbrace
	sort_string = "KCAAB"


/datum/design/circuit/mecha/AssembleDesignName()
	name = "Exosuit module circuit design ([name])"
/datum/design/circuit/mecha/AssembleDesignDesc()
	desc = "Allows for the construction of \a [name] module."


/datum/design/circuit/tcom
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)

/datum/design/circuit/tcom/AssembleDesignName()
	name = "Telecommunications machinery circuit design ([name])"
/datum/design/circuit/tcom/AssembleDesignDesc()
	desc = "Allows for the construction of a telecommunications [name] circuit board."

/datum/design/circuit/tcom/server
	name = "server mainframe"
	id = "tcom-server"
	build_path = /obj/item/weapon/circuitboard/telecomms/server
	sort_string = "PAAAA"

/datum/design/circuit/tcom/processor
	name = "processor unit"
	id = "tcom-processor"
	build_path = /obj/item/weapon/circuitboard/telecomms/processor
	sort_string = "PAAAB"

/datum/design/circuit/tcom/bus
	name = "bus mainframe"
	id = "tcom-bus"
	build_path = /obj/item/weapon/circuitboard/telecomms/bus
	sort_string = "PAAAC"

/datum/design/circuit/tcom/hub
	name = "hub mainframe"
	id = "tcom-hub"
	build_path = /obj/item/weapon/circuitboard/telecomms/hub
	sort_string = "PAAAD"

/datum/design/circuit/tcom/relay
	name = "relay mainframe"
	id = "tcom-relay"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 4, TECH_BLUESPACE = 3)
	build_path = /obj/item/weapon/circuitboard/telecomms/relay
	sort_string = "PAAAE"

/datum/design/circuit/tcom/broadcaster
	name = "subspace broadcaster"
	id = "tcom-broadcaster"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4, TECH_BLUESPACE = 2)
	build_path = /obj/item/weapon/circuitboard/telecomms/broadcaster
	sort_string = "PAAAF"

/datum/design/circuit/tcom/receiver
	name = "subspace receiver"
	id = "tcom-receiver"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3, TECH_BLUESPACE = 2)
	build_path = /obj/item/weapon/circuitboard/telecomms/receiver
	sort_string = "PAAAG"

/datum/design/circuit/shield_generator
	name = "Shield Generator"
	desc = "Allows for the construction of a shield generator circuit board."
	id = "shield_generator"
	req_tech = list(TECH_MAGNET = 3, TECH_POWER = 4)
	build_path = /obj/item/weapon/circuitboard/shield_generator
	sort_string = "VAAAC"

/datum/design/circuit/ntnet_relay
	name = "Foundation Quantum Relay"
	id = "ntnet_relay"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/weapon/circuitboard/ntnet_relay
	sort_string = "WAAAA"

/datum/design/circuit/replicator
	name = "food replicator"
	id = "freplicator"
	req_tech = list(TECH_BIO = 3, TECH_DATA = 3)
	build_path = /obj/item/weapon/circuitboard/replicator
	sort_string = "WAAAR"

/datum/design/circuit/aicore
	name = "AI core"
	id = "aicore"
	req_tech = list(TECH_DATA = 4, TECH_BIO = 3)
	build_path = /obj/item/weapon/circuitboard/aicore
	sort_string = "XAAAA"

/datum/design/circuit/integrated
	name = "integrated circuit"
	id = "integrated"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/weapon/circuitboard/integrated_printer
	sort_string = "WAAAS"

/datum/design/aimodule
	build_type = IMPRINTER
	materials = list("glass" = 2000, "gold" = 100)

/datum/design/aimodule/AssembleDesignName()
	name = "AI module design ([name])"

/datum/design/aimodule/AssembleDesignDesc()
	desc = "Allows for the construction of \a '[name]' AI module."

/datum/design/aimodule/safeguard
	name = "Safeguard"
	id = "safeguard"
	req_tech = list(TECH_DATA = 3, TECH_MATERIAL = 4)
	build_path = /obj/item/weapon/aiModule/safeguard
	sort_string = "XABAA"

/datum/design/aimodule/onehuman
	name = "OneCrewMember"
	id = "onehuman"
	req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 6)
	build_path = /obj/item/weapon/aiModule/oneHuman
	sort_string = "XABAB"

/datum/design/aimodule/protectstation
	name = "ProtectInstallation"
	id = "protectstation"
	req_tech = list(TECH_DATA = 3, TECH_MATERIAL = 6)
	build_path = /obj/item/weapon/aiModule/protectStation
	sort_string = "XABAC"

/datum/design/aimodule/notele
	name = "TeleporterOffline"
	id = "notele"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/weapon/aiModule/teleporterOffline
	sort_string = "XABAD"

/datum/design/aimodule/quarantine
	name = "Quarantine"
	id = "quarantine"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 2, TECH_MATERIAL = 4)
	build_path = /obj/item/weapon/aiModule/quarantine
	sort_string = "XABAE"

/datum/design/aimodule/oxygen
	name = "OxygenIsToxicToHumans"
	id = "oxygen"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 2, TECH_MATERIAL = 4)
	build_path = /obj/item/weapon/aiModule/oxygen
	sort_string = "XABAF"

/datum/design/aimodule/freeform
	name = "Freeform"
	id = "freeform"
	req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 4)
	build_path = /obj/item/weapon/aiModule/freeform
	sort_string = "XABAG"

/datum/design/aimodule/reset
	name = "Reset"
	id = "reset"
	req_tech = list(TECH_DATA = 3, TECH_MATERIAL = 6)
	build_path = /obj/item/weapon/aiModule/reset
	sort_string = "XAAAA"

/datum/design/aimodule/purge
	name = "Purge"
	id = "purge"
	req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 6)
	build_path = /obj/item/weapon/aiModule/purge
	sort_string = "XAAAB"

// Core modules
/datum/design/aimodule/core
	req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 6)

/datum/design/aimodule/core/AssembleDesignName()
	name = "AI core module design ([name])"

/datum/design/aimodule/core/AssembleDesignDesc()
	desc = "Allows for the construction of \a '[name]' AI core module."

/datum/design/aimodule/core/freeformcore
	name = "Freeform"
	id = "freeformcore"
	build_path = /obj/item/weapon/aiModule/freeformcore
	sort_string = "XACAA"
