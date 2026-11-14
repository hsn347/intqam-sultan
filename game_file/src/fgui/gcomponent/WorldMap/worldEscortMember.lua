local baseComponent = require("fgui.base.baseComponent")
local worldEscortMember = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://WorldMap/worldEscortMember", worldEscortMember)
local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local queueCtrl = gametop.playertop_:getModule("queueCtrl")
local lordLocalData = include("lordLocalData")
function worldEscortMember:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
	self.head = self.fields.CCS_commonHead_head
	self.text_aid_time = self.fields.text_aid_time
	self.text_name = self.fields.text_name
	self.text_troops = self.fields.text_troops
	self.text_info = self.fields.text_info
	self.text_info:setString(i18n("common_text_2324"))
	self.layerTouch = self.fields.anel_touch
	self:setSwallowTouches(true)
	self:addClickEventListener(handler(self, self.btnPanelClick))
	self.text_def = self.fields.text_def
	self.text_life = self.fields.text_life
	self.text_atk = self.fields.text_atk
end
function worldEscortMember:onShow()
end
function worldEscortMember:initWithData(data)
	self.itemData = data
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
	end
	if not data.queueInfo then
		return
	end
	local imageId = data.queueInfo.assistorInfo.imageId
	local avatarCurl = data.queueInfo.assistorInfo.avatar
	local nickName = data.queueInfo.playerName
	local playerID = data.queueInfo.playerID
	self.head:setHeadSprite(imageId, avatarCurl)
	self.head:setSwallowTouches(true)
	self.head:setPlayerID(playerID)
	self.text_name:setString(nickName)
	local armyCount = 0
	for i, v in ipairs(data.queueInfo.from.army) do
		for m, n in ipairs(v.armyList) do
			armyCount = armyCount + n.num
		end
	end
	_ENV = nil
	;(nil).cur = string.formatnumberthousands(armyCount)
	self.text_troops:setString(i18n("common_text_297", nil))
	local assistBattlePlus = data.queueInfo.assistBattlePlus
	_ENV = i18n("common_text_297", nil)
	i18n("common_text_297", nil).title = i18n("common_text_320")
	i18n("common_text_297", nil).value = assistBattlePlus.dfPlus / 10
	self.text_def:setString(i18n("common_text_1298", i18n("common_text_297", nil)))
	_ENV = i18n("common_text_1298", i18n("common_text_297", nil))
	i18n("common_text_1298", i18n("common_text_297", nil)).title = i18n("common_text_321")
	i18n("common_text_1298", i18n("common_text_297", nil)).value = assistBattlePlus.hpPlus / 10
	self.text_life:setString(i18n("common_text_1298", i18n("common_text_1298", i18n("common_text_297", nil))))
	_ENV = i18n("common_text_1298", i18n("common_text_1298", i18n("common_text_297", nil)))
	i18n("common_text_1298", i18n("common_text_1298", i18n("common_text_297", nil))).title = i18n("common_text_319")
	i18n("common_text_1298", i18n("common_text_1298", i18n("common_text_297", nil))).value = assistBattlePlus.akPlus / 10
	self.text_atk:setString(i18n("common_text_1298", i18n("common_text_1298", i18n("common_text_1298", i18n("common_text_297", nil)))))
	self:updateTime()
	self.timeHandler = SoradCreateTimer(self, handler(self, self.updateTime))
end
function worldEscortMember:btnPanelClick(target, event)
	print("打开部队详情-------------------------")
	if not self.itemData.queueInfo then
		return
	end
	SoraDPlaySound()
	local troopsData = self.itemData.queueInfo.from.army
	local imageId = self.itemData.queueInfo.assistorInfo.imageId
	local avatarCurl = self.itemData.queueInfo.assistorInfo.avatar
	local nickName = self.itemData.queueInfo.playerName
	if troopsData[1] then
		troopsData[1].imageId = imageId
		troopsData[1].avatar = avatarCurl
		troopsData[1].nickName = nickName
	end
	_ENV = nil
	;(nil).troopsData = troopsData
	;(nil).allianceName = self.itemData.queueInfo.leagueName
	uiManager:show("WorldMapTroopsDetails", nil)
end
function worldEscortMember:getQueue()
	local queueType = gQueueTypeDef.escort_assist_wait_self_escort
	local queue = queueCtrl:queryQueue(queueType)
	return queue
end
function worldEscortMember:updateTime()
	local queue = self:getQueue()
	if queue == nil then
		return
	end
	local remainTime = queue.timerNode.timer:getRemainTime()
	local timeStr = SoraDConvertSecondToString(remainTime)
	_ENV = nil
	;(nil).time = timeStr
	self.text_aid_time:setString(i18n("common_text_2350", nil))
end
return worldEscortMember
