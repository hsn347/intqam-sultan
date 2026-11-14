local gametop = gModuleMgr.getObject("gametop")
local epicWarCtrl = gametop.playertop_:getModule("epicWarCtrl")
local epicWarltCtrl = include("epicWarltCtrl")
local epicWarChapterAward = class("epicWarChapterAward", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("epicWarChapterAward")
	end
	return target
end)
function epicWarChapterAward:ctor()
	self.data, _ENV = nil, nil
	self.Text_title = SoraDGetChildByName(self, "Text_title")
	self.Text_title:setString(i18n("epic_war_dailyBox_desc"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_reward")
	self.Button_gain = SoraDGetChildByName(self, "Button_gain")
	self.Button_gain:addTouchEventListener(handler(self, self.onBtnClickBack))
	self.Node_time = SoraDGetChildByName(self, "Node_time")
	self.Text_time = SoraDGetChildByName(self, "Text_time")
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	self.icon_box = SoraDGetChildByName(self, "icon_box")
	self:initData()
end
function epicWarChapterAward:initData()
	local ret, time = epicWarCtrl:isDailyRewardReceived()
	self.Node_time:setVisible(ret)
	self.Button_gain:setPositionY(ret and -176 or -196)
	self.icon_box:setSpriteFrame(ret and "icon_epicWar_dailybox2.png" or "icon_epicWar_dailybox1.png")
	if ret then
		self.Button_gain:setTitleText(i18n("common_text_1892"))
		self.Button_gain:setBright(false)
		self.Button_gain:setTouchEnabled(false)
		self.Button_gain:setTitleColor(cc.c3b(120, 120, 120))
		self.Text_time:beginTime(time)
		self.Text_time:setTimeEndListener(function()
			self:initData()
		end)
		SoraDToCenter(self.Node_time)
	else
		self.Button_gain:setTitleText(i18n("common_text_1146"))
		self.Button_gain:setBright(true)
		self.Button_gain:setTouchEnabled(true)
		self.Button_gain:setTitleColor(cc.c3b(255, 255, 255))
	end
	self:setAwards()
end
function epicWarChapterAward:setAwards()
	local stageID = epicWarCtrl:getMaxPassedGateID()
	local dailybox = epicWarltCtrl.getDailyBox(stageID)
	_ENV = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	local award = serviceFunctions.tableFormat(dailybox, nil)
	local scrollH = math.max(self.scroll:getContentSize().height, 100 * math.ceil(#award / 5))
	self.scroll:setInnerContainerSize(cc.size(self.scroll:getContentSize().width, scrollH))
	self.scroll:setBounceEnabled(self.scroll:getInnerContainerSize().height > self.scroll:getContentSize().height)
	for k, v in ipairs(award) do
		local line = math.ceil(k / 5)
		local row = k % 5 == 0 and 5 or k % 5
		local itemAward = include("commonItemAward").new()
		itemAward:setScale(0.8)
		itemAward:setBaseScale(1.0)
		itemAward:setOwnView(self)
		itemAward:initData(v.id, v.count)
		itemAward:setPosition(70 + (row - 1) * 100, scrollH - line * 100 + 50)
		itemAward:addTo(self.scroll)
	end
end
function epicWarChapterAward:onBtnClickBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		epicWarCtrl:sendRevieveDailyReward()
		self:removeFromParent()
	end
end
return epicWarChapterAward
