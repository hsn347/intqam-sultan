local baseFguiPanel = require("fgui.base.baseFguiPanel")
local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
local raidersLostArkRead = include("raidersLostArkRead")
local publicRead = include("publicRead")
local RaidersLostArkGetKeyPopPanel = class("RaidersLostArkGetKeyPopPanel", baseFguiPanel)
function RaidersLostArkGetKeyPopPanel:ctor(...)
	self.super.ctor(self, ...)
	print("RaidersLostArkGetKeyPopPanel:ctor", self.viewName)
end
function RaidersLostArkGetKeyPopPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function RaidersLostArkGetKeyPopPanel:onInit()
	self.chooseIndex = self.proxy.param.boxType or 1
	self.fields.Panel_bg:setTitle(i18n("Martial_arts_text_38"))
	self.fields.txtKill:setString(i18n("Martial_arts_text_40"))
	self.fields.btnKillGo:setTitleText(i18n("common_text_477"))
	self.fields.btnKillGo:addClickEventListener(handler(self, self.onKillGoClick))
	print("=======RaidersLostArkGetKeyPopPanel:onInit")
end
function RaidersLostArkGetKeyPopPanel:refreshView()
	local chestInfo = raidersLostArkRead:getTreasureChestInfo(self.chooseIndex)
	local keyTable = raidersLostArkRead:getTreasureKeyTable(self.chooseIndex)
	local keyNameStr = ""
	for i, v in ipairs(keyTable) do
		local singleKey = publicRead.getName(v)
		if i == 1 then
			keyNameStr = keyNameStr .. singleKey
		elseif i <= #keyTable then
			keyNameStr = keyNameStr .. "、" .. singleKey
		end
	end
	raidersLostArkRead = nil
	;(nil).name = keyNameStr
	;(nil).box = i18n(chestInfo.name)
	self.fields.txtBox:setString(i18n("Martial_arts_text_02", nil))
end
function RaidersLostArkGetKeyPopPanel:onShow()
	self:refreshView()
	print("=======RaidersLostArkGetKeyPopPanel:onShow")
end
function RaidersLostArkGetKeyPopPanel:onHide()
	print("=======RaidersLostArkGetKeyPopPanel:onHide")
end
function RaidersLostArkGetKeyPopPanel:onDispose()
	print("=======RaidersLostArkGetKeyPopPanel:onDispose")
end
function RaidersLostArkGetKeyPopPanel:onKillGoClick(button, type)
	SoraDPlaySound()
	SoraDRemoveAllPanelFromManager()
	_ENV = nil
	mildGuideManager:starToWorldAndKillMonster(nil)
end
return RaidersLostArkGetKeyPopPanel
