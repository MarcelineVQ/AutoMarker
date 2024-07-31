# AutoMarker 1.14.3
AutoMarker for [SuperWow](https://github.com/balakethelock/SuperWoW/) on the 1.12 client.

* Default values are (so far) calibrated for Turtle WoW specifically.
___

* Hold `shift then ctrl or alt` to activate automatic raid marking when mousing over a mob group.  
* Enables setting marks on units without needing a group

### Keybinds:
* Automark moused over group or target - synonymous with `/am mark`
* Clear all marks - synonmous with `/am clearmarks`
* Mark next pack (based on default order from NPCList.lua) - synonymous with `/am next`

Many pre-defined groups exists already in the addon but can be customized with the following commands.  
### Commands:  

- `/am set <packname> - Set the current pack name.` `Alias: /am s`
- `/am get - Get the current pack name and information about the targeted mob.` `Alias: /am g`
- `/am clear - Clear all mobs in the current pack.` `Alias: /am c`
- `/am add [packname] - Add the targeted mob to a specified pack. If no pack name is provided, use the current 'set' pack name.` `Alias: /am a`
- `/am sweep [packname] - Toggle sweep mode to add multiple mobs to a specified pack. If no pack name is provided, use the current 'set' pack name.`
- `/am remove - Remove the targeted mob from its current pack.` `Alias: /am r`
- `/am clearmarks - Remove all active marks.`
- `/am next - Mark next pack based on default order from NPCList.lua`
- `/am mark - Mark pack of current target or mouseover.`
- `/am markname <unit name> - Mark all units of a given name.`

- `/am debug - Toggle debug mode.`

### Automatic Features:  
* Marks highest health corehound in a fight with a Skull
* Re-marks Buru eggs as they respawn
* Marks Flame Keepers in Blackrock Depths
* Marks soldiers that are getting to close during KT Fight
* Marks Fankriss worms as they spawn
* Marks Solinus adds when they spawn based on best kill prio
* Informs you of Jed Runewatcher being present in Blackrock Spire

___
* Made by and for Weird Vibes of Turtle Wow  
