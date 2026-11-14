local gametop = gModuleMgr.getObject("gametop")
local stuffWorkshopCtrl = gametop.playertop_:getModule("stuffWorkshopCtrl")
local queueCtrl = gametop.playertop_:getModule("queueCtrl")
local itemDesRead = include("itemDesRead")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_icon = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://BuildMaterialWorkshop/Com_icon", Com_icon)
function Com_icon:onInit()
	self:addEventListener(fgui.UIEventType.TouchBegin, handler(self, self.btnClickBeginCallBack))
	self:addClickListener(handler(self, self.btnClickCallBack))
end
function Com_icon:onShow()
end
function Com_icon:registerEvent()
	SoraDAddMessage(self, "MESSAGE_UI_MATERIAL_FACTORY_TOUCH_CHANGE", function(target, data)
		if not self.curPos and data.mid == self.singleData.mid then
			self.fields.icon:setVisible(data.show)
		end
	end)
	SoraDAddMessage(self, "MESSAGE_UI_MATERIAL_FACTORY_TOUCH_MOVE", function(target, data)
		if data.pos == self.curPos then
			self.fields.bg:setIcon(itemDesRead.getBg(data.mid))
			self.fields.icon:setURL(itemDesRead.getIcon(data.mid))
			self.controllers.c1:setSelectedIndex(data.show and 4 or 1)
		end
	end)
end
function Com_icon:initData(data, pos, count)
	dump(data, "Com_icon")
	self.singleData = data
	if pos then
		self.curPos = pos
		self.speedCount = count
		if self.singleData.type == 0 then
			self.controllers.c1:setSelectedIndex(1)
		elseif self.singleData.type == 1 then
			self.controllers.c1:setSelectedIndex(0)
		end
		self:showMaterial()
	end
	self.fields.bg:setIcon(itemDesRead.getBg(data.mid))
	self.fields.icon:setURL(itemDesRead.getIcon(data.mid))
end
function Com_icon:showMaterial()
	if self.singleData.mid then
		if self.curPos == 1 then
			self.queue = queueCtrl:queryQueue(gQueueTypeDef.stuff_workshop)
			if self.queue then
				self.fields.title:setString(i18n("activity_text_05"))
				self:openTimeUp()
				self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
				_ENV = handler(self, self.openTimeUp)
				handler(self, self.openTimeUp)[1] = ffa.fadeTo(1, 0.5)
				handler(self, self.openTimeUp)[2] = ffa.fadeTo(1, 1)
				handler(self, self.openTimeUp)[3] = ffa.fadeTo(1, 1)
				handler(self, self.openTimeUp)[4] = ffa.fadeTo(1, 1)
				self.fields.icon:runAction(ffa.repeatForever(ffa.seq(handler(self, self.openTimeUp))))
			end
			self.controllers.c1:setSelectedIndex(3)
		else
			self.controllers.c1:setSelectedIndex(2)
			self.fields.timeBar:setFillAmount(1)
			self.fields.title:setString(i18n("suit_text_11"))
		end
	else
		self.fields.title:setString(i18n("herotrain_text_01"))
	end
end
function Com_icon:openTimeUp(dt)
	local leftTime = self.queue.timerNode and self.queue.timerNode.timer:getRemainTime() or 0
	local totalTime = self.queue.ottime or self.queue.totaltime
	self.fields.timeBar:setFillAmount(leftTime / totalTime)
	if leftTime == nil or leftTime <= 0 then
		self:removeTimer()
	end
end
function Com_icon:removeTimer()
	if self.timer then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
	end
end
function Com_icon:btnClickBeginCallBack()
	print("btnClickBeginCallBack")
	if self.controllers.c1:getSelectedIndex() == 4 then
		_ENV = self.controllers.c1
		self.controllers.c1.msg = "MESSAGE_UI_MATERIAL_FACTORY_PRESS"
		self.controllers.c1.data = self.singleData
		self.controllers.c1.pos = self:getPosition()
		SoraDSendMessage(self.controllers.c1)
	end
end
function Com_icon:btnClickCallBack(button, event)
	if self.singleData.type == 0 and self.singleData.mid then
		if self.curPos == 1 and self.queue then
			if 0 < self.speedCount then
				_ENV = nil
				;(nil).count = self.speedCount
				_ENV = "common_text_2045"
				;("common_text_2045").isMaterialFactory = true
				SoraDShowSpeedUpBox(self.queue, nil, i18n("common_text_2045", nil), "common_text_2045")
			else
				SoraDShowMsgTip(i18n("common_text_2046"))
			end
		else
			stuffWorkshopCtrl:sendCancelRefinery(self.curPos)
		end
	elseif self.singleData.type == 1 then
		if self.singleData.vip then
			local vipData = lordInfoCtrl:getVip()
			if not (vipData[1] >= self.singleData.vip) or not vipData[2] then
				_ENV = i18n("common_text_2046")
				_ENV = i18n("common_text_2046")
				i18n("common_text_2046").lv = self.singleData.vip
				i18n("common_text_2046").content = i18n("common_text_1148", i18n("common_text_2046"))
				i18n("common_text_2046").confirmString = i18n("mail_text_67")
				i18n("common_text_2046").confirmFunc = function()
					uiManager:show("vipCenterView")
				end
				uiManager:show("MessageBox", i18n("common_text_2046"))
				return
			end
		end
		_ENV = uiManager.show
		_ENV, uiManager.show.msgKey = uiManager, "common_text_2044"
		uiManager.show.msgParams, uiManager.gold = uiManager, self.singleData.gold
		uiManager.show.gold = self.singleData.gold
		uiManager.show.title = i18n("common_text_246")
		function uiManager.show.handle(type)
			if type == MSGBOX_CALLBACK_YES then
				stuffWorkshopCtrl:sendOpenPos(self.curPos)
			end
		end
		SoraDShowBuyBoxNew(uiManager.show)
	end
end
return Com_icon
