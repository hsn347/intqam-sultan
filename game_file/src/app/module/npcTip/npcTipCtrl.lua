local gameModule = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local npcTipCtrl = class("npcTipCtrl", gameModule)
local _ENV, RSP = "npcTipCtrl", "npcTipCtrl"
function npcTipCtrl:initClientData(data)
