if GetLocale() == "zhCN" then
    AutoMarkerLocale = {
        ["Naxxramas"] = "纳克萨玛斯",
        ["Ahn'Qiraj"] = "安其拉神殿",
        ["Zul'Gurub"] = "祖尔格拉布",
        ["Emerald Sanctum"] = "翡翠圣殿",
        ["Molten Core"] = "熔火之心",
        ["Ruins of Ahn'Qiraj"] = "安其拉废墟",
        ["Blackwing Lair"] = "黑翼之巢",
        ["Tower of Karazhan"] = "卡拉赞", -- TODO needs re-localising!
        ["Stratholme"] = "斯坦索姆",
        ["Blackrock Spire"] = "黑石塔",
        ["The Upper Necropolis"] = "The Upper Necropolis",  -- 未知副本
        ["Blackrock Depths"] = "黑石深渊",
        ["The Lyceum"] = "The Lyceum", -- needs localizing
        ["Dire Maul"] = "Dire Maul", -- needs localizing
        ["Capital Gardens"] = "Capital Gardens", -- needs localizing

        -- TODO these need localising!
        ["Solnius"] = "Solnius",
        ["Sanctum Supressor"] = "Sanctum Supressor",
        ["Sanctum Dragonkin"] = "Sanctum Dragonkin",
        ["Sanctum Wyrmkin"] = "Sanctum Wyrmkin",
        ["Sanctum Scalebane"] = "Sanctum Scalebane",
        ["Core Hound"] = "Core Hound",
        ["Lord Victor Nefarius"] = "Lord Victor Nefarius",
        ["Soldier of the Frozen Wastes"] = "Soldier of the Frozen Wastes",
        ["Shadowforge Flame Keeper"] = "Shadowforge Flame Keeper",
        ["Ironbark Protector"] = "Ironbark Protector", -- needs localizing
        ["Buru Egg"] = "Buru Egg",
        ["Spawn of Fankriss"] = "Spawn of Fankriss",
        ["Flamewaker Healer"] = "Flamewaker Healer",
        ["Flamewaker Elite"] = "Flamewaker Elite",
        ["Naxxramas Follower"] = "Naxxramas Follower",
        ["Naxxramas Worshipper"] = "Naxxramas Worshipper",

        ["Unmarked"] = "未标记",
        ["Star"] = "星星",
        ["Circle"] = "大饼",
        ["Diamond"] = "紫菱",
        ["Triangle"] = "三角",
        ["Moon"] = "月亮",
        ["Square"] = "方块",
        ["Cross"] = "红叉",
        ["Skull"] = "骷髅",

        ["AutoMarker loaded!"] = "AutoMarker 已加载！",
        [" Type "] = " 输入 ",
        [" to see commands."] = " 查看命令。",

        ["Keys to hold to activate mouseover mark"] = "激活鼠标悬停标记需要按住的键",
        ["Mark mouseover or target"] = "标记鼠标指向的目标或当前目标",
        ["Mark next group based on default order"] = "根据默认顺序标记下一组",
        ["Clear all current marks"] = "清除所有当前标记",
        ["Warning:"] = "警告：",
        [" a mark set while not a leader/assistant is not visible to others"] = "非领导者/助手设置的标记对其他人不可见",
        [" wasn't found nearby!"] = " 未在附近发现！",
        ["Marking: "] = "正在标记：",
        ["Updating "] = "更新 ",
        ["Adding "] = "添加 ",
        [") in pack: "] = ") ,其所在组为: ",
        [" with new mark: "] = " ，新的标记为：",
        [" in zone: "] = "，所在区域为：",
        ["Jed is in the instance!"] = "发现杰德！！！",
        ["Sweep mode [ "] = "扫描模式 [ ",
        ["AutoMarker is now ["] = "自动标记 [",
        ["enabled"] = "启用",
        ["disabled"] = "禁用",
        ["You must provide a pack name as well when using set."] = "使用此命令时，您还必须提供组名称。\n例如：|cffffff00/am set 巡逻1",
        ["Packname set to: "] = "组名称设置为：",
        ["Current packname set to: "] = "当前组名称为：",
        ["none"] = "无",
        ["Mob %s (%s) is %s in pack: %s"] = "生物 %s (%s)，其标记为：%s，所在组：%s",
        ["Mob %s (%s) is not in any pack."] = "生物 %s (%s) 不在任何组中。",
        ["Mobs in "] = "",  -- 故意设置为空的
        [" have been cleared."] = " 组已被清空。",
        ["A packname isn't currently set."] = "当前未设置组名称。",

        ["Must target a mob to remove it from its pack."] = "必须指定一个生物才能从其组中移除它。",
        ["Mob not in any pack."] = "生物不在任何组中。",
        ["Removing mob "]  = "移除生物: ",
        [" from pack: "] = "从组：",
        ["You must target a mob."] = "您必须指定一个生物。",
        ["You must provide a pack name to add the mob to."] = "您必须提供要添加生物的组名称。",
        ["The mob is already in a pack. Use "] = "生物已经在一个组中。使用 ",
        [" to override."] = " 命令进行覆盖操作.",
        ["Provide the pack name to this command as well or set one using "] = "当前未指定组名，使用此命令需要提供组名称，或先指定当前组 使用命令：",

        ["on"] = "开启",
        ["off"] = "关闭",
        [" ] sweep your mouse over enemies to add them to pack: "] = " ] 扫描鼠标指向以将敌人添加到组：",
        ["You must provide a name as well when using markname."] = "在使用 markname 命令时，还必须提供名称。",

        ["Debug mode set to: "] = "调试模式设置为：",
        ["Commands:"] = "命令：\n|cffffff00尖括号<>为必须项，中括号[]为可选项",
        ["nable - enabled or disable addon."] = "nable - 开启或关闭插件。",
        ["et <packname> - Set the current pack name."] = "et <packname> - 设置当前组的名称。",
        ["et - Get the current pack name and information about the targeted mob."] = "et - 获取当前组的名称以及目标生物的信息。",
        ["lear - Clear all mobs in the current pack."] = "lear - 清除当前组中的所有生物。",
        [" [packname] - Toggle sweep mode to add mobs to a specified pack. If no pack name is provided, use the current pack name."] = " [packname] - 切换扫荡模式，将生物添加到指定的组中。如果没有提供组名，则使用当前组名。",
        ["dd [packname] - Add the targeted mob to a specified pack. If no pack name is provided, use the current pack name."] = "dd [packname] - 将目标生物添加到指定的组中。如果没有提供组名，则使用当前组名。",
        ["emove - Remove the targeted mob from its current pack."] = "emove - 从当前组中移除目标生物。",
        ["/am clearmarks - Remove all active marks."] = "/am clearmarks - 移除所有标记。",
        ["/am next - Mark next pack."] = "/am next - 标记下一个组。",
        ["/am mark - Mark pack of current target or mouseover."] = "/am mark - 标记当前目标或鼠标悬停目标所属的组。",
        ["/am markname - Mark all units of a given name."] = "/am markname - Mark all units of a given name.", -- needs localizing
        ["/am debug - Toggle debug mode."] = "/am debug - 切换调试模式。"
    }
end