local alliancePetCtrl = SoraDGetCtrl("alliancePetCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local AlliancePetReduceTimePanel = class("AlliancePetReduceTimePanel", baseFguiPanel)
function AlliancePetReduceTimePanel:ctor(...)
	self.super.ctor(self, ...)
	print("AlliancePetReduceTimePanel:ctor", self.viewName)
	self.round = 0
	self.costList = require_data("alliance_beast_reduce", true).data
	self.isHideCurrentSceneView = true
end
function AlliancePetReduceTimePanel:onInit()
	print("=======AlliancePetReduceTimePanel:onInit")
	self.fields.Com_title:initData(i18n("alliance_beast_text_31"), handler(self, self.onClickClose))
	self.txtRemainTime = SoraDCreateTimerLabel(self, self.fields.text_remainTime)
	self.fields.Com_title2:setString(i18n("alliance_beast_text_35"))
	local Button_help = self.fields.Com_title2:getChild("Button_help")
	Button_help:addClickListener(handler(self, self.questClickCallBack))
	self.fields.btn_donate:setItemID(gIDDef.GOLD)
	self.fields.btn_donate:addClickListener(handler(self, self.donateClickCallBack))
	self.fields.List_log:setItemRenderer(handler(self, self.onItemRenderer))
	local comStr = string.format([[
%s
%s]], i18n("alliance_beast_text_37"), i18n("alliance_beast_text_38"))
	self.fields.text_warning:setString(comStr)
end
function AlliancePetReduceTimePanel:onShow()
	print("=======AlliancePetReduceTimePanel:onShow")
	local callTimeCD = alliancePetCtrl:getAlliancePetCallTimeCD()
	local totalTime = alliancePetCtrl:getAlliancePetTotalTime()
	self.txtRemainTime:setTimeLast(function(str)
		self.fields.LoadingBar_progress:setPercent(callTimeCD / totalTime)
		callTimeCD = callTimeCD / totalTime
		;(callTimeCD / totalTime).time = str
		return i18n("common_text_725", callTimeCD / totalTime)
	end)
	self.txtRemainTime:setTimeEndListener(function(...)
		self:removeFromParent()
		uiManager:show("AlliancePetSelect")
	end)
	self.txtRemainTime:beginTime(callTimeCD)
	alliancePetCtrl:sendReqPetInfo()
	SoraDShowLoading(self:displayObject())
end
function AlliancePetReduceTimePanel:initData()
	local curCost = self.costList[self.round + 1]
	curCost = curCost or self.costList[self.round]
	_ENV = nil
	;(nil).Time = SoraDConvertSecondToString(curCost.Reduce)
	self.fields.text_donateTime:setString(i18n("alliance_beast_text_36", nil))
	self.fields.btn_donate:setPrice(curCost.Cost)
	self.fields.List_log:setNumItems(#self.reduceList)
	local callTimeCD = alliancePetCtrl:getAlliancePetCallTimeCD()
	local totalTime = alliancePetCtrl:getAlliancePetTotalTime()
	if 0 < callTimeCD then
		self.txtRemainTime:setTimeLast(function(str)
			self.fields.LoadingBar_progress:setPercent(callTimeCD / totalTime)
			callTimeCD = callTimeCD / totalTime
			;(callTimeCD / totalTime).time = str
			return i18n("common_text_725", callTimeCD / totalTime)
		end)
		self.txtRemainTime:beginTime(callTimeCD)
	else
		self:removeFromParent()
		uiManager:show("AlliancePetSelect")
	end
end
function AlliancePetReduceTimePanel:onItemRenderer(index, obj)
	local data = self.reduceList[index + 1]
	local _fields = obj._fields
	if not _fields then
		_fields = fguiHelper.get_fields(obj)
		obj._fields = _fields
		if not SoraDFIsRA() then
			obj:fixChildrenPos()
		end
	end
	_fields.text_name:setString(data.name)
	local timeStr = string.format(" %ss", data.time)
	_ENV = nil
	;(nil).Name = ""
	;(nil).Time = timeStr
	_fields.text_reduceTime:setString(i18n("alliance_beast_text_34", nil))
end
function AlliancePetReduceTimePanel:donateClickCallBack()
	SoraDPlaySound()
	if self.costList[self.round + 1] then
		local needGold = self.costList[self.round + 1].Cost
		if SoraDEnoughGold(needGold, true) then
			_ENV = nil
			;(nil).Gold = needGold
			SoraDShowMsgBox(i18n("alliance_beast_text_33", nil), i18n("common_text_054"), nil, function(eventType)
				if MSGBOX_CALLBACK_YES == eventType then
					alliancePetCtrl:sendReqReducePetCD()
					SoraDShowLoading(self:displayObject())
				end
			end)
		else
			SoraDShowMsgBox(i18n("common_text_430"), i18n("common_text_054"), nil, handler(self, self.gotoStore))
		end
	else
		SoraDShowMsgTip(i18n("alliance_beast_text_39"))
	end
end
function AlliancePetReduceTimePanel:gotoStore(type)
	if type == MSGBOX_CALLBACK_YES then
		if GLOBAL_GAME_RECHARGE_MODE then
			uiManager:show("rechargeView")
		else
			SoraDCreatePanel("rechargeView"):show()
		end
	end
end
function AlliancePetReduceTimePanel:questClickCallBack()
	SoraDPlaySound()
	SoraDShowHelpMsgTip(i18n("guardian_animal_faq"))
end
function AlliancePetReduceTimePanel:onMsgReqInfoBack(target, data)
	SoraDCloseLoading(self:displayObject())
	self.reduceList, _ENV = SoraDCloseLoading, SoraDCloseLoading
	for k, v in pairs(data.alliancePetData.reduceList) do
		if v.name then
			table.insert(self.reduceList, v)
		end
	end
	table.sort(self.reduceList, function(l, r)
		local time1 = l.opTime or l.time
		local time2 = r.opTime or r.time
		return time1 < time2
	end)
	self.round = tonumber(data.alliancePetData.reduceNum)
	self:initData()
end
function AlliancePetReduceTimePanel:onMsgReqDonateBack(target, data)
	SoraDCloseLoading(self:displayObject())
	self.round = tonumber(data.alliancePetData.reduceNum)
	alliancePetCtrl:sendReqReducePetCDList()
	SoraDShowLoading(self:displayObject())
end
function AlliancePetReduceTimePanel:onMsgReqDonateListBack(target, data)
	SoraDCloseLoading(self:displayObject())
	self.reduceList = data.alliancePetData.reduceList
	self:initData()
	local callTimeCD = alliancePetCtrl:getAlliancePetCallTimeCD()
	if callTimeCD <= 0 then
		uiManager:show("AlliancePetSelect")
	end
end
return AlliancePetReduceTimePanel
