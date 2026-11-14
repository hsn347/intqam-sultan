local gametop = gModuleMgr.getObject("gametop")
local godArmsCtrl = gametop.playertop_:getModule("godArmsCtrl")
local godArmsRuneCtrl = gametop.playertop_:getModule("godArmsRuneCtrl")
local equipDesRead = include("equipDesRead")
local artifactRuneRead = include("artifactRuneRead")
local buffDesRead = include("buffDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ArtifactSelectPanel = class("ArtifactSelectPanel", baseFguiPanel)
function ArtifactSelectPanel:ctor(...)
	self.super.ctor(self, ...)
	print("ArtifactSelectPanel:ctor", self.viewName)
end
function ArtifactSelectPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function ArtifactSelectPanel:onInit()
	print("=======ArtifactSelectPanel:onInit")
	self.lastIndex = -1
	self.fields.List_attr:fixPos()
	self.fields.Node_skill:fixPos()
	self.fields.Text_arrtTitle:setString(i18n("artifact_text_30"))
	self.fields.Panel_bg:setString(i18n("artifact_text_29"))
	self.fields.Button_select:setTitleText(i18n("common_text_204"))
	self.fields.Text_des:setString(i18n("artifact_text_26"))
	self.fields.List_select:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.List_attr:setItemRenderer(handler(self, self.onItemBuffRederer))
	self.fields.Button_select:addClickListener(handler(self, self.btnClickCallBack))
	self.fields.List_select:addClickListener(handler(self, self.onClickHeroItem))
end
function ArtifactSelectPanel:onShow()
	print("=======ArtifactSelectPanel:onShow")
	self:setMode(self.proxy.param.myMode)
end
function ArtifactSelectPanel:initData()
	self.armsData = godArmsCtrl:getArmsList()
	self:initScroll()
	self:updateView()
end
function ArtifactSelectPanel:selectArtifact(index)
	self.curIndex = index
	self.curData = self.armsData[self.curIndex]
	self:updateView()
	self.fields.List_attr:jumpToTop()
end
function ArtifactSelectPanel:initScroll(...)
	if SoraDFIsRA() then
		self.fields.List_select:jumpToRight()
	else
		self.fields.List_select:scrollToLeft()
	end
	self.fields.List_select:setNumItems(#self.armsData)
end
function ArtifactSelectPanel:updateView()
	if self.curData then
		self:updateAttr()
	else
		self:showEmpty()
	end
end
function ArtifactSelectPanel:showEmpty(...)
	self.fields.List_attr:setVisible(false)
	self.fields.Button_select:setVisible(false)
	self.fields.Node_skill:setIcon("icon_jctz_wh.png")
end
function ArtifactSelectPanel:updateAttr(...)
	dump(self.curData, "ArtifactSelectPanel:updateAttr")
	if self.curData.info then
		local skillData = self.curData.info.skillList
		if self.curData.info.skillList[1] == nil then
			skillData, _ENV = self.curData.info.skillList[1], self.curData.info.skillList[1]
			for k, v in pairs(self.curData.info.skillList) do
				table.insert(skillData, v)
			end
			table.sort(skillData, function(l, r)
				return l.activeLevel < r.activeLevel
			end)
			self.curData.info.skillList = skillData
			self.armsData[self.curIndex].info.skillList = skillData
		end
		self.skillData = clone(skillData)
		self:getRuneBuff()
		self.fields.List_attr:setNumItems(#self.skillData)
		self.fields.Node_skill:setIcon(self.curData.icon)
		self.fields.Button_select:setVisible(true)
		self.fields.List_attr:setVisible(true)
	end
end
function ArtifactSelectPanel:btnClickCallBack()
	SoraDPlaySound()
	if self.myMode == gHeroSelectBannerStyle.defend then
		godArmsCtrl:reqSaveDefend(self.curData.weaponID)
	end
	_ENV = godArmsCtrl
	godArmsCtrl.msg = "MESSAGE_SERVER_GODEQUIP_SELECT"
	godArmsCtrl.weaponID = self.curData.weaponID
	SoraDSendMessage(godArmsCtrl)
	self:removeFromParent()
end
function ArtifactSelectPanel:onClickHeroItem()
	local index = self.fields.List_select:getSelectedIndex()
	if index < 0 or self.lastIndex == index then
		return
	end
	SoraDPlaySound()
	local obj = self.fields.List_select:getChildAt(index)
	if obj:buttonClickcheck() then
		self:selectArtifact(index + 1)
		self.lastIndex = index
	else
		self.fields.List_select:setSelectedIndex(self.lastIndex)
	end
end
function ArtifactSelectPanel:setMode(mode)
	self.myMode = mode
	self:initData()
end
function ArtifactSelectPanel:onItemRederer(index, target)
	target:initData(self.armsData[index + 1], self.myMode)
end
function ArtifactSelectPanel:onItemBuffRederer(index, target)
	target:initData(self.skillData[index + 1], self.curData.info.level, self.curData.info.awakeStatus)
end
function ArtifactSelectPanel:getRuneBuff()
	local runeList = godArmsRuneCtrl:getRunedData(self.curData.info.armsID)
	local godArmsRuneCtrl, tableAttr = godArmsRuneCtrl, godArmsRuneCtrl
	local godArmsRuneCtrl, buffArray = self.curData.info.armsID, self.curData.info.armsID
	for k, v in ipairs(runeList) do
		local info = artifactRuneRead.getRuneInfo(v.rid)
		local pLvCfg = artifactRuneRead.getPropertiesLvCfg(info.BasicProperties.growType, v.level)
		godArmsRuneCtrl = nil
		;(nil).buffType = info.BasicProperties.buffType
		;(nil).buffVal = info.BasicProperties.buffVal + pLvCfg.GrowingValue
		;(nil).buffMode = info.BasicProperties.buffMode
		table.insert(buffArray, nil)
		if not v.extraProperty then
			godArmsRuneCtrl = v.extraProperty
		end
		for m, n in ipairs(v.extraProperty) do
			if n[3] then
				local propertyArray, quality = artifactRuneRead.getPropertyArray(n[1])
				for ki, vi in ipairs(propertyArray) do
					local pLvCfg = artifactRuneRead.getPropertiesLvCfg(vi.growType, n[2])
					godArmsRuneCtrl = nil
					;(nil).buffType = vi.buffType
					;(nil).buffVal = vi.buffVal + pLvCfg.GrowingValue
					;(nil).buffMode = vi.buffMode
					table.insert(buffArray, nil)
				end
			end
		end
	end
	local cfg = artifactRuneRead.getSuitInfo(self.curData.info.armsID)
	local totalLv = godArmsRuneCtrl:getArmTotalLevel(self.curData.info.armsID)
	for k, v in ipairs(cfg) do
		if totalLv >= v.lv then
			local skillInfo = artifactRuneRead.getSuitSkillInfo(v.skill)
			for i = 1, #skillInfo.Data, 3 do
				godArmsRuneCtrl = ipairs(propertyArray)
				ipairs(propertyArray).buffType = skillInfo.Data[i]
				ipairs(propertyArray).buffVal = skillInfo.Data[i + 2]
				ipairs(propertyArray).buffMode = skillInfo.Data[i + 1]
				table.insert(buffArray, ipairs(propertyArray))
			end
		end
	end
	local godArmsRuneCtrl, tempBuffArray = (for generator), ipairs(cfg)
	for k, v in ipairs(buffArray) do
		if tempBuffArray[v.buffType] then
			tempBuffArray[v.buffType].val = tempBuffArray[v.buffType].val + v.buffVal
		else
			godArmsRuneCtrl = tempBuffArray[v.buffType].val + v.buffVal
			;(tempBuffArray[v.buffType].val + v.buffVal).val = v.buffVal
			tempBuffArray[v.buffType], (tempBuffArray[v.buffType].val + v.buffVal).mode = tempBuffArray[v.buffType].val + v.buffVal, v.buffMode
		end
	end
	self.buffList, godArmsRuneCtrl = ipairs(buffArray)
	for k, v in pairs(tempBuffArray) do
		godArmsRuneCtrl = v.buffMode
		v.buffMode.id = k
		v.buffMode.val = v.val
		v.buffMode.mode = v.mode
		table.insert(self.buffList, v.buffMode)
	end
	table.sort(self.buffList, function(a, b)
		return a.id < b.id
	end)
	if next(self.buffList) then
		self.skillData[1].index = 1
	else
		self.skillData[1].index = nil
	end
	for k, v in ipairs(self.buffList) do
		local des, base, value = buffDesRead.getBuffDes(v.id, v.val, v.mode, true)
		godArmsRuneCtrl = buffArray
		buffArray.index = k
		buffArray.base = base
		buffArray.value = value
		table.insert(self.skillData, buffArray)
	end
end
return ArtifactSelectPanel
