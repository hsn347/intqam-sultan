local gametop = gModuleMgr.getObject("gametop")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local allianceDesRead = include("allianceDesRead")
local baseComponent = require("fgui.base.baseComponent")
local allianceBuildBuildingSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceBuildView/allianceBuildBuildingSingle", allianceBuildBuildingSingle)
function allianceBuildBuildingSingle:onInit()
	self.totalArmyCount = 0
	self.data, _ENV, self.isFold = nil, nil, true
	self.handlRepatriate = nil
	self.baseH = self:getHeight()
	self.Panel_touch = self.fields.Panel_touch
	self.Panel_touch:addClickListener(handler(self, self.btnUnfoldCallBack))
	self.Sprite_arr = self.fields.Sprite_arr
	self.Text_name = self.fields.Text_name
	self.Text_troop = self.fields.Text_count
	self.Text_state = self.fields.Text_state
	self.Text_state:setString(i18n("common_text_043"))
	self.Text_notice = self.fields.Text_notice
	if not SoraDFIsRA() then
		self:fixChildrenPos()
		self.Sprite_arr:fix()
	end
end
function allianceBuildBuildingSingle:onShow()
end
function allianceBuildBuildingSingle:btnUnfoldCallBack()
	SoraDPlaySound()
	if self.data.sType == 3 then
		return
	end
	if self.data.army then
		self:meFoldOrNot()
	else
		if self.data.isSelfIn then
			SoraDShowMsgTip(i18n("alliance_stronghold_text_018"))
			return
		end
		if self.isFull then
			SoraDShowMsgTip(i18n("alliance_stronghold_text_109"))
			return
		end
		local dispatchPanel = uiManager:show("WorldDispatchArmyView")
		dispatchPanel:initData(self.data.dispatchData)
	end
end
function allianceBuildBuildingSingle:isFold()
	return self.isFold
end
function allianceBuildBuildingSingle:getTotalArmyCount()
	return self.totalArmyCount
end
function allianceBuildBuildingSingle:getQid()
	return self.data.playerID
end
function allianceBuildBuildingSingle:setParent(parent)
	self.parent = parent
end
function allianceBuildBuildingSingle:btnBackClick()
	SoraDPlaySound()
	kingdomMapCtrl:reqBackQueueById(self.data.queueId)
	self.parent:removeFromParent()
end
function allianceBuildBuildingSingle:initData(data, isFold, classID, isFull)
	self.data = data
	self.classID = classID
	self.isFull = isFull
	if isFold then
		self.isFold = isFold
	end
	self:update()
	self.fields.Com_head:setPlayerID()
	self.fields.Com_head:setHeadSprite("")
	if self.data.sType == 1 then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Com_head:setPlayerID(self.data.playerID)
		self.fields.Com_head:setHeadSprite(self.data.headid, self.data.avatar)
		self.Text_name:setString(self.data.playerName)
		self.totalArmyCount = self.data.armyNum
		_ENV = nil
		;(nil).cur = string.formatnumberthousands(self.totalArmyCount)
		self.Text_troop:setString(i18n("common_text_297", nil))
	elseif self.data.sType == 2 then
		self.controllers.c1:setSelectedIndex(0)
		_ENV = i18n("common_text_297", nil)
		i18n("common_text_297", nil).name = i18n(allianceDesRead.getBuildName(self.classID))
		self.Text_notice:setString(i18n("alliance_stronghold_text_092", i18n("common_text_297", nil)))
	elseif self.data.sType == 3 then
		self.controllers.c1:setSelectedIndex(2)
		self.Text_notice:setString(i18n("common_text_304"))
	end
end
function allianceBuildBuildingSingle:update()
	if self.isFold == false then
		self:meFoldOrNot()
	end
end
function allianceBuildBuildingSingle:meFoldOrNot()
	if self.isFold and self.data and next(self.data) then
		self.isFold = false
		self.Sprite_arr:setRotation(SoraDFSign(0))
		self:initArmy()
	else
		self.Sprite_arr:setRotation(SoraDFPosX(90, 0))
		self.isFold = true
		self:removeArmy()
	end
	self.handlRepatriate()
end
function allianceBuildBuildingSingle:initArmy()
	if not self.Com_army then
		local Com_army = fgui.UIPackage:createObject("AllianceBuildView", "Com_army")
		Com_army:addTo(self.fields.Com_army)
		self.Com_army = Com_army
		self.Com_army:setBtnBackClick(handler(self, self.btnBackClick))
	else
		self.Com_army:setVisible(true)
	end
	self.Com_army:initMemberData(self.data)
	local isSelfArmy = self.data.playerID == gametop.playertop_:getPlayerID()
	self.Com_army:setIsSelfArmy(isSelfArmy)
	self:setHeight(self.baseH + self.Com_army:getHeight())
end
function allianceBuildBuildingSingle:removeArmy()
	if self.Com_army then
		self.Com_army:setVisible(false)
	end
	self:setHeight(self.baseH)
end
function allianceBuildBuildingSingle:setRepatriateCallBack(handl)
	self.handlRepatriate = handl
end
return allianceBuildBuildingSingle
