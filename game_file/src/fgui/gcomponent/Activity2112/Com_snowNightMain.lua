local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local constantRead = include("constantRead")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local snowyNightCarnivalCtrl = SoraDGetCtrl("snowyNightCarnivalCtrl")
local snowyNightCarnivalltCtrl = include("snowyNightCarnivalltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_snowNightMain = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity2112/Com_snowNightMain", Com_snowNightMain)
function Com_snowNightMain:onInit()
	self:fixChildrenPos()
	self.fields.n1:fix(false)
	self.fields.n2:fix(false)
	self.activityID = gActivityTimeActivityID.SNOWY_NIGHT_CARNIVAL_ACTIVITY
	self.openFurtherCost = constantRead.getConstValue("SNOWY_NIGHT_UNLOCK_GOLD", 1000)
	self:setTime()
	self.fields.Text_advance:setString(i18n("common_text_1225"))
	self.fields.Text_normal:setString(i18n("cityUp_title_03"))
	self.fields.Text_level:setString(i18n("common_text_748"))
	self.fields.List_reward:setVirtual()
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self:initData()
	if not snowyNightCarnivalCtrl:getUnlockFurther() then
		self.fields.Button_extraPrice:initData(self.openFurtherCost, i18n("common_text_740"))
		self:updateFurtherBtn()
		self.fields.Button_extraPrice:addClickListener(handler(self, self.onClickOpenFurther))
	else
		self.fields.Touch_lock:setVisible(false)
		self.fields.Button_extraPrice:setVisible(false)
	end
end
function Com_snowNightMain:initData()
	self.fields.List_reward:setNumItems(snowyNightCarnivalltCtrl.getRewardConfigSize())
end
function Com_snowNightMain:updateFurtherBtn()
	if not snowyNightCarnivalCtrl:getUnlockFurther() then
		local haveGold = lordInfoCtrl:getBaseInfo().gold
		self.fields.Button_extraPrice:setStatus(haveGold >= self.openFurtherCost)
	else
		self.fields.Touch_lock:setVisible(false)
		self.fields.Button_extraPrice:setVisible(false)
	end
end
function Com_snowNightMain:setTime()
	local eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	if eventTime then
		self.fields.Label_time:beginTime(eventTime.timerNode.timer:getRemainTime())
	end
end
function Com_snowNightMain:onItemRenderer(index, object)
	object:initData(index + 1, snowyNightCarnivalltCtrl.getRewardConfigByLevel(index + 1))
end
function Com_snowNightMain:onClickOpenFurther()
	SoraDPlaySound()
	if SoraDEnoughGold(self.openFurtherCost) then
		_ENV = nil
		_ENV = nil
		;(nil).num = self.openFurtherCost
		;(nil).content = i18n("snowy_night_text_002", nil)
		;(nil).confirmFunc = function()
			snowyNightCarnivalCtrl:sendOpenFutherRewardMsg()
		end
		;(nil).cancelFunc = function()
		end
		uiManager:show("MessageBox", nil):setOwnerKey(self)
	end
end
function Com_snowNightMain:onShow()
end
return Com_snowNightMain
