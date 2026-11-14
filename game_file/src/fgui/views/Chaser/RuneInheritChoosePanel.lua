local godArmsRuneCtrl = SoraDGetCtrl("godArmsRuneCtrl")
local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local artifactRuneRead = include("artifactRuneRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RuneInheritChoosePanel = class("RuneInheritChoosePanel", baseFguiPanel)
function RuneInheritChoosePanel:ctor(...)
	self.super.ctor(self, ...)
	print("RuneInheritChoosePanel:ctor", self.viewName)
end
function RuneInheritChoosePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function RuneInheritChoosePanel:onInit()
	print("=======RuneInheritChoosePanel:onInit")
	self.selectData = nil
	self.fields.Com_title:initData(i18n("Weapon_Rune_inherit_001"), handler(self, self.onClickClose))
	self.fields.com_info:setNoneInfo(i18n("Weapon_Rune_tips_032"))
	self.fields.Text_list:setString(i18n("Weapon_Rune_tips_025"))
	self.fields.list:setVirtual()
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_none:setString(i18n("Weapon_Rune_tips_019"))
	self.fields.Text_none:setVisible(false)
	self.fields.Btn_operate:setString(i18n("treasure_crystal_btn_02"))
	self.fields.Btn_operate:setEnabled(false)
	self.fields.Btn_operate:addClickListener(handler(self, self.onOperateClick))
	self:initData()
end
function RuneInheritChoosePanel:onShow()
	print("=======RuneInheritChoosePanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.fields.Com_bgex:setGradientColor()
end
function RuneInheritChoosePanel:onItemRenderer(index, obj)
	local isSelect = false
	if self.selectData and self.selectData.uid == self.myRuneList[index + 1].uid then
		isSelect = true
	end
	obj:initData(self.myRuneList[index + 1], isSelect, self.param.tag)
end
function RuneInheritChoosePanel:updateView(target, data)
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
function RuneInheritChoosePanel:initData()
	local runeList = godArmsRuneCtrl:getRuneData()
	self.myRuneList, godArmsRuneCtrl, self.curSeason = nebulaActivityCtrl:getCurSeason(), nebulaActivityCtrl:getCurSeason(), nebulaActivityCtrl:getCurSeason()
	local heritType
	if self.param and self.param.target then
		local info = artifactRuneRead.getRuneInfo(self.param.target.rid)
		heritType = self.param.target.heritType or info.HeritType
	end
	for k, v in ipairs(runeList) do
		local info = artifactRuneRead.getRuneInfo(v.rid)
		local lvCfg = artifactRuneRead.getRuneLvCfg(info.ExpGrowingType, v.level)
		if self.param.tag == 0 then
			if not self.param.target or self.param.target and heritType == info.HeritType and info.Season < self.param.target.season then
				godArmsRuneCtrl = nil
				;(nil).rid = v.rid
				;(nil).uid = v.uid
				;(nil).exp = v.exp
				;(nil).isLock = v.isLock
				;(nil).class = lvCfg.Class
				;(nil).level = v.level
				;(nil).luckyValue = v.luckyValue or 0
				;(nil).cLevel = lvCfg.Level
				;(nil).season = info.Season
				;(nil).heritType = info.HeritType
				;(nil).runeType = info.RuneType
				;(nil).isWear = godArmsRuneCtrl:isRuneWear(v.uid)
				;(nil).extraProperty = v.extraProperty
				table.insert(self.myRuneList, nil)
			end
		elseif self.param.tag == 1 and (not self.param.source or self.param.source and self.param.source.heritType == info.HeritType and info.Season > self.param.source.season) then
			godArmsRuneCtrl = nil
			;(nil).rid = v.rid
			;(nil).uid = v.uid
			;(nil).exp = v.exp
			;(nil).isLock = v.isLock
			;(nil).class = lvCfg.Class
			;(nil).level = v.level
			;(nil).luckyValue = v.luckyValue or 0
			;(nil).cLevel = lvCfg.Level
			;(nil).season = info.Season
			;(nil).heritType = info.HeritType
			;(nil).runeType = info.RuneType
			;(nil).isWear = godArmsRuneCtrl:isRuneWear(v.uid)
			;(nil).extraProperty = v.extraProperty
			table.insert(self.myRuneList, nil)
		end
	end
	table.sort(self.myRuneList, function(a, b)
		if a.isWear and b.isWear or not a.isWear and not b.isWear then
			if a.season == b.season then
				if a.class == b.class then
					if a.level == b.level then
						if a.luckyValue == b.luckyValue then
							return a.rid > b.rid
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
				return a.season > b.season
			end
		else
			return a.isWear
		end
	end)
	self.fields.Text_none:setVisible(#self.myRuneList == 0)
	self.fields.list:setVisible(#self.myRuneList > 0)
	if #self.myRuneList > 0 then
		self.fields.list:setNumItems(#self.myRuneList)
	end
end
function RuneInheritChoosePanel:onOperateClick()
	SoraDPlaySound()
	print("选择=========")
	if self.selectData then
		if self.param.tag == 0 then
			_ENV = "选择========="
			;("选择=========").msg = "MESSAGE_UI_RUNE_INHERIT_CHOOSE_SOURCE"
			;("选择=========").data = self.selectData
			SoraDSendMessage("选择=========")
		elseif self.param.tag == 1 then
			_ENV = "选择========="
			;("选择=========").msg = "MESSAGE_UI_RUNE_INHERIT_CHOOSE_TARGET"
			;("选择=========").data = self.selectData
			SoraDSendMessage("选择=========")
		end
		self:close()
	end
end
return RuneInheritChoosePanel
