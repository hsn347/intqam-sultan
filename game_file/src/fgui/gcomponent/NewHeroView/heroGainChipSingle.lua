local gametop = gModuleMgr.getObject("gametop")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local activityTimeRead = include("activityTimeRead")
local baseComponent = require("fgui.base.baseComponent")
local heroGainChipSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewHeroView/heroGainChipSingle", heroGainChipSingle)
function heroGainChipSingle:onInit()
	self.fields.Button_method:setTitleText(i18n("common_text_477"))
	self:fixChildrenPos()
end
function heroGainChipSingle:onShow()
end
function heroGainChipSingle:initData(data, heroRarity)
	self.data = data
	self.heroRarity = heroRarity
	self.controllers.c1:setSelectedIndex(self.data.methodType - 1)
	if self.data.methodType == gHeroChipMethodType.rechargeEvent then
		self.fields.Text_method:setString(i18n("hero_text_47"))
		if self.data.heroID and self.data.heroID == gHeroBerserkerID and heroCtrl:getHeroInfoByID(self.data.heroID) then
			self.fields.Button_method:setVisible(true)
			self.fields.Button_method:addClickListener(function()
				SoraDPlaySound()
				if GLOBAL_GAME_RECHARGE_MODE then
					_ENV = nil
					;(nil).rechargeID = gHeroLadderBreakJailMaxGiftID
					uiManager:show("rechargeView", nil)
				else
					local panel = SoraDCreatePanel("rechargeView")
					panel:jumpToLimitNode(20, gHeroLadderBreakJailMaxGiftID)
					panel:show()
				end
			end)
		else
			self.fields.Button_method:setVisible(false)
		end
	elseif self.data.methodType == gHeroChipMethodType.epicWar then
		local epicWarCtrl = gametop.playertop_:getModule("epicWarCtrl")
		local epicWarltCtrl = include("epicWarltCtrl")
		self.fields.Text_method:setString(i18n("epicbattle_title_01"))
		self.fields.Text_unlock:setString(i18n("common_text_2274"))
		self.fields.Text_unlock:setColor(cc.c3b(120, 120, 120))
		local cid, sid = epicWarltCtrl.getChapNumAndStageNum(self.data.bringData)
		self.fields.Text_method_route:setString(cid .. "-" .. sid)
		if SoraDFIsRA() then
			self.fields.Text_method_route:setPositionX(self.fields.Text_method:getPositionX() - self.fields.Text_method:getContentSize().width - 20)
		else
			self.fields.Text_method_route:setPositionX(self.fields.Text_method:getPositionX() + self.fields.Text_method:getContentSize().width + 20)
		end
		local isUnlock = epicWarCtrl:getCurChapterInfo(cid).isUnlock
		if not isUnlock then
			self.fields.Button_method:setVisible(false)
			self.fields.Text_unlock:setVisible(true)
		else
			self.fields.Button_method:setVisible(true)
			self.fields.Text_unlock:setVisible(false)
			self.fields.Button_method:addClickListener(function()
				SoraDPlaySound()
				local panel = SoraDCreatePanel("epicWarChapterView")
				panel:show()
				panel:skipToGate(self.data.bringData)
			end)
		end
	elseif self.data.methodType == gHeroChipMethodType.hegemon then
		self.fields.Text_method:setString(i18n("hegemon_name_13"))
		local hegemonCtrl = gametop.playertop_:getModule("hegemonCtrl")
		local hegemonState = hegemonCtrl:getHegemonActivityStatus()
		local isUnlock = hegemonState == gActivityState.OPEN
		if not isUnlock then
			self.fields.Button_method:setVisible(false)
			self.fields.Text_unlock:setString(i18n("common_text_699"))
			self.fields.Text_unlock:setVisible(true)
		else
			self.fields.Text_unlock:setVisible(false)
			self.fields.Button_method:setVisible(true)
			self.fields.Button_method:addClickListener(function()
				SoraDPlaySound()
				SoraDCreatePanel("hegemonActivity"):show()
			end)
		end
	elseif self.data.methodType == gHeroChipMethodType.daily then
		self.fields.Text_method:setString(i18n("daily_reward_name_13"))
		self.fields.Button_method:addClickListener(function()
			SoraDPlaySound()
			uiManager:show("LuckyCard")
		end)
	elseif self.data.methodType == gHeroChipMethodType.activity then
		if self.data.activityID then
			local cfg = clientEventMgr.getActivityCfg(self.data.activityID)
			if cfg and next(cfg) then
				self.controllers.c1:setSelectedIndex(8)
				self.fields.Text_method:setString(cfg.name)
				self.fields.n7:setSpriteFrame(cfg.icon)
				self.fields.Button_method:addClickListener(function()
					SoraDPlaySound()
					clientEventMgr.singleClickEvent(self.data.activityID)
				end)
			else
				self.fields.Text_method:setString(i18n("common_text_835"))
			end
		else
			self.fields.Text_method:setString(i18n("common_text_835"))
		end
	elseif self.data.methodType == gHeroChipMethodType.annals then
		self.fields.Text_method:setString(i18n("history_name_11"))
		self.fields.Button_method:addClickListener(function()
			SoraDPlaySound()
			SoraDRemoveAllPanelFromManager()
			local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
			_ENV = nil
			mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.ANNALS, nil)
		end)
	elseif self.data.methodType == gHeroChipMethodType.exchange then
		local chipID = heroltCtrl:getChipID(self.data.heroID)
		local exchangeInfo = heroltCtrl:getExchangeInfo(chipID)
		local heroInfo = heroCtrl:getHeroInfoByID(self.data.heroID)
		local publicRead = include("publicRead")
		self.fields.n7:setSpriteFrame(publicRead.getIcon(exchangeInfo.changeID))
		self.fields.Text_method:setString(publicRead.getName(exchangeInfo.changeID))
		self.fields.Button_method:addTouchEventListener(function()
			SoraDPlaySound()
			if heroInfo then
				local ownNum = backpackCtrl:getItemCount(exchangeInfo.changeID)
				if 0 < ownNum then
					_ENV = nil
					;(nil).heroID = self.data.heroID
					;(nil).mode = 2
					uiManager:show("HeroChipExchange", nil)
				else
					SoraDShowMsgTip(i18n("heroskill_text_03"), "#" .. publicRead.getIcon(exchangeInfo.changeID))
				end
			else
				_ENV = "#" .. publicRead.getIcon(exchangeInfo.changeID)
				;("#" .. publicRead.getIcon(exchangeInfo.changeID)).name = publicRead.getName(exchangeInfo.changeID)
				SoraDShowMsgTip(i18n("hero_text_115", "#" .. publicRead.getIcon(exchangeInfo.changeID)))
			end
		end)
	elseif self.data.methodType == gHeroChipMethodType.dress then
		local jumpType = self.data.output.jumpType
		if jumpType == 1 then
			self.fields.Text_method:setString(i18n(self.data.output.jumpDes))
			self.fields.Button_method:addTouchEventListener(function()
				SoraDPlaySound()
				local jumpTab = self.data.output.type[1]
				local activityID = self.data.output.type[2]
				local targetID = self.data.output.type[3]
				local giftID = self.data.output.type[4]
				if clientEventMgr.judgeIsOpen(activityID) then
					if SoraDCheckShow(giftID) or SoraDCheckPresentGift(giftID) then
						if GLOBAL_GAME_RECHARGE_MODE then
							_ENV = nil
							;(nil).toCategory = gRechargeCenterCategory.RECHARGE_PRESENT
							;(nil).rechargeID = giftID
							uiManager:show("rechargeView", nil)
						else
							local panel = SoraDCreatePanel("rechargeView")
							panel:expect2SelectTab(jumpTab, activityID, targetID, giftID)
							panel:show()
						end
					else
						SoraDShowMsgTip(i18n("common_text_4603"))
					end
				else
					SoraDShowMsgTip(i18n("common_text_2486"))
				end
			end)
		elseif jumpType == 2 then
			local activityID = self.data.activityID
			local classType = self.data.classType or 0
			self.fields.Text_method:setString(i18n(activityTimeRead.getActivityNameByID(activityID, classType)))
			self.fields.Button_method:addTouchEventListener(function()
				SoraDPlaySound()
				if clientEventMgr.judgeIsOpen(activityID) then
					local param = SoraDGetCtrl("activityShowCtrl"):getParamByID(activityID)
					local curClassType = param.classtype or 1
					if self.data.classType and self.data.classType == curClassType or not self.data.classType then
						clientEventMgr.singleClickEvent(activityID)
					else
						SoraDShowMsgTip(i18n("common_text_2486"))
					end
				else
					SoraDShowMsgTip(i18n("common_text_2486"))
				end
			end)
		elseif jumpType == 3 then
			self.fields.Text_method:setString(i18n(self.data.output.jumpDes))
			self.fields.Button_method:addTouchEventListener(function()
				SoraDPlaySound()
				local isOnSale = false
				for _, giftID in ipairs(self.data.output.type) do
					if SoraDCheckShow(giftID) then
						isOnSale = true
						break
					end
				end
				if isOnSale then
					if GLOBAL_GAME_RECHARGE_MODE then
						_ENV = nil
						;(nil).rechargeIDList = self.data.output.type
						uiManager:show("rechargeView", nil)
					else
						local class = self.data.output.class > 0 and self.data.output.class or 12
						local panel = SoraDCreatePanel("rechargeView")
						panel:jumpToLimitNodeByList(class, self.data.output.type)
						panel:show()
					end
				else
					SoraDShowMsgTip(i18n("common_text_4603"))
				end
			end)
		end
	elseif self.data.methodType == gHeroChipMethodType.dailyTask then
		self.fields.Text_method:setString(i18n(self.data.des))
		self.fields.Button_method:addTouchEventListener(function()
			SoraDPlaySound()
			if self.heroRarity >= gHeroRarity.ORANGE then
				uiManager:show("bagView")
			else
				_ENV = nil
				;(nil).tab = 2
				uiManager:show("questView", nil)
			end
		end)
	elseif self.data.methodType == gHeroChipMethodType.rechargeExp then
		self.fields.Text_method:setString(i18n(self.data.des))
		self.fields.Button_method:addTouchEventListener(function()
			SoraDPlaySound()
			if GLOBAL_GAME_RECHARGE_MODE then
				_ENV = nil
				;(nil).menuEnum = 18
				uiManager:show("rechargeView", nil)
			else
				local panel = SoraDCreatePanel("rechargeView")
				panel:jumpToLimitNodeByList(18)
				panel:show()
			end
		end)
	end
end
return heroGainChipSingle
