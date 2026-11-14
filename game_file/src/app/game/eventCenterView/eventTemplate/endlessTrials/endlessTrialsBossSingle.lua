local endlessTrialsCtrl = SoraDGetCtrl("endlessTrialsCtrl")
local mailFunctions = include("mailFunctions")
local endlessTrialsBossSingle = class("endlessTrialsBossSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("endlessTrialsBossSingle")
	end
	return target
end)
function endlessTrialsBossSingle:ctor()
	self:initWidget()
end
function endlessTrialsBossSingle:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_CLOSELOADING", function()
		SoraDCloseLoading(self.Button_go)
	end)
end
function endlessTrialsBossSingle:initWidget()
	SoraDGetAllChildFromWidget(self, self)
	self.Text_point = SoraDChangeTextToHtml(self.Text_point)
	self.Text_point:setTouchEnabled(true)
	self.Text_point:addTouchEventListener(handler(self, self.onCoordinate))
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	self.Text_time:setTimeLast(function(ticket)
		return i18n("Endless_trial_text_07") .. ticket
	end)
	self.Text_time:setTimeEndListener(handler(self, self.refreshTime))
	self:refreshTime()
	self.Button_go:setTitleText(i18n("treasure_crystal_btn_01"))
	self.Button_go:addTouchEventListener(handler(self, self.btnGoCallBack))
	self.Button_info:addTouchEventListener(handler(self, self.btnInfoCallBack))
	SoraDAutoSizeButtonTextByContent(self.Button_go)
end
function endlessTrialsBossSingle:initData(data, otherData)
	if otherData.isDown then
		self.Node_info:setVisible(false)
		return
	elseif otherData.isUp then
		self.Panel_cut:setVisible(false)
	end
	self.data = data
	self.scroll = otherData.scroll
	self.bossTypeList = endlessTrialsCtrl:getBossTypeList(data.type)
	self.Text_name1:setString(i18n(worldMapDefine.getWorldBossName(self.bossTypeList[1])))
	self.Text_name2:setString(i18n(data.name))
	self.pos = endlessTrialsCtrl:getProtalInfo(data.snowmountainID) or cc.p(data.coordinate[1], data.coordinate[2])
	local myCityTilePoint = SoraDGetCtrl("cityCtrl"):getCurCityPos()
	local miles = cc.pGetDistance(myCityTilePoint, self.pos)
	local u = not otherData.noJump
	self.Text_point:setTouchEnabled(u)
	endlessTrialsCtrl = u
	u.title = i18n("common_text_2155", self.pos)
	endlessTrialsCtrl = self.pos
	self.pos.distance = math.ceil(miles)
	endlessTrialsCtrl, endlessTrialsCtrl, u.des = "common_text_489", i18n("common_text_489", self.pos), i18n("common_text_489", self.pos)
	i18n("common_text_489", self.pos).__default, ("common_text_489").u = "common_text_489", u
	local str = i18n_html("common_text_2482", u, (i18n("common_text_489", self.pos)))
	self.Text_point:setString(str)
	self.Text_point:setPositionX(self.Text_name2:getPositionX() - SoraDFSign(self.Text_name2:getContentSize().width + 10))
	self.bossInfoList = endlessTrialsCtrl:getBossInfoList()
	local maxLv = self.bossInfoList[tostring(data.type)] or data.maxlv or 1
	self.maxLv = maxLv
	endlessTrialsCtrl = miles
	miles.lv = maxLv
	self.Text_maxLv:setString(i18n("Endless_trial_text_08") .. i18n("common_text_2567", miles))
	self.Sprite_class1:setSpriteFrame(mailFunctions:getSoldierClassIcon(data.arms[1]))
	self.Sprite_class2:setSpriteFrame(mailFunctions:getSoldierClassIcon(data.arms[2]))
	local config = endlessTrialsCtrl:getScoreConfig(data.type, maxLv)
	endlessTrialsCtrl = mailFunctions:getSoldierClassIcon(data.arms[2])
	mailFunctions:getSoldierClassIcon(data.arms[2]).num1 = maxLv
	mailFunctions:getSoldierClassIcon(data.arms[2]).num2 = config.perScore
	mailFunctions:getSoldierClassIcon(data.arms[2]).num3 = config.allienceScore
	self.Text_reward:setString(i18n("Endless_trial_text_09", mailFunctions:getSoldierClassIcon(data.arms[2])))
	if u then
		self.Text_time:setVisible(false)
	else
		self.Text_name2:setVisible(false)
		self.Text_point:setVisible(false)
	end
end
function endlessTrialsBossSingle:btnGoCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			return
		end
		SoraDPlaySound()
		SoraDShowLoading(button)
		endlessTrialsCtrl:reqSearchBoss(self.pos, self.maxLv, self.bossTypeList)
	end
end
function endlessTrialsBossSingle:btnInfoCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			return
		end
		SoraDPlaySound()
		local panel = SoraDCreatePanel("endlessTrialsScore")
		panel:initData(self.data.type)
		panel:show()
	end
end
function endlessTrialsBossSingle:onCoordinate(button, type)
	if type == ccui.TouchEventType.ended then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			return
		end
		SoraDPlaySound()
		SoraDGotoWorldMapPoint(self.pos, true)
		SoraDRemoveAllPanelFromManager()
	end
end
function endlessTrialsBossSingle:refreshTime(...)
	local leftTime = endlessTrialsCtrl:getNextRefreshTime()
	if leftTime then
		self.Text_time:setVisible(true)
		self.Text_time:beginTime(leftTime)
	else
		self.Text_time:setVisible(false)
	end
end
return endlessTrialsBossSingle
