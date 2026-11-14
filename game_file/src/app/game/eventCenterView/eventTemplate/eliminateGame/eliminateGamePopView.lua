local publicRead = include("publicRead")
local gametop = gModuleMgr.getObject("gametop")
local eliminateGameCommon = include("eliminateGameCommon")
local siegeCombatCtrl = gametop.playertop_:getModule("siegeCombatCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
_ENV = gametop.playertop_
gametop.playertop_.begin = 320
gametop.playertop_.dis = 48
local gametop.playertop_.size, giftPosMsg = 94, gametop.playertop_
local EliminateGamePopView = class("eliminateGamePopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("eliminateGamePopView")
	end
	return target
end)
function EliminateGamePopView:ctor()
	self.activityID = gActivityTimeActivityID.SIEGE_COMBAT
	self.Node_star = SoraDGetChildByName(self, "Node_star")
	self.nodeCenter = SoraDGetChildByName(self, "Center_Node")
	self.btnConfirm = SoraDGetChildByName(self, "Button_confirm")
	self.btnExit = SoraDGetChildByName(self, "Button_exit")
	self.btnShare = SoraDGetChildByName(self, "Button_share")
	_UPVALUE3_, self.btnRetry = SoraDGetChildByName(self, "Button_retry"), SoraDGetChildByName(self, "Button_retry")
	self.tableBtnPass, SoraDGetChildByName(self, "Button_retry")[1] = SoraDGetChildByName(self, "Button_retry"), self.btnExit
	self.tableBtnPass, SoraDGetChildByName(self, "Button_retry")[2] = SoraDGetChildByName(self, "Button_retry"), self.btnShare
	self.tableBtnPass, SoraDGetChildByName(self, "Button_retry")[3] = SoraDGetChildByName(self, "Button_retry"), self.btnRetry
	self.btnConfirm:setTitleText(i18n("common_text_204"))
	self.btnExit:setTitleText(i18n("notice_0168"))
	self.btnShare:setTitleText(i18n("common_text_533"))
	self.btnRetry:setTitleText(i18n("common_text_2541"))
	self.title = SoraDGetChildByName(self, "title")
	self.title:setString(i18n("common_text_316"))
	self.imgWin = SoraDGetChildByName(self, "Image_win")
	self.totalStep = SoraDGetChildByName(self, "totalStep")
	self.totalDouble = SoraDGetChildByName(self, "totalDouble")
	self.totalStep:setString(i18n("common_text_2539") .. ":" .. siegeCombatCtrl:getTotalUseStep())
	self.totalDouble:setString(i18n("common_text_2540") .. ":" .. siegeCombatCtrl:getTotalUseDouble())
	self.labelDes = SoraDGetChildByName(self, "Text_des")
	self.labelDes:setString(i18n("common_text_4382"))
	self.scroll = SoraDGetChildByName(self, "Scroll_rewards")
	self.sharePicBtn = include("commonShareButton").createSnapshootButton(5)
	self.sharePicBtn:addTo(self.nodeCenter, self.btnConfirm:getLocalZOrder())
	self.btnConfirm:addTouchEventListener(handler(self, self.onClose))
	self.btnExit:addTouchEventListener(handler(self, self.OnBtnClick))
	self.btnShare:addTouchEventListener(handler(self, self.OnBtnClick))
	self.btnRetry:addTouchEventListener(handler(self, self.OnBtnClick))
	self.panel = SoraDGetChildByName(self, "Panel_1")
	self.panel:setSwallowTouches(true)
	self.tableItems, _ENV = self.panel.setSwallowTouches, self.panel.setSwallowTouches
	self.sendFinish = true
	self.sendFinishAlliance = true
	self.Node_spine = SoraDGetChildByName(self, "Node_spine")
	local spine_lost = sp.SkeletonAnimation:create("spine/shengli.skel", "spine/shengli.atlas", 1)
	spine_lost:addTo(self.Node_spine)
	spine_lost:setAnimation(0, "animation", true)
end
function EliminateGamePopView:initDataBy9001629()
	self.totalStep:setString(i18n("common_text_2539") .. ":" .. siegeCombatCtrl:getTotalUseStep())
	self.totalDouble:setString(i18n("common_text_2540") .. ":" .. siegeCombatCtrl:getTotalUseDouble())
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001629
end
function EliminateGamePopView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_ELIMINATEGAME_SHARE", self.onShareBack)
	SoraDAddMessage(self, "MESSAGE_SERVER_ELIMINATEGAME_SHARE_ALLIANCE", self.onShareAllianceBack)
	SoraDAddMessage(self, "MESSAGE_UI_ELIMINATEGAME_SHOW_ITEMINFO", handler(self, self.openItemInfo))
	SoraDAddMessage(self, "MESSAGE_UI_ELIMINATEGAME_CLOSE_ITEMINFO", handler(self, self.closeItemInfo))
end
function EliminateGamePopView:sortItem(data)
	_ENV = nil
	;(nil)["frame_item_base_01.png"] = 1
	;(nil)["frame_item_base_02.png"] = 2
	;(nil)["frame_item_base_03.png"] = 3
	;(nil)["frame_item_base_04.png"] = 4
	;(nil)["frame_item_base_05.png"] = 5
	local (nil)["frame_item_base_06.png"], values = 6, nil
	table.sort(data, function(a, b)
		return values[publicRead.getBg(a.id)] > values[publicRead.getBg(b.id)]
	end)
end
function EliminateGamePopView:initData(data, pageType)
	self.tableItems, _ENV = nil, nil
	self.awardData = data
	self:stopAllActions()
	if pageType ~= "winView" then
		for i, v in ipairs(self.tableBtnPass) do
			v:setVisible(false)
		end
		self.title:setVisible(false)
		self.imgWin:setVisible(true)
		self.sharePicBtn:setVisible(false)
		self:setCloseCallBack(function()
			if self.confirmHandle then
				self.confirmHandle()
				SoraDMailGainItems(self.awardData, true)
				self:removeFromParent()
			end
		end)
	else
		self.imgWin:setVisible(false)
		self.title:setVisible(true)
		self.btnConfirm:setVisible(false)
		self.sharePicBtn:setPosition(-260, self.totalDouble:getPositionY() - 10)
		if not SoraDFIsRA() then
			self.sharePicBtn:setPositionX(260)
		end
		self.sharePicBtn:setVisible(true)
		self:setCloseCallBack(function()
			if self.exitHandle then
				self.exitHandle()
			end
			self:removeFromParent()
		end)
	end
	self.scroll:removeAllChildren()
	self:sortItem(data)
	local posX = giftPosMsg.begin - #data * giftPosMsg.dis
	local height = math.max(self.scroll:getContentSize().height, #data / 5 * 100)
	if self.scroll:getContentSize().height == height then
		self.scroll:setBounceEnabled(false)
	end
	self.scroll:setInnerContainerSize(cc.size(self.scroll:getContentSize().width, height))
	for index, item in ipairs(data) do
		local single = SoraDCreatePanel("commonItemAward")
		local pos = posX + (index - 1) % 5 * giftPosMsg.size + 65
		if SoraDFIsRA() then
			pos = 600 - (posX + (index - 1) % 5 * giftPosMsg.size)
		end
		single:addTo(self.scroll)
		single:setPosition(cc.p(pos, height - math.floor((index - 1) / 5) * giftPosMsg.size - 40))
		single:setOwnView(self)
		single:setScale(0.8)
		single:setBaseScale(1.0)
		single:initData(item.id, item.count)
		single:setVisible(false)
		table.insert(self.tableItems, single)
	end
	for i, v in ipairs(self.tableItems) do
		giftPosMsg = 600 - (posX + (index - 1) % 5 * giftPosMsg.size)
		;(600 - (posX + (index - 1) % 5 * giftPosMsg.size))[1] = cca.delay(0.15 * i)
		;(600 - (posX + (index - 1) % 5 * giftPosMsg.size))[2] = cca.callFunc(function()
			v:setVisible(true)
		end)
		;(600 - (posX + (index - 1) % 5 * giftPosMsg.size))[3] = cca.callFunc(function()
			v:setVisible(true)
		end)
		;(600 - (posX + (index - 1) % 5 * giftPosMsg.size))[4] = cca.callFunc(function()
			v:setVisible(true)
		end)
		;(600 - (posX + (index - 1) % 5 * giftPosMsg.size))[5] = cca.callFunc(function()
			v:setVisible(true)
		end)
		;(600 - (posX + (index - 1) % 5 * giftPosMsg.size))[6] = cca.callFunc(function()
			v:setVisible(true)
		end)
		local seq = cca.seq(600 - (posX + (index - 1) % 5 * giftPosMsg.size))
		v:runAction(seq)
	end
end
function EliminateGamePopView:onClose(sender, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.confirmHandle then
			self.confirmHandle()
			SoraDMailGainItems(self.awardData, true)
			self:removeFromParent()
		end
	end
end
function EliminateGamePopView:OnBtnClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if button == self.btnExit then
			if self.exitHandle then
				self.exitHandle()
			end
			self:removeFromParent()
		elseif button == self.btnRetry then
			local eventState = activityShowCtrl:getStateByID(self.activityID)
			if eventState ~= gActivityState.OPEN then
				SoraDShowMsgTip(i18n("common_text_1859"))
				return
			end
			eliminateGameCommon.restartGame(function()
				if self.retryHandle then
					self.retryHandle()
				end
				self:removeFromParent()
			end)
		elseif button == self.btnShare then
			local playerAlliance = allianceMgr:getAlliance()
			if playerAlliance ~= nil then
				_ENV, _ENV = self.confirmShare, self
				self.confirmShare.normal = "btn_green_small_01.png"
				self.confirmShare.pressed = ""
				self.noStyle, self.confirmShare.cancel = self.confirmShare, ""
				SoraDShowMsgBox(i18n("common_text_1485"), i18n("common_text_1487"), i18n("common_text_1486"), handler(self, self.confirmShare), self)
			else
				SoraDShowMsgBox(i18n("common_text_1485"), i18n("common_text_1486"), nil, handler(self, self.confirmShare))
			end
		end
	end
end
function EliminateGamePopView:onShareBack(data)
	if data.errCode == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("notice_0103"))
	else
		SoraDShowMsgTip(i18n("common_text_2126"))
	end
	self.hasShared = true
	self.sendFinish = true
end
function EliminateGamePopView:onShareAllianceBack(data)
	if data.errCode == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("notice_0103"))
	else
		SoraDShowMsgTip(i18n("common_text_2549"))
	end
	self.hasSharedAlliance = true
	self.sendFinishAlliance = true
end
function EliminateGamePopView:openItemInfo(target, data)
	local itemID = data.id
	local item = data.item
	if self.itemTips == nil then
		self.itemTips = SoraDCreatePanel("commonItemTips")
		self.itemTips:setPositionY(50)
		self.itemTips:addTo(self)
		self.itemTips:setLocalZOrder(10)
		self.itemTips:setVisible(false)
	end
	local worldPos = item:convertToWorldSpace(cc.p(0, 0))
	local nodePos = self:convertToNodeSpace(worldPos)
	local deltaTipX = 0
	if SoraDFIsRA() then
		deltaTipX = 0
	else
		deltaTipX = -280
	end
	if nodePos.x > 300 then
		self.itemTips:setPositionX(nodePos.x + 15 + deltaTipX)
	else
		self.itemTips:setPositionX(nodePos.x + 325 + deltaTipX)
	end
	self.itemTips:setPositionY(nodePos.y + 200)
	self.itemTips:setVisible(true)
	self.itemTips:initData(itemID)
end
function EliminateGamePopView:confirmShare(event)
	if event == MSGBOX_CALLBACK_YES then
		local gametop = gModuleMgr.getObject("gametop")
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		local playerAlliance = allianceMgr:getAlliance()
		if playerAlliance ~= nil then
			print("分享到联盟")
			if self.hasSharedAlliance then
				SoraDShowMsgTip(i18n("common_text_2550"))
			elseif self.sendFinishAlliance then
				self.sendFinishAlliance = false
				siegeCombatCtrl:sendAllianceShare()
				self.btnShare:setEnabled(false)
				self.btnShare:setBright(false)
			end
		else
			print("分享到世界")
			if self.hasShared then
				SoraDShowMsgTip(i18n("common_text_2550"))
			elseif self.sendFinish then
				self.sendFinish = false
				siegeCombatCtrl:sendShare()
				self.btnShare:setEnabled(false)
				self.btnShare:setBright(false)
			end
		end
	elseif event == MSGBOX_CALLBACK_NO then
		print("分享到世界")
		if self.hasShared then
			SoraDShowMsgTip(i18n("common_text_2550"))
		elseif self.sendFinish then
			self.sendFinish = false
			siegeCombatCtrl:sendShare()
			self.btnShare:setEnabled(false)
			self.btnShare:setBright(false)
		end
	else
		print("取消分享")
	end
end
function EliminateGamePopView:closeItemInfo(target, data)
	if self.itemTips then
		self.itemTips:setVisible(false)
	end
end
function EliminateGamePopView:setRetryHandle(handle)
	self.retryHandle = handle
end
function EliminateGamePopView:setConfirmHandle(handle)
	self.confirmHandle = handle
end
function EliminateGamePopView:setExitHandle(handle)
	self.exitHandle = handle
end
return EliminateGamePopView
