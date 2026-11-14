local godArmsRuneCtrl = SoraDGetCtrl("godArmsRuneCtrl")
local artifactRuneRead = include("artifactRuneRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RuneAddViewPanel = class("RuneAddViewPanel", baseFguiPanel)
function RuneAddViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("RuneAddViewPanel:ctor", self.viewName)
end
function RuneAddViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function RuneAddViewPanel:onInit()
	print("=======RuneAddViewPanel:onInit")
	self.selectData = nil
	self.selectIndex = nil
	self.isSelect = false
	self.fields.Com_title:initData(i18n("Weapon_Rune_title_001"), handler(self, self.onClickClose))
	self.fields.com_info:setNoneInfo(i18n("Weapon_Rune_tips_020"))
	self.fields.Text_list:setString(i18n("Weapon_Rune_tips_025"))
	self.fields.list:setVirtual()
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.list:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onChooseItem))
	self.fields.Btn_operate:setString(i18n("Weapon_Rune_button_006"))
	self.fields.Btn_operate:setEnabled(false)
	self.fields.Btn_operate:addClickListener(handler(self, self.onOperateClick))
	self:initData()
end
function RuneAddViewPanel:onShow()
	print("=======RuneAddViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.fields.Com_bgex:setGradientColor()
end
function RuneAddViewPanel:onItemRenderer(index, obj)
	local isSelect = false
	if self.selectIndex and self.selectIndex == index then
		isSelect = true
	end
	local usingGroup = godArmsRuneCtrl:getArmUsingGroup(self.param.data.godArmsID)
	obj:initData(self.myRuneList[index + 1], isSelect, false, false, 0, self.viewName, usingGroup == self.param.group)
end
function RuneAddViewPanel:onChooseItem()
	local index = self.fields.list:getSelectedIndex()
	if not self.selectData then
		self.selectIndex = index
		self.selectData = self.myRuneList[index + 1]
		self.fields.Btn_operate:setEnabled(true)
		self.fields.com_info:setRuneInfo(self.selectData)
	elseif index == self.selectIndex then
		self.selectIndex = nil
		self.selectData = nil
		self.fields.Btn_operate:setEnabled(false)
		self.fields.com_info:setNoneInfo(i18n("Weapon_Rune_tips_020"))
	else
		self.selectIndex = index
		self.selectData = self.myRuneList[index + 1]
		self.fields.Btn_operate:setEnabled(true)
		self.fields.com_info:setRuneInfo(self.selectData)
	end
	self.fields.list:setNumItems(#self.myRuneList)
end
function RuneAddViewPanel:initData()
	local runeList = godArmsRuneCtrl:getRuneData()
	self.myRuneList, godArmsRuneCtrl = godArmsRuneCtrl, godArmsRuneCtrl
	for k, v in ipairs(runeList) do
		local info = artifactRuneRead.getRuneInfo(v.rid)
		local lvCfg = artifactRuneRead.getRuneLvCfg(info.ExpGrowingType, v.level)
		if info.RuneType == self.param.data.holeType or self.param.data.holeType == 5 then
			godArmsRuneCtrl = nil
			;(nil).rid = v.rid
			;(nil).uid = v.uid
			;(nil).isLock = v.isLock
			;(nil).class = lvCfg.Class
			;(nil).level = v.level
			;(nil).luckyValue = v.luckyValue or 0
			;(nil).cLevel = lvCfg.Level
			;(nil).runeType = info.RuneType
			;(nil).heritType = info.HeritType
			;(nil).isWear = godArmsRuneCtrl:isRuneWear(v.uid)
			;(nil).extraProperty = v.extraProperty
			table.insert(self.myRuneList, nil)
		end
	end
	table.sort(self.myRuneList, function(a, b)
		if a.isWear and b.isWear or not a.isWear and not b.isWear then
			if a.class == b.class then
				if a.level == b.level then
					if a.luckyValue == b.luckyValue then
						if a.runeType == b.runeType then
							return a.rid < b.rid
						else
							return a.runeType < b.runeType
						end
					else
						return a.luckyValue > b.luckyValue
					end
				else
					return a.level > b.level
				end
			else
				return a.class > b.class
			end
		else
			return not a.isWear
		end
	end)
	self.fields.list:setNumItems(#self.myRuneList)
end
function RuneAddViewPanel:unChoose()
	self.selectIndex = nil
	self.selectData = nil
	self.fields.Btn_operate:setEnabled(false)
	self.fields.com_info:setNoneInfo(i18n("Weapon_Rune_tips_020"))
	self.fields.list:setNumItems(#self.myRuneList)
end
function RuneAddViewPanel:replace(target, data)
	godArmsRuneCtrl:sendWear(self.param.data.godArmsID, self.param.data.godArmsCell, data.uid, self.param.group)
	self:close()
end
function RuneAddViewPanel:onOperateClick()
	SoraDPlaySound()
	print("镶嵌=========")
	if self.selectData then
		local usingGroup = godArmsRuneCtrl:getArmUsingGroup(self.param.data.godArmsID)
		if usingGroup == self.param.group then
			if self.selectData.isWear then
				local equipDesRead = include("equipDesRead")
				local runeInfo = godArmsRuneCtrl:getWearRuneInfo(self.selectData.uid)
				local name1 = equipDesRead.getArtifactName(runeInfo.armid)
				local info = artifactRuneRead.getRuneInfo(self.selectData.rid)
				local name3 = equipDesRead.getArtifactName(self.param.data.godArmsID)
				_ENV = nil
				;(nil).name1 = name1
				;(nil).name2 = i18n(info.RuneName)
				;(nil).name3 = name3
				SoraDShowMsgBox(i18n("Weapon_Rune_tips_021", nil), i18n("common_text_204"), i18n("common_text_185"), function(event)
					if event == MSGBOX_CALLBACK_YES then
						godArmsRuneCtrl:sendWear(self.param.data.godArmsID, self.param.data.godArmsCell, self.selectData.uid, self.param.group)
						self:close()
					end
				end)
			else
				godArmsRuneCtrl:sendWear(self.param.data.godArmsID, self.param.data.godArmsCell, self.selectData.uid, self.param.group)
				self:close()
			end
		else
			godArmsRuneCtrl:sendWear(self.param.data.godArmsID, self.param.data.godArmsCell, self.selectData.uid, self.param.group)
			self:close()
		end
	end
end
return RuneAddViewPanel
