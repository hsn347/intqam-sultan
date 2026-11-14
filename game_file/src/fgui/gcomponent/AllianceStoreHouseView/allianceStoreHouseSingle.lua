local allianceTreasureltCtrl = include("allianceTreasureltCtrl")
local MAX_AWARD_NUM = 5
local baseComponent = require("fgui.base.baseComponent")
local allianceStoreHouseSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceStoreHouseView/allianceStoreHouseSingle", allianceStoreHouseSingle)
function allianceStoreHouseSingle:onInit()
	self.itemList, _ENV, self.style = nil, nil, 1
	self.fields.Text_helper:setVisible(false)
	self.fields.List_items:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_free:addClickListener(handler(self, self.onClickBtnBox))
	self.fields.Button_dig:addClickListener(handler(self, self.onClickBtnBox))
	self.fields.Text_tip = SoraDCreateTimerLabel(self, self.fields.Text_tip)
	self:fixChildrenPos()
end
function allianceStoreHouseSingle:onItemRenderer(index, obj)
	obj:initData(self.itemList[index + 1].id, self.itemList[index + 1].count)
end
function allianceStoreHouseSingle:onShow()
end
function allianceStoreHouseSingle:initData(info)
	self.style = info.style
	self.data = info.data
	self.tData = self.data.data
	self.handle = self.data.handle
	self.fields.Text_helper:setVisible(false)
	local name = allianceTreasureltCtrl.getTreasureName(self.tData.teasureID, self.tData.quality)
	self.fields.Text_name:setString(name)
	self.fields.Text_name:setColor(gQualityTextColorDef[self.tData.quality])
	self:setStyle()
	self:initAwards(self.tData.award)
	if self.style == 1 then
		self:setTipText(self.data.tipText)
	elseif self.style == 2 then
		self:setTipStatus(self.data.status, self.data.time, self.data.assistNickName)
	elseif self.style == 3 then
		self:setHeadInfo(self.data.ownUid, self.data.avatar, self.data.headID, self.data.name)
		self:setHelpTipStatus(self.data.status, self.data.time)
	end
	self:setBtnBoxInfo(self.data.btnStyle, self.data.text, self.data.gold, self.data.isReward, self.data.timeData)
end
function allianceStoreHouseSingle:setHeadInfo(ownUid, avatar, headID, name)
	self.fields.Com_head:setPlayerID(ownUid)
	self.fields.Com_head:setHeadSprite(headID, avatar)
	self.fields.Text_memberName:setString(name)
end
function allianceStoreHouseSingle:setBtnBoxInfo(btnStyle, text, gold, isReward, timeData)
	if isReward then
		self.fields.Button_free:setBtnColorIndex(0)
	else
		self.fields.Button_free:setBtnColorIndex(2)
	end
	if btnStyle == 1 then
		self.fields.Button_free:setString(text)
		self.fields.Button_free:setVisible(true)
		self.fields.Button_free:setEnabled(true)
		self.fields.Button_dig:setVisible(false)
	elseif btnStyle == 2 then
		self.fields.Button_free:setVisible(false)
		self.fields.Button_dig:setVisible(true)
		self.fields.Button_dig:endGoldTimer()
		self.fields.Button_dig:setString(text)
		if timeData and next(timeData) then
			self.fields.Button_dig:setGoldTimer(gold, timeData.curTime, timeData.totalTime)
		else
			self.fields.Button_dig:setCostTitle(gold)
		end
	elseif btnStyle == 3 then
		self.fields.Button_free:setString(text)
		self.fields.Button_free:setVisible(true)
		self.fields.Button_free:setEnabled(false)
		self.fields.Button_dig:setVisible(false)
	elseif btnStyle == 4 then
		self.fields.Button_free:setVisible(false)
		self.fields.Button_dig:setVisible(false)
	end
end
function allianceStoreHouseSingle:setTipText(time)
	self.fields.Text_tip:endTime()
	_ENV = nil
	;(nil).num = math.ceil(time / 3600)
	self.fields.Text_tip:setString(i18n("allitreas_text_20", nil))
	self.fields.Text_tip:setColor(cc.c3b(215, 195, 155))
end
function allianceStoreHouseSingle:setTipStatus(status, time, assistNickName)
	self.fields.Text_tip:endTime()
	if status == gTreasureDigStatus.REWARD then
		self.fields.Text_tip:setString(i18n("allitreas_text_16"))
		self.fields.Text_tip:setColor(cc.c3b(215, 195, 155))
		self.fields.Text_helper:setVisible(false)
	elseif status == gTreasureDigStatus.BE_HELPED then
		self.fields.Text_helper:setVisible(true)
		_ENV = cc.c3b(215, 195, 155)
		cc.c3b(215, 195, 155).name = assistNickName
		self.fields.Text_helper:setString(i18n("allitreas_columntext_01", cc.c3b(215, 195, 155)))
		self.fields.Text_tip:setColor(cc.c3b(215, 195, 155))
		_ENV = cc.c3b(215, 195, 155)
		cc.c3b(215, 195, 155).time = SoraDConvertSecondToString(time)
		self.fields.Text_tip:setString(i18n("allitreas_text_15", cc.c3b(215, 195, 155)))
		self.fields.Text_tip:setTimeUpdateListener(function(time)
			if time <= 0 then
				self.fields.Text_tip:setString(i18n("allitreas_text_16"))
			else
				self = i18n("allitreas_text_16")
				i18n("allitreas_text_16").time = SoraDConvertSecondToString(time)
				self.fields.Text_tip:setString(i18n("allitreas_text_15", i18n("allitreas_text_16")))
			end
		end)
		self.fields.Text_tip:beginTime(time)
	else
		self.fields.Text_helper:setVisible(false)
		self.fields.Text_tip:setColor(cc.c3b(190, 40, 40))
		self.fields.Text_tip:setTimeUpdateListener(function(time)
			if time <= 0 then
				self.fields.Text_tip:setString("")
			else
				self = nil
				;(nil).time = SoraDConvertSecondToString(time)
				self.fields.Text_tip:setString(i18n("allitreas_text_14", nil))
			end
		end)
		self.fields.Text_tip:beginTime(time)
	end
end
function allianceStoreHouseSingle:setHelpTipStatus(status, time)
	self.fields.Text_tip:endTime()
	if status == gTreasureHelpStatus.REWARD then
		self.fields.Text_tip:setString(i18n("allitreas_text_16"))
		self.fields.Text_tip:setColor(cc.c3b(215, 195, 155))
	elseif status == gTreasureHelpStatus.HELPED then
		_ENV = cc.c3b(215, 195, 155)
		cc.c3b(215, 195, 155).time = SoraDConvertSecondToString(time)
		self.fields.Text_tip:setString(i18n("allitreas_text_15", cc.c3b(215, 195, 155)))
		self.fields.Text_tip:setColor(cc.c3b(190, 40, 40))
		self.fields.Text_tip:setTimeUpdateListener(function(time)
			if time <= 0 then
				self.fields.Text_tip:setString(i18n("allitreas_text_16"))
				self.fields.Text_tip:setColor(cc.c3b(215, 195, 155))
			else
				self = cc.c3b(215, 195, 155)
				cc.c3b(215, 195, 155).time = SoraDConvertSecondToString(time)
				self.fields.Text_tip:setString(i18n("allitreas_text_15", cc.c3b(215, 195, 155)))
			end
		end)
		self.fields.Text_tip:beginTime(time)
	else
		_ENV = cc.c3b(190, 40, 40)
		cc.c3b(190, 40, 40).num = math.ceil(time / 3600)
		self.fields.Text_tip:setString(i18n("allitreas_text_20", cc.c3b(190, 40, 40)))
		self.fields.Text_tip:setColor(cc.c3b(215, 195, 155))
	end
end
function allianceStoreHouseSingle:setStyle()
	if self.style == 1 or self.style == 2 then
		self.fields.Com_box:setVisible(true)
		self.fields.Com_head:setVisible(false)
		self.fields.Text_memberName:setVisible(false)
		self.fields.Com_box:setBoxPng(allianceTreasureltCtrl.getTreasureBox(self.tData.teasureID, self.tData.quality))
		self.fields.Com_box:setBoxParticle(self.tData.quality)
	elseif self.style == 3 then
		self.fields.Com_box:setVisible(false)
		self.fields.Com_head:setVisible(true)
		self.fields.Text_memberName:setVisible(true)
	end
end
function allianceStoreHouseSingle:initAwards(award)
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	self.itemList = serviceFunctions.tableFormat(award, nil)
	self.fields.List_items:setNumItems(math.min(#self.itemList, MAX_AWARD_NUM))
end
function allianceStoreHouseSingle:onClickBtnBox()
	SoraDPlaySound()
	if self.handle then
		self.handle(self.data)
	end
end
return allianceStoreHouseSingle
