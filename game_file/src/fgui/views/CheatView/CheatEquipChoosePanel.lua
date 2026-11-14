local equipDesRead = include("equipDesRead")
local equipmentltCtrl = include("equipmentltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CheatEquipChoosePanel = class("CheatEquipChoosePanel", baseFguiPanel)
function CheatEquipChoosePanel:ctor(...)
	self.isLRU = true
	CheatEquipChoosePanel.super.ctor(self, ...)
	print("CheatEquipChoosePanel:ctor", self.viewName)
end
function CheatEquipChoosePanel:onInit()
	print("=======CheatEquipChoosePanel:onInit")
	self.fields.Text_equip:setString("装备")
	self.fields.Text_name:setString("装备名字")
	self.fields.Text_id:setString("装备ID")
	self.equipCfg = require_once("app." .. _G.LocalTblPath .. ".config_server.equipment_base_property_config")
	self.fields.List:setItemRenderer(handler(self, self.onEquipRenderer))
	self.fields.List:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onChooseEquip))
	self.fields.Btn_ok:setString(i18n("common_text_204"))
	self.fields.Btn_ok:addClickListener(handler(self, self.btnClick))
	self.input = self.fields.input:getChild("input")
	self.input:setPromptHolder("装备名或装备ID")
	self.fields.Button_search:setString("搜索")
	self.fields.Button_search:addClickListener(handler(self, self.btnSearchClick))
end
function CheatEquipChoosePanel:onEquipRenderer(index, obj)
	obj:initData(self.equipShowList[index + 1])
end
function CheatEquipChoosePanel:onChooseEquip()
	SoraDPlaySound()
	self.selIndex = self.fields.List:getSelectedIndex() + 1
	self.fields.Btn_ok:setEnabled(true)
end
function CheatEquipChoosePanel:getPartEquipMent(part)
	local _ENV, ret
	for k, v in ipairs(self.equipCfg) do
		if v.eType == part and v.suitequipID == 0 then
			table.insert(ret, v)
		end
	end
	return ret
end
function CheatEquipChoosePanel:onShow()
	print("=======CheatEquipChoosePanel:onShow")
	self.equipShowList, _ENV, self.clientEquipList, _ENV, self.equipList, _ENV, self.selIndex = print, print, print, print, print, print, nil
	self.part = self.param.part
	self.fields.Panel_bg:setString(self.param.name)
	self.fields.Btn_ok:setEnabled(false)
	local equipList = self:getPartEquipMent(self.part)
	for k, v in ipairs(equipList) do
		_ENV = nil
		;(nil).eid = v.equipmentID
		;(nil).epid = self.part * 10000 + k
		;(nil).lv = v.level
		;(nil).slv = equipmentltCtrl.getStrengthenMaxLv(v.level, v.equipType)
		;(nil).qly = v.quality
		;(nil).wear = gStatus.YES
		;(nil).isCle = gStatus.NO
		self.equipList[k], (nil).extra, _ENV, (nil).remakeTimes = nil, gStatus.NO, gStatus.NO, 0
	end
	self.equipShowList = self.equipList
	self.fields.List:SelectNone()
	self.fields.List:setNumItems(#self.equipShowList)
	self.fields.List:jumpToTop()
end
function CheatEquipChoosePanel:btnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_CHEAT_UI_FIGHTDEMO_EQUIP"
	;(nil).part = self.part
	;(nil).equip = self.equipShowList[self.selIndex]
	SoraDSendMessage(nil)
	self:close()
end
function CheatEquipChoosePanel:btnSearchClick()
	SoraDPlaySound()
	local text = self.input:getText()
	local equipmentID = tonumber(text)
	local _ENV, suitArray = text, text
	if equipmentID then
		for _, v in ipairs(self.equipList) do
			if string.find(tostring(v.eid), tostring(equipmentID)) then
				table.insert(suitArray, v)
			end
		end
	else
		for _, v in ipairs(self.equipList) do
			local name = equipDesRead.getName(v.eid)
			if string.find(name, text) then
				table.insert(suitArray, v)
			end
		end
	end
	if 0 < #suitArray then
		self.equipShowList = suitArray
		self.fields.List:SelectNone()
		self.fields.List:setNumItems(#self.equipShowList)
		self.fields.List:jumpToTop()
	else
		SoraDShowMsgTip("未搜索到匹配结果！")
	end
end
return CheatEquipChoosePanel
