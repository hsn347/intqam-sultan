local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local unchartedCtrl = gametop.playertop_:getModule("unchartedCtrl")
local unchartedFreeTaskView = class("unchartedFreeTaskView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("unchartedFreeTaskView")
	end
	return target
end)
local CORLOR_GREY = cc.c3b(120, 120, 120)
local CORLOR_NORMAL = cc.c3b(255, 255, 255)
local CORLOR_GREEN = cc.c3b(0, 190, 30)
local singleCostGold = 50
function unchartedFreeTaskView:ctor()
	self:initControls()
	self:initFourBlocks()
end
function unchartedFreeTaskView:initControls()
	self.panelCommon = SoraDGetChildByName(self, "panel_common")
	self.btnQuest = SoraDGetChildByName(self, "btn_quest")
	self.btnJump = SoraDGetChildByName(self, "btn_jump")
	self.btnReset = SoraDGetChildByName(self, "btn_reset")
	self.txtRemainSet = SoraDGetChildByName(self, "text_remainSet")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("Secret_explore_text_04"))
	self.btnJump:addTouchEventListener(handler(self, self.singleClickCallBack))
	self.btnReset:addTouchEventListener(handler(self, self.resetClickCallBack))
	self.btnQuest:addTouchEventListener(handler(self, self.questClickCallBack))
	self.ccs_bg:setSize(cc.size(550, 800))
	if display.height < 960 then
		self.ccs_bg.Panel_cut:setPosition(cc.p(275, 100))
		self.btnQuest:setPositionY(470)
		self.txtRemainSet:setPositionY(-250)
	else
		self.ccs_bg.Panel_cut:setPosition(cc.p(275, 170))
		self.btnQuest:setPositionY(540)
		self.txtRemainSet:setPositionY(-180)
	end
	self.txtGoldTable, _ENV, self.btnResetTable, _ENV, self.canDoTable, _ENV, self.btnTable, _ENV = self.txtRemainSet.setPositionY, self.txtRemainSet.setPositionY, self.txtRemainSet.setPositionY, self.txtRemainSet.setPositionY, self.txtRemainSet.setPositionY, self.txtRemainSet.setPositionY, self.txtRemainSet.setPositionY, self.txtRemainSet.setPositionY
	self.resetCountTable, _ENV, self.goldCostTable, _ENV, self.totalResetTimes = self.txtRemainSet.setPositionY, self.txtRemainSet.setPositionY, self.txtRemainSet.setPositionY, self.txtRemainSet.setPositionY, 0
end
function unchartedFreeTaskView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_UNCHARTED_COMMON_REFRESH_BACK", handler(self, self.refreshData))
end
function unchartedFreeTaskView:initFourBlocks()
	for i = 1, 4 do
		local cell = self.panelCommon:clone()
		local txtCando = SoraDGetChildByName(cell, "text_canDo")
		local btnReset = SoraDGetChildByName(cell, "btn_reset")
		local txtGold = SoraDGetChildByName(cell, "text_gold")
		local txtReset = SoraDGetChildByName(cell, "text_reset")
		local btnJump = SoraDGetChildByName(cell, "btn_jump")
		local imageTask = SoraDGetChildByName(cell, "image_task")
		if i == 1 then
			if display.height < 960 then
				cell:setPosition(140, 400)
			else
				cell:setPosition(140, 490)
			end
			imageTask:loadTexture("btn_challenge_xyc.png", ccui.TextureResType.plistType)
			local wellCell = cityCtrl:getBuildCell(BUILDID.WISHING_WELL, 0)
			if wellCell == nil or tonumber(wellCell.info.state) == BUILD_STATE.BUILDING then
				imageTask:getVirtualRenderer():setState(1)
				btnJump:getVirtualRenderer():setState(1)
				btnJump:setEnabled(false)
			end
		elseif i == 2 then
			if display.height < 960 then
				cell:setPosition(405, 400)
			else
				cell:setPosition(405, 490)
			end
			imageTask:loadTexture("1010.png", ccui.TextureResType.plistType)
			local castleLV = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
			imageTask:getVirtualRenderer():setState(tonumber(castleLV) < CASTLE_LV8_LIMITED and 1 or 0)
			btnJump:getVirtualRenderer():setState(tonumber(castleLV) < CASTLE_LV8_LIMITED and 1 or 0)
			btnJump:setEnabled(tonumber(castleLV) >= CASTLE_LV8_LIMITED)
		elseif i == 3 then
			if display.height < 960 then
				cell:setPosition(140, 80)
			else
				cell:setPosition(140, 170)
			end
			imageTask:loadTexture("3004.png", ccui.TextureResType.plistType)
		elseif i == 4 then
			if display.height < 960 then
				cell:setPosition(405, 80)
			else
				cell:setPosition(405, 170)
			end
			imageTask:loadTexture("allitreas_box_01.png", ccui.TextureResType.plistType)
		end
		btnJump:setTag(i)
		btnReset:setTag(i)
		txtReset:setString(i18n("common_text_4152"))
		cell:addTo(self.ccs_bg)
		table.insert(self.btnTable, btnJump)
		table.insert(self.canDoTable, txtCando)
		table.insert(self.btnResetTable, btnReset)
		table.insert(self.txtGoldTable, txtGold)
	end
end
function unchartedFreeTaskView:initData(unchartedInfo)
	if not unchartedInfo then
		return
	end
	dump(unchartedInfo, "description")
	local resetStr = string.format("%s%d", i18n("Secret_explore_text_49"), unchartedInfo.totalReset)
	self.txtRemainSet:setString(resetStr)
	for i = 1, 4 do
		local txtTimes = SoraDGetChildByName(self.btnTable[i], "text_times")
		local txtDes = SoraDGetChildByName(self.btnTable[i], "text_describe")
		local planStr = ""
		local desStr = ""
		local commonCanDoStr = ""
		if self.btnTable[i]:getTag() == gUnchartedFreeType.WISH then
			planStr = string.format("%d/%d", unchartedInfo.wishInfo.plan, unchartedInfo.wishInfo.need)
			_ENV = unchartedInfo.wishInfo.plan
			unchartedInfo.wishInfo.plan.Num = unchartedInfo.wishInfo.need
			desStr = i18n("Secret_explore_text_41", unchartedInfo.wishInfo.plan)
			commonCanDoStr = string.format([[
(%s %d/%d)
%s]], i18n("Secret_explore_text_45"), unchartedInfo.wishInfo.cando, unchartedInfo.wishInfo.maxdo, i18n("Secret_explore_text_46"))
			self.canDoTable[i]:setVisible(unchartedInfo.wishInfo.cando > 0)
			self.btnResetTable[i]:setVisible(unchartedInfo.wishInfo.cando <= 0)
			self.txtGoldTable[i]:setString(unchartedInfo.wishInfo.maxdo * singleCostGold)
			table.insert(self.goldCostTable, unchartedInfo.wishInfo.maxdo * singleCostGold)
			table.insert(self.resetCountTable, unchartedInfo.wishInfo.cando)
		elseif self.btnTable[i]:getTag() == gUnchartedFreeType.COSTPW then
			planStr = string.format("%d/%d", unchartedInfo.costPWCoin.plan, unchartedInfo.costPWCoin.need)
			_ENV = unchartedInfo.costPWCoin.plan
			unchartedInfo.costPWCoin.plan.Num = unchartedInfo.costPWCoin.need
			desStr = i18n("Secret_explore_text_42", unchartedInfo.costPWCoin.plan)
			commonCanDoStr = string.format([[
(%s %d/%d)
%s]], i18n("Secret_explore_text_45"), unchartedInfo.costPWCoin.cando, unchartedInfo.costPWCoin.maxdo, i18n("Secret_explore_text_46"))
			self.canDoTable[i]:setVisible(0 < unchartedInfo.costPWCoin.cando)
			self.btnResetTable[i]:setVisible(0 >= unchartedInfo.costPWCoin.cando)
			self.txtGoldTable[i]:setString(unchartedInfo.costPWCoin.maxdo * singleCostGold)
			table.insert(self.goldCostTable, unchartedInfo.costPWCoin.maxdo * singleCostGold)
			table.insert(self.resetCountTable, unchartedInfo.costPWCoin.cando)
		elseif self.btnTable[i]:getTag() == gUnchartedFreeType.COSTPHYSICAL then
			planStr = string.format("%d/%d", unchartedInfo.costPhysical.plan, unchartedInfo.costPhysical.need)
			_ENV = unchartedInfo.costPhysical.plan
			unchartedInfo.costPhysical.plan.Num = unchartedInfo.costPhysical.need
			desStr = i18n("Secret_explore_text_43", unchartedInfo.costPhysical.plan)
			commonCanDoStr = string.format([[
(%s %d/%d)
%s]], i18n("Secret_explore_text_45"), unchartedInfo.costPhysical.cando, unchartedInfo.costPhysical.maxdo, i18n("Secret_explore_text_46"))
			self.canDoTable[i]:setVisible(0 < unchartedInfo.costPhysical.cando)
			self.btnResetTable[i]:setVisible(0 >= unchartedInfo.costPhysical.cando)
			self.txtGoldTable[i]:setString(unchartedInfo.costPhysical.maxdo * singleCostGold)
			table.insert(self.goldCostTable, unchartedInfo.costPhysical.maxdo * singleCostGold)
			table.insert(self.resetCountTable, unchartedInfo.costPhysical.cando)
		elseif self.btnTable[i]:getTag() == gUnchartedFreeType.CHEST then
			planStr = string.format("%d/%d", unchartedInfo.openChest.plan, unchartedInfo.openChest.need)
			_ENV = unchartedInfo.openChest.plan
			unchartedInfo.openChest.plan.Num = unchartedInfo.openChest.need
			desStr = i18n("Secret_explore_text_44", unchartedInfo.openChest.plan)
			commonCanDoStr = string.format([[
(%s %d/%d)
%s]], i18n("Secret_explore_text_45"), unchartedInfo.openChest.cando, unchartedInfo.openChest.maxdo, i18n("Secret_explore_text_46"))
			self.canDoTable[i]:setVisible(0 < unchartedInfo.openChest.cando)
			self.btnResetTable[i]:setVisible(0 >= unchartedInfo.openChest.cando)
			self.txtGoldTable[i]:setString(unchartedInfo.openChest.maxdo * singleCostGold)
			table.insert(self.goldCostTable, unchartedInfo.openChest.maxdo * singleCostGold)
			table.insert(self.resetCountTable, unchartedInfo.openChest.cando)
		end
		txtTimes:setString(planStr)
		txtDes:setString(desStr)
		self.totalResetTimes = unchartedInfo.totalReset
		self.canDoTable[i]:setString(commonCanDoStr)
	end
end
function unchartedFreeTaskView:refreshData(target, data)
	local unchartedInfo = unchartedCtrl:getUnchartedInfo()
	self.goldCostTable, unchartedCtrl, self.resetCountTable, unchartedCtrl = unchartedCtrl, unchartedCtrl, unchartedCtrl, unchartedCtrl
	self:initData(unchartedInfo)
end
function unchartedFreeTaskView:singleClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if button:getTag() == gUnchartedFreeType.WISH then
			uiManager:show("TreasureHuntView")
		elseif button:getTag() == gUnchartedFreeType.COSTPW then
			uiManager:show("pyramidMain")
		elseif button:getTag() == gUnchartedFreeType.COSTPHYSICAL then
			_ENV = gUnchartedFreeType.COSTPHYSICAL
			gUnchartedFreeType.COSTPHYSICAL.msg = "MESSAGE_MAINSCEN_ONSHOW"
			gUnchartedFreeType.COSTPHYSICAL.viewType = VIEW_TYPE_MAP
			SoraDSendMessage(gUnchartedFreeType.COSTPHYSICAL)
			SoraDRemoveAllPanelFromManager()
		elseif button:getTag() == gUnchartedFreeType.CHEST then
			if allianceMgr:hasJoinAlliance() then
				local depotBcell = cityCtrl:getBuildCell(BUILDID.DEPOT, 0)
				if tonumber(depotBcell.info.lv) >= DEPOT_LV_ALLIANCE_TRRASURE then
					if GLOBAL_GAME_ALLIANCE_MODE then
						_ENV = nil
						;(nil).tag = 3
						uiManager:show("allianceStoreHouseView", nil)
					else
						local panel = SoraDCreatePanel("allianceStoreHouseView")
						panel:gotoBtn(3)
						panel:show()
					end
				else
					SoraDShowMsgTip(i18n("allitreas_text_03"))
				end
			else
				uiManager:show("AllianceJoinView")
			end
		end
	end
end
function unchartedFreeTaskView:resetClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.resetCountTable[button:getTag()] > 0 then
			SoraDShowMsgTip(i18n("Secret_explore_notice_16"))
			return
		end
		if 0 < self.totalResetTimes then
			if lordInfoCtrl:getBaseInfo().gold < self.goldCostTable[button:getTag()] then
				SoraDShowMsgBox(i18n("common_text_430"), i18n("common_text_054"), nil, handler(self, self.gotoStore))
			else
				SoraDShowMsgTip(i18n("Secret_explore_notice_11"))
				unchartedCtrl:sendResetTaskMsg(button:getTag())
			end
		else
			SoraDShowMsgTip(i18n("Secret_explore_notice_09"))
		end
	end
end
function unchartedFreeTaskView:gotoStore(type)
	if type == MSGBOX_CALLBACK_YES then
		if GLOBAL_GAME_RECHARGE_MODE then
			uiManager:show("rechargeView")
		else
			SoraDCreatePanel("rechargeView"):show()
		end
	end
end
function unchartedFreeTaskView:questClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.UNCHARTED_FREE_TASK)
	end
end
return unchartedFreeTaskView
