PLUGIN.name = "Helix RPG"
PLUGIN.author = "Hoooldini"
PLUGIN.description = "RPG and stats system for Helix for a more tangible roleplay experience."
-- [[ FILE INCLUSIONS ]] --
ix.util.Include("sh_hooks.lua")
ix.util.Include("cl_hooks.lua")
ix.util.Include("sh_config.lua")
ix.util.Include("sh_commands.lua")
ix.util.Include("sh_chat.lua")
ix.util.Include("sv_plugin.lua")
PLUGIN.MaxWounds = 20
PLUGIN.DefaultWounds = 10
PLUGIN.MaxShields = 10