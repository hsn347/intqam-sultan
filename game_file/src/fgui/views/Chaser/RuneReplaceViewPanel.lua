local godArmsRuneCtrl = SoraDGetCtrl("godArmsRuneCtrl")
local artifactRuneRead = include("artifactRuneRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RuneReplaceViewPanel = class("RuneReplaceViewPanel", baseFguiPanel)
function RuneReplaceViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("RuneReplaceViewPanel:ctor", self.viewName)
end
function RuneReplaceViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function RuneReplaceViewPanel:onInit()
	print("=======RuneReplaceViewPanel:onInit")
	self.selectData = nil
	self.isSelect = false
	self.fields.Com_title:initData(i18n("Weapon_Rune_title_001"), handler(self, self.onClickClose))
	self.fields.list:setVirtual()
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.com_info_new:setNoneInfo(i18n("Weapon_Rune_tips_022"))
	self.fields.Btn_operate:setString(i18n("Weapon_Rune_button_004"))
	self.fields.Btn_operate:setEnabled(false)
	self.fields.Btn_operate:addClickListener(handler(self, self.onOperateClick))
	self.fields.Text_none:setString(i18n("Weapon_Rune_tips_019"))
	self.fields.Text_none:setVisible(false)
	self:initData()
end
function RuneReplaceViewPanel:onItemRenderer(index, obj)
	local isSelect = false
	if self.selectData and self.selectData.uid == self.myRuneList[index + 1].uid then
		isSelect = true
	end
	obj:initData(self.myRuneList[index + 1], isSelect, false, false, 0, self.viewName)
end
function RuneReplaceViewPanel:onShow()
	print("=======RuneReplaceViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
end
function RuneReplaceViewPanel:chooseBack(target, data)
	local chooseData = data.data
	local isChoose = data.isChoose
	if not self.selectData then
		self.selectData = chooseData
		self.fields.Btn_operate:setEnabled(true)
		self.fields.com_info_new:setRuneInfo(self.selectData)
	elseif self.selectData and self.selectData.uid == chooseData.uid then
		self.selectData = nil
		self.fields.Btn_operate:setEnabled(false)
		self.fields.com_info_new:setNoneInfo(i18n("Weapon_Rune_tips_022"))
	else
		self.selectData = chooseData
		self.fields.Btn_operate:setEnabled(true)
		self.fields.com_info_new:setRuneInfo(self.selectData)
	end
	self.fields.list:setNumItems(#self.myRuneList)
end
function RuneReplaceViewPanel:replace(target, data)
	print("替换replace=========")
	godArmsRuneCtrl:sendWear(self.param.data.godArmsID, self.param.data.godArmsCell, data.uid, self.param.group)
	self:close()
end
function RuneReplaceViewPanel:updateView()
	local runeList = godArmsRuneCtrl:getRuneData()
	self.myRuneList, godArmsRuneCtrl = godArmsRuneCtrl, godArmsRuneCtrl
	for k, v in ipairs(runeList) do
		local info = artifactRuneRead.getRuneInfo(v.rid)
		local lvCfg = artifactRuneRead.getRuneLvCfg(info.ExpGrowingType, v.level)
		if info.RuneType == self.param.data.holeType or self.param.data.holeType == 5 then
			local wearRuneInfo = godArmsRuneCtrl:getWearRuneInfo(v.uid)
			local wearInfo = godArmsRuneCtrl:getWearRuneInfo(self.param.data.uid)
			if not godArmsRuneCtrl:isRuneWear(v.uid) or wearRuneInfo and wearInfo and (wearRuneInfo.armid ~= wearInfo.armid or wearRuneInfo.cell ~= wearInfo.cell) then
				godArmsRuneCtrl = v.uid
				v.uid.rid = v.rid
				v.uid.uid = v.uid
				v.uid.isLock = v.isLock
				v.uid.class = lvCfg.Class
				v.uid.level = v.level
				v.uid.cLevel = lvCfg.Level
				v.uid.luckyValue = v.luckyValue or 0
				v.uid.runeType = info.RuneType
				v.uid.heritType = info.HeritType
				v.uid.isWear = godArmsRuneCtrl:isRuneWear(v.uid)
				v.uid.extraProperty = v.extraProperty
				table.insert(self.myRuneList, v.uid)
			end
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
	self.fields.Text_none:setVisible(#self.myRuneList == 0)
	self.fields.list:setNumItems(#self.myRuneList)
end
function RuneReplaceViewPanel:initData()
	self.fields.com_info_old:setRuneInfo(self.param.data)
	self:updateView()
end
function RuneReplaceViewPanel:onOperateClick()
	SoraDPlaySound()
	print("替换=========")
	if self.selectData then
		if artifactRuneRead.isRuneSetLock(self.param.group - 1) then
			SoraDShowMsgTip(i18n("Weapon_Rune_tips_095"))
		elseif self.selectData.isWear then
			local equipDesRead = include("equipDesRead")
			local name1 = equipDesRead.getArtifactName(self.selectData.godArmsID)
			local info = artifactRuneRead.getRuneInfo(self.selectData.rid)
			local name3 = equipDesRead.getArtifactName(self.param.data.godArmsID)
			_ENV = i18n("Weapon_Rune_tips_095")
			i18n("Weapon_Rune_tips_095").name1 = name1
			i18n("Weapon_Rune_tips_095").name2 = i18n(info.RuneName)
			i18n("Weapon_Rune_tips_095").name3 = name3
			SoraDShowMsgBox(i18n("Weapon_Rune_tips_021", i18n("Weapon_Rune_tips_095")), i18n("common_text_204"), i18n("common_text_185"), function(event)
				if event == MSGBOX_CALLBACK_YES then
					godArmsRuneCtrl:sendWear(self.param.data.godArmsID, self.param.data.godArmsCell, self.selectData.uid, self.param.group)
					self:close()
				end
			end)
		else
			godArmsRuneCtrl:sendWear(self.param.data.godArmsID, self.param.data.godArmsCell, self.selectData.uid, self.param.group)
			self:close()
		end
	end
end
return RuneReplaceViewPanel
