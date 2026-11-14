local dailyRemindManager = include("dailyRemindManager")
local godArmsRuneCtrl = SoraDGetCtrl("godArmsRuneCtrl")
local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
local artifactRuneRead = include("artifactRuneRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RuneExchangeChoosePanel = class("RuneExchangeChoosePanel", baseFguiPanel)
function RuneExchangeChoosePanel:ctor(...)
	self.super.ctor(self, ...)
	print("RuneExchangeChoosePanel:ctor", self.viewName)
end
function RuneExchangeChoosePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function RuneExchangeChoosePanel:onInit()
	print("=======RuneExchangeChoosePanel:onInit")
	self.shopItemID = self.param.shopItemID
	self.rid = self.param.rid
	self.selectData = nil
	self.fields.Com_title:initData(i18n("activity_name_9001532"), handler(self, self.onClickClose))
	self.fields.com_info:setNoneInfo(i18n("Weapon_Rune_tips_032"))
	self.fields.Text_list:setString(i18n("Weapon_Rune_tips_025"))
	self.fields.list:setVirtual()
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_none:setString(i18n("Weapon_Rune_tips_019"))
	self.fields.Text_none:setVisible(false)
	self.fields.Btn_operate:setString(i18n("common_text_1889"))
	self.fields.Btn_operate:setEnabled(false)
	self.fields.Btn_operate:addClickListener(handler(self, self.onOperateClick))
	self:initData()
end
function RuneExchangeChoosePanel:onShow()
	print("=======RuneExchangeChoosePanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.fields.Com_bgex:setGradientColor()
end
function RuneExchangeChoosePanel:onItemRenderer(index, obj)
	local isSelect = false
	if self.selectData and self.selectData.uid == self.myRuneList[index + 1].uid then
		isSelect = true
	end
	obj:initData(self.myRuneList[index + 1], isSelect, self.param.tag)
end
function RuneExchangeChoosePanel:updateView(target, data)
	if data and data.msg == "MESSAGE_UI_RUNE_INHERIT_CHOOSE" then
		if data.isChoose then
			self.selectData = data.data
			self.fields.com_info:setRuneInfo(self.selectData)
			self.fields.Btn_operate:setEnabled(true)
		else
			self.selectData = nil
			self.fields.com_info:setNoneInfo(i18n("Weapon_Rune_tips_020"))
			self.fields.Btn_operate:setEnabled(false)
		end
	end
	self:initData()
end
function RuneExchangeChoosePanel:isFeeded(data)
	local ret = false
	for k, v in ipairs(data.extraProperty) do
		if v[2] > 1 then
			ret = true
			break
		end
	end
	return ret
end
function RuneExchangeChoosePanel:initData()
	local runeList = godArmsRuneCtrl:getRuneData()
	self.myRuneList, godArmsRuneCtrl = godArmsRuneCtrl, godArmsRuneCtrl
	for k, v in ipairs(runeList) do
		if v.rid == self.rid and v.level == 1 and not godArmsRuneCtrl:isRuneWear(v.uid) and not self:isFeeded(v) then
			local info = artifactRuneRead.getRuneInfo(v.rid)
			local lvCfg = artifactRuneRead.getRuneLvCfg(info.ExpGrowingType, v.level)
			godArmsRuneCtrl = nil
			;(nil).rid = v.rid
			;(nil).uid = v.uid
			;(nil).isLock = v.isLock
			;(nil).class = lvCfg.Class
			;(nil).level = v.level
			;(nil).luckyValue = v.luckyValue or 0
			;(nil).cLevel = lvCfg.Level
			;(nil).season = info.Season
			;(nil).heritType = info.HeritType
			;(nil).runeType = info.RuneType
			;(nil).extraProperty = v.extraProperty
			table.insert(self.myRuneList, nil)
		end
	end
	table.sort(self.myRuneList, function(a, b)
		if a.season == b.season then
			if a.class == b.class then
				if a.level == b.level then
					if a.luckyValue == b.luckyValue then
						return a.rid < b.rid
					else
						return a.luckyValue < b.luckyValue
					end
				else
					return a.level < b.level
				end
			else
				return a.class < b.class
			end
		else
			return a.season < b.season
		end
	end)
	self.fields.Text_none:setVisible(#self.myRuneList == 0)
	self.fields.list:setNumItems(#self.myRuneList)
end
function RuneExchangeChoosePanel:onOperateClick()
	SoraDPlaySound()
	print("选择=========")
	if self.selectData then
		if self.selectData.luckyValue > 0 then
			local key = dailyRemindManager.REMIND_TYPE.runeLuckyValue
			if dailyRemindManager.checkNeedRemind(key) then
				_ENV = nil
				;(nil).content = i18n("Weapon_Rune_tips_116")
				;(nil).confirmFunc = function()
					self = nil
					;(nil)[1] = self.selectData.uid
					activityExchangeMallCtrl:reqActivityExchange(self.shopItemID, 1, nil)
					self:close()
				end
				uiManager:show("MessageBox", nil):setOwnerKey(self)
				dailyRemindManager.addRemindToManager(key)
				return
			end
		end
		dailyRemindManager = nil
		;(nil)[1] = self.selectData.uid
		activityExchangeMallCtrl:reqActivityExchange(self.shopItemID, 1, nil)
		self:close()
	end
end
return RuneExchangeChoosePanel
