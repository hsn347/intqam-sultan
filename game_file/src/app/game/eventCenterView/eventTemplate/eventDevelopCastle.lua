local gametop = gModuleMgr.getObject("gametop")
local newActivityCtrl = gametop.playertop_:getModule("newActivityCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
_ENV = gametop.playertop_
gametop.playertop_.HIDE = 1
gametop.playertop_.SHOWCOMPLETE = 2
local gametop.playertop_.SHOWTIP, panelMaskStatus = 3, gametop.playertop_
local eventDevelopCastle = class("eventDevelopCastle", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("eventDevelopCastle")
	end
	return target
end)
function eventDevelopCastle:ctor()
	self:bindBtnClose()
	self.awardArray, _ENV, self.curLvData, _ENV, self.castleData, _ENV = self.bindBtnClose, self.bindBtnClose, self.bindBtnClose, self.bindBtnClose, self.bindBtnClose, self.bindBtnClose
	self.index = 1
	self.isMoved = false
	self.direction = 0
	local kingdomLevelDataModuleAPI = include("kingdomLevelDataModuleAPI")
	self.isOpen = kingdomLevelDataModuleAPI:isOpen()
	self.textTitle = SoraDGetChildByName(self, "Text_title")
	self.textTitle:setString(i18n("common_text_2650"))
	self.Image_eventBg = SoraDGetChildByName(self, "Image_eventBg")
	self.Image_eventBg:loadTexture(SoraDCheckPNG("bg_activity_show_Pursue_man.png", gDefaultPNG.ACTIVITY_BG), ccui.TextureResType.plistType)
	self.textDes = SoraDGetChildByName(self, "Text_des")
	self.textDes:setString(i18n("common_text_2651"))
	self.nodeTime = SoraDGetChildByName(self, "Node_time")
	self.nodeTime:setVisible(false)
	self.text_leftTime = SoraDGetChildByName(self.nodeTime, "Text_leftTime")
	self.text_leftTime:setString(i18n("common_text_2669"))
	self.text_time = SoraDGetChildByName(self.nodeTime, "Text_time")
	self.text_time = SoraDCreateTimerLabel(self, self.text_time)
	self.text_LVReward = SoraDGetChildByName(self, "Text_rewardLV")
	SoraDSetTextWidthHeight(self.text_LVReward, cc.size(480, 40))
	self.scroll = SoraDGetChildByName(self, "ScrollView_reward")
	self.Text_page = SoraDGetChildByName(self, "Text_page")
	self.text_tip = SoraDGetChildByName(self, "Text_tip")
	self.text_tip:setString(i18n("common_text_2652"))
	self.text_tip:setVisible(false)
	self.panel_reward = SoraDGetChildByName(self, "Panel_reward")
	self.panel_mask = SoraDGetChildByName(self, "Panel_mask")
	self:setMaskStatus(panelMaskStatus.HIDE)
	self.img_complete = SoraDGetChildByName(self.panel_mask, "Image_1")
	self.text_complete = SoraDGetChildByName(self.panel_mask, "Text_complete")
	self.text_complete:setString(i18n("common_text_2210"))
	self.btn_help = SoraDGetChildByName(self, "Button_help")
	self.btn_help:addTouchEventListener(handler(self, self.btnHelpClickCallBack))
	self.btn_pre = SoraDGetChildByName(self, "Button_pre")
	self.btn_pre:addTouchEventListener(handler(self, self.btnPreClickCallBack))
	self.btn_next = SoraDGetChildByName(self, "Button_next")
	self.btn_next:addTouchEventListener(handler(self, self.btnNextClickCallBack))
	self.btn_pre:setPressedActionEnabled(true)
	self.btn_next:setPressedActionEnabled(true)
	SoraDGetChildByName(self, "Size_Tile_bg"):setFillType(1)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	self:initData()
end
function eventDevelopCastle:initData()
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	self.castleLV = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
	self.castleData = newActivityCtrl:getCastleUpgradeData()
	for k, v in pairs(self.castleData) do
		if not self.isOpen and v.castleLv > CASTLE_MAXLV_WAR then
			self.castleData[k] = nil
		end
	end
	for k, v in ipairs(self.castleData) do
		if v and v.castleLv > self.castleLV then
			self.index = k
			break
		end
	end
	if self.castleLV == CASTLE_MAXLV_NEW_WAR then
		self.index = #self.castleData
	end
	local upgradeCastleTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.CASTLE_UPGRADE_ACTIVITY)
	if upgradeCastleTime then
		self.nodeTime:setVisible(true)
		self.text_time:beginTime(upgradeCastleTime.timerNode.timer:getRemainTime())
		SoraDToCenter(self.nodeTime, 10, not SoraDFIsRA())
	end
	self.Text_page:setString(self.index .. "/" .. #self.castleData)
	self:refreshView()
end
function eventDevelopCastle:refreshView()
	self.curLvData = self.castleData[self.index]
	_ENV = nil
	;(nil).lv = self.curLvData.castleLv
	self.text_LVReward:setString(i18n("common_text_2671", nil))
	local buildLogic = include("buildLogic")
	local isWarLv, warLv, percent = buildLogic.isBuildWarLv(self.curLvData.castleLv)
	if isWarLv and 0 < warLv then
		_ENV = i18n("common_text_2671", nil)
		i18n("common_text_2671", nil).lv = warLv
		self.text_LVReward:setString(i18n("common_text_2678", i18n("common_text_2671", nil)))
	end
	if isWarLv and 0 < percent then
		if warLv == 0 then
			if IsArClient then
				local percentStr = percent * 100 .. "%"
				_ENV = i18n("common_text_2678", i18n("common_text_2671", nil))
				i18n("common_text_2678", i18n("common_text_2671", nil)).lv = warLv
				i18n("common_text_2678", i18n("common_text_2671", nil)).percent = percentStr
				self.text_LVReward:setString(i18n("common_text_4391", i18n("common_text_2678", i18n("common_text_2671", nil))))
			else
				local percentStr = percent * 100
				_ENV = i18n("common_text_4391", i18n("common_text_2678", i18n("common_text_2671", nil)))
				i18n("common_text_4391", i18n("common_text_2678", i18n("common_text_2671", nil))).lv = 30
				i18n("common_text_4391", i18n("common_text_2678", i18n("common_text_2671", nil))).Percent = percentStr
				self.text_LVReward:setString(i18n("common_text_2651_ros", i18n("common_text_4391", i18n("common_text_2678", i18n("common_text_2671", nil)))))
			end
		elseif IsArClient then
			local percentStr = percent * 100 .. "%"
			_ENV = i18n("common_text_2651_ros", i18n("common_text_4391", i18n("common_text_2678", i18n("common_text_2671", nil))))
			i18n("common_text_2651_ros", i18n("common_text_4391", i18n("common_text_2678", i18n("common_text_2671", nil)))).lv = warLv
			i18n("common_text_2651_ros", i18n("common_text_4391", i18n("common_text_2678", i18n("common_text_2671", nil)))).percent = percentStr
			self.text_LVReward:setString(i18n("common_text_4391", i18n("common_text_2651_ros", i18n("common_text_4391", i18n("common_text_2678", i18n("common_text_2671", nil))))))
		else
			local percentStr = percent * 100
			_ENV = i18n("common_text_4391", i18n("common_text_2651_ros", i18n("common_text_4391", i18n("common_text_2678", i18n("common_text_2671", nil)))))
			i18n("common_text_4391", i18n("common_text_2651_ros", i18n("common_text_4391", i18n("common_text_2678", i18n("common_text_2671", nil))))).Lvl = warLv
			i18n("common_text_4391", i18n("common_text_2651_ros", i18n("common_text_4391", i18n("common_text_2678", i18n("common_text_2671", nil))))).Percent = percentStr
			self.text_LVReward:setString(i18n("common_text_4391", i18n("common_text_4391", i18n("common_text_2651_ros", i18n("common_text_4391", i18n("common_text_2678", i18n("common_text_2671", nil)))))))
		end
	end
	if self.curLvData.receive then
		self:setMaskStatus(panelMaskStatus.SHOWCOMPLETE)
	elseif self.castleLV >= self.curLvData.castleLv then
		self:setMaskStatus(panelMaskStatus.SHOWTIP)
	else
		self:setMaskStatus(panelMaskStatus.HIDE)
	end
	self:initRewards(self.curLvData.reward)
	self.Text_page:setString(self.index .. "/" .. #self.castleData)
end
function eventDevelopCastle:initRewards(rewardData)
	for k, v in ipairs(self.awardArray) do
		if v then
			v:setVisible(false)
		end
	end
	local scrollH = math.max(self.scroll:getContentSize().height, 90 * math.ceil(#rewardData / 4))
	local initPosY = scrollH + 45
	self.scroll:setInnerContainerSize(cc.size(self.scroll:getContentSize().width, scrollH))
	for k, v in ipairs(rewardData) do
		if not self.awardArray[k] then
			local line = math.ceil(k / 4)
			local row = k % 4 == 0 and 4 or k % 4
			local item = include("commonItemAward").new()
			item:setScale(0.8)
			item:setBaseScale(1.0)
			item:setPosition(cc.p(60 + 100 * (row - 1), initPosY - 90 * line))
			item:setOwnView(self)
			item:addTo(self.scroll)
			self.awardArray[k] = item
		else
			self.awardArray[k]:setVisible(true)
		end
		self.awardArray[k]:initData(v.id, v.count)
	end
end
function eventDevelopCastle:setMaskStatus(status)
	if status == panelMaskStatus.HIDE then
		self.panel_mask:setVisible(false)
		self.text_tip:setVisible(false)
	elseif status == panelMaskStatus.SHOWCOMPLETE then
		self.panel_mask:setVisible(true)
		self.img_complete:setVisible(true)
		self.text_tip:setVisible(false)
	elseif status == panelMaskStatus.SHOWTIP then
		self.panel_mask:setVisible(true)
		self.img_complete:setVisible(false)
		self.text_tip:setVisible(true)
	end
end
function eventDevelopCastle:btnHelpClickCallBack(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowHelpMsgTip(i18n("common_text_2670"))
	end
end
function eventDevelopCastle:showItemDes(target)
	local tips = SoraDCreatePanel("commonItemTips")
	tips:initData(target:getTag())
	local dt = 140
	if not SoraDFIsRA() then
		dt = -140
	end
	tips:setPosition(cc.p(self.panel_reward:getContentSize().width / 2 + dt, 175))
	tips:setName("tips")
	tips:addTo(self.panel_reward, 99)
end
function eventDevelopCastle:removeItemDes(target)
	local tips = self.panel_reward:getChildByName("tips")
	if tips then
		tips:removeFromParent()
	end
end
function eventDevelopCastle:showPreData()
	self.index = self.index - 1
	if self.index < 1 then
		self.index = #self.castleData
	end
	self:refreshView()
end
function eventDevelopCastle:showNextData()
	self.index = self.index + 1
	if self.index > #self.castleData then
		self.index = 1
	end
	self:refreshView()
end
function eventDevelopCastle:btnPreClickCallBack(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:showPreData()
	end
end
function eventDevelopCastle:btnNextClickCallBack(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:showNextData()
	end
end
function eventDevelopCastle:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.CASTLE_UPGRADE_ACTIVITY) then
		self:removeFromParent()
	end
end
return eventDevelopCastle
