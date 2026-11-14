local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local lordLocalData = include("lordLocalData")
local baseComponent = require("fgui.base.baseComponent")
local allianceBuildMainArmySingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceBuildView/allianceBuildMainArmySingle", allianceBuildMainArmySingle)
function allianceBuildMainArmySingle:onInit()
	self.tableArmy, _ENV, self.tableMemberData, _ENV = nil, nil, nil, nil
	self.isLaunched = false
	self.isOwn = false
	self.handle = nil
	self.baseH = self:getHeight()
	self.labelName = self.fields.Text_name
	self.labelCount = self.fields.Text_armyCount
	self.spriteArr = self.fields.Image_arrow
	self.layerTouch = self.fields.Com_touch
	self.layerTouch:addClickListener(handler(self, self.btnClickCallBack))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
		self.spriteArr:fix()
	end
end
function allianceBuildMainArmySingle:onShow()
end
function allianceBuildMainArmySingle:initData(data, type)
	self.tableMemberData = data
	dump(self.tableMemberData, "allianceBuildMainArmySingle:initData")
	self:showMemberSingle()
end
function allianceBuildMainArmySingle:showMemberSingle()
	self.isOwn = lordInfoCtrl:getLordInfo().base.uid == self.tableMemberData.playerID
	self:showMember()
	self:setState(self.isLaunched)
end
function allianceBuildMainArmySingle:showMember()
	self.fields.Com_head:setHeadSprite(self.tableMemberData.headid, self.tableMemberData.avatar)
	self.labelName:setString(self.tableMemberData.playerName)
	_ENV = nil
	;(nil).count = string.formatnumberthousands(self.tableMemberData.armyNum)
	self.labelCount:setString(i18n("common_text_556", nil))
end
function allianceBuildMainArmySingle:getState()
	return self.isLaunched
end
function allianceBuildMainArmySingle:setState(state)
	if self.isLaunched == state then
	end
	if not state then
		self:removeArmy()
		self.spriteArr:setRotation(SoraDFPosX(90, 0))
	else
		self:initArmy()
		self.spriteArr:setRotation(0)
	end
	self.isLaunched = state
end
function allianceBuildMainArmySingle:initArmy()
	if not self.Com_army then
		local Com_army = fgui.UIPackage:createObject("AllianceBuildView", "Com_army")
		Com_army:addTo(self.fields.Com_army)
		self.Com_army = Com_army
		self.Com_army:setBtnBackClick(handler(self, self.btnLordClickCallBack))
		self.Com_army:setIsSelfArmy(true)
	else
		self.Com_army:setVisible(true)
	end
	self.Com_army:initMemberData(self.tableMemberData)
	self.Com_army:setTitleText(self.isOwn and i18n("common_text_017") or i18n("common_text_501"))
	self:setHeight(self.baseH + self.Com_army:getHeight())
end
function allianceBuildMainArmySingle:removeArmy()
	if self.Com_army then
		self.Com_army:setVisible(false)
	end
	self:setHeight(self.baseH)
end
function allianceBuildMainArmySingle:btnLordClickCallBack()
	SoraDPlaySound()
	if self.isOwn then
		local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
		kingdomMapCtrl:reqBackQueueById(self.tableMemberData.queueId)
	else
		_ENV = kingdomMapCtrl.reqBackQueueById
		kingdomMapCtrl.reqBackQueueById.msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
		kingdomMapCtrl.reqBackQueueById.playerID = self.tableMemberData.playerID
		kingdomMapCtrl.reqBackQueueById.kid = gametop.playertop_:getKingdomID()
		SoraDSendMessage(kingdomMapCtrl.reqBackQueueById)
	end
end
function allianceBuildMainArmySingle:btnClickCallBack()
	SoraDPlaySound()
	local state = not self.isLaunched
	self:setState(state)
	if self.handle then
		self.handle(state, self.tableMemberData.queueId)
	end
end
function allianceBuildMainArmySingle:setClickCallBack(handle)
	self.handle = handle
end
return allianceBuildMainArmySingle
