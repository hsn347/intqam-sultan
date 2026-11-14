local nebulaEmperorUtil = include("nebulaEmperorUtil")
local nebulaEmperorRead = include("nebulaEmperorRead")
local nebulaEmperorCtrl = SoraDGetCtrl("nebulaEmperorCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaEmperorAwardPanel = class("NebulaEmperorAwardPanel", baseFguiPanel)
function NebulaEmperorAwardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaEmperorAwardPanel:ctor", self.viewName)
	self.giftInfo, _ENV, self.isKing = nebulaEmperorCtrl:getIsSelfNebulaEmperor(), nebulaEmperorCtrl:getIsSelfNebulaEmperor(), nebulaEmperorCtrl:getIsSelfNebulaEmperor()
	self.cfgs = nebulaEmperorRead.getOfficerAward()
end
function NebulaEmperorAwardPanel:onInit()
	print("=======NebulaEmperorAwardPanel:onInit")
	local handlerHelp = nebulaEmperorUtil.getHandler_onClickHelp()
	self.fields.Com_title:initData(i18n("nebulaemperor_text_24"), handler(self, self.onClickClose), handlerHelp)
	self.fields.List_award:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_record:setTitle(i18n("common_text_836"))
	self.fields.Button_record:addClickListener(handler(self, self.onClickBtnRecord))
end
function NebulaEmperorAwardPanel:onShow()
	print("=======NebulaEmperorAwardPanel:onShow")
	nebulaEmperorCtrl:reqGiftInfo()
	SoraDShowLoading(self:displayObject())
end
function NebulaEmperorAwardPanel:onClickBtnRecord(...)
	SoraDPlaySound()
	uiManager:show("NebulaEmperorAwardRecord")
end
function NebulaEmperorAwardPanel:onItemRenderer(index, obj)
	local cfg = self.cfgs[index + 1]
	local giftID = cfg.index
	if not obj._fields then
		local _fields = fguiHelper.get_fields(obj)
		obj._fields = _fields
		_fields.Btn_reward:setString(i18n("common_text_1441"))
		_fields.Btn_reward:addClickListener(handler(self, self.onClickBtnReward))
	end
	local _fields = obj._fields
	_fields.Text_name:setString(i18n(cfg.name))
	local numMax = cfg.num
	if not self.giftInfo[tostring(giftID)] then
		_ENV = self.giftInfo[tostring(giftID)]
	end
	local numSend = #self.giftInfo[tostring(giftID)]
	local numLeft = math.max(0, numMax - numSend)
	local Text_num = _fields.Btn_reward:getChild("Text_num")
	_ENV = i18n(cfg.name)
	i18n(cfg.name).var = numLeft
	i18n(cfg.name).var1 = numMax
	Text_num:setString(i18n("atlantiswar_text_0378", i18n(cfg.name)))
	_UPVALUE2_ = i18n("atlantiswar_text_0378", i18n(cfg.name))
	i18n("atlantiswar_text_0378", i18n(cfg.name))[1] = "id"
	i18n("atlantiswar_text_0378", i18n(cfg.name))[2] = "count"
	local _rewards = serviceFunctions.tableFormat(cfg.rewards, i18n("atlantiswar_text_0378", i18n(cfg.name)))
	_fields.List_reward:setItemRenderer(function(_index, _obj)
		local item = _rewards[_index + 1]
		_obj:initData(item.id, item.count)
	end)
	_fields.List_reward:setNumItems(#_rewards)
	local height = math.ceil(#_rewards / 5) * 107 - 7
	local sSize = cc.size(_fields.List_reward:getContentSize().width, height)
	_fields.List_reward:setContentSize(sSize)
	_fields.Btn_reward:setTag(giftID)
	if self.isKing and 0 < numLeft then
		_fields.Btn_reward:setEnabled(true)
	else
		_fields.Btn_reward:setEnabled(false)
	end
end
function NebulaEmperorAwardPanel:onClickBtnReward(EventContext)
	SoraDPlaySound()
	local giftID = EventContext:getSender():getTag()
	local panel = SoraDCreatePanel("worldMapKingdomCityAppointSelect")
	panel:setNebulaEmperorGift(giftID, self.giftInfo)
	panel:show()
end
function NebulaEmperorAwardPanel:onMsgReqGiftInfoRsp(target, event)
	SoraDCloseLoading(self:displayObject())
	if not event.rspdata then
		_ENV = event.rspdata
	end
	self.giftInfo = event.rspdata
	self.fields.List_award:setNumItems(#self.cfgs)
end
function NebulaEmperorAwardPanel:onMsgReqAwardGiftRsp(target, event)
	local uid = event.uid
	local giftID = event.giftID
	if not self.giftInfo[tostring(giftID)] then
		_ENV = self.giftInfo[tostring(giftID)]
	end
	self.giftInfo[tostring(giftID)] = self.giftInfo[tostring(giftID)]
	table.insert(self.giftInfo[tostring(giftID)], uid)
	self.fields.List_award:setNumItems(#self.cfgs)
end
return NebulaEmperorAwardPanel
