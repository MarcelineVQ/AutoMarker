local L = AutoMarkerLocale

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
  Alternatively we can just do a sweeping re-mark every time we see a new one, though the marks won't stay consistent.

--]]


-- Function to add entries while maintaining order
function addToDefaultNpcsToMark(instance, packName, npcs)
  if not defaultNpcsToMark[instance] then
    defaultNpcsToMark[instance] = {}
  end
  defaultNpcsToMark[instance][packName] = npcs
  table.insert(orderedPacks, {instance = instance, packName = packName})
end

addToDefaultNpcsToMark("Orgrimmar", "org_dummies", {
  ["0xF13000C55326FDD0"] = SKULL,
  ["0xF13000C55226FDCE"] = SQUARE,
  ["0xF13000C55426FE5A"] = CROSS,
})

--/////////////// Naxxramas ///////////////

defaultNpcsToMark[L["Naxxramas"]] = {}

--/////////////// SPIDER ///////////////

addToDefaultNpcsToMark(L["Naxxramas"], "spider_entrance_patrol", {
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

addToDefaultNpcsToMark(L["Naxxramas"], "spider_entrance_right", {
  ["0xF130003E680158F6"]  = SKULL, -- Venom Stalker
  ["0xF130003E6601590E"]  = CROSS, -- Dread Creeper
  ["0xF130003E6601590F"]  = SQUARE, -- Dread Creeper
  ["0xF130003E670158F4"]  = MOON, -- Carrion Spinner
  ["0xF130003E670158F5"]  = TRIANGLE, -- Carrion Spinner
  ["0xF130003E670158F3"]  = DIAMOND, -- Carrion Spinner
})

addToDefaultNpcsToMark(L["Naxxramas"], "spider_entrance_left", {
  ["0xF130003E680158F7"]  = SKULL, -- Venom Stalker
  ["0xF130003E66015911"]  = CROSS, -- Dread Creeper
  ["0xF130003E66015910"]  = SQUARE, -- Dread Creeper
  ["0xF130003E670158F9"]  = MOON, -- Carrion Spinner
  ["0xF130003E670158FA"]  = TRIANGLE, -- Carrion Spinner
  ["0xF130003E670158F8"]  = DIAMOND, -- Carrion Spinner
})

addToDefaultNpcsToMark(L["Naxxramas"], "spider_anubrekhan_hallway", {
  ["0xF130003E68015917"]  = SKULL, -- Venom Stalker
  ["0xF130003E66015912"]  = CROSS, -- Dread Creeper
  ["0xF130003E66015913"]  = SQUARE, -- Dread Creeper
  ["0xF130003E67015914"]  = MOON, -- Carrion Spinner
  ["0xF130003E67015915"]  = TRIANGLE, -- Carrion Spinner
  ["0xF130003E67015916"]  = DIAMOND, -- Carrion Spinner
})

addToDefaultNpcsToMark(L["Naxxramas"], "spider_anubrekhan", {
  ["0xF130003E5401591A"]  = SKULL, -- Anub'Rekhan
  ["0xF1300040BD04B2DF"]  = CROSS, -- Crypt Guard
  ["0xF1300040BD04B2DE"]  = SQUARE, -- Crypt Guard
})

addToDefaultNpcsToMark(L["Naxxramas"], "spider_central_right", {
  ["0xF130003E6A0159DF"]  = SKULL, -- Crypt Reaver
  ["0xF130003E67269C2D"]  = CROSS, -- Carrion Spinner
  ["0xF130003E67269C2C"]  = SQUARE, -- Carrion Spinner
  ["0xF130003E67269C2B"]  = TRIANGLE, -- Carrion Spinner
  ["0xF130003E67269C2A"]  = DIAMOND, -- Carrion Spinner
  ["0xF130003E670159F3"]  = MOON, -- Carrion Spinner
  ["0xF130003E670159F4"]  = CIRCLE, -- Carrion Spinner
})

addToDefaultNpcsToMark(L["Naxxramas"], "spider_central_patrol", {
  ["0xF130003E69269C0B"]  = STAR, -- Infectious Skitterer
  ["0xF130003E69269C0C"]  = UNMARKED, -- Infectious Skitterer
  ["0xF130003E69269C13"]  = UNMARKED, -- Infectious Skitterer
  ["0xF130003E69269C12"]  = UNMARKED, -- Infectious Skitterer
  ["0xF130003E69269C11"]  = UNMARKED, -- Infectious Skitterer
  ["0xF130003E69269C10"]  = UNMARKED, -- Infectious Skitterer
  ["0xF130003E69269C0E"]  = UNMARKED, -- Infectious Skitterer
  ["0xF130003E69269C0D"]  = UNMARKED, -- Infectious Skitterer
})

addToDefaultNpcsToMark(L["Naxxramas"], "spider_necro_1", {
  ["0xF130004045015A20"]  = SKULL, -- Necro Stalker
  ["0xF130004045015A1F"]  = CROSS, -- Necro Stalker
})

addToDefaultNpcsToMark(L["Naxxramas"], "spider_necro_2", {
  ["0xF130004045269C25"]  = SKULL, -- Necro Stalker
  ["0xF130004045269C24"]  = CROSS, -- Necro Stalker
})

addToDefaultNpcsToMark(L["Naxxramas"], "spider_faerlina_patrol", {
  ["0xF130003E69049D6A"]  = STAR, -- Infectious Skitterer
  ["0xF130003E69049D6B"]  = UNMARKED, -- Infectious Skitterer
  ["0xF130003E69049D6C"]  = UNMARKED, -- Infectious Skitterer
  ["0xF130003E69049D69"]  = UNMARKED, -- Infectious Skitterer
  ["0xF130003E69049D68"]  = UNMARKED, -- Infectious Skitterer
  ["0xF130003E69049D67"]  = UNMARKED, -- Infectious Skitterer
  ["0xF130003E69049D66"]  = UNMARKED, -- Infectious Skitterer
  ["0xF130003E69049D65"]  = UNMARKED, -- Infectious Skitterer
})

addToDefaultNpcsToMark(L["Naxxramas"], "spider_faerlina_left_1", {
  ["0xF130003E6D269BFD"] = CROSS, -- Naxxramas Acolyte
  ["0xF130003E6C269C02"] = CIRCLE,-- Naxxramas Cultistz
  ["0xF130003E6C269BFE"] = TRIANGLE,-- Naxxramas Cultist
  ["0xF130003E6D269C01"] = MOON, -- Naxxramas Acolyte
  ["0xF130003E6C269BFC"] = STAR,-- Naxxramas Cultist
  ["0xF130003E6D269BFB"] = SQUARE, -- Naxxramas Acolyte
  ["0xF130003E6C269C00"] = DIAMOND,-- Naxxramas Cultist
  ["0xF130003E6D269BFF"] = SKULL, -- Naxxramas Acolyte
})

addToDefaultNpcsToMark(L["Naxxramas"], "spider_faerlina_left_2", {
  ["0xF130003E6D269BFA"] = MOON, -- Naxxramas Acolyte
  ["0xF130003E6C269BF5"] = CIRCLE, -- Naxxramas Cultist
  ["0xF130003E6C269BF3"] = TRIANGLE,-- Naxxramas Cultist
  ["0xF130003E6C269BF7"] = DIAMOND,-- Naxxramas Cultist
  ["0xF130003E6D269BF8"] = SQUARE, -- Naxxramas Acolyte
  ["0xF130003E6C269BF9"] = STAR,-- Naxxramas Cultist
  ["0xF130003E6D269BF4"] = SKULL, -- Naxxramas Acolyte
  ["0xF130003E6D269BF6"] = CROSS, -- Naxxramas Acolyte
})

addToDefaultNpcsToMark(L["Naxxramas"], "spider_faerlina_left_3", {
  ["0xF130003E6C269BDA"] = STAR,-- Naxxramas Cultist
  ["0xF130003E6D269BD9"] = SQUARE, -- Naxxramas Acolyte
  ["0xF130003E6C269BD8"] = DIAMOND,-- Naxxramas Cultist
  ["0xF130003E6D269BD7"] = SKULL, -- Naxxramas Acolyte
  ["0xF130003E6C269BD6"] = CIRCLE,-- Naxxramas Cultist
  ["0xF130003E6D269BD5"] = CROSS, -- Naxxramas Acolyte
  ["0xF130003E6D269BD4"] = MOON, -- Naxxramas Acolyte
  ["0xF130003E6C269BD3"] = TRIANGLE,-- Naxxramas Cultist
})

addToDefaultNpcsToMark(L["Naxxramas"], "spider_faerlina_right_1", {
  ["0xF130003E6D269BE2"] = SQUARE, -- Naxxramas Acolyte
  ["0xF130003E6C269BE1"] = DIAMOND,-- Naxxramas Cultist
  ["0xF130003E6D269BE0"] = CROSS, -- Naxxramas Acolyte
  ["0xF130003E6C269BDF"] = TRIANGLE,-- Naxxramas Cultist
  ["0xF130003E6D269BDE"] = MOON, -- Naxxramas Acolyte
  ["0xF130003E6C269BDD"] = CIRCLE,-- Naxxramas Cultist
  ["0xF130003E6C269BDC"] = STAR,-- Naxxramas Cultist
  ["0xF130003E6D269BDB"] = SKULL, -- Naxxramas Acolyte
})

addToDefaultNpcsToMark(L["Naxxramas"], "spider_faerlina_right_2", {
  ["0xF130003E6C269BE3"] = CIRCLE,-- Naxxramas Cultist
  ["0xF130003E6C269BE5"] = DIAMOND,-- Naxxramas Cultist
  ["0xF130003E6C269BE7"] = STAR,-- Naxxramas Cultist
  ["0xF130003E6C269BE9"] = TRIANGLE,-- Naxxramas Cultist
  ["0xF130003E6D269BE8"] = CROSS, -- Naxxramas Acolyte
  ["0xF130003E6D269BEA"] = SQUARE, -- Naxxramas Acolyte
  ["0xF130003E6D269BE6"] = MOON, -- Naxxramas Acolyte
  ["0xF130003E6D269BE4"] = SKULL, -- Naxxramas Acolyte
})

addToDefaultNpcsToMark(L["Naxxramas"], "spider_faerlina_right_3", {
  ["0xF130003E6D269BED"] = SQUARE, -- Naxxramas Acolyte
  ["0xF130003E6C269BF0"] = DIAMOND, -- Naxxramas Cultist
  ["0xF130003E6D269BF1"] = MOON, -- Naxxramas Acolyte
  ["0xF130003E6C269BF2"] = STAR, -- Naxxramas Cultist
  ["0xF130003E6D269BEB"] = SKULL, -- Naxxramas Acolyte
  ["0xF130003E6C269BEC"] = TRIANGLE, -- Naxxramas Cultist
  ["0xF130003E6D269BEF"] = CROSS, -- Naxxramas Acolyte
  ["0xF130003E6C269BEE"] = CIRCLE, -- Naxxramas Cultist
})

addToDefaultNpcsToMark(L["Naxxramas"], "spider_faerlina", {
  ["0xF130003E510159B0"] = TRIANGLE, -- Grand Widow Faerlina
  ["0xF130004079276DE5"] = CROSS, -- Naxxramas Follower
  ["0xF130004079276DE6"] = SKULL, -- Naxxramas Follower
  ["0xF13000407A276DE7"] = CIRCLE, -- Naxxramas Worshipper
  ["0xF13000407A276DE8"] = SQUARE, -- Naxxramas Worshipper
  ["0xF13000407A276DE9"] = MOON, -- Naxxramas Worshipper
  ["0xF13000407A276DEA"] = STAR, -- Naxxramas Worshipper
})

addToDefaultNpcsToMark(L["Naxxramas"], "spider_final", {
  ["0xF130003E66269C1A"] = CROSS, -- Dread Creeper
  ["0xF130003E66269C18"] = TRIANGLE, -- Dread Creeper
  ["0xF130003E66015A2F"] = SQUARE, -- Dread Creeper
  ["0xF130003E66269C19"] = MOON, -- Dread Creeper
  ["0xF130003E6B01F3EE"] = SKULL, -- Tomb Horror
})

addToDefaultNpcsToMark(L["Naxxramas"],"spider_ring_ghouls_1", {
  ["0xF13000403F269C03"] = SKULL,
  ["0xF13000403F269C04"] = SQUARE,
  ["0xF13000403F269C06"] = CROSS,
})

addToDefaultNpcsToMark(L["Naxxramas"],"spider_ring_ghouls_2", {
  ["0xF13000403F269BAE"] = SKULL,
  ["0xF13000403F269BAD"] = SQUARE,
  ["0xF13000403F269BAC"] = CROSS,
})

addToDefaultNpcsToMark(L["Naxxramas"], "spider_ring_pats", {
  -- addToDefaultNpcsToMark(L["Naxxramas"], "spider_ring_acolyte_1", {
    ["0xF130003FF0015AD7"] = CROSS, -- Necropolis Acolyte
    ["0xF130003FF0015AD8"] = SKULL, -- Necropolis Acolyte
  -- })
  -- ["spider_ring_spiders1"] = {
    ["0xF130004045269C07"] = CIRCLE, -- Necro Stalker
    ["0xF130004045269C08"] = UNMARKED, -- Necro Stalker
  -- },
  -- ["spider_ring_spiders2"] = {
    ["0xF130004045269C09"] = UNMARKED, -- Necro Stalker
    ["0xF130004045269C0A"] = STAR, -- Necro Stalker
  -- },
  -- ["garg1"] = {
    ["0xF13000403E269C44"] = UNMARKED, -- Plagued Gargoyle
    ["0xF13000403E269C45"] = TRIANGLE, -- Plagued Gargoyle
  -- },
  -- ["garg2"] = {
    ["0xF13000403E269C43"] = DIAMOND, -- Plagued Gargoyle
    ["0xF13000403E015B18"] = UNMARKED, -- Plagued Gargoyle
  -- },
})

addToDefaultNpcsToMark(L["Naxxramas"], "spider_ring_acolyte_2", {
  ["0xF130003FF0015AD5"] = CROSS, -- Necropolis Acolyte
  ["0xF130003FF0015AD6"] = SKULL, -- Necropolis Acolyte
})

addToDefaultNpcsToMark(L["Naxxramas"], "spider_ring_acolyte_3", {
  ["0xF130003FF0015AD4"]  = SKULL, -- Necropolis Acolyte
  ["0xF130003FF0015AD3"]  = CROSS, -- Necropolis Acolyte
})

----/////////////// MILITARY ///////////////

addToDefaultNpcsToMark(L["Naxxramas"], "military_entrance_middle", {
  ["0xF130003F1101594B"]  = SKULL, -- Deathknight Captain
  ["0xF130003F1101594C"]  = CROSS, -- Deathknight Captain
})

addToDefaultNpcsToMark(L["Naxxramas"], "military_entrance_left", {
  ["0xF130003F1201594A"]  = SKULL, -- Deathknight
  ["0xF130003F1A015950"]  = CROSS, -- Risen Deathknight
  ["0xF130003F1A015951"]  = SQUARE, -- Risen Deathknight
})

addToDefaultNpcsToMark(L["Naxxramas"], "military_entrance_right", {
  ["0xF130003F12015949"]  = SKULL, -- Deathknight
  ["0xF130003F1A015953"]  = CROSS, -- Risen Deathknight
  ["0xF130003F1A015952"]  = SQUARE, -- Risen Deathknight
})

addToDefaultNpcsToMark(L["Naxxramas"], "military_entrance_patrol", {
  ["0xF130003F2401594D"]  = SKULL, -- Shade of Naxxramas
  ["0xF130003F2501594F"]  = CROSS, -- Necro Knight
  ["0xF130003F2501594E"]  = SQUARE, -- Necro Knight
})

addToDefaultNpcsToMark(L["Naxxramas"], "military_static_1", {
  ["0xF130003F12015967"]  = SKULL, -- Deathknight
  ["0xF130003F1C015956"]  = CROSS, -- Dark Touched Warrior
  ["0xF130003F1E015955"]  = SQUARE, -- Death Touched Warrior
  ["0xF130003F11015954"]  = MOON, -- Deathknight Captain
})

addToDefaultNpcsToMark(L["Naxxramas"], "military_forge_captains", {
  ["0xF130003F11015968"]  = SKULL, -- Deathknight Captain
  ["0xF130003F11015969"]  = CROSS, -- Deathknight Captain
})

addToDefaultNpcsToMark(L["Naxxramas"], "military_forge_shade_patrol", {
  ["0xF130003F24015957"]  = STAR, -- Shade of Naxxramas
})

addToDefaultNpcsToMark(L["Naxxramas"], "military_forge_shades", {
  ["0xF130003F24015961"]  = SKULL, -- Shade of Naxxramas
  ["0xF130003F24015960"]  = CROSS, -- Shade of Naxxramas
  ["0xF130003F2501596A"]  = SQUARE, -- Necro Knight
})

addToDefaultNpcsToMark(L["Naxxramas"], "military_forge_constructs", {
  ["0xF130003F27015962"]  = SKULL, -- Bony Construct
  ["0xF130003F27015963"]  = CROSS, -- Bony Construct
  ["0xF130003F27015964"]  = SQUARE, -- Bony Construct
  ["0xF130003F27015965"]  = MOON, -- Bony Construct
  ["0xF130003F27015966"]  = TRIANGLE, -- Bony Construct
})

addToDefaultNpcsToMark(L["Naxxramas"], "military_forge_smiths", {
  ["0xF130003F4101595A"]  = SKULL, -- Skeletal Smith
  ["0xF130003F41015958"]  = CROSS, -- Skeletal Smith
  ["0xF130003F41015959"]  = SQUARE, -- Skeletal Smith
  ["0xF130003F4101595B"]  = MOON, -- Skeletal Smith
})

addToDefaultNpcsToMark(L["Naxxramas"], "military_static_2", {
  ["0xF130003F1201595E"]  = SKULL, -- Deathknight
  ["0xF130003F1201595D"]  = CROSS, -- Deathknight
  ["0xF130003F1101595C"]  = SQUARE, -- Deathknight Captain
  ["0xF130003F1101595F"]  = MOON, -- Deathknight Captain
})

addToDefaultNpcsToMark(L["Naxxramas"], "military_static_3", {
  ["0xF130003F1201596E"]  = SKULL, -- Deathknight
  ["0xF130003F1C01596B"]  = CROSS, -- Dark Touched Warrior
  ["0xF130003F1D01596C"]  = SQUARE, -- Doom Touched Warrior
  ["0xF130003F1101596D"]  = MOON, -- Deathknight Captain
})

addToDefaultNpcsToMark(L["Naxxramas"], "military_upper_patrol", {
  ["0xF130003F12015978"]  = SKULL, -- Deathknight
  ["0xF130003F1E01597A"]  = CROSS, -- Death Touched Warrior
  ["0xF130003F1E015979"]  = SQUARE, -- Death Touched Warrior
})

addToDefaultNpcsToMark(L["Naxxramas"], "military_static_4", {
  ["0xF130003F12015973"]  = SKULL, -- Deathknight
  ["0xF130003F12015972"]  = CROSS, -- Deathknight
  ["0xF130003F1101596F"]  = SQUARE, -- Deathknight Captain
})

addToDefaultNpcsToMark(L["Naxxramas"], "military_static_5", {
  ["0xF130003F12015975"]  = SKULL, -- Deathknight
  ["0xF130003F12015974"]  = CROSS, -- Deathknight
  ["0xF130003F11015970"]  = SQUARE, -- Deathknight Captain
})

addToDefaultNpcsToMark(L["Naxxramas"], "military_static_6", {
  ["0xF130003F12015977"]  = SKULL, -- Deathknight
  ["0xF130003F12015976"]  = CROSS, -- Deathknight
  ["0xF130003F11015971"]  = SQUARE, -- Deathknight Captain
})

addToDefaultNpcsToMark(L["Naxxramas"], "military_static_7", {
  ["0xF130003F1201597C"]  = SKULL, -- Deathknight
  ["0xF130003F1E01597B"]  = CROSS, -- Death Touched Warrior
  ["0xF130003F1D01597E"]  = SQUARE, -- Doom Touched Warrior
  ["0xF130003F1101597D"]  = MOON, -- Deathknight Captain
})

addToDefaultNpcsToMark(L["Naxxramas"], "military_horse_duo", {
  ["0xF130003F23269C6E"]  = SKULL, -- Deathknight Cavalier
  ["0xF130003F23269C6D"]  = CROSS, -- Deathknight Cavalier
})

addToDefaultNpcsToMark(L["Naxxramas"], "military_horse_1", {
  ["0xF130003F2301597F"]  = SKULL, -- Deathknight Cavalier
  ["0xF130003F1E015982"]  = CROSS, -- Death Touched Warrior
  ["0xF130003F1E015981"]  = SQUARE, -- Death Touched Warrior
  ["0xF130003F1E015989"]  = MOON, -- Death Touched Warrior
})

addToDefaultNpcsToMark(L["Naxxramas"], "military_horse_2", {
  ["0xF130003F23015980"]  = SKULL, -- Deathknight Cavalier
  ["0xF130003F1C015983"]  = CROSS, -- Dark Touched Warrior
  ["0xF130003F1C015984"]  = SQUARE, -- Dark Touched Warrior
  ["0xF130003F1D015985"]  = MOON, -- Doom Touched Warrior
})

addToDefaultNpcsToMark(L["Naxxramas"], "military_horse_3", {
  ["0xF130003F23269C6C"]  = SKULL, -- Deathknight Cavalier
  ["0xF130003F1C015988"]  = CROSS, -- Dark Touched Warrior
  ["0xF130003F1A015987"]  = SQUARE, -- Risen Deathknight
  ["0xF130003F1A015986"]  = MOON, -- Risen Deathknight
})

addToDefaultNpcsToMark(L["Naxxramas"], "military_horse_trio", {
  ["0xF1300041DD082208"]  = SKULL, -- Death Lord
  ["0xF130003F23015992"]  = CROSS, -- Deathknight Cavalier
  ["0xF130003F23015991"]  = SQUARE, -- Deathknight Cavalier
})

addToDefaultNpcsToMark(L["Naxxramas"], "military_horse_4", {
  ["0xF130003F23015993"]  = SKULL, -- Deathknight Cavalier
  ["0xF130003F1C01598A"]  = CROSS, -- Dark Touched Warrior
  ["0xF130003F1C01598B"]  = SQUARE, -- Dark Touched Warrior
  ["0xF130003F1D01598C"]  = MOON, -- Doom Touched Warrior
})

addToDefaultNpcsToMark(L["Naxxramas"], "military_razuvious", {
  ["0xF1300041A304A65F"]  = DIAMOND, -- Deathknight Understudy, left far
  ["0xF1300041A304A660"]  = STAR, -- Deathknight Understudy, right far
  ["0xF1300041A304A661"]  = TRIANGLE, -- Deathknight Understudy, left close
  ["0xF1300041A304A662"]  = CIRCLE, -- Deathknight Understudy, right close
  ["0xF130003EBD01598C"]  = SKULL, -- Instructor Razuvious
})

addToDefaultNpcsToMark(L["Naxxramas"], "military_weps_1", {
  ["0xF130003F4201F334"]  = SKULL, -- Unholy Axe
  ["0xF130003F4201F335"]  = CROSS, -- Unholy Axe
})

addToDefaultNpcsToMark(L["Naxxramas"], "military_weps_2", {
  ["0xF130003F5801F350"]  = SKULL, -- Unholy Swords
  ["0xF130003F4201F336"]  = CROSS, -- Unholy Axe
})

addToDefaultNpcsToMark(L["Naxxramas"], "military_weps_3", {
  ["0xF130003F5801F34F"]  = SKULL, -- Unholy Swords
  ["0xF130003F4201F337"]  = CROSS, -- Unholy Axe
})

addToDefaultNpcsToMark(L["Naxxramas"], "military_weps_4", {
  ["0xF130003F5701F34A"]  = SKULL, -- Unholy Staff
  ["0xF130003F4201F333"]  = CROSS, -- Unholy Axe
})

addToDefaultNpcsToMark(L["Naxxramas"], "military_weps_5", {
  ["0xF130003F5701F34B"]  = SKULL, -- Unholy Staff
  ["0xF130003F57269C68"]  = CROSS, -- Unholy Staff
})

addToDefaultNpcsToMark(L["Naxxramas"], "military_gothik_horses", {
  ["0xF130003F2301599A"]  = SKULL, -- Deathknight Cavalier
  ["0xF130003F23015999"]  = CROSS, -- Deathknight Cavalier
})

addToDefaultNpcsToMark(L["Naxxramas"], "military_gothik_shade", {
  ["0xF130003F24015996"]  = SKULL, -- Shade of Naxxramas
  ["0xF130003F25015998"]  = CROSS, -- Necro Knight
  ["0xF130003F25015997"]  = SQUARE, -- Necro Knight
})

addToDefaultNpcsToMark(L["Naxxramas"], "gothick_ring_ghouls", {
  ["0xF13000403F015B30"] = SQUARE, -- Plagued Ghoul
  ["0xF13000403F015B33"] = SKULL, -- Plagued Ghoul
  ["0xF13000403F015B31"] = MOON, -- Plagued Ghoul
  ["0xF13000403F015B32"] = CROSS, -- Plagued Ghoul
})

addToDefaultNpcsToMark(L["Naxxramas"], "gothick_ring_horse", {
  ["0xF130004044015ADC"] = SKULL, -- Necro Knight
  ["0xF130004044015ADD"] = CROSS, -- Necro Knight
})

addToDefaultNpcsToMark(L["Naxxramas"], "military_ring_acolyte_1", {
  ["0xF130003FF0015AD9"]  = SKULL, -- Necropolis Acolyte
  ["0xF130003FF0015ADA"]  = CROSS, -- Necropolis Acolyte
  ["0xF130004043015ADB"]  = DIAMOND, -- Deathknight Vindicator
  ["0xF13000403E015B42"]  = TRIANGLE, -- Plagued Gargoyle
  ["0xF13000403E269C6F"]  = UNMARKED, -- Plagued Gargoyle
})

addToDefaultNpcsToMark(L["Naxxramas"], "military_ring_acolyte_2", {
  ["0xF130003FF0015ADE"]  = SKULL, -- Necropolis Acolyte
  ["0xF130003FF0015ADF"]  = CROSS, -- Necropolis Acolyte
})

addToDefaultNpcsToMark(L["Naxxramas"], "military_ring_ghouls1", {
  ["0xF13000403F015B39"] = SKULL,
  ["0xF13000403F015B3A"] = MOON,
  ["0xF13000403F015B3B"] = SQUARE,
  ["0xF13000403F015B3C"] = CROSS,
})

addToDefaultNpcsToMark(L["Naxxramas"], "military_ring_acolyte_3", {
  ["0xF130003FF0015AE0"]  = SKULL, -- Necropolis Acolyte
  ["0xF130003FF0015AE1"]  = CROSS, -- Necropolis Acolyte
})

addToDefaultNpcsToMark(L["Naxxramas"], "military_ring_four_horsemen", {
  ["0xF130003EBE015AB3"]  = SKULL, -- Highlord Mograine
  ["0xF130003EC0015AB0"]  = CROSS, -- Thane Korth'azz
  ["0xF130003EBF015AB2"]  = SQUARE, -- Sir Zeliak
  ["0xF130003EC1015AB1"]  = MOON, -- Lady Blaumeux
})

----/////////////// PLAGUE ///////////////

addToDefaultNpcsToMark(L["Naxxramas"], "plague_1", {
  ["0xF130003F2801581F"] = CIRCLE, -- Stoneskin Gargoyle (patrol)
  ["0xF130003F74015811"] = SQUARE, -- Infectious Ghoul
  ["0xF130003F74015813"] = CROSS, -- Infectious Ghoul
  ["0xF130003F74015812"] = SKULL, -- Infectious Ghoul
  ["0xF130003F73015810"] = MOON, -- Plague Slime
  ["0xF130003F7301580F"] = STAR, -- Plague Slime
})

addToDefaultNpcsToMark(L["Naxxramas"], "plague_2", {
  ["0xF130003F73015817"] = MOON, -- Plague Slime
  ["0xF130003F73015816"] = STAR, -- Plague Slime
  ["0xF130003F74015814"] = SQUARE, -- Infectious Ghoul
  ["0xF130003F74015815"] = CROSS, -- Infectious Ghoul
  ["0xF130003F74015818"] = SKULL, -- Infectious Ghoul
})

addToDefaultNpcsToMark(L["Naxxramas"], "plague_gargs1_pat", {
  ["0xF130003F2801581E"] = STAR, -- pat
})

addToDefaultNpcsToMark(L["Naxxramas"], "plague_gargs1", {
  ["0xF130003F2801581C"] = SKULL, -- stone1_right
  ["0xF130003F2801581D"] = CROSS,
})

addToDefaultNpcsToMark(L["Naxxramas"], "plague_gargs2", {
  ["0xF130003F28015820"] = SKULL, -- stone2_right
  ["0xF130003F28015821"] = CROSS,
})

addToDefaultNpcsToMark(L["Naxxramas"], "plague_gargs3", {
  ["0xF130003F28015822"] = SKULL, -- stone3_right
  ["0xF130003F28015823"] = CROSS,
})

addToDefaultNpcsToMark(L["Naxxramas"], "plague_ring_ghouls1", {
  ["0xF13000403F015C0C"] = SKULL,
  ["0xF13000403F015C0A"] = CROSS,
  ["0xF13000403F015C0D"] = SQUARE,
  ["0xF13000403F015C0B"] = MOON,
})

addToDefaultNpcsToMark(L["Naxxramas"], "plague_ring_ghouls2", {
  ["0xF13000403F015C0F"] = SKULL,
  ["0xF13000403F015C10"] = CROSS,
  ["0xF13000403F015C11"] = SQUARE,
  ["0xF13000403F015C0E"] = MOON,
})


----/////////////// CONSTRUCT ///////////////

addToDefaultNpcsToMark(L["Naxxramas"], "construct_entrance", {
  ["0xF130003E910158C7"]  = SKULL, -- Patchwork Golem
  ["0xF130003E910158C6"]  = CROSS, -- Patchwork Golem
  ["0xF130003E910158C5"]  = SQUARE, -- Patchwork Golem
  ["0xF130003E910158C8"]  = MOON, -- Patchwork Golem
})

addToDefaultNpcsToMark(L["Naxxramas"], "construct_entrance_patrol", {
  ["0xF130003E920158CD"]  = TRIANGLE, -- Bile Retcher
  ["0xF130003E920158CE"]  = DIAMOND, -- Bile Retcher
  ["0xF130003E9D015A90"]  = CIRCLE, -- Sludge Belcher
  ["0xF130003E9D015A91"]  = STAR, -- Sludge Belcher
})

addToDefaultNpcsToMark(L["Naxxramas"], "construct_central_left", {
  ["0xF130003E920158CF"]  = SKULL, -- Bile Retcher
  ["0xF130003E910158CA"]  = CROSS, -- Patchwork Golem
  ["0xF130003E910158C9"]  = SQUARE, -- Patchwork Golem
})

addToDefaultNpcsToMark(L["Naxxramas"], "construct_central_right", {
  ["0xF130003E920158D0"]  = SKULL, -- Bile Retcher
  ["0xF130003E910158CB"]  = CROSS, -- Patchwork Golem
  ["0xF130003E910158CC"]  = SQUARE, -- Patchwork Golem
})

addToDefaultNpcsToMark(L["Naxxramas"], "construct_central", {
  ["0xF130003E910158D8"]  = SKULL, -- Patchwork Golem
  ["0xF130003E910158D7"]  = CROSS, -- Patchwork Golem
  ["0xF130003E910158D6"]  = SQUARE, -- Patchwork Golem
  ["0xF130003E910158D9"]  = MOON, -- Patchwork Golem
})

addToDefaultNpcsToMark(L["Naxxramas"], "construct_patchwerk_patrol", {
  ["0xF130003E92015A93"]  = SKULL, -- Bile Retcher
  ["0xF130003E92015A8E"]  = TRIANGLE, -- Bile Retcher
  ["0xF130003E9D015A92"]  = CIRCLE, -- Sludge Belcher
  ["0xF130003E92015A8F"]  = STAR, -- Bile Retcher
})

addToDefaultNpcsToMark(L["Naxxramas"], "construct_scientist_1", {
  ["0xF130003E95269C46"] = SKULL, -- Living Monstrosity
  ["0xF130003E94269C4B"] = MOON, -- Mad Scientist
  ["0xF130003E94269C4C"] = SQUARE, -- Mad Scientist
  ["0xF130003E94269C4D"] = CROSS, -- Mad Scientist
  ["0xF130003E94269C4E"] = DIAMOND, -- Mad Scientist
})

addToDefaultNpcsToMark(L["Naxxramas"], "construct_scientist_2", {
  ["0xF130003E95269C4F"] = SKULL, -- Living Monstrosity
  ["0xF130003E94015AA1"] = MOON, -- Mad Scientist
  ["0xF130003E94015AA0"] = SQUARE, -- Mad Scientist
  ["0xF130003E94015A9F"] = CROSS, -- Mad Scientist
  ["0xF130003E94015A9E"] = DIAMOND, -- Mad Scientist
})

addToDefaultNpcsToMark(L["Naxxramas"], "construct_patchwerk", {
  ["0xF130003E91015A96"]  = SKULL, -- Patchwork Golem
  ["0xF130003E91015A94"]  = CROSS, -- Patchwork Golem
  ["0xF130003E91015A97"]  = SQUARE, -- Patchwork Golem
  ["0xF130003E91015A95"]  = MOON, -- Patchwork Golem
})

addToDefaultNpcsToMark(L["Naxxramas"], "construct_scientist_3", {
  ["0xF130003E95269C54"] = SKULL, -- Living Monstrosity
  ["0xF130003E94269C5C"] = MOON, -- Mad Scientist
  ["0xF130003E94269C5B"] = SQUARE, -- Mad Scientist
  ["0xF130003E94269C59"] = CROSS, -- Mad Scientist
  ["0xF130003E94269C5A"] = DIAMOND, -- Mad Scientist
})

addToDefaultNpcsToMark(L["Naxxramas"], "construct_scientist_4", {
  ["0xF130003E95269C5D"]  = SKULL, -- Living Monstrosity
  ["0xF130003E94269C61"]  = MOON, -- Mad Scientist
  ["0xF130003E94269C60"]  = SQUARE, -- Mad Scientist
  ["0xF130003E94269C5F"]  = CROSS, -- Mad Scientist
  ["0xF130003E94269C5E"]  = DIAMOND, -- Mad Scientist
})

addToDefaultNpcsToMark(L["Naxxramas"], "construct_scientist_5", {
  ["0xF130003E95269C66"] = SKULL, -- Living Monstrosity
  ["0xF130003E94015A85"] = MOON, -- Mad Scientist
  ["0xF130003E94015A86"] = SQUARE, -- Mad Scientist
  ["0xF130003E94015A87"] = CROSS, -- Mad Scientist
  ["0xF130003E94015A88"] = DIAMOND, -- Mad Scientist
})

addToDefaultNpcsToMark(L["Naxxramas"], "construct_grobb_entrance", {
  ["0xF130003E990158F2"]  = SKULL, -- Stitched Spewer
  ["0xF130003E990158F1"]  = CROSS, -- Stitched Spewer
})

addToDefaultNpcsToMark(L["Naxxramas"], "construct_grobb_left", {
  ["0xF130003E990158EC"]  = SKULL, -- Stitched Spewer
  ["0xF130003E990158EB"]  = CROSS, -- Stitched Spewer
})

addToDefaultNpcsToMark(L["Naxxramas"], "construct_grobb_far", {
  ["0xF130003E990158ED"]  = SKULL, -- Stitched Spewer
  ["0xF130003E99269D08"]  = CROSS, -- Stitched Spewer -- is this changing weekly?
  ["0xF130003E990158EE"]  = SQUARE, -- Stitched Spewer
})

--/////////////// AQ40 ///////////////

defaultNpcsToMark[L["Ahn'Qiraj"]] = {}

addToDefaultNpcsToMark(L["Ahn'Qiraj"], "entrance_1", {
  ["0xF130003BA0015613"]  = SKULL, -- Anubisath Sentinel
  ["0xF130003BA0015610"]  = MOON, -- Anubisath Sentinel
  ["0xF130003BA0015611"]  = SQUARE, -- Anubisath Sentinel
  ["0xF130003BA0015612"]  = CROSS, -- Anubisath Sentinel
})

addToDefaultNpcsToMark(L["Ahn'Qiraj"], "entrance_2", {
  ["0xF130003BA001560C"]  = SKULL, -- Anubisath Sentinel
  ["0xF130003BA001560D"]  = CROSS, -- Anubisath Sentinel
  ["0xF130003BA001560F"]  = MOON, -- Anubisath Sentinel
  ["0xF130003BA001560E"]  = SQUARE, -- Anubisath Sentinel
})
addToDefaultNpcsToMark(L["Ahn'Qiraj"], "entrance_patrols", {
  ["0xF130003B9E130799"] = STAR, -- Obsidian Eradicator
  ["0xF130003B9E01580A"] = TRIANGLE, -- Obsidian Eradicator
  ["0xF130003B9E13079A"] = DIAMOND, -- Obsidian Eradicator
})

addToDefaultNpcsToMark(L["Ahn'Qiraj"], "skeram", {
  ["0xF130003B9F01580B"]  = SQUARE, -- Skeram
  ["0xF130003B9F04A65A"]  = CROSS, -- Clone
  ["0xF130003B9F04A659"]  = SKULL, -- Clone
})

addToDefaultNpcsToMark(L["Ahn'Qiraj"], "brainwasher_1", {
  ["0xF130003B8F01562D"] = SKULL, -- Qiraji Brainwasher
  ["0xF130003B8101562C"] = SQUARE, -- Vekniss Guardian
  ["0xF130003B8101562B"] = CROSS, -- Vekniss Guardian
})

addToDefaultNpcsToMark(L["Ahn'Qiraj"], "warrior_1", {
  ["0xF130003B7E01567A"] = TRIANGLE, -- Vekniss Warrior
  ["0xF130003B7E015679"] = UNMARKED, -- Vekniss Warrior
  ["0xF130003B7E015678"] = UNMARKED -- Vekniss Warrior
})

addToDefaultNpcsToMark(L["Ahn'Qiraj"], "brainwasher_2", {
  ["0xF130003B81015630"]  = MOON, -- Vekniss Guardian
  ["0xF130003B8101562F"]  = SQUARE, -- Vekniss Guardian
  ["0xF130003B81015677"]  = CROSS, -- Vekniss Guardian
  ["0xF130003B8F01562E"]  = SKULL, -- Qiraji Brainwasher
})

addToDefaultNpcsToMark(L["Ahn'Qiraj"], "brainwasher_left", {
  ["0xF130003B8101563A"]  = SQUARE, -- Vekniss Guardian
  ["0xF130003B8F015636"]  = CROSS, -- Qiraji Brainwasher
  ["0xF130003B81015639"]  = MOON, -- Vekniss Guardian
  ["0xF130003B81015638"]  = TRIANGLE, -- Vekniss Guardian
  ["0xF130003B8F015637"]  = SKULL, -- Qiraji Brainwasher
})

addToDefaultNpcsToMark(L["Ahn'Qiraj"], "brainwasher_right", {
  ["0xF130003B8101563C"]  = MOON, -- Vekniss Guardian
  ["0xF130003B8F015634"]  = SKULL, -- Qiraji Brainwasher
  ["0xF130003B8101563D"]  = TRIANGLE, -- Vekniss Guardian
  ["0xF130003B8101563B"]  = SQUARE, -- Vekniss Guardian
  ["0xF130003B8F015635"]  = CROSS, -- Qiraji Brainwasher
})

addToDefaultNpcsToMark(L["Ahn'Qiraj"], "warrior_2", {
  ["0xF130003B7E049CA2"]  = STAR, -- Vekniss Warrior
  ["0xF130003B7E049CA4"]  = UNMARKED, -- Vekniss Warrior
  ["0xF130003B7E049CA3"]  = UNMARKED, -- Vekniss Warrior
})

addToDefaultNpcsToMark(L["Ahn'Qiraj"], "guardian_1", {
  ["0xF130003B81015644"]  = SQUARE, -- Vekniss Guardian
  ["0xF130003B81015645"]  = DIAMOND, -- Vekniss Guardian
  ["0xF130003B8113079F"]  = CROSS, -- Vekniss Guardian
  ["0xF130003B81015642"]  = SKULL, -- Vekniss Guardian
  ["0xF130003B81015643"]  = MOON, -- Vekniss Guardian
  ["0xF130003B81015641"]  = TRIANGLE, -- Vekniss Guardian
})

addToDefaultNpcsToMark(L["Ahn'Qiraj"], "guardian_2", {
  ["0xF130003B81015648"]  = CROSS, -- Vekniss Guardian
  ["0xF130003B81015649"]  = TRIANGLE, -- Vekniss Guardian
  ["0xF130003B81015647"]  = SQUARE, -- Vekniss Guardian
  ["0xF130003B8101564A"]  = MOON, -- Vekniss Guardian
  ["0xF130003B81015646"]  = DIAMOND, -- Vekniss Guardian
  ["0xF130003B8101564B"]  = SKULL, -- Vekniss Guardian
})

addToDefaultNpcsToMark(L["Ahn'Qiraj"], "guardian_3", {
  ["0xF130003B8101564E"]  = SQUARE, -- Vekniss Guardian
  ["0xF130003B8101564F"]  = SKULL, -- Vekniss Guardian
  ["0xF130003B8101564C"]  = CROSS, -- Vekniss Guardian
  ["0xF130003B81015650"]  = DIAMOND, -- Vekniss Guardian
  ["0xF130003B8101564D"]  = TRIANGLE, -- Vekniss Guardian
  ["0xF130003B81015651"]  = MOON, -- Vekniss Guardian
})

addToDefaultNpcsToMark(L["Ahn'Qiraj"], "guardian_4", {
  ["0xF130003B8101565B"]  = TRIANGLE, -- Vekniss Guardian
  ["0xF130003B81015657"]  = CROSS, -- Vekniss Guardian
  ["0xF130003B8101565A"]  = DIAMOND, -- Vekniss Guardian
  ["0xF130003B81015658"]  = SQUARE, -- Vekniss Guardian
  ["0xF130003B8101565C"]  = MOON, -- Vekniss Guardian
  ["0xF130003B81015659"]  = SKULL, -- Vekniss Guardian
})

addToDefaultNpcsToMark(L["Ahn'Qiraj"], "sartura", {
  ["0xF130003E70015662"]  = CROSS, -- Sartura's Royal Guard
  ["0xF130003E70015661"]  = SQUARE, -- Sartura's Royal Guard
  ["0xF130003E70015663"]  = MOON, -- Sartura's Royal Guard
  ["0xF130003C9C015660"]  = SKULL, -- Battleguard Sartura
})

addToDefaultNpcsToMark(L["Ahn'Qiraj"], "soldiers", {
  ["0xF130003B7D015762"]  = SKULL, -- Vekniss Soldier
  ["0xF130003B7D01575D"]  = TRIANGLE, -- Vekniss Soldier
  ["0xF130003B7D01575F"]  = SQUARE, -- Vekniss Soldier
  ["0xF130003B7D015760"]  = CROSS, -- Vekniss Soldier
  ["0xF130003B7D01575E"]  = MOON, -- Vekniss Soldier
})

addToDefaultNpcsToMark(L["Ahn'Qiraj"], "scorpions", {
  ["0xF130003B88015798"]  = SKULL, -- Vekniss Hive Crawler
  ["0xF130003B88015799"]  = CROSS, -- Vekniss Hive Crawler
  ["0xF130003B881307A3"]  = MOON, -- Vekniss Hive Crawler
  ["0xF130003B881307A4"]  = SQUARE, -- Vekniss Hive Crawler
})

addToDefaultNpcsToMark(L["Ahn'Qiraj"], "scorpions2", {
  ["0xF130003B8801578E"]  = SKULL, -- Vekniss Hive Crawler
  ["0xF130003B8801578F"]  = CROSS, -- Vekniss Hive Crawler
})

addToDefaultNpcsToMark(L["Ahn'Qiraj"], "lashers", {
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

addToDefaultNpcsToMark(L["Ahn'Qiraj"], "defenders", {
  ["0xF130003BAD0157CF"] = SKULL, -- Anubisath Defender
  ["0xF130003BAD0157D1"] = CROSS, -- Anubisath Defender
  ["0xF130003BAD0157D2"] = SQUARE, -- Anubisath Defender
  ["0xF130003BAD0157D0"] = MOON, -- Anubisath Defender
  ["0xF130003BAD0157D3"] = TRIANGLE -- Anubisath Defender
})

addToDefaultNpcsToMark(L["Ahn'Qiraj"], "champions", {
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

defaultNpcsToMark[L["Zul'Gurub"]] = {}

--/////////////// Entrance to Jindo ///////////////

addToDefaultNpcsToMark(L["Zul'Gurub"], "entrance_snakes_left_1", {
  ["0xF130002C6C00BFC2"] = SKULL,
  ["0xF130002C6B00BFC3"] = CROSS,
})
addToDefaultNpcsToMark(L["Zul'Gurub"], "entrance_priest_left", {
  ["0xF130002E3600BFDB"] = SKULL,
  ["0xF130002C5600BFDA"] = MOON,
})

addToDefaultNpcsToMark(L["Zul'Gurub"], "jindo_entrance_patrols", {
  ["0xF1300039E911E65A"] = UNMARKED,
  ["0xF130002E36016542"] = DIAMOND,
  ["0xF1300039E911E65D"] = STAR,
  ["0xF130002C5800CAEC"] = SKULL,
  ["0xF1300039E911E65C"] = UNMARKED,
  ["0xF1300039E911E65B"] = UNMARKED,
  ["0xF130002C57016541"] = TRIANGLE,
})

addToDefaultNpcsToMark(L["Zul'Gurub"], "jindo_misress_1_patrol", {
  ["0xF1300039E911E657"] = STAR,
  ["0xF1300039E900C0F6"] = UNMARKED,
  ["0xF1300039E900C0F5"] = UNMARKED,
  ["0xF1300039E911E658"] = UNMARKED,
  ["0xF1300039E911E659"] = UNMARKED,
  ["0xF130003A2200C0F7"] = UNMARKED,
  ["0xF1300039E911E656"] = UNMARKED,
  ["0xF130003A2200C0F8"] = UNMARKED,
  ["0xF130003A2200C1A8"] = DIAMOND, -- jindo pull 2nd from back, left
  ["0xF130003A2200C1A9"] = CIRCLE, -- jindo pull 2nd from back, right
})

addToDefaultNpcsToMark(L["Zul'Gurub"], "jindo_mistress_2", {
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

addToDefaultNpcsToMark(L["Zul'Gurub"], "jindo_boss_pack", {
  ["0xF1300039E900C1A5"] = UNMARKED,
  ["0xF1300039E900C0FA"] = UNMARKED,
  ["0xF130003A2200C1A7"] = UNMARKED,
  ["0xF130002C7400C1F7"] = SKULL,
  ["0xF1300039E900C0FB"] = UNMARKED,
  ["0xF130003A2200C1A8"] = DIAMOND, -- 2nd from back, left
  ["0xF130003A2200C1A9"] = CIRCLE, -- 2nd from back, right
  ["0xF1300039E900C10D"] = UNMARKED,
  ["0xF130003A2300C1F2"] = SQUARE,
  ["0xF130003A2200C1A6"] = UNMARKED,
  ["0xF130003A2300C1C9"] = MOON,
})

--/////////////// Marli(Bat) ///////////////

addToDefaultNpcsToMark(L["Zul'Gurub"], "hill_bottom_priest", {
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
addToDefaultNpcsToMark(L["Zul'Gurub"], "consolidated_bat_1", cbat)

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
addToDefaultNpcsToMark(L["Zul'Gurub"], "consolidated_bat_2", cbat)


--/////////////// Venoxis ///////////////

addToDefaultNpcsToMark(L["Zul'Gurub"], "venoxis_two_axethrower", {
  ["0xF130002C5600BFD1"] = MOON,
  ["0xF130002C5600BFD0"] = SKULL,
})

addToDefaultNpcsToMark(L["Zul'Gurub"], "venoxis_priest_pat", {
  ["0xF130002C6C00C8FB"] = UNMARKED,
  ["0xF130002E3600C258"] = SKULL, -- priest
  ["0xF130002C6B00C8FC"] = UNMARKED,
  ["0xF130002C5600C257"] = MOON, -- axethrower
})

addToDefaultNpcsToMark(L["Zul'Gurub"], "venoxis_room", {
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

addToDefaultNpcsToMark(L["Zul'Gurub"], "venoxis_exit_snake_1", {
  ["0xF130002C6B00C250"] = UNMARKED,
  ["0xF130002C6B00C251"] = UNMARKED,
  ["0xF130002C6C00C252"] = SKULL,
  ["0xF130002C6B00C24F"] = UNMARKED,
})

addToDefaultNpcsToMark(L["Zul'Gurub"], "venoxis_exit_snake_2", {
  ["0xF130002C6C00BFC7"] = SKULL, -- adder
  ["0xF130002C6B00BFC6"] = UNMARKED,
  ["0xF130002C6B00BFC5"] = UNMARKED,
  ["0xF130002C6B00BFC4"] = UNMARKED,
})

--/////////////// Mandokir //////////////

addToDefaultNpcsToMark(L["Zul'Gurub"], "zanza_tower_zerks", {
  ["0xF130002C5800CAFA"] = TRIANGLE,
  ["0xF130002C5800CAEB"] = DIAMOND,
  ["0xF130002C58016565"] = CIRCLE,
  ["0xF130002C5800C222"] = STAR,
})

addToDefaultNpcsToMark(L["Zul'Gurub"], "mandokir_entrance_and_zerk", {
  ["0xF130002E3600C278"] = SKULL,
  ["0xF130002C5900C280"] = UNMARKED,
  ["0xF130002C5900C27F"] = SQUARE,
  ["0xF130002C5900C271"] = UNMARKED,
  ["0xF130002E3600C279"] = CROSS,
  ["0xF130002C5900C270"] = MOON,
  ["0xF130002C5800C229"] = STAR,
})

addToDefaultNpcsToMark(L["Zul'Gurub"], "mandokir_room", {
  ["0xF130002E3600C287"] = SKULL, -- priest
  ["0xF130002C5900C285"] = MOON, -- blooddrinker
  ["0xF130002C5C00C282"] = STAR, -- guardian, pat
  ["0xF130002C5C00C283"] = UNMARKED, -- guardian
  ["0xF130002C5C00C281"] = UNMARKED, -- guardian
  ["0xF130002C5C00CB5B"] = UNMARKED, -- guardian
  ["0xF130002C5C00C284"] = UNMARKED, -- guardian
  ["0xF130002C5C00CB88"] = UNMARKED, -- guardian

  -- to mark room easier
  ["0xF1300039E500C974"] = UNMARKED, -- raptors
  ["0xF1300039E500CB00"] = UNMARKED, -- raptors
  ["0xF1300039E500C972"] = UNMARKED, -- raptors
  ["0xF1300039E500C973"] = UNMARKED, -- raptors
  ["0xF1300039E500CAFF"] = UNMARKED, -- raptors
  ["0xF1300039E500CB01"] = UNMARKED, -- raptors
})

addToDefaultNpcsToMark(L["Zul'Gurub"], "zanaz_witchdoctor_rtv", {
  ["0xF130002C6100CAF2"] = UNMARKED,
  ["0xF130002E37016557"] = SKULL,
  ["0xF130002C6100CAF1"] = UNMARKED,
  ["0xF130002C56016556"] = MOON,
})

--/////////////// Madness /////////////

addToDefaultNpcsToMark(L["Zul'Gurub"], "madness1", {
  ["0xF130003B0700BFA4"] = DIAMOND,
  ["0xF130003B0700BFA3"] = SKULL,
  ["0xF130003B0700BFA5"] = CROSS,
  ["0xF130000B6200BF8D"] = UNMARKED,
  ["0xF130003B0700BFA0"] = CIRCLE,
})

addToDefaultNpcsToMark(L["Zul'Gurub"], "madness2", {
  ["0xF130003B0700BF9F"] = DIAMOND,
  ["0xF130003B0700BFA1"] = CROSS,
  ["0xF130003B0700BF9D"] = SKULL,
  ["0xF130003B0700BF9E"] = TRIANGLE,
})

addToDefaultNpcsToMark(L["Zul'Gurub"], "madness3", {
  ["0xF130003B0700BFAA"] = CROSS,
  ["0xF130003B0700BFA9"] = DIAMOND,
  ["0xF130003B0700BFAB"] = TRIANGLE,
  ["0xF130002C4C00BF9B"] = SKULL,
})

addToDefaultNpcsToMark(L["Zul'Gurub"], "madness4", {
  ["0xF130002C4C00BF9C"] = SKULL,
  ["0xF130003B0700BFA8"] = DIAMOND,
  ["0xF130003B0700BFA6"] = TRIANGLE,
  ["0xF130003B0700BFA7"] = CROSS,
})

--/////////////// Thekal //////////////

addToDefaultNpcsToMark(L["Zul'Gurub"], "thekal_pack", {
  ["0xF13000390700C09E"] = DIAMOND,
  ["0xF130002C5300C0A2"] = SQUARE,
  ["0xF130002C5400C0A1"] = TRIANGLE,

  -- to mark thekal easier
  ["0xF130002C6100C08D"] = UNMARKED, -- tiger
  ["0xF130002C6100C08A"] = UNMARKED, -- tiger
  ["0xF130002C6100C089"] = UNMARKED, -- tiger
  ["0xF130002C6100C08E"] = UNMARKED, -- tiger
  ["0xF130002C6100C08C"] = UNMARKED, -- tiger
  ["0xF130002C6100C08B"] = UNMARKED, -- tiger
  ["0xF130002C6000C09A"] = UNMARKED, -- tiger cub
  ["0xF130002C6000C098"] = UNMARKED, -- tiger cub
  ["0xF130002C6000C97C"] = UNMARKED, -- tiger cub
  ["0xF130002C6000C97D"] = UNMARKED, -- tiger cub
  ["0xF130002C6000C288"] = UNMARKED, -- tiger cub
  ["0xF130002C6000C292"] = UNMARKED, -- tiger cub
})

addToDefaultNpcsToMark(L["Zul'Gurub"], "gaz_fish", {
  ["0xF130002C6E00C242"] = TRIANGLE,
  ["0xF130002C6E00BFAD"] = CIRCLE,
  ["0xF130002C6E00C8F4"] = DIAMOND,
  ["0xF130002C6E00C23E"] = STAR,
  ["0xF130002C6E00BFAF"] = CROSS,

  -- to mark fish easier
  ["0xF130003AC300C22C"] = UNMARKED, -- croc
  ["0xF130003AC300C22D"] = UNMARKED, -- croc
  ["0xF130003AC300C22B"] = SKULL, -- croc
  ["0xF130003AC300C22A"] = UNMARKED, -- croc

})

addToDefaultNpcsToMark(L["Zul'Gurub"], "thekal_zerk_panther", {
  ["0xF130002C5801652B"] = STAR,
  ["0xF130002C6500C0A6"] = UNMARKED,
  ["0xF130002C6500C0A7"] = UNMARKED,
  ["0xF130002C6500C0A8"] = CIRCLE,
})

--/////////////// Arlok ///////////////

addToDefaultNpcsToMark(L["Zul'Gurub"], "arlok_1", {
  ["0xF130002C4B00C899"] = UNMARKED,
  ["0xF130002C4B00C8A4"] = SKULL,
  ["0xF130002C4B00C89A"] = CROSS,
  ["0xF130002C4B00C8A3"] = UNMARKED,
})

addToDefaultNpcsToMark(L["Zul'Gurub"], "arlok_2", {
  ["0xF130002C6500C0C2"] = UNMARKED,
  ["0xF130002C6500C0C1"] = UNMARKED,
  ["0xF130002C5900C98B"] = MOON,
  ["0xF130002C5900C98A"] = SQUARE,
  ["0xF130002C6500C0C0"] = UNMARKED,
  ["0xF130002C6500C0BF"] = SKULL,
})

addToDefaultNpcsToMark(L["Zul'Gurub"], "arlok_3", {
  ["0xF130002C6500C0BD"] = UNMARKED, -- panther
  ["0xF130002C6500C0BE"] = SKULL, -- panther
  ["0xF130002C4B00C0B1"] = TRIANGLE, -- shadow hunter
  ["0xF130002C6500C0BB"] = UNMARKED, -- panther
  ["0xF130002C6500C0BC"] = UNMARKED, -- panther
})

addToDefaultNpcsToMark(L["Zul'Gurub"], "arlok_4", {
  ["0xF130002C6500C8B7"] = UNMARKED,
  ["0xF130002C6500C8B5"] = SKULL,
  ["0xF130002C6500C8AF"] = UNMARKED,
  ["0xF130002C4B00C8A5"] = DIAMOND, -- shadow hunter
  ["0xF130002C6500C8B6"] = UNMARKED,
  ["0xF130002C4B00C8A6"] = TRIANGLE, -- shadow hunter
})

addToDefaultNpcsToMark(L["Zul'Gurub"], "arlokk", {
  ["0xF1300038B3276EF0"] = CIRCLE,
})

--/////////////// Hakkar ///////////////

addToDefaultNpcsToMark(L["Zul'Gurub"], "hakkar_bottom", {
  ["0xF130003AC300C231"] = CROSS, -- left zerk
  ["0xF130002C5800C8C3"] = STAR, -- crocs
  ["0xF130002C5800C8C4"] = SKULL, -- right zerk
})

addToDefaultNpcsToMark(L["Zul'Gurub"], "hakkar_sons", {
  ["0xF130002C5D00BF8A"] = DIAMOND,
  ["0xF130002C5D00BF89"] = CIRCLE,
})

addToDefaultNpcsToMark(L["Zul'Gurub"], "hakkar_soulflayer_1", {
  ["0xF130002C5F00C8E0"] = MOON, -- son
  ["0xF130002C5D00C8E2"] = SKULL, -- flayer
  ["0xF130002C5D00C8E1"] = CROSS, -- son
})

addToDefaultNpcsToMark(L["Zul'Gurub"], "hakkar_soulflayer_2", {
  ["0xF130002C5D00C8E4"] = CROSS, -- son
  ["0xF130002C5D00C8E5"] = SKULL, -- flayer
  ["0xF130002C5F00C8E3"] = MOON, -- son
})

addToDefaultNpcsToMark(L["Zul'Gurub"], "hakkar_large_1", {
  ["0xF130002C5F00C8D7"] = MOON, -- soulflayer
  ["0xF130002C5800C204"] = UNMARKED,
  ["0xF130002E3600C8D6"] = SKULL, -- priest
  ["0xF130002C5C00C8D8"] = UNMARKED,
  ["0xF130002E3600C8D9"] = CROSS, -- priest
  ["0xF130002C5F11E679"] = SQUARE, -- soulflayer
})

addToDefaultNpcsToMark(L["Zul'Gurub"], "hakkar_large_2", {
  ["0xF130002C5F11F381"] = SQUARE, -- soulflayer
  ["0xF130002E3611F383"] = SKULL, -- priest
  ["0xF130002E3611F384"] = CROSS, -- priest
  ["0xF130002C5F11F380"] = MOON, -- soulflayer
  ["0xF130002C4C11F37E"] = UNMARKED,
  ["0xF130002C5C11F382"] = UNMARKED,
})

--/////////////// ES ///////////////

local errenius = "0xF13000ED4B2739FA"
local errenius_mark = CIRCLE

addToDefaultNpcsToMark(L["Emerald Sanctum"], "entrance", {
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

addToDefaultNpcsToMark(L["Emerald Sanctum"], "wyrmkin_pack_right_2", {
  ["0xF13000ED492739F3"] = SKULL, -- sanctum wyrmkin
  ["0xF13000ED492739F4"] = CROSS, -- sanctum wyrmkin
  ["0xF13000ED472739F5"] = SQUARE, -- sanctum dragonkin
  ["0xF13000ED462739F6"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED462739F7"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED462739F8"] = UNMARKED, -- sanctum dreamer
})

addToDefaultNpcsToMark(L["Emerald Sanctum"], "dreamer_pack_left_2", {
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

addToDefaultNpcsToMark(L["Emerald Sanctum"], "wyrmkin_pack_left_1", {
  ["0xF13000ED47273A1C"] = SQUARE, -- sanctum dragonkin
  ["0xF13000ED4A273A1A"] = MOON, -- sanctum scalebane
  ["0xF13000ED49273A18"] = CROSS, -- sanctum wyrmkin
  ["0xF13000EF1C275495"] = SKULL, -- sanctum supressor
  ["0xF13000ED47273A1E"] = STAR, -- sanctum dragonkin

  [errenius] = errenius_mark, -- increase chance of spotting him early
})

addToDefaultNpcsToMark(L["Emerald Sanctum"], "wyrmkin_pack_left_2", {
  ["0xF13000ED46273A26"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED46273A1F"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED49273A25"] = SKULL, -- sanctum wyrmkin
  ["0xF13000ED49273A24"] = STAR, -- sanctum wyrmkin
  ["0xF13000ED46273A20"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED46273A27"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED48273A19"] = CROSS, -- sanctum wrym
  [errenius] = errenius_mark, -- increase chance of spotting him early
})

addToDefaultNpcsToMark(L["Emerald Sanctum"], "dreamer_pack_right_1", {
  ["0xF13000ED462754A3"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED462754A4"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED462754A5"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED462754A6"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED462754A7"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED462754A8"] = UNMARKED, -- sanctum dreamer
  ["0xF13000ED462754A9"] = UNMARKED, -- sanctum dreamer

  [errenius] = errenius_mark, -- increase chance of spotting him early
})

addToDefaultNpcsToMark(L["Emerald Sanctum"], "wyrmkin_pack_left_3", {
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

addToDefaultNpcsToMark(L["Emerald Sanctum"], "dreamer_pack_end", {
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

addToDefaultNpcsToMark(L["Emerald Sanctum"], "wyrmkin_pack_right_3", {
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

addToDefaultNpcsToMark(L["Emerald Sanctum"], "solnius", {
  ["0xF13000ED4C2739E1"] = UNMARKED, -- solnius
})

--/////////////// MC ///////////////

addToDefaultNpcsToMark(L["Molten Core"], "giants1", {
  ["0xF130002D8A00DD81"] = CROSS,
  ["0xF130002D8A00DD80"] = SKULL,
})

addToDefaultNpcsToMark(L["Molten Core"], "pats1", {
  ["0xF130002D9900DE21"] = MOON,
  ["0xF130002F4500DE0C"] = TRIANGLE,
  ["0xF130002F4500DE07"] = CIRCLE,
  ["0xF130002D9900DE15"] = STAR,
  ["0xF130002D9900DE13"] = CROSS,
  ["0xF130002D9900DE14"] = SQUARE,
  ["0xF130002D9900DE16"] = DIAMOND,
})

addToDefaultNpcsToMark(L["Molten Core"], "giants2", {
  ["0xF130002D8A00DD8C"] = CROSS,
  ["0xF130002D8A00DD8D"] = SKULL,
})

addToDefaultNpcsToMark(L["Molten Core"], "lucifron", {
  ["0xF130002F5700DD1F"] = CROSS,
  ["0xF130002F5600DD1D"] = SKULL,
  ["0xF130002F5700DD1E"] = SQUARE,
})

addToDefaultNpcsToMark(L["Molten Core"], "imp_surgers", {
  ["0xF130002F4500DE0A"] = DIAMOND,
  ["0xF130002F4500DE0B"] = TRIANGLE,
  ["0xF130002F4500DE08"] = SKULL,
  ["0xF130002F4500DE09"] = CROSS,
})

addToDefaultNpcsToMark(L["Molten Core"], "giants3", {
  ["0xF130002D8A00DD83"] = CROSS,
  ["0xF130002D8A00DD82"] = SKULL,
})

addToDefaultNpcsToMark(L["Molten Core"], "gehennas", {
  ["0xF130002D8D00DDA2"] = CROSS,
  ["0xF130002D8D00DDA3"] = SQUARE,
  ["0xF130002FE300DDA1"] = SKULL,
})

addToDefaultNpcsToMark(L["Molten Core"], "giants4", {
  ["0xF130002D8A00DD86"] = SKULL,
  ["0xF130002D8B00DD87"] = CROSS, -- destroyer
})

addToDefaultNpcsToMark(L["Molten Core"], "pats2", {
  ["0xF130002D9900DE1E"] = CIRCLE,
  ["0xF130002D9900DE1A"] = TRIANGLE,
  ["0xF130002D9900DE20"] = DIAMOND,
  ["0xF130002D9900DE17"] = CROSS,
  ["0xF130002F4500DE11"] = STAR,
  ["0xF130002D9900DE19"] = SKULL,
  ["0xF130002F4500DE10"] = MOON,
  ["0xF130002D9900DE18"] = SQUARE,
})

addToDefaultNpcsToMark(L["Molten Core"], "giants5", {
  ["0xF130002D8B00DD7D"] = CROSS, -- destroyer
  ["0xF130002D8B00DD7C"] = SKULL, -- destroyer
})

addToDefaultNpcsToMark(L["Molten Core"], "garr", {
  ["0xF130002F4300DD28"] = STAR,
  ["0xF130002F4300DD2E"] = CIRCLE,
  ["0xF130002F4300DD2C"] = SQUARE,
  ["0xF130002F4300DD34"] = DIAMOND,
  ["0xF130002F4300DD2B"] = SKULL,
  ["0xF130002F4300DD32"] = CROSS,
  ["0xF130002F4300DD33"] = MOON,
  ["0xF130002F4300DD22"] = TRIANGLE,
})

addToDefaultNpcsToMark(L["Molten Core"], "baron_pack_1", {
  ["0xF130002D93016498"] = CROSS,
  ["0xF130002F2C016497"] = CIRCLE,
  ["0xF130002D92016496"] = SKULL,
  ["0xF130002F2C016499"] = DIAMOND,
})

addToDefaultNpcsToMark(L["Molten Core"], "baron_pack_2", {
  ["0xF130002F2C016480"] = CIRCLE,
  ["0xF130002F2C01647E"] = DIAMOND,
  ["0xF130002D9301647F"] = CROSS,
  ["0xF130002D9201647D"] = SKULL,
  ["0xF130002F1800DD4F"] = STAR, -- baron
})

addToDefaultNpcsToMark(L["Molten Core"], "baron_pack_3", {
  ["0xF130002D9301649C"] = CROSS,
  ["0xF130002D9201649A"] = SKULL,
  ["0xF130002F4401649B"] = CIRCLE,
  ["0xF130002FE800DD20"] = STAR, -- shazzrah
})

addToDefaultNpcsToMark(L["Molten Core"], "baron_pack_4", {
  ["0xF130002D9200DD92"] = SKULL,
  ["0xF130002F4400DD93"] = CIRCLE,
  ["0xF130002D9300DD94"] = CROSS,
})

addToDefaultNpcsToMark(L["Molten Core"], "baron_pack_5", {
  ["0xF130002F2C00DDD9"] = CIRCLE,
  ["0xF130002D9300DDDA"] = CROSS,
  ["0xF130002D9200DDD8"] = SKULL,
  ["0xF130002F2C00DDDB"] = DIAMOND,
})

addToDefaultNpcsToMark(L["Molten Core"], "sulfuron", {
  ["0xF130002D8E00DD69"] = MOON,
  ["0xF130002D8E00DD66"] = SQUARE,
  ["0xF130002D8E00DD67"] = CROSS,
  ["0xF130002F4200DD65"] = TRIANGLE,
  ["0xF130002D8E00DD6A"] = SKULL,
})

addToDefaultNpcsToMark(L["Molten Core"], "domo", {
  ["0xF130002D90278D51"] = DIAMOND, -- elite
  ["0xF130002D90278D52"] = STAR, -- elite
  ["0xF130002D90278D53"] = CIRCLE, -- elite
  ["0xF130002D90278D54"] = TRIANGLE, -- elite
  ["0xF130002D8F278D55"] = SKULL, -- healer
  ["0xF130002D8F278D56"] = SQUARE, -- healer
  ["0xF130002D8F278D57"] = MOON, -- healer
  ["0xF130002D8F278D58"] = CROSS, -- healer
  ["0xF130002EF2278D50"] = UNMARKED, -- domo
})

--/////////////// AQ20 ///////////////

addToDefaultNpcsToMark(L["Ruins of Ahn'Qiraj"], "entrance", {
  ["0xF130003BEF11FB53"] = TRIANGLE,
  ["0xF130003BDC0155E6"] = CIRCLE,
  ["0xF130003BDC11FAC8"] = SKULL,
})

addToDefaultNpcsToMark(L["Ruins of Ahn'Qiraj"], "entrance_pats", {
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

addToDefaultNpcsToMark(L["Ruins of Ahn'Qiraj"], "entrance_pats_2", {
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

addToDefaultNpcsToMark(L["Ruins of Ahn'Qiraj"], "general_rajaxx", {
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

addToDefaultNpcsToMark(L["Ruins of Ahn'Qiraj"], "buru_path", {
  ["0xF130003BE7014F7D"] = STAR,
  ["0xF130003BDC11FACC"] = CIRCLE,
  ["0xF130003BDC11FACD"] = SKULL,
  ["0xF130003BDB11FB96"] = TRIANGLE,
})

addToDefaultNpcsToMark(L["Ruins of Ahn'Qiraj"], "buru_slimes", {
  ["0xF130003BE711FE02"] = CROSS, -- slime
  ["0xF130003BE711FB9F"] = SKULL, -- slime
})

addToDefaultNpcsToMark(L["Ruins of Ahn'Qiraj"], "buru_eggs", {
  ["0xF130003C9A276DE0"] = CIRCLE, -- egg
  ["0xF130003C9A276DE1"] = DIAMOND, -- egg
  ["0xF130003C9A276DE2"] = TRIANGLE, -- egg
  ["0xF130003C9A276DE3"] = MOON, -- egg
  ["0xF130003C9A276DE4"] = SQUARE, -- egg
  ["0xF130003C9A276DE5"] = STAR, -- egg
  ["0xF130003C0A0162F9"] = UNMARKED, -- buru
})

addToDefaultNpcsToMark(L["Ruins of Ahn'Qiraj"], "resevoir", {
  ["0xF130003BE711FC27"] = SQUARE,
  ["0xF130003BEA11FC12"] = DIAMOND,
  ["0xF130003BEA0153E5"] = MOON,
  ["0xF130003BDC11FACE"] = SKULL,
  ["0xF130003BEA11FC39"] = TRIANGLE,
  ["0xF130003BDC11FACF"] = CIRCLE,
  ["0xF130003BE711FC2B"] = STAR,
})

addToDefaultNpcsToMark(L["Ruins of Ahn'Qiraj"], "ossirian_room", {
  ["0xF130003BFB11FBDC"] = CROSS,
  ["0xF130003BFB11FBDD"] = SKULL,
  ["0xF130003BFB0155C3"] = SQUARE,
  ["0xF130003BFB11FBE0"] = TRIANGLE,
  ["0xF130003BFB11FBDF"] = STAR,
  ["0xF130003BFB11FBDB"] = DIAMOND,
  ["0xF130003BFB11FBDE"] = CIRCLE,
  ["0xF130003BFB11FBE1"] = MOON,
})

--/////////////// BWL ///////////////

addToDefaultNpcsToMark(L["Blackwing Lair"], "bwl_razor", {
  ["0xF1300030930149A4"] = STAR, -- razorgore
  ["0xF13000310D0149A5"] = SKULL, -- grethok
  ["0xF1300038780149A7"] = UNMARKED,
  ["0xF1300038780149A6"] = UNMARKED,
})

addToDefaultNpcsToMark(L["Blackwing Lair"], "vael", {
  ["0xF1300032DC014A20"] = STAR,
  ["0xF1300036AC104CD6"] = CROSS,
  ["0xF1300036AC104CD5"] = SQUARE,
  ["0xF1300036AC104CD4"] = MOON,
  ["0xF1300036AC104DD3"] = TRIANGLE,
  ["0xF1300036AC104DD2"] = DIAMOND,
  ["0xF1300036AC104DD1"] = CIRCLE,
})

addToDefaultNpcsToMark(L["Blackwing Lair"], "wrym1", {
  ["0xF1300030B1014A2E"] = SQUARE,
  ["0xF1300030B1014A2D"] = MOON,
  ["0xF1300030B3014A27"] = STAR,
  ["0xF1300030B0014A2C"] = SKULL,
  ["0xF1300030B0014A2B"] = CROSS,
  ["0xF1300030AF014A33"] = DIAMOND,
  ["0xF1300030AF014A34"] = CIRCLE,
})

addToDefaultNpcsToMark(L["Blackwing Lair"], "wrym2", {
  ["0xF1300030B1014A30"] = MOON,
  ["0xF1300030B1014A2F"] = SQUARE,
  ["0xF1300030B3014A28"] = STAR,
  ["0xF1300030B0014A29"] = SKULL,
  ["0xF1300030B0014A2A"] = CROSS,
  ["0xF1300030AF014A31"] = DIAMOND,
  ["0xF1300030AF014A32"] = CIRCLE,
})

addToDefaultNpcsToMark(L["Blackwing Lair"], "supress1", {
  ["0xF1300030AA104BD1"] = CROSS, -- taskmaster
  ["0xF1300030AA104BD0"] = SQUARE, -- taskmaster
  ["0xF1300030AA104BCF"] = SKULL, -- taskmaster
  ["0xF1300030B40BA218"] = TRIANGLE, -- hatcher
  ["0xF1300030B40BA216"] = DIAMOND, -- hatcher
  ["0xF1300030B40BA08B"] = STAR, -- hatcher
})

addToDefaultNpcsToMark(L["Blackwing Lair"], "supress1_2", {
  ["0xF1300030AA104BD5"] = CROSS, -- taskmaster
  ["0xF1300030AA104BD4"] = SQUARE, -- taskmaster
  ["0xF1300030AA104BD3"] = SKULL, -- taskmaster
  ["0xF1300030B40BA43A"] = TRIANGLE, -- hatcher
  ["0xF1300030B40BA3BF"] = DIAMOND, -- hatcher
  ["0xF1300030B40BA395"] = STAR, -- hatcher
})

addToDefaultNpcsToMark(L["Blackwing Lair"], "supress2", {
  ["0xF1300030AA104BD8"] = CROSS, -- taskmaster
  ["0xF1300030AA104BD7"] = SQUARE, -- taskmaster
  ["0xF1300030AA104BD6"] = SKULL, -- taskmaster
  ["0xF1300030B40BA441"] = TRIANGLE, -- hatcher
  ["0xF1300030B40BA43F"] = DIAMOND, -- hatcher
  ["0xF1300030B40BA43D"] = STAR, -- hatcher
})

addToDefaultNpcsToMark(L["Blackwing Lair"], "supress2_2", {
  ["0xF1300030AA104BDB"] = CROSS, -- taskmaster
  ["0xF1300030AA104BDA"] = SQUARE, -- taskmaster
  ["0xF1300030AA104BD9"] = SKULL, -- taskmaster
  ["0xF1300030B40BA632"] = TRIANGLE, -- hatcher
  ["0xF1300030B40BA630"] = DIAMOND, -- hatcher
  ["0xF1300030B40BA62E"] = STAR, -- hatcher
  ["0xF130002EF10149A3"] = CIRCLE, -- lashlayer
})

addToDefaultNpcsToMark(L["Blackwing Lair"], "lab1", {
  ["0xF1300036AC11F796"] = UNMARKED,
  ["0xF1300036AC014A3C"] = UNMARKED,
  ["0xF1300036AC11F797"] = UNMARKED,
  ["0xF1300036AC014A37"] = UNMARKED,
  ["0xF1300036AC014A3B"] = UNMARKED,
  ["0xF1300036AC014A38"] = UNMARKED,
  ["0xF1300030AB014A3E"] = CROSS,
  ["0xF1300030AB014A3D"] = SKULL,
})

addToDefaultNpcsToMark(L["Blackwing Lair"], "lab2", {
  ["0xF1300036AC11F79B"] = UNMARKED,
  ["0xF1300030A9014A44"] = DIAMOND,
  ["0xF1300036AC014A4A"] = UNMARKED,
  ["0xF1300036AC11F79A"] = UNMARKED,
  ["0xF1300036AC014A47"] = UNMARKED,
  ["0xF1300036AC014A46"] = UNMARKED,
  ["0xF1300030AB014A42"] = SKULL,
  ["0xF1300030AB014A49"] = CROSS,
  ["0xF1300036AC014A48"] = UNMARKED,
  ["0xF1300036AC014A4B"] = UNMARKED,
  ["0xF1300030AD014A4D"] = CIRCLE,
  ["0xF130002ECF014A5C"] = TRIANGLE, -- firemaw
})

addToDefaultNpcsToMark(L["Blackwing Lair"], "lab3", {
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

addToDefaultNpcsToMark(L["Blackwing Lair"], "wyrmguard1", {
  ["0xF1300030AD014A6D"] = DIAMOND,
  ["0xF1300030AC014A70"] = SKULL,
  ["0xF1300030AD014A6E"] = CROSS,
  ["0xF1300030AD014A6F"] = CIRCLE,
})

addToDefaultNpcsToMark(L["Blackwing Lair"], "lab4", {
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

addToDefaultNpcsToMark(L["Blackwing Lair"], "lab5", {
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


addToDefaultNpcsToMark(L["Blackwing Lair"], "lab6", {
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
  ["0xF1300030AB014F0F"] = CROSS,
})

addToDefaultNpcsToMark(L["Blackwing Lair"], "lab7", {
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

addToDefaultNpcsToMark(L["Blackwing Lair"], "wyrmguard2", {
  ["0xF1300030AC014A9B"] = SKULL,
  ["0xF1300030AC014A9A"] = CROSS,
  ["0xF1300030AC014A94"] = CIRCLE,
  ["0xF130003841014A93"] = MOON,
  ["0xF130002ECD014F17"] = SQUARE, -- flamegor
  ["0xF130003909014F14"] = TRIANGLE, -- ebonroc
})

addToDefaultNpcsToMark(L["Blackwing Lair"], "wyrmguard3", {
  ["0xF1300030AC014A9F"] = CIRCLE,
  ["0xF1300030AC014AAA"] = SKULL,
  ["0xF1300030AC014AA8"] = CROSS,
  ["0xF1300036C4014F18"] = TRIANGLE, -- chromag
})


--/////////////// KARA10 ///////////////

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara1", {
  ["0xF13000EF0A2747D1"] = UNMARKED,
  ["0xF13000EF082747D2"] = CROSS,
  ["0xF13000EF0A2747D0"] = UNMARKED,
  ["0xF13000EF092747CF"] = UNMARKED,
  ["0xF13000EF082747D3"] = SKULL,
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara2", {
  ["0xF13000EF082747C1"] = SKULL,
  ["0xF13000EF082747C9"] = CROSS,
  ["0xF13000EF092747C7"] = UNMARKED,
  ["0xF130003A212755AA"] = UNMARKED,
  ["0xF13000EF0A2747C4"] = UNMARKED,
  ["0xF13000EF0A2747C6"] = UNMARKED,
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara3", {
  ["0xF13000EF0A2747AD"] = UNMARKED,
  ["0xF13000EF0A2747AE"] = UNMARKED,
  ["0xF13000EF072747AA"] = STAR,
  ["0xF13000EF082747B3"] = SKULL,
  ["0xF13000EF0A2747AF"] = UNMARKED,
  ["0xF130000FEB2755A4"] = UNMARKED,
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara4", {
  ["0xF13000EF082747A9"] = CROSS,
  ["0xF13000EF0A2747A8"] = UNMARKED,
  ["0xF13000EF092747AB"] = UNMARKED,
  ["0xF13000EF072747AA"] = STAR,
  ["0xF13000EF082747AC"] = SKULL,
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "rider", {
  ["0xF13000EF1B274792"] = CROSS,
  ["0xF13000EF1427470C"] = TRIANGLE,
  ["0xF13000EF13277329"] = UNMARKED,
  ["0xF13000EF1327732A"] = UNMARKED,
  ["0xF13000EF12274794"] = DIAMOND,
  ["0xF13000EF1B274795"] = SQUARE,
  ["0xF13000EF1B2747A2"] = SKULL,
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara5", {
  ["0xF13000EF152756BF"] = SKULL,
  ["0xF13000EF102756C0"] = UNMARKED,
  ["0xF13000EF102747BD"] = UNMARKED,
  ["0xF13000EF102747BE"] = UNMARKED,
  ["0xF13000EF152756BE"] = CROSS,
  ["0xF13000EF072747D4"] = TRIANGLE,
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara6", {
  ["0xF13000EF082747EB"] = CROSS,
  ["0xF13000EF0A2747AE"] = UNMARKED,
  ["0xF13000EF0A2747AF"] = UNMARKED,
  ["0xF13000EF0A2747AD"] = UNMARKED,
  ["0xF13000EF082747E7"] = SKULL,
  ["0xF13000EF0A2747E8"] = UNMARKED,
  ["0xF13000EF0A2747E9"] = UNMARKED,
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara7", {
  ["0xF13000EF0A2747DD"] = UNMARKED,
  ["0xF13000EF082747DE"] = SKULL,
  ["0xF13000EF082747DC"] = CROSS,
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara8", {
  ["0xF13000EF082747DA"] = CROSS,
  ["0xF13000EF0A2747DB"] = UNMARKED,
  ["0xF13000EF082747D9"] = SKULL,
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "imps1", {
  ["0xF13000EF0C274822"] = UNMARKED,
  ["0xF13000EF102747F0"] = SQUARE,
  ["0xF13000EF182747F4"] = TRIANGLE,
  ["0xF13000EF102747F1"] = UNMARKED,
  ["0xF13000EF102747E5"] = UNMARKED,
  ["0xF13000EF0B274824"] = SKULL,
  ["0xF13000EF102747E4"] = CROSS,
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "imps2", {
  ["0xF13000EF0C274808"] = UNMARKED,
  ["0xF13000EF0B274802"] = MOON,
  ["0xF13000EF0B274801"] = SQUARE,
  ["0xF13000EF0B274803"] = CROSS,
  ["0xF13000EF0B274806"] = SKULL,
  ["0xF13000EF0D274809"] = UNMARKED,
  ["0xF13000EF0D274804"] = UNMARKED,
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "imps3", {
  ["0xF13000EF0D27480F"] = UNMARKED,
  ["0xF13000EF0C274812"] = UNMARKED,
  ["0xF13000EF0B27480D"] = CROSS,
  ["0xF13000EF0B274811"] = SKULL,
  ["0xF13000EF0D27480E"] = UNMARKED,
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "imps4", {
  ["0xF13000EF0B27481B"] = SQUARE,
  ["0xF13000EF0B27481C"] = SKULL,
  ["0xF13000EF0B274819"] = CROSS,
  ["0xF13000EF0C274815"] = UNMARKED,
  ["0xF130003A212755AD"] = UNMARKED,
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "imps5", {
  ["0xF13000EF0C2747F9"] = UNMARKED,
  ["0xF13000EF0B2747F7"] = SKULL,
  ["0xF13000EF0D2747FB"] = UNMARKED,
  ["0xF130000FEB2755AE"] = UNMARKED,
  ["0xF13000EF0C274800"] = UNMARKED,
  ["0xF13000EF0C2747F8"] = UNMARKED,
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "imps6", {
  ["0xF13000EF0D27481F"] = UNMARKED,
  ["0xF13000EF0C274823"] = UNMARKED,
  ["0xF13000EF0D274814"] = UNMARKED,
  ["0xF13000EF0D27481A"] = TRIANGLE,
  ["0xF13000EF0C27481D"] = UNMARKED,
  ["0xF13000EF0D274817"] = UNMARKED,
  ["0xF13000EF0D274818"] = UNMARKED,
  ["0xF13000EF0B274820"] = SKULL,
  ["0xF13000EF0C27481E"] = UNMARKED,
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "imps7", {
  ["0xF13000EF0C2747FD"] = UNMARKED,
  ["0xF13000EF0B2747FA"] = SKULL,
  ["0xF13000EF0D2747FE"] = UNMARKED,
  ["0xF13000EF0B2747FC"] = CROSS,
  ["0xF13000EF0C2747FF"] = UNMARKED,
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "spiderpats", {
  ["0xF130003A212755BA"] = UNMARKED,
  ["0xF13000EF16274778"] = UNMARKED,
  ["0xF13000EF1927477B"] = UNMARKED,
  ["0xF13000EF16274776"] = UNMARKED,
  ["0xF13000EF152756C3"] = CROSS,
  ["0xF13000EF1627477E"] = UNMARKED,
  ["0xF13000EF16274772"] = UNMARKED,
  ["0xF13000EF182747F4"] = TRIANGLE,
  ["0xF13000EF19274775"] = UNMARKED,
  ["0xF13000EF1827477A"] = SKULL,
  ["0xF13000EF1827475C"] = SQUARE,
  ["0xF13000EF18274753"] = CIRCLE,
  ["0xF13000EF19274774"] = UNMARKED,
  ["0xF13000EF16274777"] = UNMARKED,
  ["0xF130003A212755B3"] = UNMARKED,
  ["0xF13000EF1627477F"] = UNMARKED,
  ["0xF13000EF19274773"] = UNMARKED,
  ["0xF130003A212755B2"] = UNMARKED,
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "moroes1", {
  ["0xF13000EF072747D5"] = SKULL, -- alpha
  ["0xF13000EF0A2747D7"] = UNMARKED,
  ["0xF13000EF082747EF"] = CROSS, -- darkcaster
  ["0xF13000EF0F2756DE"] = CIRCLE, -- magiskull
  ["0xF13000EF0A2747D6"] = UNMARKED,
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "moroes2", {
  ["0xF13000EF0F2756DD"] = CROSS,
  ["0xF13000EF0F2756E3"] = DIAMOND,
  ["0xF13000EF0F2756E4"] = TRIANGLE,
  ["0xF13000EF0F2756DE"] = CIRCLE,
  ["0xF13000EF0F2756DC"] = SKULL,
  })

addToDefaultNpcsToMark(L["Tower of Karazhan"], "moroes3", {
  ["0xF13000EF0E274841"] = UNMARKED,
  ["0xF13000EF0E27483D"] = UNMARKED,
  ["0xF13000EF1027484C"] = CROSS,
  ["0xF13000EF0E274842"] = UNMARKED,
  ["0xF13000EF0E27483E"] = UNMARKED,
  ["0xF13000EF10274840"] = UNMARKED,
  ["0xF13000EF0827483C"] = SKULL,
  ["0xF13000EF0F27482A"] = CIRCLE,
  ["0xF13000EF0E27483F"] = STAR,
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "moroes4", {
  ["0xF13000EF15274838"] = TRIANGLE,
  ["0xF13000EF19274828"] = UNMARKED,
  ["0xF13000EF15274839"] = SKULL,
  ["0xF13000EF1027483A"] = UNMARKED,
  ["0xF13000EF16274826"] = UNMARKED,
  ["0xF13000EF15274832"] = DIAMOND,
  ["0xF13000EF15274837"] = CROSS,
  ["0xF13000EF16274827"] = UNMARKED,
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "moroes5", {
  ["0xF13000EF15274845"] = SKULL,
  ["0xF13000EF10274849"] = UNMARKED,
  ["0xF13000EF15274847"] = CROSS,
  ["0xF13000EF15274832"] = DIAMOND,
})

--/////////////// Kara40 ///////////////


addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara_entrance_patrols", {
  ["0xF13000F1F0276B43"] = CIRCLE, -- Shadowclaw Darkbringer
  ["0xF13000F1F2276B2C"] = TRIANGLE, -- Shadowclaw Rager
  ["0xF13000F1ED276B19"] = DIAMOND, -- Greater Gloomwing
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara_entrance_1", {
  ["0xF13000F1EE276B1F"] = SKULL, -- Spectral Worker
  ["0xF13000F1EE276B20"] = SQUARE, -- Spectral Worker
  ["0xF13000F1EE276B21"] = CROSS, -- Spectral Worker
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara_entrance_2", {
  ["0xF13000F1EE276B25"] = SKULL, -- Spectral Worker
  ["0xF13000F1F1276B24"] = CROSS, -- Shadowclaw Worgen
  ["0xF13000F1F1276B23"] = SQUARE, -- Shadowclaw Worgen
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara_entrance_worgen_1", {
  ["0xF13000F1F1276B29"] = TRIANGLE, -- Shadowclaw Worgen
  ["0xF13000F1F1276B2B"] = SQUARE, -- Shadowclaw Worgen
  ["0xF13000F1F1276B27"] = MOON, -- Shadowclaw Worgen
  ["0xF13000F1F0276B28"] = SKULL, -- Shadowclaw Darkbringer
  ["0xF13000F1F2276B26"] = CROSS, -- Shadowclaw Rager
  ["0xF13000F1F1276B57"] = DIAMOND, -- Shadowclaw Worgen
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara_entrance_worgen_2", {
  ["0xF13000F1F0276B33"] = DIAMOND, -- Shadowclaw Darkbringer
  ["0xF13000F1EC276B2D"] = SQUARE, -- vampiric gloomwing
  ["0xF13000F1ED276B2E"] = MOON, -- greater gloomwing
  ["0xF13000F1EF276B36"] = SKULL, -- Duskfang Creeper
  ["0xF13000F1F2276B31"] = CROSS, -- rager
  ["0xF13000F1ED276B2F"] = TRIANGLE, -- Greater Gloomwing
  ["0xF13000F1F1276B30"] = UNMARKED, -- Shadowclaw Worgen
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara_entrance_worker", {
  ["0xF13000F1EE276B34"] = SKULL, -- Spectral Worker
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara_entrance_outer", {
  ["0xF13000F1ED276B39"] = SQUARE, -- Greater Gloomwing
  ["0xF13000F1EE276B37"] = SKULL, -- Spectral Worker
  ["0xF13000F1EE276B38"] = CROSS, -- Spectral Worker
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara_entrance_outer_2", {
  ["0xF13000F1EE276B3B"] = SKULL, -- Spectral Worker
  ["0xF13000F1F1276B3A"] = CROSS, -- Shadowclaw Worgen
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara_entrance_outer_3", {
  ["0xF13000F1F2276B41"] = SQUARE, -- Shadowclaw Rager
  ["0xF13000F1F2276B42"] = CROSS, -- Shadowclaw Rager
  ["0xF13000F1F1276B3D"] = TRIANGLE, -- Shadowclaw Worgen
  ["0xF13000F1F1276B3E"] = MOON, -- Shadowclaw Worgen
  ["0xF13000F1F0276B40"] = SKULL, -- Shadowclaw Darkbringer
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara_entrance_inner_2", {
  ["0xF13000F1F0276B48"] = SKULL, -- Shadowclaw Darkbringer
  ["0xF13000F1EC276B44"] = CROSS, -- Vampiric Gloomwing
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara_entrance_gnarlmoon", {
  ["0xF13000F1F2276B51"] = TRIANGLE, -- Shadowclaw Rager
  ["0xF13000F1F0276B4F"] = CROSS, -- Shadowclaw Darkbringer
  ["0xF13000F1F1276B54"] = DIAMOND, -- Shadowclaw Worgen
  ["0xF13000F1F2276B52"] = MOON, -- Shadowclaw Rager
  ["0xF13000F1F0276B53"] = SKULL, -- Shadowclaw Darkbringer
  ["0xF13000F1F1276B55"] = CIRCLE, -- Shadowclaw Worgen
  ["0xF13000F1F0276B50"] = SQUARE, -- Shadowclaw Darkbringer
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara_upper_demon_3", {
  ["0xF13000F48C278713"] = DIAMOND, -- invader
  ["0xF13000F48C278714"] = SKULL, -- invader
  ["0xF13000F48D278715"] = CROSS, -- destroyer
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara_entrance_inner_1", {
  ["0xF13000F1F0276B4A"] = CROSS,
  ["0xF13000F1F1276B46"] = SKULL,
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "gnarlmoon_owls", {
  ["0xF13000EA5E278C14"] = STAR,     -- blue owl 1, fake id
  ["0xF13000EA5E278C15"] = CIRCLE,   -- blue owl 2, fake id
  ["0xF13000EA5D278C16"] = DIAMOND,  -- red owl 1, fake id
  ["0xF13000EA5D278C17"] = TRIANGLE, -- red owl 2, fake id
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara_library_1", {
  ["0xF13000F1F8276B9C"] = CROSS, -- Manascale Mageweaver
  ["0xF13000F1F7276B9E"] = SKULL, -- Manascale Suppressor
  ["0xF13000F1F6276B9B"] = SQUARE, -- Manascale Dragon Guard
  ["0xF13000EA54276B8A"] = UNMARKED, -- Manascale Whelp ??wrong id??
  ["0xF13000F1F8276B9F"] = DIAMOND, -- Manascale Mageweaver
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara_library_patrols", {
  ["0xF13000F1F7276B70"] = DIAMOND, -- Manascale Suppressor
  ["0xF13000F1F6276B8C"] = STAR, -- Manascale Dragon Guard ??wrong id??
  ["0xF13000F1F7276BA0"] = TRIANGLE, -- Manascale Suppressor
  ["0xF13000F1F9276B5F"] = CIRCLE, -- Manascale Overseer
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara_library_2", {
  ["0xF13000EA54276B98"] = UNMARKED, -- Manascale Whelp
  ["0xF13000EA54276B9A"] = UNMARKED, -- Manascale Whelp
  ["0xF13000F1F8276B97"] = SKULL, -- Manascale Mageweaver
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara_library_3", {
  ["0xF13000EA54276B66"] = UNMARKED, -- Manascale Whelp
  ["0xF13000F1F8276B61"] = CROSS, -- Manascale Mageweaver
  ["0xF13000EA54276B63"] = UNMARKED, -- Manascale Whelp
  ["0xF13000EA54276B65"] = UNMARKED, -- Manascale Whelp
  ["0xF13000F1F8276B62"] = SKULL, -- Manascale Mageweaver
  ["0xF13000F1F6276B60"] = SQUARE, -- Manascale Dragon Guard
  ["0xF13000EA54276B64"] = UNMARKED, -- Manascale Whelp
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara_library_4", {
  ["0xF13000EA54276B8E"] = UNMARKED, -- Manascale Whelp
  ["0xF13000F1F4276B71"] = SKULL, -- Manascale Drake
  ["0xF13000EA54276B94"] = UNMARKED, -- Manascale Whelp
  ["0xF13000EA54276B91"] = UNMARKED, -- Manascale Whelp
  ["0xF13000EA54276B92"] = UNMARKED, -- Manascale Whelp
  ["0xF13000EA54276B96"] = UNMARKED, -- Manascale Whelp
  ["0xF13000EA54276B8F"] = UNMARKED, -- Manascale Whelp
  ["0xF13000EA54276B93"] = UNMARKED, -- Manascale Whelp
  ["0xF13000EA54276B8D"] = UNMARKED, -- Manascale Whelp
  ["0xF13000EA54276B95"] = UNMARKED, -- Manascale Whelp
})

-- skippable
addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara_library_5", {
  ["0xF13000F1F8276B80"] = CROSS,
  ["0xF13000F1F8276B81"] = SQUARE,
  ["0xF13000F1F8276B82"] = SKULL,
})

-- skippable
addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara_library_6", {
  ["0xF13000EA54276B79"] = UNMARKED,
  ["0xF13000EA54276B7B"] = UNMARKED,
  ["0xF13000F1F8276B73"] = SQUARE,
  ["0xF13000F1F6276B72"] = MOON,
  ["0xF13000EA54276B76"] = UNMARKED,
  ["0xF13000F1F7276B75"] = SKULL,
  ["0xF13000F1F7276B74"] = CROSS,
  ["0xF13000EA54276B7F"] = UNMARKED,
  ["0xF13000EA54276B7C"] = UNMARKED,
  ["0xF13000EA54276B7D"] = UNMARKED,
  ["0xF13000EA54276B7E"] = UNMARKED,
  ["0xF13000EA54276B77"] = UNMARKED,
  ["0xF13000EA54276B78"] = UNMARKED,
  ["0xF13000EA54276B7A"] = UNMARKED,
})

-- skippable
addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara_library_7", {
  ["0xF13000EA54276BA8"] = UNMARKED,
  ["0xF13000F1F7276BA4"] = SKULL,
  ["0xF13000F1F7276BA3"] = CROSS,
  ["0xF13000EA54276BA7"] = UNMARKED,
  ["0xF13000EA54276BA6"] = UNMARKED,
  ["0xF13000EA54276BAB"] = UNMARKED,
  ["0xF13000F1F8276BA2"] = SQUARE,
  ["0xF13000EA54276BA9"] = UNMARKED,
  ["0xF13000F1F6276BA1"] = TRIANGLE,
  ["0xF13000F1F6276BA5"] = MOON,
  ["0xF13000EA54276BAC"] = UNMARKED,
  ["0xF13000EA54276BAA"] = UNMARKED,
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara_library_8", {
  ["0xF13000F1F7276BAF"] = CROSS, -- Manascale Suppressor
  ["0xF13000F1F8276BB0"] = SQUARE, -- Manascale Mageweaver
  ["0xF13000F1F6276BB1"] = TRIANGLE, -- Manascale Dragon Guard
  ["0xF13000F1F6276BB2"] = MOON, -- Manascale Dragon Guard
  ["0xF13000F1F4276BAE"] = SKULL, -- Manascale Drake
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "incantagos_seekers", {
  ["0xF13000EA55278B84"] = SQUARE, -- Manascale Ley-Seeker
  ["0xF13000EA55278B83"] = CROSS, -- Manascale Ley-Seeker
  ["0xF13000EA55278B82"] = MOON, -- Manascale Ley-Seeker
  ["0xF13000EA55278B81"] = SKULL, -- Manascale Ley-Seeker
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara_library_upper_1", {
  ["0xF13000F1F8276BC0"] = SQUARE, -- Manascale Mageweaver
  ["0xF13000F1F72783E5"] = SKULL, -- Manascale Suppressor
  ["0xF13000F1F62783E9"] = MOON, -- Manascale Dragon Guard
  ["0xF13000F1F62783E7"] = TRIANGLE, -- Manascale Dragon Guard
  ["0xF13000EA54276BBE"] = UNMARKED, -- Manascale Whelp
  ["0xF13000EA54276BBF"] = UNMARKED, -- Manascale Whelp
  ["0xF13000EA54276BBB"] = UNMARKED, -- Manascale Whelp
  ["0xF13000EA54276BBC"] = UNMARKED, -- Manascale Whelp
  ["0xF13000F1F82783E8"] = CROSS, -- Manascale Mageweaver
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara_library_upper_patrols", {
  ["0xF13000F1F6276BC1"] = DIAMOND, -- Dragon Guard
  ["0xF13000F1FE276BD6"] = CIRCLE, -- Arcane Anomaly
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara_library_upper_2", {
  ["0xF13000F1F7276BC2"] = CROSS, -- Manascale Suppressor
  ["0xF13000EA54276BC9"] = UNMARKED, -- Manascale Whelp
  ["0xF13000EA54276BC5"] = UNMARKED, -- Manascale Whelp
  ["0xF13000EA54276BCA"] = UNMARKED, -- Manascale Whelp
  ["0xF13000EA54276BC7"] = UNMARKED, -- Manascale Whelp
  ["0xF13000EA54276BC8"] = UNMARKED, -- Manascale Whelp
  ["0xF13000F1F7276BC3"] = SKULL, -- Manascale Suppressor
  ["0xF13000F1FC2783E4"] = SQUARE, -- Unstable Arcane Elemental
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara_library_upper_3", {
  ["0xF13000F1FC276BCE"] = STAR, -- Unstable Arcane Elemental
  ["0xF13000F1F7276BCB"] = SKULL, -- Manascale Suppressor
  ["0xF13000F1FB276BCC"] = MOON, -- Arcane Overflow
  ["0xF13000F1FB276BCF"] = SQUARE, -- Arcane Overflow
  ["0xF13000F1FB276BCD"] = CROSS, -- Arcane Overflow
  ["0xF13000F1FC2783E3"] = DIAMOND, -- Unstable Arcane Elemental
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara_library_anomalus", {
  ["0xF13000F1FD276BDA"] = SKULL, -- Disrupted Arcane Elemental
  ["0xF13000F1FB276BD8"] = CROSS, -- Arcane Overflow
  ["0xF13000F1FB276BDB"] = SQUARE, -- Arcane Overflow
  ["0xF13000F1FB2783E2"] = MOON, -- Arcane Overflow
  ["0xF13000F1FC276BDC"] = DIAMOND, -- Unstable Arcane Elemental
  ["0xF13000F1FC276BD9"] = STAR, -- Unstable Arcane Elemental
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara_observatory_1", {
  ["0xF13000F1FB276BE1"] = MOON, -- Arcane Overflow
  ["0xF13000F1FB276BDD"] = TRIANGLE, -- Arcane Overflow
  ["0xF13000F1FE276BE0"] = DIAMOND, -- Arcane Anomaly
  ["0xF13000F1FB276BDF"] = SQUARE, -- Arcane Overflow
  ["0xF13000F1FC276BDE"] = SKULL, -- Unstable Arcane Elemental
  ["0xF13000F1FD2783E1"] = CROSS, -- Disrupted Arcane Elemental
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara_observatory_patrols", {
  ["0xF13000F1FB276D3D"] = MOON, -- Arcane Overflow
  ["0xF13000F203276D40"] = DIAMOND, -- Lingering Arcanist
  ["0xF13000F1FB276D3F"] = STAR, -- Arcane Overflow
  ["0xF13000F1F7276D3C"] = TRIANGLE, -- Manascale Suppressor
  ["0xF13000F205276D3E"] = CIRCLE, -- Lingering Enchanter
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara_observatory_2", {
  ["0xF13000F204276D36"] = SKULL, -- Lingering Astrologist
  ["0xF13000F203276D37"] = SQUARE, -- Lingering Arcanist
  ["0xF13000F202276D35"] = CROSS, -- Lingering Magus
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara_observatory_left", {
  ["0xF13000F202276D38"] = CROSS, -- Lingering Magus
  ["0xF13000F205276D39"] = MOON, -- Lingering Enchanter
  ["0xF13000F202276D3A"] = SQUARE, -- 0xF13000F202276D3A
  ["0xF13000F204276D3B"] = SKULL, -- 0xF13000F204276D3B
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara_observatory_3", {
  ["0xF13000F1FE276D4D"] = CIRCLE, -- Arcane Anomaly
  ["0xF13000F201276D61"] = SKULL, -- Karazhan Protector Golem
  ["0xF13000F201276D60"] = CROSS, -- Karazhan Protector Golem
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara_observatory_6", {
  ["0xF13000F200276D68"] = SQUARE,
  ["0xF13000F203276D52"] = CROSS,
  ["0xF13000F201276D66"] = TRIANGLE,
  ["0xF13000F202276D51"] = SKULL,
  ["0xF13000F201276D67"] = MOON,
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara_echo_pre_1", {
  ["0xF13000F203276D2F"] = MOON, -- Lingering Arcanist
  ["0xF13000F205276D33"] = TRIANGLE, -- Lingering Arcanist
  ["0xF13000F204276D32"] = SKULL, -- Lingering Astrologist
  ["0xF13000F202276D31"] = CROSS, -- Lingering Magus
  ["0xF13000F202276D30"] = SQUARE, -- Lingering Magus
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara_echo_pre_2_1", {
  ["0xF13000F200276D62"] = SQUARE, -- Crumbling Protector
  ["0xF13000F202276D2E"] = SKULL, -- magus
  ["0xF13000F1FE2783E6"] = CROSS, -- arcane anomaly
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara_echo_pre_2_2", {
  ["0xF13000F200276D63"] = SQUARE, -- Crumbling Protector
  ["0xF13000F204276D2B"] = SKULL, -- Lingering Astrologist
  ["0xF13000F205276D2C"] = MOON, -- Lingering Enchanter
  ["0xF13000F203276D2D"] = CROSS, -- Lingering Arcanist
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara_chess_1", {
  ["0xF13000F1FB276D47"] = TRIANGLE, -- Arcane Overflow
  ["0xF13000F204276D43"] = SKULL, -- Lingering Astrologist
  ["0xF13000F200276D64"] = MOON, -- Crumbling Protector
  ["0xF13000F205276D44"] = CROSS, -- Lingering Enchanter
  ["0xF13000F201276D65"] = SQUARE, -- Karazhan Protector Golem
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara_chess_2", {
  ["0xF13000F1FD2783E0"] = SQUARE, -- Disrupted Arcane Elemental
  ["0xF13000F204276D4A"] = CROSS, -- Lingering Astrologist
  ["0xF13000F202276D49"] = SKULL, -- Lingering Magus
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara_chess_3", {
  ["0xF13000F201276D66"] = TRIANGLE, -- Karazhan Protector Golem
  ["0xF13000F203276D52"] = CROSS, -- Lingering Arcanist
  ["0xF13000F201276D67"] = MOON, -- Karazhan Protector Golem
  ["0xF13000F202276D51"] = SKULL, -- Lingering Magus
  ["0xF13000F200276D68"] = SQUARE, -- Crumbling Protector
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara_chess", {
  ["0xF13000EA42276C07"] = CIRCLE,
  ["0xF13000BF75278779"] = SKULL,
  ["0xF13000EA40276C08"] = TRIANGLE,
  ["0xF13000EA43276C06"] = DIAMOND,
  ["0xF13000BF74278778"] = SQUARE,
  ["0xF13000BF76278777"] = CROSS,
  ["0xF13000EA3F276C05"] = STAR,
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara_foyer_1", {
  ["0xF13000F203276D54"] = SQUARE, -- Lingering Arcanist
  ["0xF13000F205276D55"] = MOON, -- Lingering Enchanter
  ["0xF13000F202276D53"] = SKULL, -- Lingering Magus
  ["0xF13000F204276D56"] = CROSS, -- Lingering Astrologist
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara_foyer_2", {
  ["0xF13000F202276D57"] = SKULL, -- Lingering Magus
  ["0xF13000F205276D5A"] = MOON, -- Lingering Enchanter
  ["0xF13000F203276D5B"] = SQUARE, -- Lingering Arcanist
  ["0xF13000F204276D58"] = CROSS, -- Lingering Astrologist
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara_foyer_3", {
  ["0xF13000F48F278747"] = CROSS, -- Forgotten Echo
  ["0xF13000F48F278746"] = SKULL, -- Forgotten Echo
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara_roof", {
  ["0xF13000F48F278741"] = SKULL, -- Forgotten Echo
  ["0xF13000F48F27873F"] = SQUARE, -- Forgotten Echo
  ["0xF13000F48F278740"] = CROSS, -- Forgotten Echo
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara_upper_demon_1", {
  ["0xF13000F48D278726"] = CROSS, -- destroyer
  ["0xF13000F48C278725"] = DIAMOND, -- invader
  ["0xF13000F48C278724"] = SKULL, -- invader
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara_upper_demon_2", {
  ["0xF13000F48C278713"] = DIAMOND, -- Desolate Invader
  ["0xF13000F48C278714"] = SKULL, -- Desolate Invader
  ["0xF13000F48D278715"] = CROSS, -- Desolate Destroyer
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara_upper_demon_3", {
  ["0xF13000F48C278710"] = DIAMOND, -- Desolate Invader
  ["0xF13000F48C278711"] = SKULL, -- Desolate Invader
  ["0xF13000F48D278712"] = CROSS, -- Desolate Destroyer
})

addToDefaultNpcsToMark(L["Tower of Karazhan"], "kara_upper_demon_4", {
  ["0xF13000F48C27870F"] = SKULL, -- invader
  ["0xF13000F48D27870D"] = SQUARE, -- destroyer
  ["0xF13000F48E27870B"] = MOON, -- Ima'ghaol
  ["0xF13000F48D27870C"] = CROSS, -- destroyer
})

addToDefaultNpcsToMark(L["???"], "darkbinders1", {
  ["0xF13000F243276CCD"] = SKULL, -- Warbringer Overseer
  ["0xF13000F245276CE7"] = CROSS, -- Draenei Darkbinder
  ["0xF13000F245276CE6"] = SQUARE, -- Draenei Darkbinder
  ["0xF13000F244276C76"] = MOON, -- souleater
})

addToDefaultNpcsToMark(L["???"], "village_1", {
  ["0xF13000F243276CCC"] = SKULL, -- Warbringer Overseer
})

addToDefaultNpcsToMark(L["???"], "village_2", {
  ["0xF13000F240276CCB"] = SKULL, -- Doomguard Annihilator
  ["0xF13000F242276CC9"] = CROSS, -- Darkflame Imp
  ["0xF13000F242276CC8"] = SQUARE, -- Darkflame Imp
})

addToDefaultNpcsToMark(L["???"], "village_3", {
  ["0xF13000F245276CD7"] = SKULL, -- Draenei Darkbinder
  ["0xF13000F245276CE2"] = CROSS, -- Draenei Darkbinder
  ["0xF13000F246276CDF"] = UNMARKED, -- Draenei Worshipper
  ["0xF13000F246276CE1"] = UNMARKED, -- Draenei Worshipper
  ["0xF13000F246276CE0"] = UNMARKED, -- Draenei Worshipper
  ["0xF13000F246276CDE"] = UNMARKED, -- Draenei Worshipper
  ["0xF13000F245276CD6"] = SQUARE, -- Draenei Darkbinder
})

addToDefaultNpcsToMark(L["???"], "infernal_2", {
  ["0xF13000F241276D0A"] = SKULL, -- infernal
  ["0xF13000F242276D0C"] = UNMARKED, --imp
  ["0xF13000F242276D0D"] = UNMARKED, --imp
  ["0xF13000F242276D0B"] = UNMARKED, --imp
  ["0xF13000F242276D0E"] = UNMARKED, --imp
})

addToDefaultNpcsToMark(L["???"], "sanv_1", {
  ["0xF13000F245276CDA"] = SKULL, -- Draenei Darkbinder
  ["0xF13000F244276CD9"] = CROSS, -- Outcast Souleater
  ["0xF13000F244276CD8"] = SQUARE, -- Outcast Souleater
  ["0xF13000F246276CDD"] = UNMARKED, -- Draenei Worshipper
  ["0xF13000F246276CDB"] = UNMARKED, -- Draenei Worshipper
})

addToDefaultNpcsToMark(L["???"], "sanv_2", {
  ["0xF13000F245276C92"] = SKULL, -- Draenei Darkbinder
  ["0xF13000F244276C94"] = CROSS, -- Outcast Souleater
  ["0xF13000F246276C85"] = UNMARKED, -- Draenei Worshipper
  ["0xF13000F246276C7D"] = UNMARKED, -- Draenei Worshipper
  ["0xF13000F246276C80"] = UNMARKED, -- Draenei Worshipper
  ["0xF13000F246276C81"] = UNMARKED, -- Draenei Worshipper
  ["0xF13000F246276C7F"] = UNMARKED, -- Draenei Worshipper
  ["0xF13000F246276C82"] = UNMARKED, -- Draenei Worshipper
  ["0xF13000F246276C83"] = UNMARKED, -- Draenei Worshipper
})
addToDefaultNpcsToMark(L["???"], "sanv_3", {
  ["0xF13000F245276C8E"] = SKULL, -- Draenei Darkbinder
  ["0xF13000F245276C8F"] = CROSS, -- Draenei Darkbinder
  ["0xF13000F244276C8D"] = SQUARE, -- Outcast Souleater
  ["0xF13000F246276C7E"] = UNMARKED, -- Draenei Worshipper
  ["0xF13000F246276C91"] = UNMARKED, -- Draenei Worshipper
  ["0xF13000F246276C90"] = UNMARKED, -- Draenei Worshipper
})

addToDefaultNpcsToMark(L["???"], "sanv_3", {
  ["0xF13000F245276C87"] = SKULL, -- Draenei Darkbinder
  ["0xF13000F245276C86"] = CROSS, -- Draenei Darkbinder
  ["0xF13000F244276C88"] = SQUARE, -- Outcast Souleater
  ["0xF13000F246276C84"] = UNMARKED, -- Draenei Worshipper
  ["0xF13000F246276C8C"] = UNMARKED, -- Draenei Worshipper
  ["0xF13000F246276C8B"] = UNMARKED, -- Draenei Worshipper
})

addToDefaultNpcsToMark(L["???"], "pre_rupturan_1", {
  ["0xF13000F241276CBE"] = SKULL, -- Infernal Destroyer
  ["0xF13000F242276CC7"] = UNMARKED, -- Darkflame Imp
  ["0xF13000F242276CC4"] = UNMARKED, -- Darkflame Imp
  ["0xF13000F242276CC6"] = UNMARKED, -- Darkflame Imp
  ["0xF13000F242276CC3"] = UNMARKED, -- Darkflame Imp
  ["0xF13000F242276CC5"] = UNMARKED, -- Darkflame Imp
})

addToDefaultNpcsToMark(L["???"], "rupturan_exile", {
  ["0xF13000EA38073D39"] = SKULL, -- crumbling exile
  ["0xF13000EA38073D38"] = CROSS, -- crumbling exile
  ["0xF13000EA38073D37"] = SQUARE, -- crumbling exile
  ["0xF13000EA38073D36"] = MOON, -- crumbling exile
  ["0xF13000EA39073D35"] = UNMARKED,-- Rupturan the Broken
})

addToDefaultNpcsToMark(L["???"], "rupturan_fragments", {
  ["0xF13000EA35279A2F"] = SKULL, -- Fragment of Rupturan, fake id
  ["0xF13000EA35279A30"] = CROSS, -- Fragment of Rupturan, fake id
  ["0xF13000EA35279A31"] = SQUARE, -- Fragment of Rupturan, fake id
})

addToDefaultNpcsToMark(L["???"], "outland_patrols", {
  ["0xF13000F240276CB1"] = 3,
  ["0xF13000F241276D09"] = 2,
})

addToDefaultNpcsToMark(L["???"], "pre_krull_1", {
  ["0xF13000F240276D11"] = CROSS, -- Doomguard Annihilator
  ["0xF13000F240276D10"] = SQUARE, -- Doomguard Annihilator
  ["0xF13000F243276D0F"] = SKULL, -- Warbringer Overseer
})

addToDefaultNpcsToMark(L["???"], "pre_krull_2", {
  ["0xF13000F23F276D12"] = SKULL, -- Dreadlord Doomseeker
  ["0xF13000F23F276D17"] = CROSS, -- Dreadlord Doomseeker
  ["0xF13000F23F276D14"] = SQUARE, -- Dreadlord Doomseeker
  ["0xF13000F23F276D13"] = MOON, -- Dreadlord Doomseeker
  ["0xF13000F23F276D15"] = TRIANGLE, -- Dreadlord Doomseeker
  ["0xF13000F23F276D16"] = DIAMOND, -- Dreadlord Doomseeker
})

addToDefaultNpcsToMark(L["???"], "mephistroth", {
  ["0xF130016C98271234"] = SKULL, -- hellfire doomguard, fake id
  ["0xF130016C98271235"] = CROSS, -- hellfire doomguard, fake id
})

--/////////////// Stratholme ///////////////

addToDefaultNpcsToMark(L["Stratholme"], "live_pats", {
  ["0xF1300028AB11E66A"] = STAR, -- Eye of Naxxramas
  ["0xF1300028AB11E66B"] = TRIANGLE, -- Eye of Naxxramas
  ["0xF1300028AE00D2C1"] = SQUARE, -- "Patchwork Horror"
  ["0xF1300028AE00D2C2"] = CIRCLE, -- "Patchwork Horror"
  ["0xF1300028AE00D2B7"] = DIAMOND, -- "Patchwork Horror"
})

addToDefaultNpcsToMark(L["Stratholme"], "dead_pats", {
  ["0xF1300028A800D22E"] = SKULL,-- Rockwing Gargoyle
  ["0xF1300028A800D22B"] = CROSS,-- Rockwing Gargoyle
  ["0xF1300028A800D229"] = SQUARE,-- Rockwing Screecher
  ["0xF1300028A800D227"] = MOON,-- Rockwing Gargoyle
  ["0xF1300028A800D225"] = TRIANGLE,-- Rockwing Screecher
  ["0xF1300028A800D223"] = DIAMOND,-- Rockwing Screecher
  ["0xF1300028A800D221"] = CIRCLE,-- Rockwing Gargoyle
  -- ["0xF130002A3900D22F"] = STAR,-- Stonespine -- need the mark for eye
  ["0xF1300028AB11E66C"] = STAR,-- Eye of Naxxramas
})


