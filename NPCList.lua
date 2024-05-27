local SKULL    = 8
local CROSS    = 7
local SQUARE   = 6
local MOON     = 5
local TRIANGLE = 4
local DIAMOND  = 3
local CIRCLE   = 2
local STAR     = 1
local UNMARKED = 0

defaultNpcsToMark = {}
orderedPacks = {}

--[[

  Some ids such as anub adds, raz adds, faerlina adds, and buru adds are interesting and special.
  Special from each other in fact, each boss has a different behavior in how id's are consistent or not.

  When buru eggs die during the fight the id counter increases multiple times. Shortly after death a spawner is created for them which is one id higher,
  and when the egg spawns back in it will be one id higher than the spawner. If multiple eggs die at once this id increase is likely expounded
  and somewhat unpredictable.
  A mechanism which detects the order of deaths for marked eggs and re-applies marks in order of final respawn accounts for this.

  Anub'rekhan's adds are always fresh ids and not consistent each instance start. When fight resets they will be fresh yet again.
  A mechanism which detects 2 of his adds respawning is in effect.

  Raz has adds which have a consistent mark when the instance starts, but every time the fight resets the adds are all respawned with new ids
  one at a time in a clockwise order.
  A mechanism which detects 4 of his adds respawning is in effect.

  Skeram spawns clones when he does his 3-way split but his own id never changes.
  A mechanism which detects 3 of his adds respawning is in effect. Since they all share the same name.

  Arlokk doesn't have adds to mark exactly, but she does disappear in the fight.
  The mechanism to detect 1 add respawning is used to remark her.

  Faerlina adds which aren't dead will not respawn and not gain new ids if the fight resets, they simply run back to their start positions,
  however dead adds will gain new ids.
  A mechanism like the buru egg one could work to update them, tracking order of mark deaths, assuming they respawn while the marker isn't released.
  **If** there's any consistency with their new id's a composite approach can be used.
  The queue for if we res in room, or detecting the add id's when we run back to her and using the fact that new id's are higher, we can re-mark
  based on identifying what adds are missing marks and then comparing their death order vs sorted ids.

--]]


-- Function to add entries while maintaining order
function addToDefaultNpcsToMark(instance, packName, npcs)
    if not defaultNpcsToMark[instance] then
        defaultNpcsToMark[instance] = {}
    end
    defaultNpcsToMark[instance][packName] = npcs
    table.insert(orderedPacks, {instance = instance, packName = packName})
end

--/////////////// Naxxramas ///////////////

defaultNpcsToMark["Naxxramas"] = {}

--/////////////// SPIDER ///////////////

addToDefaultNpcsToMark("Naxxramas", "spider_entrance_patrol", {
  ["0xF130003E69269C39"] = UNMARKED, -- Infectious Skitterer
  ["0xF130003E69269C38"] = UNMARKED, -- Infectious Skitterer
  ["0xF130003E69269C37"] = UNMARKED, -- Infectious Skitterer
  ["0xF130003E69269C36"] = UNMARKED, -- Infectious Skitterer
  ["0xF130003E69269C35"] = UNMARKED, -- Infectious Skitterer
  ["0xF130003E69269C34"] = UNMARKED, -- Infectious Skitterer
  ["0xF130003E69269C33"] = UNMARKED, -- Infectious Skitterer
  ["0xF130003E69269C32"] = UNMARKED, -- Infectious Skitterer
  ["0xF130003E69269C05"] = UNMARKED, -- Infectious Skitterer
  ["0xF130003E69269C0F"] = STAR, -- Infectious Skitterer
})

addToDefaultNpcsToMark("Naxxramas", "spider_entrance_right", {
  ["0xF130003E680158F6"]  = SKULL, -- Venom Stalker
  ["0xF130003E6601590E"]  = CROSS, -- Dread Creeper
  ["0xF130003E6601590F"]  = SQUARE, -- Dread Creeper
  ["0xF130003E670158F4"]  = MOON, -- Carrion Spinner
  ["0xF130003E670158F5"]  = TRIANGLE, -- Carrion Spinner
  ["0xF130003E670158F3"]  = DIAMOND, -- Carrion Spinner
})

addToDefaultNpcsToMark("Naxxramas", "spider_entrance_left", {
  ["0xF130003E680158F7"]  = SKULL, -- Venom Stalker
  ["0xF130003E66015911"]  = CROSS, -- Dread Creeper
  ["0xF130003E66015910"]  = SQUARE, -- Dread Creeper
  ["0xF130003E670158F9"]  = MOON, -- Carrion Spinner
  ["0xF130003E670158FA"]  = TRIANGLE, -- Carrion Spinner
  ["0xF130003E670158F8"]  = DIAMOND, -- Carrion Spinner
})

addToDefaultNpcsToMark("Naxxramas", "spider_anubrekhan_hallway", {
  ["0xF130003E68015917"]  = SKULL, -- Venom Stalker
  ["0xF130003E66015912"]  = CROSS, -- Dread Creeper
  ["0xF130003E66015913"]  = SQUARE, -- Dread Creeper
  ["0xF130003E67015914"]  = MOON, -- Carrion Spinner
  ["0xF130003E67015915"]  = TRIANGLE, -- Carrion Spinner
  ["0xF130003E67015916"]  = DIAMOND, -- Carrion Spinner
})

addToDefaultNpcsToMark("Naxxramas", "spider_anubrekhan", {
  ["0xF130003E5401591A"]  = SKULL, -- Anub'Rekhan
  ["0xF1300040BD04B2DF"]  = CROSS, -- Crypt Guard
  ["0xF1300040BD04B2DE"]  = SQUARE, -- Crypt Guard
})

addToDefaultNpcsToMark("Naxxramas", "spider_central_right", {
  ["0xF130003E6A0159DF"]  = SKULL, -- Crypt Reaver
  ["0xF130003E67269C2D"]  = CROSS, -- Carrion Spinner
  ["0xF130003E67269C2C"]  = SQUARE, -- Carrion Spinner
  ["0xF130003E67269C2B"]  = TRIANGLE, -- Carrion Spinner
  ["0xF130003E67269C2A"]  = DIAMOND, -- Carrion Spinner
  ["0xF130003E670159F3"]  = MOON, -- Carrion Spinner
  ["0xF130003E670159F4"]  = CIRCLE, -- Carrion Spinner
})

addToDefaultNpcsToMark("Naxxramas", "spider_central_patrol", {
  ["0xF130003E69269C0B"]  = STAR, -- Infectious Skitterer
  ["0xF130003E69269C0C"]  = UNMARKED, -- Infectious Skitterer
  ["0xF130003E69269C13"]  = UNMARKED, -- Infectious Skitterer
  ["0xF130003E69269C12"]  = UNMARKED, -- Infectious Skitterer
  ["0xF130003E69269C11"]  = UNMARKED, -- Infectious Skitterer
  ["0xF130003E69269C10"]  = UNMARKED, -- Infectious Skitterer
  ["0xF130003E69269C0E"]  = UNMARKED, -- Infectious Skitterer
  ["0xF130003E69269C0D"]  = UNMARKED, -- Infectious Skitterer
})

addToDefaultNpcsToMark("Naxxramas", "spider_necro_1", {
  ["0xF130004045015A20"]  = SKULL, -- Necro Stalker
  ["0xF130004045015A1F"]  = CROSS, -- Necro Stalker
})

addToDefaultNpcsToMark("Naxxramas", "spider_necro_2", {
  ["0xF130004045049DBE"]  = SKULL, -- Necro Stalker
  ["0xF130004045049DBF"]  = CROSS, -- Necro Stalker
})

addToDefaultNpcsToMark("Naxxramas", "spider_faerlina_patrol", {
  ["0xF130003E69049D6A"]  = STAR, -- Infectious Skitterer
  ["0xF130003E69049D6B"]  = UNMARKED, -- Infectious Skitterer
  ["0xF130003E69049D6C"]  = UNMARKED, -- Infectious Skitterer
  ["0xF130003E69049D69"]  = UNMARKED, -- Infectious Skitterer
  ["0xF130003E69049D68"]  = UNMARKED, -- Infectious Skitterer
  ["0xF130003E69049D67"]  = UNMARKED, -- Infectious Skitterer
  ["0xF130003E69049D66"]  = UNMARKED, -- Infectious Skitterer
  ["0xF130003E69049D65"]  = UNMARKED, -- Infectious Skitterer
})


addToDefaultNpcsToMark("Naxxramas", "spider_faerlina_left_1", {
	["0xF130003E6D269BFD"] = CROSS, -- Naxxramas Acolyte
	["0xF130003E6C269C02"] = CIRCLE,-- Naxxramas Cultistz
	["0xF130003E6C269BFE"] = TRIANGLE,-- Naxxramas Cultist
	["0xF130003E6D269C01"] = MOON, -- Naxxramas Acolyte
	["0xF130003E6C269BFC"] = STAR,-- Naxxramas Cultist
	["0xF130003E6D269BFB"] = SQUARE, -- Naxxramas Acolyte
	["0xF130003E6C269C00"] = DIAMOND,-- Naxxramas Cultist
	["0xF130003E6D269BFF"] = SKULL, -- Naxxramas Acolyte
})

addToDefaultNpcsToMark("Naxxramas", "spider_faerlina_left_2", {
	["0xF130003E6D269BFA"] = MOON, -- Naxxramas Acolyte
	["0xF130003E6C269BF5"] = CIRCLE,
	["0xF130003E6C269BF3"] = TRIANGLE,-- -- Naxxramas CultistNaxxramas Cultist
	["0xF130003E6C269BF7"] = DIAMOND,-- Naxxramas Cultist
	["0xF130003E6D269BF8"] = SQUARE, -- Naxxramas Acolyte
	["0xF130003E6C269BF9"] = STAR,-- Naxxramas Cultist
	["0xF130003E6D269BF4"] = SKULL, -- Naxxramas Acolyte
	["0xF130003E6D269BF6"] = CROSS, -- Naxxramas Acolyte
})

addToDefaultNpcsToMark("Naxxramas", "spider_faerlina_left_3", {
	["0xF130003E6C269BDA"] = STAR,-- Naxxramas Cultist
	["0xF130003E6D269BD9"] = SQUARE, -- Naxxramas Acolyte
	["0xF130003E6C269BD8"] = DIAMOND,-- Naxxramas Cultist
	["0xF130003E6D269BD7"] = SKULL, -- Naxxramas Acolyte
	["0xF130003E6C269BD6"] = CIRCLE,-- Naxxramas Cultist
	["0xF130003E6D269BD5"] = CROSS, -- Naxxramas Acolyte
	["0xF130003E6D269BD4"] = MOON, -- Naxxramas Acolyte
	["0xF130003E6C269BD3"] = TRIANGLE,-- Naxxramas Cultist
})

addToDefaultNpcsToMark("Naxxramas", "spider_faerlina_right_1", {
	["0xF130003E6D269BE2"] = SQUARE, -- Naxxramas Acolyte
	["0xF130003E6C269BE1"] = DIAMOND,-- Naxxramas Cultist
	["0xF130003E6D269BE0"] = CROSS, -- Naxxramas Acolyte
	["0xF130003E6C269BDF"] = TRIANGLE,-- Naxxramas Cultist
	["0xF130003E6D269BDE"] = MOON, -- Naxxramas Acolyte
	["0xF130003E6C269BDD"] = CIRCLE,-- Naxxramas Cultist
	["0xF130003E6C269BDC"] = STAR,-- Naxxramas Cultist
	["0xF130003E6D269BDB"] = SKULL, -- Naxxramas Acolyte
})

addToDefaultNpcsToMark("Naxxramas", "spider_faerlina_right_2", {
	["0xF130003E6C269BE3"] = CIRCLE,-- Naxxramas Cultist
	["0xF130003E6C269BE5"] = DIAMOND,-- Naxxramas Cultist
	["0xF130003E6C269BE7"] = STAR,-- Naxxramas Cultist
	["0xF130003E6C269BE9"] = TRIANGLE,-- Naxxramas Cultist
	["0xF130003E6D269BE8"] = CROSS, -- Naxxramas Acolyte
	["0xF130003E6D269BEA"] = SQUARE, -- Naxxramas Acolyte
	["0xF130003E6D269BE6"] = MOON, -- Naxxramas Acolyte
	["0xF130003E6D269BE4"] = SKULL, -- Naxxramas Acolyte
})

addToDefaultNpcsToMark("Naxxramas", "spider_faerlina_right_3", {
	["0xF130003E6D269BED"] = SQUARE, -- Naxxramas Acolyte
	["0xF130003E6C269BF0"] = DIAMOND, -- Naxxramas Cultist
	["0xF130003E6D269BF1"] = MOON, -- Naxxramas Acolyte
	["0xF130003E6C269BF2"] = STAR, -- Naxxramas Cultist
	["0xF130003E6D269BEB"] = SKULL, -- Naxxramas Acolyte
	["0xF130003E6C269BEC"] = TRIANGLE, -- Naxxramas Cultist
	["0xF130003E6D269BEF"] = CROSS, -- Naxxramas Acolyte
	["0xF130003E6C269BEE"] = CIRCLE, -- Naxxramas Cultist
})

addToDefaultNpcsToMark("Naxxramas", "spider_faerlina", {
  ["0xF130003E510159B0"] = TRIANGLE, -- Grand Widow Faerlina
  ["0xF130004079276DE5"] = CROSS, -- Naxxramas Follower
  ["0xF130004079276DE6"] = SKULL, -- Naxxramas Follower
  ["0xF13000407A276DE7"] = CIRCLE, -- Naxxramas Worshipper
  ["0xF13000407A276DE8"] = SQUARE, -- Naxxramas Worshipper
  ["0xF13000407A276DE9"] = MOON, -- Naxxramas Worshipper
  ["0xF13000407A276DEA"] = STAR, -- Naxxramas Worshipper
})

addToDefaultNpcsToMark("Naxxramas", "spider_final", {
	["0xF130003E66269C1A"] = CROSS, -- Dread Creeper
	["0xF130003E66269C18"] = TRIANGLE, -- Dread Creeper
	["0xF130003E66015A2F"] = SQUARE, -- Dread Creeper
	["0xF130003E66269C19"] = MOON, -- Dread Creeper
	["0xF130003E6B01F3EE"] = SKULL, -- Tomb Horror
})

addToDefaultNpcsToMark("Naxxramas", "spider_ring_3", {
  ["0xF130003FF0015AD4"]  = SKULL, -- Necropolis Acolyte
  ["0xF130003FF0015AD3"]  = CROSS, -- Necropolis Acolyte
})


----/////////////// CONSTRUCT ///////////////

addToDefaultNpcsToMark("Naxxramas", "construct_entrance", {
  ["0xF130003E910158C7"]  = SKULL, -- Patchwork Golem
  ["0xF130003E910158C6"]  = CROSS, -- Patchwork Golem
  ["0xF130003E910158C5"]  = SQUARE, -- Patchwork Golem
  ["0xF130003E910158C8"]  = MOON, -- Patchwork Golem
})

addToDefaultNpcsToMark("Naxxramas", "construct_entrance_patrol", {
  ["0xF130003E920158CD"]  = TRIANGLE, -- Bile Retcher
  ["0xF130003E920158CE"]  = DIAMOND, -- Bile Retcher
  ["0xF130003E9D015A90"]  = CIRCLE, -- Sludge Belcher
  ["0xF130003E9D015A91"]  = STAR, -- Sludge Belcher
})

addToDefaultNpcsToMark("Naxxramas", "construct_central_left", {
  ["0xF130003E920158CF"]  = SKULL, -- Bile Retcher
  ["0xF130003E910158CA"]  = CROSS, -- Patchwork Golem
  ["0xF130003E910158C9"]  = SQUARE, -- Patchwork Golem
})

addToDefaultNpcsToMark("Naxxramas", "construct_central_right", {
  ["0xF130003E920158D0"]  = SKULL, -- Bile Retcher
  ["0xF130003E910158CB"]  = CROSS, -- Patchwork Golem
  ["0xF130003E910158CC"]  = SQUARE, -- Patchwork Golem
})

addToDefaultNpcsToMark("Naxxramas", "construct_central", {
  ["0xF130003E910158D8"]  = SKULL, -- Patchwork Golem
  ["0xF130003E910158D7"]  = CROSS, -- Patchwork Golem
  ["0xF130003E910158D6"]  = SQUARE, -- Patchwork Golem
  ["0xF130003E910158D9"]  = MOON, -- Patchwork Golem
})

addToDefaultNpcsToMark("Naxxramas", "construct_patchwerk_patrol", {
  ["0xF130003E92015A93"]  = SKULL, -- Bile Retcher
  ["0xF130003E92015A8E"]  = TRIANGLE, -- Bile Retcher
  ["0xF130003E9D015A92"]  = CIRCLE, -- Sludge Belcher
  ["0xF130003E92015A8F"]  = STAR, -- Bile Retcher
})

addToDefaultNpcsToMark("Naxxramas", "construct_scientist_1", {
  ["0xF130003E95269C46"] = SKULL, -- Living Monstrosity
  ["0xF130003E94269C4B"] = MOON, -- Mad Scientist
  ["0xF130003E94269C4C"] = SQUARE, -- Mad Scientist
  ["0xF130003E94269C4D"] = CROSS, -- Mad Scientist
  ["0xF130003E94269C4E"] = DIAMOND, -- Mad Scientist
})

addToDefaultNpcsToMark("Naxxramas", "construct_scientist_2", {
  ["0xF130003E95269C4F"] = SKULL, -- Living Monstrosity
  ["0xF130003E94015AA1"] = MOON, -- Mad Scientist
  ["0xF130003E94015AA0"] = SQUARE, -- Mad Scientist
  ["0xF130003E94015A9F"] = CROSS, -- Mad Scientist
  ["0xF130003E94015A9E"] = DIAMOND, -- Mad Scientist
})

addToDefaultNpcsToMark("Naxxramas", "construct_patchwerk", {
  ["0xF130003E91015A96"]  = SKULL, -- Patchwork Golem
  ["0xF130003E91015A94"]  = CROSS, -- Patchwork Golem
  ["0xF130003E91015A97"]  = SQUARE, -- Patchwork Golem
  ["0xF130003E91015A95"]  = MOON, -- Patchwork Golem
})

addToDefaultNpcsToMark("Naxxramas", "construct_scientist_3", {
  ["0xF130003E95269C54"] = SKULL, -- Living Monstrosity
  ["0xF130003E94269C5C"] = MOON, -- Mad Scientist
  ["0xF130003E94269C5B"] = SQUARE, -- Mad Scientist
  ["0xF130003E94269C59"] = CROSS, -- Mad Scientist
  ["0xF130003E94269C5A"] = DIAMOND, -- Mad Scientist
})

addToDefaultNpcsToMark("Naxxramas", "construct_scientist_4", {
  ["0xF130003E95269C5D"]  = SKULL, -- Living Monstrosity
  ["0xF130003E94269C61"]  = MOON, -- Mad Scientist
  ["0xF130003E94269C60"]  = SQUARE, -- Mad Scientist
  ["0xF130003E94269C5F"]  = CROSS, -- Mad Scientist
  ["0xF130003E94269C5E"]  = DIAMOND, -- Mad Scientist
})

addToDefaultNpcsToMark("Naxxramas", "construct_scientist_5", {
  ["0xF130003E95269C66"] = SKULL, -- Living Monstrosity
  ["0xF130003E94015A85"] = MOON, -- Mad Scientist
  ["0xF130003E94015A86"] = SQUARE, -- Mad Scientist
  ["0xF130003E94015A87"] = CROSS, -- Mad Scientist
  ["0xF130003E94015A88"] = DIAMOND, -- Mad Scientist
})

addToDefaultNpcsToMark("Naxxramas", "construct_grobb_entrance", {
  ["0xF130003E990158F2"]  = SKULL, -- Stitched Spewer
  ["0xF130003E990158F1"]  = CROSS, -- Stitched Spewer
})

addToDefaultNpcsToMark("Naxxramas", "construct_grobb_left", {
  ["0xF130003E990158EC"]  = SKULL, -- Stitched Spewer
  ["0xF130003E990158EB"]  = CROSS, -- Stitched Spewer
})

addToDefaultNpcsToMark("Naxxramas", "construct_grobb_far", {
  ["0xF130003E990158ED"]  = SKULL, -- Stitched Spewer
  ["0xF130003E99049E6B"]  = CROSS, -- Stitched Spewer
  ["0xF130003E990158EE"]  = SQUARE, -- Stitched Spewer
})

----/////////////// MILITARY ///////////////

addToDefaultNpcsToMark("Naxxramas", "military_entrance_middle", {
  ["0xF130003F1101594B"]  = SKULL, -- Deathknight Captain
  ["0xF130003F1101594C"]  = CROSS, -- Deathknight Captain
})

addToDefaultNpcsToMark("Naxxramas", "military_entrance_left", {
  ["0xF130003F1201594A"]  = SKULL, -- Deathknight
  ["0xF130003F1A015950"]  = CROSS, -- Risen Deathknight
  ["0xF130003F1A015951"]  = SQUARE, -- Risen Deathknight
})

addToDefaultNpcsToMark("Naxxramas", "military_entrance_right", {
  ["0xF130003F12015949"]  = SKULL, -- Deathknight
  ["0xF130003F1A015953"]  = CROSS, -- Risen Deathknight
  ["0xF130003F1A015952"]  = SQUARE, -- Risen Deathknight
})

addToDefaultNpcsToMark("Naxxramas", "military_entrance_patrol", {
  ["0xF130003F2401594D"]  = SKULL, -- Shade of Naxxramas
  ["0xF130003F2501594F"]  = CROSS, -- Necro Knight
  ["0xF130003F2501594E"]  = SQUARE, -- Necro Knight
})

addToDefaultNpcsToMark("Naxxramas", "military_static_1", {
  ["0xF130003F12015967"]  = SKULL, -- Deathknight
  ["0xF130003F1C015956"]  = CROSS, -- Dark Touched Warrior
  ["0xF130003F1E015955"]  = SQUARE, -- Death Touched Warrior
  ["0xF130003F11015954"]  = MOON, -- Deathknight Captain
})

addToDefaultNpcsToMark("Naxxramas", "military_forge_captains", {
  ["0xF130003F11015968"]  = SKULL, -- Deathknight Captain
  ["0xF130003F11015969"]  = CROSS, -- Deathknight Captain
})

addToDefaultNpcsToMark("Naxxramas", "military_forge_shade_patrol", {
  ["0xF130003F24015957"]  = STAR, -- Shade of Naxxramas
})

addToDefaultNpcsToMark("Naxxramas", "military_forge_shades", {
  ["0xF130003F24015961"]  = SKULL, -- Shade of Naxxramas
  ["0xF130003F24015960"]  = CROSS, -- Shade of Naxxramas
  ["0xF130003F2501596A"]  = SQUARE, -- Necro Knight
})

addToDefaultNpcsToMark("Naxxramas", "military_forge_constructs", {
  ["0xF130003F27015962"]  = SKULL, -- Bony Construct
  ["0xF130003F27015963"]  = CROSS, -- Bony Construct
  ["0xF130003F27015964"]  = SQUARE, -- Bony Construct
  ["0xF130003F27015965"]  = MOON, -- Bony Construct
  ["0xF130003F27015966"]  = TRIANGLE, -- Bony Construct
})

addToDefaultNpcsToMark("Naxxramas", "military_forge_smiths", {
  ["0xF130003F4101595A"]  = SKULL, -- Skeletal Smith
  ["0xF130003F41015958"]  = CROSS, -- Skeletal Smith
  ["0xF130003F41015959"]  = SQUARE, -- Skeletal Smith
  ["0xF130003F4101595B"]  = MOON, -- Skeletal Smith
})

addToDefaultNpcsToMark("Naxxramas", "military_static_2", {
  ["0xF130003F1201595E"]  = SKULL, -- Deathknight
  ["0xF130003F1201595D"]  = CROSS, -- Deathknight
  ["0xF130003F1101595C"]  = SQUARE, -- Deathknight Captain
  ["0xF130003F1101595F"]  = MOON, -- Deathknight Captain
})

addToDefaultNpcsToMark("Naxxramas", "military_static_3", {
  ["0xF130003F1201596E"]  = SKULL, -- Deathknight
  ["0xF130003F1C01596B"]  = CROSS, -- Dark Touched Warrior
  ["0xF130003F1D01596C"]  = SQUARE, -- Doom Touched Warrior
  ["0xF130003F1101596D"]  = MOON, -- Deathknight Captain
})

addToDefaultNpcsToMark("Naxxramas", "military_upper_patrol", {
  ["0xF130003F12015978"]  = SKULL, -- Deathknight
  ["0xF130003F1E01597A"]  = CROSS, -- Death Touched Warrior
  ["0xF130003F1E015979"]  = SQUARE, -- Death Touched Warrior
})

addToDefaultNpcsToMark("Naxxramas", "military_static_4", {
  ["0xF130003F12015973"]  = SKULL, -- Deathknight
  ["0xF130003F12015972"]  = CROSS, -- Deathknight
  ["0xF130003F1101596F"]  = SQUARE, -- Deathknight Captain
})

addToDefaultNpcsToMark("Naxxramas", "military_static_5", {
  ["0xF130003F12015975"]  = SKULL, -- Deathknight
  ["0xF130003F12015974"]  = CROSS, -- Deathknight
  ["0xF130003F11015970"]  = SQUARE, -- Deathknight Captain
})

addToDefaultNpcsToMark("Naxxramas", "military_static_6", {
  ["0xF130003F12015977"]  = SKULL, -- Deathknight
  ["0xF130003F12015976"]  = CROSS, -- Deathknight
  ["0xF130003F11015971"]  = SQUARE, -- Deathknight Captain
})

addToDefaultNpcsToMark("Naxxramas", "military_static_7", {
  ["0xF130003F1201597C"]  = SKULL, -- Deathknight
  ["0xF130003F1E01597B"]  = CROSS, -- Death Touched Warrior
  ["0xF130003F1D01597E"]  = SQUARE, -- Doom Touched Warrior
  ["0xF130003F1101597D"]  = MOON, -- Deathknight Captain
})

addToDefaultNpcsToMark("Naxxramas", "military_horse_duo", {
  ["0xF130003F23269C6E"]  = SKULL, -- Deathknight Cavalier
  ["0xF130003F23269C6D"]  = CROSS, -- Deathknight Cavalier
})

addToDefaultNpcsToMark("Naxxramas", "military_horse_1", {
  ["0xF130003F2301597F"]  = SKULL, -- Deathknight Cavalier
  ["0xF130003F1E015982"]  = CROSS, -- Death Touched Warrior
  ["0xF130003F1E015981"]  = SQUARE, -- Death Touched Warrior
  ["0xF130003F1E015989"]  = MOON, -- Death Touched Warrior
})

addToDefaultNpcsToMark("Naxxramas", "military_horse_2", {
  ["0xF130003F23015980"]  = SKULL, -- Deathknight Cavalier
  ["0xF130003F1C015983"]  = CROSS, -- Dark Touched Warrior
  ["0xF130003F1C015984"]  = SQUARE, -- Dark Touched Warrior
  ["0xF130003F1D015985"]  = MOON, -- Doom Touched Warrior
})

addToDefaultNpcsToMark("Naxxramas", "military_horse_3", {
  ["0xF130003F23269C6C"]  = SKULL, -- Deathknight Cavalier
  ["0xF130003F1C015988"]  = CROSS, -- Dark Touched Warrior
  ["0xF130003F1A015987"]  = SQUARE, -- Risen Deathknight
  ["0xF130003F1A015986"]  = MOON, -- Risen Deathknight
})

addToDefaultNpcsToMark("Naxxramas", "military_horse_trio", {
  ["0xF1300041DD082208"]  = SKULL, -- Death Lord
  ["0xF130003F23015992"]  = CROSS, -- Deathknight Cavalier
  ["0xF130003F23015991"]  = SQUARE, -- Deathknight Cavalier
})

addToDefaultNpcsToMark("Naxxramas", "military_horse_4", {
  ["0xF130003F23015993"]  = SKULL, -- Deathknight Cavalier
  ["0xF130003F1C01598A"]  = CROSS, -- Dark Touched Warrior
  ["0xF130003F1C01598B"]  = SQUARE, -- Dark Touched Warrior
  ["0xF130003F1D01598C"]  = MOON, -- Doom Touched Warrior
})

addToDefaultNpcsToMark("Naxxramas", "military_razuvious", {
  ["0xF1300041A304A65F"]  = DIAMOND, -- Deathknight Understudy, left far
  ["0xF1300041A304A660"]  = STAR, -- Deathknight Understudy, right far
  ["0xF1300041A304A661"]  = TRIANGLE, -- Deathknight Understudy, left close
  ["0xF1300041A304A662"]  = CIRCLE, -- Deathknight Understudy, right close
  ["0xF130003EBD01598C"]  = SKULL, -- Instructor Razuvious  
})

addToDefaultNpcsToMark("Naxxramas", "military_weps_1", {
  ["0xF130003F4201F334"]  = SKULL, -- Unholy Axe
  ["0xF130003F4201F335"]  = CROSS, -- Unholy Axe
})

addToDefaultNpcsToMark("Naxxramas", "military_weps_2", {
  ["0xF130003F5801F350"]  = SKULL, -- Unholy Swords
  ["0xF130003F4201F336"]  = CROSS, -- Unholy Axe
})

addToDefaultNpcsToMark("Naxxramas", "military_weps_3", {
  ["0xF130003F5801F34F"]  = SKULL, -- Unholy Swords
  ["0xF130003F4201F337"]  = CROSS, -- Unholy Axe
})

addToDefaultNpcsToMark("Naxxramas", "military_weps_4", {
  ["0xF130003F5701F34A"]  = SKULL, -- Unholy Staff
  ["0xF130003F4201F333"]  = CROSS, -- Unholy Axe
})

addToDefaultNpcsToMark("Naxxramas", "military_weps_5", {
  ["0xF130003F5701F34B"]  = SKULL, -- Unholy Staff
  ["0xF130003F57269C68"]  = CROSS, -- Unholy Staff
})

addToDefaultNpcsToMark("Naxxramas", "military_gothik_horses", {
  ["0xF130003F2301599A"]  = SKULL, -- Deathknight Cavalier
  ["0xF130003F23015999"]  = CROSS, -- Deathknight Cavalier
})

addToDefaultNpcsToMark("Naxxramas", "military_gothik_shade", {
  ["0xF130003F24015996"]  = SKULL, -- Shade of Naxxramas
  ["0xF130003F25015998"]  = CROSS, -- Necro Knight
  ["0xF130003F25015997"]  = SQUARE, -- Necro Knight
})

addToDefaultNpcsToMark("Naxxramas", "military_ring_acoltye_1", {
  ["0xF130003FF0015AD9"]  = SKULL, -- Necropolis Acolyte
  ["0xF130003FF0015ADA"]  = CROSS, -- Necropolis Acolyte
})

addToDefaultNpcsToMark("Naxxramas", "military_ring_acoltye_2", {
  ["0xF130003FF0015ADE"]  = SKULL, -- Necropolis Acolyte
  ["0xF130003FF0015ADF"]  = CROSS, -- Necropolis Acolyte
})

addToDefaultNpcsToMark("Naxxramas", "military_ring_acoltye_3", {
  ["0xF130003FF0015AE0"]  = SKULL, -- Necropolis Acolyte
  ["0xF130003FF0015AE1"]  = CROSS, -- Necropolis Acolyte
})

addToDefaultNpcsToMark("Naxxramas", "military_ring_four_horsemen", {
  ["0xF130003EBE015AB3"]  = SKULL, -- Highlord Mograine
  ["0xF130003EC0015AB0"]  = CROSS, -- Thane Korth'azz
  ["0xF130003EBF015AB2"]  = SQUARE, -- Sir Zeliak
  ["0xF130003EC1015AB1"]  = MOON, -- Lady Blaumeux
})

--/////////////// AQ40 ///////////////

defaultNpcsToMark["Ahn'Qiraj"] = {}

addToDefaultNpcsToMark("Ahn'Qiraj", "entrance_1", {
  ["0xF130003BA0015613"]  = SKULL, -- Anubisath Sentinel
  ["0xF130003BA0015610"]  = MOON, -- Anubisath Sentinel
  ["0xF130003BA0015611"]  = SQUARE, -- Anubisath Sentinel
  ["0xF130003BA0015612"]  = CROSS, -- Anubisath Sentinel
})

addToDefaultNpcsToMark("Ahn'Qiraj", "entrance_2", {
  ["0xF130003BA001560C"]  = SKULL, -- Anubisath Sentinel
  ["0xF130003BA001560D"]  = CROSS, -- Anubisath Sentinel
  ["0xF130003BA001560F"]  = MOON, -- Anubisath Sentinel
  ["0xF130003BA001560E"]  = SQUARE, -- Anubisath Sentinel
})
addToDefaultNpcsToMark("Ahn'Qiraj", "entrance_patrols", {
  ["0xF130003B9E130799"] = STAR, -- Obsidian Eradicator
  ["0xF130003B9E01580A"] = TRIANGLE, -- Obsidian Eradicator
  ["0xF130003B9E13079A"] = DIAMOND, -- Obsidian Eradicator
})

addToDefaultNpcsToMark("Ahn'Qiraj", "skeram", {
  ["0xF130003B9F01580B"]  = SQUARE, -- Skeram
  ["0xF130003B9F04A65A"]  = CROSS, -- Clone
  ["0xF130003B9F04A659"]  = SKULL, -- Clone
})

addToDefaultNpcsToMark("Ahn'Qiraj", "brainwasher_1", {
  ["0xF130003B8F01562D"] = SKULL, -- Qiraji Brainwasher
  ["0xF130003B8101562C"] = SQUARE, -- Vekniss Guardian
  ["0xF130003B8101562B"] = CROSS, -- Vekniss Guardian
})

addToDefaultNpcsToMark("Ahn'Qiraj", "warrior_1", {
  ["0xF130003B7E01567A"] = TRIANGLE, -- Vekniss Warrior
  ["0xF130003B7E015679"] = UNMARKED, -- Vekniss Warrior
  ["0xF130003B7E015678"] = UNMARKED -- Vekniss Warrior
})

addToDefaultNpcsToMark("Ahn'Qiraj", "brainwasher_2", {
  ["0xF130003B81015630"]  = MOON, -- Vekniss Guardian
  ["0xF130003B8101562F"]  = SQUARE, -- Vekniss Guardian
  ["0xF130003B81015677"]  = CROSS, -- Vekniss Guardian
  ["0xF130003B8F01562E"]  = SKULL, -- Qiraji Brainwasher
})

addToDefaultNpcsToMark("Ahn'Qiraj", "brainwasher_left", {
  ["0xF130003B8101563A"]  = SQUARE, -- Vekniss Guardian
  ["0xF130003B8F015636"]  = CROSS, -- Qiraji Brainwasher
  ["0xF130003B81015639"]  = MOON, -- Vekniss Guardian
  ["0xF130003B81015638"]  = TRIANGLE, -- Vekniss Guardian
  ["0xF130003B8F015637"]  = SKULL, -- Qiraji Brainwasher
})

addToDefaultNpcsToMark("Ahn'Qiraj", "brainwasher_right", {
  ["0xF130003B8101563C"]  = MOON, -- Vekniss Guardian
  ["0xF130003B8F015634"]  = SKULL, -- Qiraji Brainwasher
  ["0xF130003B8101563D"]  = TRIANGLE, -- Vekniss Guardian
  ["0xF130003B8101563B"]  = SQUARE, -- Vekniss Guardian
  ["0xF130003B8F015635"]  = CROSS, -- Qiraji Brainwasher
})

addToDefaultNpcsToMark("Ahn'Qiraj", "warrior_2", {
  ["0xF130003B7E049CA2"]  = STAR, -- Vekniss Warrior
  ["0xF130003B7E049CA4"]  = UNMARKED, -- Vekniss Warrior
  ["0xF130003B7E049CA3"]  = UNMARKED, -- Vekniss Warrior
})

addToDefaultNpcsToMark("Ahn'Qiraj", "guardian_1", {
  ["0xF130003B81015644"]  = SQUARE, -- Vekniss Guardian
  ["0xF130003B81015645"]  = DIAMOND, -- Vekniss Guardian
  ["0xF130003B81049CA1"]  = CROSS, -- Vekniss Guardian
  ["0xF130003B81015642"]  = SKULL, -- Vekniss Guardian
  ["0xF130003B81015643"]  = MOON, -- Vekniss Guardian
  ["0xF130003B81015641"]  = TRIANGLE, -- Vekniss Guardian
})

addToDefaultNpcsToMark("Ahn'Qiraj", "guardian_2", {
  ["0xF130003B81015648"]  = CROSS, -- Vekniss Guardian
  ["0xF130003B81015649"]  = TRIANGLE, -- Vekniss Guardian
  ["0xF130003B81015647"]  = SQUARE, -- Vekniss Guardian
  ["0xF130003B8101564A"]  = MOON, -- Vekniss Guardian
  ["0xF130003B81015646"]  = DIAMOND, -- Vekniss Guardian
  ["0xF130003B8101564B"]  = SKULL, -- Vekniss Guardian
})

addToDefaultNpcsToMark("Ahn'Qiraj", "guardian_3", {
  ["0xF130003B8101564E"]  = SQUARE, -- Vekniss Guardian
  ["0xF130003B8101564F"]  = SKULL, -- Vekniss Guardian
  ["0xF130003B8101564C"]  = CROSS, -- Vekniss Guardian
  ["0xF130003B81015650"]  = DIAMOND, -- Vekniss Guardian
  ["0xF130003B8101564D"]  = TRIANGLE, -- Vekniss Guardian
  ["0xF130003B81015651"]  = MOON, -- Vekniss Guardian
})

addToDefaultNpcsToMark("Ahn'Qiraj", "guardian_4", {
  ["0xF130003B8101565B"]  = TRIANGLE, -- Vekniss Guardian
  ["0xF130003B81015657"]  = CROSS, -- Vekniss Guardian
  ["0xF130003B8101565A"]  = DIAMOND, -- Vekniss Guardian
  ["0xF130003B81015658"]  = SQUARE, -- Vekniss Guardian
  ["0xF130003B8101565C"]  = MOON, -- Vekniss Guardian
  ["0xF130003B81015659"]  = SKULL, -- Vekniss Guardian
})

addToDefaultNpcsToMark("Ahn'Qiraj", "sartura", {
  ["0xF130003E70015662"]  = CROSS, -- Sartura's Royal Guard
  ["0xF130003E70015661"]  = SQUARE, -- Sartura's Royal Guard
  ["0xF130003E70015663"]  = MOON, -- Sartura's Royal Guard
  ["0xF130003C9C015660"]  = SKULL, -- Battleguard Sartura
})

addToDefaultNpcsToMark("Ahn'Qiraj", "soldiers", {
  ["0xF130003B7D015762"]  = SKULL, -- Vekniss Soldier
  ["0xF130003B7D01575D"]  = TRIANGLE, -- Vekniss Soldier
  ["0xF130003B7D01575F"]  = SQUARE, -- Vekniss Soldier
  ["0xF130003B7D015760"]  = CROSS, -- Vekniss Soldier
  ["0xF130003B7D01575E"]  = MOON, -- Vekniss Soldier
})

-- needs re-testing
addToDefaultNpcsToMark("Ahn'Qiraj", "scorpions", {
  ["0xF130003B88015798"]  = SKULL, -- Vekniss Hive Crawler
  ["0xF130003B88015799"]  = CROSS, -- Vekniss Hive Crawler
  ["0xF130003B88049CA5"]  = MOON, -- Vekniss Hive Crawler
  ["0xF130003B88049CA6"]  = SQUARE, -- Vekniss Hive Crawler
  ["0xF130003B8801578F"]  = DIAMOND, -- Vekniss Hive Crawler
  ["0xF130003B8801578E"]  = CIRCLE, -- Vekniss Hive Crawler
})

addToDefaultNpcsToMark("Ahn'Qiraj", "lashers", {
  ["0xF130003B830157CD"]  = CIRCLE, -- Vekniss Stinger
  ["0xF130003B910157BF"]  = MOON, -- Qiraji Lasher
  ["0xF130003B910157C3"]  = CROSS, -- Qiraji Lasher
  ["0xF130003B910157C0"]  = UNMARKED, -- Vekniss Wasp
  ["0xF130003B910157C1"]  = UNMARKED, -- Vekniss Wasp
  ["0xF130003B910157C2"]  = SQUARE, -- Qiraji Lasher
  ["0xF130003B910157C8"]  = SKULL, -- Qiraji Lasher
  ["0xF130003B910157BC"]  = TRIANGLE, -- Qiraji Lasher
  ["0xF130003B830157B6"]  = DIAMOND, -- Vekniss Stinger
})

addToDefaultNpcsToMark("Ahn'Qiraj", "defenders", {
  ["0xF130003BAD0157CF"] = SKULL, -- Anubisath Defender
  ["0xF130003BAD0157D1"] = CROSS, -- Anubisath Defender
  ["0xF130003BAD0157D2"] = SQUARE, -- Anubisath Defender
  ["0xF130003BAD0157D0"] = MOON, -- Anubisath Defender
  ["0xF130003BAD0157D3"] = TRIANGLE -- Anubisath Defender
})

addToDefaultNpcsToMark("Ahn'Qiraj", "champions", {
  ["0xF130003B940157E7"] = SQUARE, -- Qiraji Champion
  ["0xF130003B940157E5"] = DIAMOND, -- Qiraji Champion
  ["0xF130003B940157E6"] = CIRCLE, -- Qiraji Champion
  ["0xF130003B940157F9"] = CROSS, -- Qiraji Champion
  ["0xF130003B940157E4"] = MOON, -- Qiraji Champion
  ["0xF130003B940157FA"] = TRIANGLE, -- Qiraji Champion
  ["0xF130003B940157E3"] = SKULL, -- Qiraji Champion
  ["0xF130003B940157DE"] = STAR, -- Qiraji Champion
})

--/////////////// ZG ///////////////

defaultNpcsToMark["Zul'Gurub"] = {}

--/////////////// Entrance to Jindo ///////////////

addToDefaultNpcsToMark("Zul'Gurub", "entrance_snakes_left_1", {
  ["0xF130002C6C00BFC2"] = SKULL,
  ["0xF130002C6B00BFC3"] = CROSS,
})
addToDefaultNpcsToMark("Zul'Gurub", "entrance_priest_left", {
  ["0xF130002E3600BFDB"] = SKULL,
  ["0xF130002C5600BFDA"] = MOON,
})

addToDefaultNpcsToMark("Zul'Gurub", "jindo_entrance_patrols", {
  ["0xF1300039E911E65A"] = UNMARKED,
  ["0xF130002E36016542"] = DIAMOND,
  ["0xF1300039E911E65D"] = STAR,
  ["0xF130002C5800CAEC"] = SKULL,
  ["0xF1300039E911E65C"] = UNMARKED,
  ["0xF1300039E911E65B"] = UNMARKED,
  ["0xF130002C57016541"] = TRIANGLE,
})

addToDefaultNpcsToMark("Zul'Gurub", "jindo_misress_1_patrol", {
  ["0xF1300039E911E657"] = STAR,
  ["0xF1300039E900C0F6"] = UNMARKED,
  ["0xF1300039E900C0F5"] = UNMARKED,
  ["0xF1300039E911E658"] = UNMARKED,
  ["0xF1300039E911E659"] = UNMARKED,
  ["0xF130003A2200C0F7"] = UNMARKED,
  ["0xF1300039E911E656"] = UNMARKED,
  ["0xF130003A2200C0F8"] = UNMARKED,
})

addToDefaultNpcsToMark("Zul'Gurub", "jindo_mistress_2", {
  ["0xF130003A2300C0DB"] = MOON,
  ["0xF1300039E900C0D5"] = UNMARKED,
  ["0xF1300039E900C0D6"] = UNMARKED,
  ["0xF130003A2300C0DA"] = SKULL,
  ["0xF130003A2200C0D8"] = UNMARKED,
  ["0xF130003A2200C0D9"] = UNMARKED,
  ["0xF130003A2300C0DC"] = SQUARE,
  ["0xF1300039E900C0D3"] = UNMARKED,
  ["0xF130003A2200C0D7"] = UNMARKED,
})

addToDefaultNpcsToMark("Zul'Gurub", "jindo_boss_pack", {
  ["0xF1300039E900C1A5"] = UNMARKED,
  ["0xF1300039E900C0FA"] = UNMARKED,
  ["0xF130003A2200C1A7"] = UNMARKED,
  ["0xF130002C7400C1F7"] = SKULL,
  ["0xF1300039E900C0FB"] = UNMARKED,
  ["0xF130003A2200C1A8"] = UNMARKED,
  ["0xF130003A2200C1A9"] = CIRCLE,
  ["0xF1300039E900C10D"] = UNMARKED,
  ["0xF130003A2300C1F2"] = SQUARE,
  ["0xF130003A2200C1A6"] = UNMARKED,
  ["0xF130003A2300C1C9"] = MOON,
})

--/////////////// Marli(Bat) ///////////////

addToDefaultNpcsToMark("Zul'Gurub", "hill_bottom_priest", {
  ["0xF130002C6B00BFC9"] = UNMARKED,
  ["0xF130002C6C00BFC8"] = UNMARKED,
  ["0xF130002E3600C25A"] = SKULL,
  ["0xF130002C5800C261"] = STAR,
  ["0xF130002C5600C259"] = CROSS,
})

bat1= {}
bat1["bat_one_rider_1"] = {
  ["0xF13000399E00BFFB"] = STAR,
  ["0xF130002C6800BFF7"] = UNMARKED,
  ["0xF130002C6800BFF9"] = UNMARKED,
  ["0xF130002C6800BFF8"] = UNMARKED,
  ["0xF130002C6800BFFA"] = UNMARKED,
}
bat1["bat_one_rider_2"] = {
  ["0xF130002C6800C024"] = UNMARKED,
  ["0xF130002C6800C023"] = UNMARKED,
  ["0xF130002C6800BFFF"] = UNMARKED,
  ["0xF130002C6800C001"] = UNMARKED,
  ["0xF13000399E00C025"] = TRIANGLE,
}
bat1["bat_two_rider_1"] = {
  ["0xF130002C6800C004"] = UNMARKED,
  ["0xF130002C6800C009"] = UNMARKED,
  ["0xF13000399E00C003"] = CIRCLE, -- rider
  ["0xF130002C6800C007"] = UNMARKED,
  ["0xF130002C6800BFFE"] = UNMARKED,
  ["0xF13000399E00C002"] = DIAMOND, -- rider
}
bat1["bat_headhunter_1"] = {
  ["0xF130002E3700BFF0"] = SKULL, -- witchdoctor
  ["0xF130002C5700BFEE"] = CROSS,
  ["0xF130002C5700BFEF"] = UNMARKED,
}

local cbat = {}
for _,pack in pairs(bat1) do
  for guid,mark in pairs(pack) do
    cbat[guid] = mark
  end
end
addToDefaultNpcsToMark("Zul'Gurub", "consolidated_bat_1", cbat)

bat2 = {}
bat2["bat_two_rider_rtv"] = {
  ["0xF130002C6800BFF2"] = UNMARKED,
  ["0xF130002C6800BFF3"] = UNMARKED,
  ["0xF13000399E00BFF5"] = MOON,
  ["0xF13000399E00BFF6"] = SQUARE,
  ["0xF130002C6800BFF1"] = UNMARKED,
}
bat2["bat_two_rider_2"] = {
  ["0xF130002C6800BFE8"] = UNMARKED,
  ["0xF130002C6800BFE7"] = UNMARKED,
  ["0xF130002C6800BFE3"] = UNMARKED,
  ["0xF130002C6800BFE5"] = UNMARKED,
  ["0xF130002C6800BFE4"] = UNMARKED,
  ["0xF13000399E00BFEA"] = CIRCLE,
  ["0xF13000399E00BFE9"] = DIAMOND,
}
bat2["bat_two_rider_3"] = {
  ["0xF130002C6800BFF4"] = UNMARKED,
  ["0xF130002C6800C022"] = UNMARKED,
  ["0xF13000399E00C021"] = STAR,
  ["0xF130002C6800C006"] = UNMARKED,
  ["0xF13000399E00C00F"] = TRIANGLE,
  ["0xF130002C6800C005"] = UNMARKED,
}
bat2["bat_headhunter_2"] = {
  ["0xF130002C5700BFED"] = UNMARKED,
  ["0xF130002E3700BFEB"] = CROSS, -- witchdoctor
  ["0xF130002E3700BFEC"] = SKULL, -- witchdoctor
}

local cbat = {}
for _,pack in pairs(bat2) do
  for guid,mark in pairs(pack) do
    cbat[guid] = mark
  end
end
addToDefaultNpcsToMark("Zul'Gurub", "consolidated_bat_2", cbat)


--/////////////// Venoxis ///////////////

addToDefaultNpcsToMark("Zul'Gurub", "venoxis_two_axethrower", {
  ["0xF130002C5600BFD1"] = MOON,
  ["0xF130002C5600BFD0"] = SKULL,
})

addToDefaultNpcsToMark("Zul'Gurub", "venoxis_priest_pat", {
  ["0xF130002C6C00C8FB"] = UNMARKED,
  ["0xF130002E3600C258"] = SKULL, -- priest
  ["0xF130002C6B00C8FC"] = UNMARKED,
  ["0xF130002C5600C257"] = MOON, -- axethrower
})

addToDefaultNpcsToMark("Zul'Gurub", "venoxis_room", {
  ["0xF130002C5600C248"] = MOON,
  ["0xF130002C6C00BFCB"] = UNMARKED,
  ["0xF130002C6C00BFD3"] = UNMARKED,
  ["0xF130002E3600C249"] = SKULL,
  ["0xF130002C6C00BFCC"] = UNMARKED,
  ["0xF130002C6B00BFD7"] = UNMARKED,
  ["0xF130002C6B00BFD9"] = UNMARKED,
  ["0xF130002C6C00BFD2"] = UNMARKED,
  ["0xF130002C6C00BFD6"] = UNMARKED,
  ["0xF130002C6B00BFCD"] = UNMARKED,
  ["0xF130002C7B00C24A"] = UNMARKED,
  ["0xF130002C6B00BFD8"] = UNMARKED,
  ["0xF130002C6C00BFCA"] = UNMARKED,
})

addToDefaultNpcsToMark("Zul'Gurub", "venoxis_exit_snake_1", {
  ["0xF130002C6B00C250"] = UNMARKED,
  ["0xF130002C6B00C251"] = UNMARKED,
  ["0xF130002C6C00C252"] = SKULL,
  ["0xF130002C6B00C24F"] = UNMARKED,
})

addToDefaultNpcsToMark("Zul'Gurub", "venoxis_exit_snake_2", {
  ["0xF130002C6C00BFC7"] = SKULL, -- adder
  ["0xF130002C6B00BFC6"] = UNMARKED,
  ["0xF130002C6B00BFC5"] = UNMARKED,
  ["0xF130002C6B00BFC4"] = UNMARKED,
})

--/////////////// Mandokir //////////////

addToDefaultNpcsToMark("Zul'Gurub", "zanza_tower_zerks", {
  ["0xF130002C5800CAFA"] = TRIANGLE,
  ["0xF130002C5800CAEB"] = DIAMOND,
  ["0xF130002C58016565"] = CIRCLE,
  ["0xF130002C5800C222"] = STAR,
})

addToDefaultNpcsToMark("Zul'Gurub", "mandokir_entrance_and_zerk", {
  ["0xF130002E3600C278"] = SKULL,
  ["0xF130002C5900C280"] = UNMARKED,
  ["0xF130002C5900C27F"] = SQUARE,
  ["0xF130002C5900C271"] = UNMARKED,
  ["0xF130002E3600C279"] = CROSS,
  ["0xF130002C5900C270"] = MOON,
  ["0xF130002C5800C229"] = STAR,
})

addToDefaultNpcsToMark("Zul'Gurub", "mandokir_room", {
  ["0xF130002C5C00C283"] = UNMARKED,
  ["0xF130002C5C00C282"] = STAR,
  ["0xF130002C5C00C281"] = UNMARKED,
  ["0xF130002E3600C287"] = SKULL,
  ["0xF130002C5C00CB5B"] = UNMARKED,
  ["0xF130002C5900C285"] = MOON,
  ["0xF130002C5C00C284"] = UNMARKED,
  ["0xF130002C5C00CB88"] = UNMARKED,
})

addToDefaultNpcsToMark("Zul'Gurub", "zanaz_witchdoctor_rtv", {
  ["0xF130002C6100CAF2"] = UNMARKED,
  ["0xF130002E37016557"] = SKULL,
  ["0xF130002C6100CAF1"] = UNMARKED,
  ["0xF130002C56016556"] = MOON,
})

--/////////////// Madness /////////////

addToDefaultNpcsToMark("Zul'Gurub", "madness1", {
  ["0xF130003B0700BFA4"] = 3,
  ["0xF130003B0700BFA3"] = 8,
  ["0xF130003B0700BFA5"] = 7,
  ["0xF130000B6200BF8D"] = 0,
  ["0xF130003B0700BFA0"] = 2,
})

addToDefaultNpcsToMark("Zul'Gurub", "madness2", {
  ["0xF130003B0700BF9F"] = 3,
  ["0xF130003B0700BFA1"] = 7,
  ["0xF130003B0700BF9D"] = 8,
  ["0xF130003B0700BF9E"] = 4,
})

addToDefaultNpcsToMark("Zul'Gurub", "madness3", {
  ["0xF130003B0700BFAA"] = 7,
  ["0xF130003B0700BFA9"] = 3,
  ["0xF130003B0700BFAB"] = 4,
  ["0xF130002C4C00BF9B"] = 8,
})

addToDefaultNpcsToMark("Zul'Gurub", "madness4", {
  ["0xF130002C4C00BF9C"] = 8,
  ["0xF130003B0700BFA8"] = 3,
  ["0xF130003B0700BFA6"] = 4,
  ["0xF130003B0700BFA7"] = 7,
})

--/////////////// Thekal //////////////

addToDefaultNpcsToMark("Zul'Gurub", "thekal_pack", {
  ["0xF13000390700C09E"] = DIAMOND,
  ["0xF130002C5300C0A2"] = SQUARE,
  ["0xF130002C5400C0A1"] = TRIANGLE,
})

addToDefaultNpcsToMark("Zul'Gurub", "gaz_fish", {
  ["0xF130002C6E00C242"] = TRIANGLE,
  ["0xF130002C6E00BFAD"] = CIRCLE,
  ["0xF130002C6E00C8F4"] = DIAMOND,
  ["0xF130002C6E00C23E"] = STAR,
  ["0xF130002C6E00BFAF"] = CROSS,
})

addToDefaultNpcsToMark("Zul'Gurub", "thekal_zerk_panther", {
  ["0xF130002C5801652B"] = STAR,
  ["0xF130002C6500C0A6"] = UNMARKED,
  ["0xF130002C6500C0A7"] = UNMARKED,
  ["0xF130002C6500C0A8"] = CIRCLE,
})

--/////////////// Arlok ///////////////

addToDefaultNpcsToMark("Zul'Gurub", "arlok_1", {
  ["0xF130002C4B00C899"] = UNMARKED,
  ["0xF130002C4B00C8A4"] = SKULL,
  ["0xF130002C4B00C89A"] = CROSS, 
  ["0xF130002C4B00C8A3"] = UNMARKED,
})

addToDefaultNpcsToMark("Zul'Gurub", "arlok_2", {
  ["0xF130002C6500C0C2"] = UNMARKED,
  ["0xF130002C6500C0C1"] = UNMARKED,
  ["0xF130002C5900C98B"] = MOON,
  ["0xF130002C5900C98A"] = SQUARE,
  ["0xF130002C6500C0C0"] = UNMARKED,
  ["0xF130002C6500C0BF"] = SKULL,
})

addToDefaultNpcsToMark("Zul'Gurub", "arlok_3", {
  ["0xF130002C6500C0BD"] = UNMARKED, -- panther
  ["0xF130002C6500C0BE"] = SKULL, -- panther
  ["0xF130002C4B00C0B1"] = TRIANGLE, -- shadow hunter
  ["0xF130002C6500C0BB"] = UNMARKED, -- panther
  ["0xF130002C6500C0BC"] = UNMARKED, -- panther
})

addToDefaultNpcsToMark("Zul'Gurub", "arlok_4", {
  ["0xF130002C6500C8B7"] = UNMARKED,
  ["0xF130002C6500C8B5"] = SKULL,
  ["0xF130002C6500C8AF"] = UNMARKED,
  ["0xF130002C4B00C8A5"] = DIAMOND, -- shadow hunter
  ["0xF130002C6500C8B6"] = UNMARKED,
  ["0xF130002C4B00C8A6"] = TRIANGLE, -- shadow hunter
})

addToDefaultNpcsToMark("Zul'Gurub", "arlokk", {
  ["0xF1300038B3276EF0"] = CIRCLE,
})

--/////////////// Hakkar ///////////////

addToDefaultNpcsToMark("Zul'Gurub", "hakkar_bottom", {
  ["0xF130003AC300C231"] = CROSS, -- left zerk
  ["0xF130002C5800C8C3"] = STAR, -- crocs
  ["0xF130002C5800C8C4"] = SKULL, -- right zerk
})

addToDefaultNpcsToMark("Zul'Gurub", "hakkar_sons", {
  ["0xF130002C5D00BF8A"] = DIAMOND,
  ["0xF130002C5D00BF89"] = CIRCLE,
})

addToDefaultNpcsToMark("Zul'Gurub", "hakkar_soulflayer_1", {
  ["0xF130002C5F00C8E0"] = MOON, -- son
  ["0xF130002C5D00C8E2"] = SKULL, -- flayer
  ["0xF130002C5D00C8E1"] = CROSS, -- son
})

addToDefaultNpcsToMark("Zul'Gurub", "hakkar_soulflayer_2", {
  ["0xF130002C5D00C8E4"] = CROSS, -- son
  ["0xF130002C5D00C8E5"] = SKULL, -- flayer
  ["0xF130002C5F00C8E3"] = MOON, -- son
})

addToDefaultNpcsToMark("Zul'Gurub", "hakkar_large_1", {
  ["0xF130002C5F00C8D7"] = MOON, -- soulflayer
  ["0xF130002C5800C204"] = UNMARKED,
  ["0xF130002E3600C8D6"] = SKULL, -- priest
  ["0xF130002C5C00C8D8"] = UNMARKED,
  ["0xF130002E3600C8D9"] = CROSS, -- priest
  ["0xF130002C5F11E679"] = SQUARE, -- soulflayer
})

addToDefaultNpcsToMark("Zul'Gurub", "hakkar_large_2", {
  ["0xF130002C5F11F381"] = SQUARE, -- soulflayer
  ["0xF130002E3611F383"] = SKULL, -- priest
  ["0xF130002E3611F384"] = CROSS, -- priest
  ["0xF130002C5F11F380"] = MOON, -- soulflayer
  ["0xF130002C4C11F37E"] = UNMARKED,
  ["0xF130002C5C11F382"] = UNMARKED,
})

--/////////////// ES ///////////////

local errenius = "0xF13000ED4B2739FA"
local errenius_mark = DIAMOND

addToDefaultNpcsToMark("Emerald Sanctum", "entrance", {
  ["0xF13000ED482739F2"] = SQUARE, -- sancutum wyrm pat
  ["0xF13000ED4A273A45"] = MOON, -- sancutum scalebane pat
  ["0xF13000ED4A273A43"] = TRIANGLE, -- sancutum scalebane pat

  -- dreamer_pack_left_1
  ["0xF13000ED462739E2"] = UNMARKED, -- sanctum dreamer, left
  ["0xF13000ED462739E3"] = UNMARKED, -- sanctum dreamer, left
  ["0xF13000ED462739E4"] = UNMARKED, -- sanctum dreamer, left
  ["0xF13000ED462739E5"] = UNMARKED, -- sanctum dreamer, left
  ["0xF13000ED462739E6"] = UNMARKED, -- sanctum dreamer, left
  ["0xF13000ED462739E7"] = UNMARKED, -- sanctum dreamer, left
  ["0xF13000ED462739E8"] = UNMARKED, -- sanctum dreamer, left
  ["0xF13000ED462739E9"] = UNMARKED, -- sanctum dreamer, left
  ["0xF13000ED462739EB"] = UNMARKED, -- sanctum dreamer, left

  -- wyrmkin_pack_right_1
  ["0xF13000ED462739F1"] = UNMARKED, -- sanctum dreamer, right
  ["0xF13000ED462739F0"] = UNMARKED, -- sanctum dreamer, right
  ["0xF13000ED462739EF"] = UNMARKED, -- sanctum dreamer, right
  ["0xF13000ED462739EE"] = UNMARKED, -- sanctum dreamer, right
  ["0xF13000ED472739ED"] = SKULL, -- sanctum dragonkin, right
  ["0xF13000ED472739EA"] = CROSS, -- sanctum dragonkin, right
})

addToDefaultNpcsToMark("Emerald Sanctum", "wyrmkin_pack_right_2", {
  ["0xF13000ED492739F3"] = SKULL, -- sanctum wyrmkin
  ["0xF13000ED492739F4"] = CROSS, -- sanctum wyrmkin
  ["0xF13000ED472739F5"] = SQUARE, -- sanctum dragonkin
  ["0xF13000ED462739F6"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED462739F7"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED462739F8"] = UNMARKED, -- sanctum dreamer
})

addToDefaultNpcsToMark("Emerald Sanctum", "dreamer_pack_left_2", {
  ["0xF13000ED49273A17"] = SKULL, -- sanctum wyrmkin
  ["0xF13000ED46273A16"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED46273A15"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED46273A14"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED46273A12"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED46273A10"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED46273A0F"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED46273A0D"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED46273A0C"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED46273A0B"] = UNMARKED, -- sanctum dreamer

  [errenius] = errenius_mark, -- increase chance of spotting him early
})

addToDefaultNpcsToMark("Emerald Sanctum", "wyrmkin_pack_left_1", {
  ["0xF13000ED47273A1C"] = SQUARE, -- sanctum dragonkin
  ["0xF13000ED4A273A1A"] = MOON, -- sanctum scalebane
  ["0xF13000ED49273A18"] = CROSS, -- sanctum wyrmkin
  ["0xF13000EF1C275495"] = SKULL, -- sanctum supressor
  ["0xF13000ED47273A1E"] = STAR, -- sanctum dragonkin

  [errenius] = errenius_mark, -- increase chance of spotting him early
})

addToDefaultNpcsToMark("Emerald Sanctum", "wyrmkin_pack_left_2", {
  ["0xF13000ED46273A26"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED46273A1F"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED49273A25"] = SKULL, -- sanctum wyrmkin
  ["0xF13000ED49273A24"] = STAR, -- sanctum wyrmkin
  ["0xF13000ED46273A20"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED46273A27"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED48273A19"] = CROS, -- sanctum wrym

  [errenius] = errenius_mark, -- increase chance of spotting him early
})

addToDefaultNpcsToMark("Emerald Sanctum", "dreamer_pack_right_1", {
  ["0xF13000ED462754A3"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED462754A4"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED462754A5"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED462754A6"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED462754A7"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED462754A8"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED462754A9"] = UNMARKED, -- sanctum dreamer

  [errenius] = errenius_mark, -- increase chance of spotting him early
})

addToDefaultNpcsToMark("Emerald Sanctum", "wyrmkin_pack_left_3", {
  ["0xF13000ED46273A4B"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED46273A4C"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED46273A54"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED46273A56"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED46273A57"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED46273A58"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED46273A59"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED4A273A48"] = CROSS, -- sanctum scalebane
  ["0xF13000ED4A273A49"] = SKULL, -- sanctum scalebane
  ["0xF13000ED49273A47"] = STAR, -- sanctum wyrmkin -- ?? 
  ["0xF13000ED47273A1C"] = SQUARE, -- sanctum dragonkin

  [errenius] = errenius_mark, -- increase chance of spotting him early
})

addToDefaultNpcsToMark("Emerald Sanctum", "dreamer_pack_end", {
  ["0xF13000ED47273A46"] = CROSS, -- sanctum dragonkin
  ["0xF13000ED46273A28"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED46273A29"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED46273A2A"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED46273A2B"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED46273A2C"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED46273A2D"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED46273A2E"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED46273A2F"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED46273A31"] = UNMARKED, -- sanctum dreamer
  ["0xF13000EF1C275497"] = SKULL, -- sanctum supressor

  [errenius] = errenius_mark, -- increase chance of spotting him early
})

addToDefaultNpcsToMark("Emerald Sanctum", "wyrmkin_pack_right_3", {
  ["0xF13000ED462754A2"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED4627549E"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED462754A0"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED462754A1"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED462754A2"] = UNMARKED, -- sanctum dreamer
  ["0xF13000EF1C275499"] = SKULL, -- sanctum supressor
  ["0xF13000ED4727549C"] = STAR, -- sanctum dragonkin
  ["0xF13000ED4A27549D"] = CROSS, -- sanctum scalebane
  ["0xF13000ED4A27549B"] = SQUARE, -- sanctum scalebane
})
-- scalebane --string.find(guid,"0xF13000ED4A27....")
-- dragonkin --string.find(guid,"0xF13000ED4727....")
-- supressor --string.find(guid,"0xF13000EF1C27....")
-- dreamer --string.find(guid,"0xF13000EF1C27....")
addToDefaultNpcsToMark("Emerald Sanctum", "solnius", {
  ["0xF13000ED4C2739E1"] = UNMARKED, -- solnius
  ["0xF13000ED47276EC3"] = CROSS, -- sanctum dragonkin
  ["0xF13000ED47276EC7"] = SQUARE, -- sanctum dragonkin
  ["0xF13000ED46276EC4"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED46276EC6"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED46276EC8"] = UNMARKED, -- sanctum dreamer
  ["0xF13000EF1C276EC5"] = SKULL, -- sanctum supressor
})

--/////////////// MC ///////////////

addToDefaultNpcsToMark("Molten Core", "pats1", {
  ["0xF130002D9900DE21"] = MOON,
  ["0xF130002F4500DE0C"] = TRIANGLE,
  ["0xF130002F4500DE07"] = CIRCLE,
  ["0xF130002D9900DE15"] = STAR,
  ["0xF130002D9900DE13"] = CROSS,
  ["0xF130002D9900DE14"] = SQUARE,
  ["0xF130002D9900DE16"] = DIAMOND,
})

addToDefaultNpcsToMark("Molten Core", "lucifron", {
  ["0xF130002F5700DD1F"] = CROSS,
  ["0xF130002F5600DD1D"] = SKULL,
  ["0xF130002F5700DD1E"] = SQUARE,
})

addToDefaultNpcsToMark("Molten Core", "imp_surgers", {
  ["0xF130002F4500DE0A"] = DIAMOND,
  ["0xF130002F4500DE0B"] = TRIANGLE,
  ["0xF130002F4500DE08"] = SKULL,
  ["0xF130002F4500DE09"] = CROSS,
})

addToDefaultNpcsToMark("Molten Core", "gehennas", {
  ["0xF130002D8D00DDA2"] = CROSS,
  ["0xF130002D8D00DDA3"] = SQUARE,
  ["0xF130002FE300DDA1"] = SKULL,
})

addToDefaultNpcsToMark("Molten Core", "pats2", {
  ["0xF130002D9900DE1E"] = CIRCLE,
  ["0xF130002D9900DE1A"] = TRIANGLE,
  ["0xF130002D9900DE20"] = DIAMOND,
  ["0xF130002D9900DE17"] = CROSS,
  ["0xF130002F4500DE11"] = STAR,
  ["0xF130002D9900DE19"] = SKULL,
  ["0xF130002F4500DE10"] = MOON,
  ["0xF130002D9900DE18"] = SQUARE,
})

addToDefaultNpcsToMark("Molten Core", "garr", {
	["0xF130002F4300DD28"] = STAR,
	["0xF130002F4300DD2E"] = CIRCLE,
	["0xF130002F4300DD2C"] = SQUARE,
	["0xF130002F4300DD34"] = DIAMOND,
	["0xF130002F4300DD2B"] = SKULL,
	["0xF130002F4300DD32"] = CROSS,
	["0xF130002F4300DD33"] = MOON,
	["0xF130002F4300DD22"] = TRIANGLE,
})

addToDefaultNpcsToMark("Molten Core", "baron_pack_1", {
	["0xF130002D93016498"] = CROSS,
	["0xF130002F2C016497"] = CIRCLE,
	["0xF130002D92016496"] = SKULL,
	["0xF130002F2C016499"] = DIAMOND,
})

addToDefaultNpcsToMark("Molten Core", "baron_pack_2", {
	["0xF130002F2C016480"] = CIRCLE,
	["0xF130002F2C01647E"] = DIAMOND,
	["0xF130002D9301647F"] = CROSS,
	["0xF130002D9201647D"] = SKULL,
	["0xF130002F1800DD4F"] = STAR, -- baron
})

addToDefaultNpcsToMark("Molten Core", "baron_pack_3", {
	["0xF130002D9301649C"] = CROSS,
	["0xF130002D9201649A"] = SKULL,
	["0xF130002F4401649B"] = CIRCLE,
	["0xF130002FE800DD20"] = STAR, -- shazzrah
})

addToDefaultNpcsToMark("Molten Core", "baron_pack_4", {
	["0xF130002D9200DD92"] = SKULL,
	["0xF130002F4400DD93"] = CIRCLE,
	["0xF130002D9300DD94"] = CROSS,
})

addToDefaultNpcsToMark("Molten Core", "baron_pack_5", {
	["0xF130002F2C00DDD9"] = CIRCLE,
	["0xF130002D9300DDDA"] = CROSS,
	["0xF130002D9200DDD8"] = SKULL,
	["0xF130002F2C00DDDB"] = DIAMOND,
})

addToDefaultNpcsToMark("Molten Core", "sulfuron", {
	["0xF130002D8E00DD69"] = MOON,
	["0xF130002D8E00DD66"] = SQUARE,
	["0xF130002D8E00DD67"] = CROSS,
	["0xF130002F4200DD65"] = TRIANGLE,
	["0xF130002D8E00DD6A"] = SKULL,
})

addToDefaultNpcsToMark("Molten Core", "domo", {
	["0xF130002D8F276EB8"] = TRIANGLE,
	["0xF130002D90276EB4"] = STAR,
	["0xF130002D90276EB5"] = CIRCLE,
	["0xF130002D90276EB3"] = DIAMOND,
	["0xF130002D90276EB6"] = CROSS,
	["0xF130002D8F276EB9"] = MOON,
	["0xF130002D8F276EBA"] = SQUARE,
	["0xF130002D8F276EB7"] = SKULL,
	["0xF130002EF2276EB2"] = UNMARKED,
})

-- ["domo2"] = {
--   ["0xF130002D90276F77"] = CROSS,
--   ["0xF130002D90276F76"] = 2,
--   ["0xF130002D8F276F79"] = 4,
--   ["0xF130002D8F276F7A"] = 5,
--   ["0xF130002D8F276F78"] = SKULL,
--   ["0xF130002D90276F75"] = 3,
--   ["0xF130002D8F276F7B"] = 6,
--   ["0xF130002EF2276F73"] = UNMARKED,
--   ["0xF130002D90276F74"] = STAR,
-- },

--/////////////// AQ20 ///////////////

addToDefaultNpcsToMark("Ruins of Ahn'Qiraj", "entrance", {
  ["0xF130003BEF11FB53"] = TRIANGLE,
  ["0xF130003BDC0155E6"] = CIRCLE,
  ["0xF130003BDC11FAC8"] = SKULL,
})

addToDefaultNpcsToMark("Ruins of Ahn'Qiraj", "entrance_pats", {
  ["0xF130003BDF0155DA"] = STAR,
  ["0xF130003BDD11FAD8"] = UNMARKED,
  ["0xF130003BDD11FAD7"] = UNMARKED,
  ["0xF130003BDD11FADF"] = UNMARKED,
  ["0xF130003BDD11FAD6"] = UNMARKED,
  ["0xF130003BDD11FAD5"] = UNMARKED,
  ["0xF130003BEF11FB4D"] = CIRCLE,
  ["0xF130003BDD11FADB"] = UNMARKED,
  ["0xF130003BDD11FADA"] = UNMARKED,
  ["0xF130003BDD11FADE"] = UNMARKED,
  ["0xF130003BDD11FAD4"] = UNMARKED,
  ["0xF130003BDF0155DB"] = SQUARE,
  ["0xF130003BEF11FAE1"] = DIAMOND,
  ["0xF130003BDF11FAE0"] = SKULL,
  ["0xF130003BDD11FAD3"] = UNMARKED,
  ["0xF130003BEF11FAE2"] = TRIANGLE,
  ["0xF130003BDF11FADD"] = MOON,
  ["0xF130003BDF11FB4E"] = CROSS,
})

addToDefaultNpcsToMark("Ruins of Ahn'Qiraj", "entrance_pats_2", {
  ["0xF130003BDD11FAF3"] = UNMARKED,
  ["0xF130003BDD11FAF7"] = UNMARKED,
  ["0xF130003BDD11FAEF"] = UNMARKED,
  ["0xF130003BDF11FAF5"] = SQUARE,
  ["0xF130003BDD11FAFA"] = UNMARKED,
  ["0xF130003BDD11FAF4"] = UNMARKED,
  ["0xF130003BDF11FAF0"] = DIAMOND,
  ["0xF130003BDF11FAF2"] = MOON,
  ["0xF130003BDF11FAF8"] = CROSS,
  ["0xF130003BF40162B5"] = TRIANGLE, -- kurinaxx
  ["0xF130003BDD11FAF6"] = UNMARKED,
  ["0xF130003BDD11FAF1"] = UNMARKED,
  ["0xF130003BDD11FAF9"] = UNMARKED,
  ["0xF130003BDC11FACA"] = CIRCLE,
  ["0xF130003BDC11FAC9"] = SKULL,
  ["0xF130003BDD11FB50"] = UNMARKED,
  ["0xF130003BDF11FB4F"] = STAR,
  ["0xF130003BDD11FB52"] = UNMARKED,
})

addToDefaultNpcsToMark("Ruins of Ahn'Qiraj", "general_rajaxx", {
  ["0xF130003C1B11FB5A"] = UNMARKED,
  ["0xF130003BF011FB71"] = UNMARKED,
  ["0xF130003C1B11FB57"] = UNMARKED,
  ["0xF130003BF011FB5C"] = UNMARKED,
  ["0xF130003BF011FB72"] = UNMARKED,
  ["0xF130003C1C11FC00"] = CIRCLE,
  ["0xF130003C1B11FB6D"] = UNMARKED,
  ["0xF130003BF011FB89"] = UNMARKED,
  ["0xF130003C1911FBFF"] = DIAMOND,
  ["0xF130003C1B11FB84"] = UNMARKED,
  ["0xF130003C1B11FB7D"] = UNMARKED,
  ["0xF130003BF011FB6F"] = UNMARKED,
  ["0xF130003BF011FB78"] = UNMARKED,
  ["0xF130003BF011FB66"] = UNMARKED,
  ["0xF130003BF011FB79"] = UNMARKED,
  ["0xF130003C1B11FB7F"] = UNMARKED,
  ["0xF130003C1B11FB6B"] = UNMARKED,
  ["0xF130003C1D11FBFD"] = CROSS,
  ["0xF130003BF011FB80"] = UNMARKED,
  ["0xF130003BF011FB64"] = UNMARKED,
  ["0xF130003C1B11FB59"] = UNMARKED,
  ["0xF130003C1B11FB5F"] = UNMARKED,
  ["0xF130003BF011FB77"] = UNMARKED,
  ["0xF130003C1B11FB60"] = UNMARKED,
  ["0xF130003BF011FB68"] = UNMARKED,
  ["0xF130003BF011FB62"] = UNMARKED,
  ["0xF130003C1F11FB5D"] = SKULL,
  ["0xF130003C2011FB5E"] = SQUARE,
  ["0xF130003BF011FB76"] = UNMARKED,
  ["0xF130003BF011FB81"] = UNMARKED,
  ["0xF130003BF011FB5B"] = UNMARKED,
  ["0xF130003C1B11FB61"] = UNMARKED,
  ["0xF130003C1B11FB58"] = UNMARKED,
  ["0xF130003BF011FB63"] = UNMARKED,
  ["0xF130003C1B11FB69"] = UNMARKED,
  ["0xF130003C1B11FB6A"] = UNMARKED,
  ["0xF130003BF011FB67"] = UNMARKED,
  ["0xF130003C1E11FC01"] = MOON,
  ["0xF130003C1B11FB85"] = UNMARKED,
  ["0xF130003BED0162F7"] = UNMARKED,
  ["0xF130003BF011FB82"] = UNMARKED,
  ["0xF130003C1A11FBFE"] = TRIANGLE,
  ["0xF130003BF011FB87"] = UNMARKED,
  ["0xF130003BF011FB70"] = UNMARKED,
  ["0xF130003C1B11FB86"] = UNMARKED,
  ["0xF130003C1B11FB7E"] = UNMARKED,
  ["0xF130003BF011FB6E"] = UNMARKED,
  ["0xF130003C1B11FB7A"] = UNMARKED,
  ["0xF130003C1B11FB88"] = UNMARKED,
})

addToDefaultNpcsToMark("Ruins of Ahn'Qiraj", "buru_path", {
  ["0xF130003BE7014F7D"] = STAR,
  ["0xF130003BDC11FACC"] = CIRCLE,
  ["0xF130003BDC11FACD"] = SKULL,
  ["0xF130003BDB11FB96"] = TRIANGLE,
})

addToDefaultNpcsToMark("Ruins of Ahn'Qiraj", "buru_eggs", {
  ["0xF130003C9A276DE0"] = CIRCLE, -- egg
  ["0xF130003C9A276DE1"] = DIAMOND, -- egg
  ["0xF130003C9A276DE2"] = TRIANGLE, -- egg
  ["0xF130003C9A276DE3"] = MOON, -- egg
  ["0xF130003C9A276DE4"] = SQUARE, -- egg
  ["0xF130003C9A276DE5"] = STAR, -- egg
  ["0xF130003C0A0162F9"] = UNMARKED, -- buru
  ["0xF130003BE711FE02"] = CROSS, -- slime
  ["0xF130003BE711FB9F"] = SKULL, -- slime
})

addToDefaultNpcsToMark("Ruins of Ahn'Qiraj", "resevoir", {
  ["0xF130003BE711FC27"] = SQUARE,
  ["0xF130003BEA11FC12"] = DIAMOND,
  ["0xF130003BEA0153E5"] = MOON,
  ["0xF130003BDC11FACE"] = SKULL,
  ["0xF130003BEA11FC39"] = TRIANGLE,
  ["0xF130003BDC11FACF"] = CIRCLE,
  ["0xF130003BE711FC2B"] = STAR,
})

addToDefaultNpcsToMark("Ruins of Ahn'Qiraj", "ossirian_room", {
  ["0xF130003BFB11FBDC"] = CROSS,
  ["0xF130003BFB11FBDD"] = SKULL,
  ["0xF130003BFB0155C3"] = SQUARE,
  ["0xF130003BFB11FBE0"] = TRIANGLE,
  ["0xF130003BFB11FBDF"] = STAR,
  ["0xF130003BFB11FBDB"] = DIAMOND,
  ["0xF130003BFB11FBDE"] = CIRCLE,
  ["0xF130003BFB11FBE1"] = MOON,
})

-- needs testing
--/////////////// BWL ///////////////

addToDefaultNpcsToMark("Blackwing Lair", "supress1_1", {
  ["0xF1300030AA104BD4"] = DIAMOND, -- taskmaster
  ["0xF1300030AA104BD3"] = TRIANGLE, -- taskmaster
  ["0xF1300030AA104BD2"] = MOON, -- taskmaster
  ["0xF1300030B40BA43A"] = 0, -- hatcher
  ["0xF1300030B40BA3BF"] = 0, -- hatcher
  ["0xF1300030B40BA395"] = 0, -- hatcher
})

addToDefaultNpcsToMark("Blackwing Lair", "supress1_2", {
  ["0xF1300030AA104BD1"] = CROSS, -- taskmaster
  ["0xF1300030AA104BD0"] = SQUARE, -- taskmaster
  ["0xF1300030AA104BCF"] = SKULL, -- taskmaster
  ["0xF1300030B40BA218"] = 0, -- hatcher
  ["0xF1300030B40BA216"] = 0, -- hatcher
  ["0xF1300030B40BA08B"] = 0, -- hatcher
})

addToDefaultNpcsToMark("Blackwing Lair", "supress2_1", {
  ["0xF1300030AA104BD8"] = CROSS, -- taskmaster
  ["0xF1300030AA104BD7"] = SQUARE, -- taskmaster
  ["0xF1300030AA104BD6"] = SKULL, -- taskmaster
  ["0xF1300030B40BA632"] = 0, -- hatcher
  ["0xF1300030B40BA630"] = 0, -- hatcher
  ["0xF1300030B40BA62E"] = 0, -- hatcher
})

addToDefaultNpcsToMark("Blackwing Lair", "supress2_2", {
  ["0xF1300030AA104BDB"] = DIAMOND, -- taskmaster
  ["0xF1300030AA104BDA"] = TRIANGLE, -- taskmaster
  ["0xF1300030AA104BD9"] = MOON, -- taskmaster
  ["0xF1300030B40BA441"] = 0, -- hatcher
  ["0xF1300030B40BA43F"] = 0, -- hatcher
  ["0xF1300030B40BA43D"] = 0, -- hatcher
  ["0xF130002EF10149A3"] = 0, -- lashlayer
})

addToDefaultNpcsToMark("Blackwing Lair", "wrym1", {
  ["0xF1300030B1014A2E"] = SQUARE,
  ["0xF1300030B1014A2D"] = MOON,
  ["0xF1300030B3014A27"] = STAR,
  ["0xF1300030B0014A2C"] = SKULL,
  ["0xF1300030B0014A2B"] = CROSS,
  ["0xF1300030AF014A33"] = DIAMOND,
  ["0xF1300030AF014A34"] = CIRCLE,
})

addToDefaultNpcsToMark("Blackwing Lair", "wrym2", {
  ["0xF1300030B1014A30"] = MOON,
  ["0xF1300030B1014A2F"] = SQUARE,
  ["0xF1300030B3014A28"] = STAR,
  ["0xF1300030B0014A29"] = SKULL,
  ["0xF1300030B0014A2A"] = CROSS,
  ["0xF1300030AF014A31"] = DIAMOND,
  ["0xF1300030AF014A32"] = CIRCLE,
})

addToDefaultNpcsToMark("Blackwing Lair", "lab1", {
  ["0xF1300036AC11F796"] = UNMARKED,
  ["0xF1300036AC014A3C"] = UNMARKED,
  ["0xF1300036AC11F797"] = UNMARKED,
  ["0xF1300036AC014A37"] = UNMARKED,
  ["0xF1300036AC014A3B"] = UNMARKED,
  ["0xF1300036AC014A38"] = UNMARKED,
  ["0xF1300030AB014A3E"] = CROSS,
  ["0xF1300030AB014A3D"] = SKULL,
})

addToDefaultNpcsToMark("Blackwing Lair", "lab2", {
  ["0xF1300036AC11F79B"] = UNMARKED,
  ["0xF1300030A9014A44"] = DIAMOND,
  ["0xF1300036AC014A4A"] = UNMARKED,
  ["0xF1300036AC11F79A"] = UNMARKED,
  ["0xF1300036AC014A46"] = UNMARKED,
  ["0xF1300036AC014A47"] = UNMARKED,
  ["0xF1300030AB014A42"] = SKULL,
  ["0xF1300036AC014A48"] = UNMARKED,
  ["0xF1300036AC014A4B"] = UNMARKED,
  ["0xF1300030AD014A4D"] = CIRCLE,
  ["0xF130002ECF014A5C"] = TRIANGLE, -- firemaw
})

addToDefaultNpcsToMark("Blackwing Lair", "lab3", {
  ["0xF1300036AC014A53"] = UNMARKED,
  ["0xF1300030A911F78B"] = DIAMOND,
  ["0xF1300036AC014A55"] = UNMARKED,
  ["0xF1300036AC014A5A"] = UNMARKED,
  ["0xF1300030AB014A51"] = CROSS,
  ["0xF1300036AC11F79D"] = UNMARKED,
  ["0xF1300030AD014A4E"] = CIRCLE,
  ["0xF1300030AB014A50"] = SKULL,
  ["0xF1300036AC014A56"] = UNMARKED,
  ["0xF1300036AC014A54"] = UNMARKED,
  ["0xF1300036AC014A58"] = UNMARKED,
})

addToDefaultNpcsToMark("Blackwing Lair", "wyrmguard1", {
  ["0xF1300030AD014A6D"] = DIAMOND,
  ["0xF1300030AC014A70"] = SKULL,
  ["0xF1300030AD014A6E"] = CROSS,
  ["0xF1300030AD014A6F"] = CIRCLE,
})

addToDefaultNpcsToMark("Blackwing Lair", "lab4", {
  ["0xF1300030A911F78C"] = DIAMOND,
  ["0xF1300036AC014A7D"] = UNMARKED,
  ["0xF1300036AC014A87"] = UNMARKED,
  ["0xF1300030AB014A77"] = CROSS,
  ["0xF1300030AB014A76"] = SKULL,
  ["0xF1300036AC014A8B"] = UNMARKED,
  ["0xF1300030AD014A91"] = CIRCLE,
  ["0xF1300036AC014A7E"] = UNMARKED,
  ["0xF1300036AC11F799"] = UNMARKED,
  ["0xF1300036AC014A86"] = UNMARKED,
  ["0xF1300036AC11F798"] = UNMARKED,
})

addToDefaultNpcsToMark("Blackwing Lair", "lab5", {
  ["0xF1300036AC014B1A"] = UNMARKED,
  ["0xF1300036AC014AAE"] = UNMARKED,
  ["0xF1300030AB014AAD"] = SKULL,
  ["0xF1300036AC014AD1"] = UNMARKED,
  ["0xF1300030AD014B68"] = CIRCLE,
  ["0xF1300036AC014AD0"] = UNMARKED,
  ["0xF1300036AC014AD3"] = UNMARKED,
  ["0xF1300030A911F78D"] = DIAMOND,
  ["0xF1300036AC11F791"] = UNMARKED,
  ["0xF1300036AC014B1B"] = UNMARKED,
  ["0xF1300036AC014B19"] = UNMARKED,
  ["0xF1300030AB014AAC"] = CROSS,
})


addToDefaultNpcsToMark("Blackwing Lair", "lab6", {
  ["0xF1300030A9014EFE"] = DIAMOND,
  ["0xF1300036AC11F794"] = UNMARKED,
  ["0xF1300036AC014F07"] = UNMARKED,
  ["0xF1300036AC014F06"] = UNMARKED,
  ["0xF1300036AC014F00"] = UNMARKED,
  ["0xF1300036AC014F0C"] = UNMARKED,
  ["0xF1300036AC014F0D"] = UNMARKED,
  ["0xF1300036AC014F04"] = UNMARKED,
  ["0xF1300030A9014F08"] = STAR,
  ["0xF1300030AD11F78F"] = CIRCLE,
  ["0xF1300036AC11F795"] = UNMARKED,
  ["0xF1300030AB014EFD"] = SKULL,
})

addToDefaultNpcsToMark("Blackwing Lair", "lab7", {
  ["0xF1300036AC014E77"] = UNMARKED,
  ["0xF1300030AB014E61"] = CROSS,
  ["0xF1300030A9014E6D"] = STAR,
  ["0xF1300036AC11F792"] = UNMARKED,
  ["0xF1300030A9014E75"] = DIAMOND,
  ["0xF1300036AC014E79"] = UNMARKED,
  ["0xF1300036AC014E69"] = UNMARKED,
  ["0xF1300036AC014E74"] = UNMARKED,
  ["0xF1300036AC014E6C"] = UNMARKED,
  ["0xF1300036AC014E6B"] = UNMARKED,
  ["0xF1300036AC014E70"] = UNMARKED,
  ["0xF1300030AB014E4D"] = SKULL,
  ["0xF1300030AD11F78E"] = CIRCLE,
})

addToDefaultNpcsToMark("Blackwing Lair", "wyrmguard2", {
  ["0xF1300030AC014A9B"] = SKULL,
  ["0xF1300030AC014A9A"] = CIRCLE,
  ["0xF1300030AC014A94"] = DIAMOND,
  ["0xF130003841014A93"] = MOON,
  ["0xF130002ECD014F17"] = SQUARE, -- flamegor
  ["0xF130003909014F14"] = TRIANGLE, -- ebonroc
})

addToDefaultNpcsToMark("Blackwing Lair", "wyrmguard3", {
  ["0xF1300030AC014A9F"] = DIAMOND,
  ["0xF1300030AC014AAA"] = SKULL,
  ["0xF1300030AC014AA8"] = CIRCLE,
  ["0xF1300036C4014F18"] = TRIANGLE, -- chromag
})
