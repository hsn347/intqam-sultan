local baseComponent = require("fgui.base.baseComponent")
local worldEscortCar = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://WorldMap/worldEscortCar", worldEscortCar)
local gametop = gModuleMgr.getObject("gametop")
local escortCartCtrl = gametop.playertop_:getModule("escortCartCtrl")
local escortDesRead = include("escortDesRead")
local effectUI = include("effectUI")
function worldEscortCar:onInit()
	self.bg = self.fields.bg
	self.Node_glow = self.fields.Node_glow
	self.img_car = self.fields.img_car
	self.bg_color = self.fields.bg_color
	self:addClickEventListener(handler(self, self.btnCarEvent))
	self.img_glow = effectUI.getCoolSuqare()
	self.img_glow:setScale(1.7)
	self.img_glow:addTo(self.Node_glow)
	self.Node_glow:setVisible(false)
	self.itemSize = self:getSize()
	self.itemWidth = self.itemSize.width
	self.itemHeight = self.itemSize.height
	self:setAnchorPoint(cc.p(0, 0))
	self.isLvMax = false
	local nodeFormat = "biaoche01_yd_ws_%02d.png"
	local nodeStart = 1
	local nodeEnd = 8
	self.lv = 1
	local frames = display.newFrames(nodeFormat, nodeStart, nodeEnd)
	local sp = display.newSprite("#biaoche01_yd_ws_01.png")
	local animation = display.newAnimation(frames, 0.16666666666666666)
	sp:addTo(self.img_car)
	sp:playAnimationForever(animation)
	self:updateCarAddValue()
end
function worldEscortCar:onShow()
	SoraDAddMessage(self, "MESSAGE_SERVER_ESCORT_ESCORT_CAR_ADD_VALUE_UPDATE", handler(self, self.sMsgUpdateCarAddValue))
end
function worldEscortCar:initWithData(data)
	self.lv = data.lv
	local quality = escortDesRead.getCarQuality(self.lv)
	if quality == nil then
		quality = 0
	end
	local qualityBg = string.format("frame_item_base_%02d.png", quality + 1)
	self.bg_color:setURL(qualityBg)
	if self.lv > 1 then
		local ex_format = "#biaoche0" .. self.lv .. "_yd_ws_01.png"
		local ex_car = display.newSprite(ex_format)
		ex_car:setPosition(cc.p(0, 0))
		ex_car:addTo(self.img_car)
	end
end
function worldEscortCar:updateCarAddValue()
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	if allianceMgr:hasJoinAlliance() then
		local alliance = allianceMgr:getAlliance()
		if alliance then
			local addValue = alliance:getEscortAddValue()
			if 0 < addValue then
				local strAddValue = string.format("+%d%%", math.floor(addValue * 100))
			else
			end
		else
		end
	else
	end
end
function worldEscortCar:getItemWidth()
	return self.itemWidth
end
function worldEscortCar:getItemHeight()
	return self.itemHeight
end
function worldEscortCar:btnCarEvent(target, event)
	SoraDPlaySound()
	print("TODO:  打开奖励界面")
	local rewards = escortCartCtrl:getCartReward(self.lv)
	local _ENV, tblRewards = escortCartCtrl, escortCartCtrl
	for i, v in ipairs(rewards) do
		if rewards[i].num > 0 then
			tblRewards[rewards[i].id] = rewards[i].num
		end
	end
	local carCfg = escortDesRead.getCar(self.lv)
	local timeStr = SoraDConvertSecondToString(carCfg.time)
	_ENV = nil
	;(nil).title = i18n("common_text_2078")
	_ENV = nil
	;(nil).time = timeStr
	;(nil).bottomtip = i18n("common_text_2471", nil)
	SoraDOpenGiftView(tblRewards, nil)
end
function worldEscortCar:confirmCallBack(eventType)
	if eventType == MSGBOX_CALLBACK_YES then
		local isEnough = SoraDEnoughGold(2500)
		if isEnough then
			print(" 召唤车辆-----------")
			_ENV = " 召唤车辆-----------"
			;(" 召唤车辆-----------").msg = "MESSAGE_UI_ESCORT_SHOW_LOADING"
			SoraDSendMessage(" 召唤车辆-----------")
			escortCartCtrl:reqCartAppoint()
		end
	end
end
function worldEscortCar:doSelect(isSelected)
	if isSelected == true then
		self.Node_glow:setVisible(true)
	elseif isSelected == false then
		self.Node_glow:setVisible(false)
	end
end
function worldEscortCar:setCallEnable(isCallEnable)
	self.isCallEnable = isCallEnable
end
function worldEscortCar:sMsgUpdateCarAddValue(target, data)
	self:updateCarAddValue()
end
return worldEscortCar
