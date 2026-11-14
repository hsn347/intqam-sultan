local gametop = gModuleMgr.getObject("gametop")
local landOfSoulCtrl = gametop.playertop_:getModule("landOfSoulCtrl")
local armyltCtrl = include("armyltCtrl")
local landOfSoulRead = include("landOfSoulRead")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local armyDesRead = include("armyDesRead")
local summonSuccessfulView = class("summonSuccessfulView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("summonSuccessfulView")
	end
	return target
end)
function summonSuccessfulView:ctor()
	self:initControls()
end
function summonSuccessfulView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function summonSuccessfulView:initControls()
	SoraDGetAllChildFromWidget(self, self)
	self.Text_name:setString(i18n("heroicSouls_text_10"))
	self.txtName:setString(i18n("common_text_2037"))
	self.txtNum:setString(i18n("common_text_2709"))
	self.txtIns:setString(i18n("heroicSouls_text_3"))
end
function summonSuccessfulView:initData(armyList, activityID)
	self.activityID = activityID
	self.armyList = armyList
	self:initScroll()
	if self.activityID == gActivityTimeActivityID.NEBULA_EMPEROR_ACTIVITY then
		self.Text_name:setString(i18n("nebulaemperor_text_127"))
		self.txtIns:setString(i18n("nebulaemperor_text_130"))
	end
end
function summonSuccessfulView:initScroll()
	self.scrollSummon:removeAllChildren()
	local scrollH = math.max(self.scrollSummon:getContentSize().height, 71 * table.nums(self.armyList))
	self.scrollSummon:setInnerContainerSize(cc.size(640, scrollH))
	local index = 1
	for k, v in pairs(self.armyList) do
		local panel = self.nodeArmySingle:clone()
		if SoraDFIsRA() then
			panel:setPosition(cc.p(258, scrollH - (index - 1) * 70))
		else
			panel:setPosition(cc.p(268, scrollH - (index - 1) * 70))
		end
		panel:addTo(self.scrollSummon)
		local txtSingleName = SoraDGetChildByName(panel, "txtSingleName")
		txtSingleName:setString(armyDesRead.getName(tonumber(k)))
		local txtSingleNum = SoraDGetChildByName(panel, "txtSingleNum")
		txtSingleNum:setString(v)
		local image_icon = SoraDGetChildByName(panel, "image_icon")
		image_icon:setScale(0.65)
		image_icon:setSpriteFrame(armyDesRead.getIcon(tonumber(k)))
		local sprLv = SoraDGetChildByName(panel, "Sprite_warLv")
		sprLv:setVisible(armyDesRead.getWarLv(tonumber(k)) > 0)
		local warLvlabel = SoraDGetChildByName(panel, "Text_warLv")
		warLvlabel:setVisible(armyDesRead.getWarLv(tonumber(k)) > 0)
		warLvlabel:setString(armyDesRead.getWarLv(tonumber(k)))
		local imgBg = SoraDGetChildByName(panel, "Image_22")
		imgBg:setVisible(index % 2 == 0)
		index = index + 1
	end
end
function summonSuccessfulView:judgeClose()
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return summonSuccessfulView
